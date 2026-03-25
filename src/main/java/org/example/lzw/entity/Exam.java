package org.example.lzw.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("exam")
public class Exam {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long courseId; // 所属课程ID
    
    private String title; // 考试名称
    
    private Integer totalScore; // 总分
    
    private LocalDateTime startTime; // 开始时间
    
    private LocalDateTime endTime; // 结束时间
    
    private Integer status; // 状态: 0-未发布, 1-已发布
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    @TableLogic
    private Integer isDeleted;
}