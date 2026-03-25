package org.example.lzw.entity.dto;

import lombok.Data;

@Data
public class UpdatePwdDTO {
    private String oldPassword;
    private String newPassword;
}