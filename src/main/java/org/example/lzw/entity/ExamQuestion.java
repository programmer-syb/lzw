package org.example.lzw.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("exam_question")
public class ExamQuestion {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long examId; // 所属考试ID
    
    private Integer type; // 题目类型: 1-单选题, 2-简答题
    
    private String content; // 题目内容
    
    private String options; // 选项(存储JSON字符串，如 ["A.xx","B.xx"])
    
    private String answer; // 标准答案
    
    private Integer score; // 该题分值
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    @TableLogic
    private Integer isDeleted;
}