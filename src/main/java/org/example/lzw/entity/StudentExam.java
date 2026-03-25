package org.example.lzw.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("student_exam")
public class StudentExam {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long examId; // 考试ID
    
    private Long studentId; // 学生ID
    
    private Integer totalScore; // 学生总得分
    
    private Integer status; // 状态: 0-考试中, 1-已交卷待批改, 2-已出成绩
    
    private LocalDateTime submitTime; // 交卷时间
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}