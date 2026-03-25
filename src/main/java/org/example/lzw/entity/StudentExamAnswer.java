package org.example.lzw.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("student_exam_answer")
public class StudentExamAnswer {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long studentExamId; // 学生考试记录ID
    
    private Long questionId; // 题目ID
    
    private String studentAnswer; // 学生填写的答案
    
    private Integer score; // 该题得分
    
    private String teacherComment; // 教师评语
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}