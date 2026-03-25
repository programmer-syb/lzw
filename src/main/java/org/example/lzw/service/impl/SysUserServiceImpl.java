package org.example.lzw.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.lzw.entity.SysUser;
import org.example.lzw.entity.dto.LoginDTO;
import org.example.lzw.entity.dto.RegisterDTO;
import org.example.lzw.entity.dto.UpdatePwdDTO;
import org.example.lzw.mapper.SysUserMapper;
import org.example.lzw.service.SysUserService;
import org.example.lzw.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
public class SysUserServiceImpl extends ServiceImpl<SysUserMapper, SysUser> implements SysUserService {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Override
    public Map<String, Object> login(LoginDTO loginDTO) {
        // 1. 根据用户名查询用户
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysUser::getUsername, loginDTO.getUsername());
        SysUser user = this.getOne(wrapper);

        // 2. 校验用户是否存在
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        // 3. 校验密码 (目前使用明文比对)
        if (!user.getPassword().equals(loginDTO.getPassword())) {
            throw new RuntimeException("密码错误");
        }

        // 4. 校验账号状态
        if (user.getStatus() == 0) {
            throw new RuntimeException("账号已被禁用，请联系管理员");
        }

        // 5. 生成 JWT Token
        String token = JwtUtils.generateToken(user.getId(), user.getUsername(), user.getRole());

        // 6. 将 Token 存入 Redis，设置过期时间为 24 小时 (与 JWT 过期时间一致)
        // Key 格式: "login:token:用户ID"
        String redisKey = "login:token:" + user.getId();
        redisTemplate.opsForValue().set(redisKey, token, 24, TimeUnit.HOURS);

        // 7. 封装返回数据
        Map<String, Object> resultData = new HashMap<>();
        resultData.put("token", token);
        resultData.put("userId", user.getId());
        resultData.put("username", user.getUsername());
        resultData.put("role", user.getRole());
        resultData.put("nickname", user.getNickname());

        return resultData;
    }
    @Override
    public void register(RegisterDTO registerDTO) {
        // 1. 检查用户名是否已存在
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysUser::getUsername, registerDTO.getUsername());
        if (this.count(wrapper) > 0) {
            throw new RuntimeException("该用户名/学号已被注册");
        }

        // 2. 封装实体类并保存
        SysUser user = new SysUser();
        user.setUsername(registerDTO.getUsername());
        user.setPassword(registerDTO.getPassword()); // 暂用明文
        user.setNickname(registerDTO.getNickname());
        user.setPhone(registerDTO.getPhone());
        user.setEmail(registerDTO.getEmail());

        // 3. 强制设置为学生角色 (2)，并启用状态 (1)
        user.setRole(2);
        user.setStatus(1);

        this.save(user);
    }
    @Override
    public void logout(Long userId) {
        if (userId != null) {
            redisTemplate.delete("login:token:" + userId);
        }
    }

    @Override
    public void updatePassword(Long userId, UpdatePwdDTO pwdDTO) {
        SysUser user = this.getById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        if (!user.getPassword().equals(pwdDTO.getOldPassword())) {
            throw new RuntimeException("原密码错误");
        }

        user.setPassword(pwdDTO.getNewPassword());
        this.updateById(user);

        // 密码修改后强制下线
        redisTemplate.delete("login:token:" + userId);
    }
}