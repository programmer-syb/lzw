package org.example.lzw.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("course_discussion")
public class CourseDiscussion {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long courseId; // 课程ID
    
    private Long userId; // 发帖人ID
    
    private Long parentId; // 父节点ID(0表示主贴)
    
    private String title; // 标题
    
    private String content; // 内容
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    @TableLogic
    private Integer isDeleted;
}