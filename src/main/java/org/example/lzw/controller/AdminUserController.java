package org.example.lzw.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.lzw.common.Result;
import org.example.lzw.entity.SysUser;
import org.example.lzw.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/user")
public class AdminUserController {

    @Autowired
    private SysUserService sysUserService;

    /**
     * 管理员获取用户列表 (强制排除 role=0 的管理员账号)
     */
    @GetMapping("/list")
    public Result<Page<SysUser>> getUserList(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Integer role,
            @RequestParam(required = false) String keyword) {

        Page<SysUser> page = new Page<>(current, size);
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();

        // 核心安全逻辑：永远不查管理员账号 (role = 0)
        wrapper.ne(SysUser::getRole, 0);

        // 按角色过滤
        if (role != null) {
            wrapper.eq(SysUser::getRole, role);
        }
        // 按关键字模糊搜索
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.and(w -> w.like(SysUser::getUsername, keyword)
                    .or()
                    .like(SysUser::getNickname, keyword));
        }

        wrapper.orderByDesc(SysUser::getCreateTime);
        return Result.success(sysUserService.page(page, wrapper));
    }

    /**
     * 封禁/解封用户状态
     */
    @PutMapping("/changeStatus/{id}/{status}")
    public Result<String> changeStatus(@PathVariable Long id, @PathVariable Integer status) {
        SysUser user = new SysUser();
        user.setId(id);
        user.setStatus(status); // 0-禁用, 1-启用
        boolean updated = sysUserService.updateById(user);
        return updated ? Result.success("状态更新成功") : Result.error("状态更新失败");
    }

    /**
     * 管理员录入新用户 (如注册教师)
     */
    @PostMapping("/add")
    public Result<String> addUser(@RequestBody SysUser user) {
        if (user.getUsername() == null || user.getPassword() == null) {
            return Result.error("用户名和密码不能为空");
        }

        // 检查用户名是否已存在
        long count = sysUserService.lambdaQuery()
                .eq(SysUser::getUsername, user.getUsername())
                .count();
        if (count > 0) {
            return Result.error("该用户名已被占用");
        }

        // 默认设置为教师且启用 (以防前端未传)
        if (user.getRole() == null) user.setRole(1);
        if (user.getStatus() == null) user.setStatus(1);

        boolean saved = sysUserService.save(user);
        return saved ? Result.success("账号注册成功") : Result.error("注册失败");
    }
}