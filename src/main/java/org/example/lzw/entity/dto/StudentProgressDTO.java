package org.example.lzw.entity.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class StudentProgressDTO {
    private Long studentId;
    private String nickname;
    private String avatar;
    private String major;
    private BigDecimal progress;
    private Integer watchTime;
}