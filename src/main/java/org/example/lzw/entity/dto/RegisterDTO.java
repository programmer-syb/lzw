package org.example.lzw.entity.dto;

import lombok.Data;

@Data
public class RegisterDTO {
    private String username; // 学号或自定义账号
    private String password;
    private String nickname;
    private String phone;
    private String email;
}