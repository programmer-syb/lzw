package org.example.lzw.controller;

import org.example.lzw.common.Result;
import org.example.lzw.entity.SysUser;
import org.example.lzw.entity.dto.LoginDTO;
import org.example.lzw.entity.dto.RegisterDTO;
import org.example.lzw.entity.dto.UpdatePwdDTO;
import org.example.lzw.service.SysUserService;
import org.example.lzw.utils.UserContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/user")
public class SysUserController {

    @Autowired
    private SysUserService sysUserService;

    /**
     * 用户登录接口
     */
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody LoginDTO loginDTO) {
        if (loginDTO.getUsername() == null || loginDTO.getPassword() == null) {
            return Result.error("用户名或密码不能为空");
        }
        
        try {
            Map<String, Object> loginData = sysUserService.login(loginDTO);
            return Result.success(loginData);
        } catch (RuntimeException e) {
            // 捕获 Service 层抛出的业务异常
            return Result.error(e.getMessage());
        }
    }

    /**
     * 用户注册
     */
    @PostMapping("/register")
    public Result<String> register(@RequestBody RegisterDTO registerDTO) {
        if (registerDTO.getUsername() == null || registerDTO.getPassword() == null) {
            return Result.error("账号和密码不能为空");
        }
        try {
            sysUserService.register(registerDTO);
            return Result.success("注册成功");
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }

    @PostMapping("/logout")
    public Result<String> logout() {
        Long userId = UserContext.getUserId();
        sysUserService.logout(userId);
        return Result.success("退出成功");
    }

    @PutMapping("/update")
    public Result<String> updateInfo(@RequestBody SysUser user) {
        Long userId = UserContext.getUserId();
        // 强制只能修改当前登录用户的信息
        user.setId(userId);

        // 保护字段：不允许通过此接口修改密码、角色、状态和用户名
        user.setPassword(null);
        user.setRole(null);
        user.setStatus(null);
        user.setUsername(null);

        boolean updated = sysUserService.updateById(user);
        return updated ? Result.success("信息更新成功") : Result.error("信息更新失败");
    }

    @PutMapping("/updatePassword")
    public Result<String> updatePassword(@RequestBody UpdatePwdDTO pwdDTO) {
        try {
            Long userId = UserContext.getUserId();
            sysUserService.updatePassword(userId, pwdDTO);
            return Result.success("密码修改成功，请重新登录");
        } catch (RuntimeException e) {
            return Result.error(e.getMessage());
        }
    }

    @GetMapping("/info")
    public Result<SysUser> getUserInfo() {
        SysUser user = sysUserService.getById(UserContext.getUserId());
        user.setPassword(null); // 抹除密码再返回给前端
        return Result.success(user);
    }
}