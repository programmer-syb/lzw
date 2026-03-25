package org.example.lzw.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.example.lzw.entity.SysUser;
import org.example.lzw.entity.dto.LoginDTO;
import org.example.lzw.entity.dto.RegisterDTO;
import org.example.lzw.entity.dto.UpdatePwdDTO;

import java.util.Map;

public interface SysUserService extends IService<SysUser> {
    // 登录方法，返回包含 token 等信息的 Map
    Map<String, Object> login(LoginDTO loginDTO);
    // 注册
    void register(RegisterDTO registerDTO);
    void logout(Long userId);
    void updatePassword(Long userId, UpdatePwdDTO pwdDTO);
}