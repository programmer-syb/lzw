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
     * 分页查询用户列表 (可按角色过滤)
     */
    @GetMapping("/list")
    public Result<Page<SysUser>> getUserList(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Integer role,
            @RequestParam(required = false) String keyword) {
            
        Page<SysUser> page = new Page<>(current, size);
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        
        if (role != null) {
            wrapper.eq(SysUser::getRole, role);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.and(w -> w.like(SysUser::getUsername, keyword)
                              .or().like(SysUser::getNickname, keyword));
        }
        
        // 抹除密码返回
        Page<SysUser> result = sysUserService.page(page, wrapper);
        result.getRecords().forEach(u -> u.setPassword(null));
        return Result.success(result);
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
}