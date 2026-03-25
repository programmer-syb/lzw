package org.example.lzw.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 学生作业提交表
 * </p>
 *
 * @author syb
 * @since 2026-03-25
 */
@Getter
@Setter
@TableName("student_homework")
public class StudentHomework implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 学生ID
     */
    private Long studentId;

    /**
     * 作业ID
     */
    private Long homeworkId;

    /**
     * 提交的文本内容 [cite: 21]
     */
    private String content;

    /**
     * 提交的附件地址 [cite: 21]
     */
    private String fileUrl;

    /**
     * 状态: 0-未提交, 1-已提交待批改, 2-已批改 [cite: 22]
     */
    private Integer status;

    /**
     * 作业得分 [cite: 23]
     */
    private BigDecimal score;

    /**
     * 教师评语 [cite: 23]
     */
    private String teacherComment;

    /**
     * 提交时间
     */
    private LocalDateTime submitTime;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
