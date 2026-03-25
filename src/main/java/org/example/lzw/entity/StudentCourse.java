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
 * 学生选课及进度表
 * </p>
 *
 * @author syb
 * @since 2026-03-25
 */
@Getter
@Setter
@TableName("student_course")
public class StudentCourse implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 学生ID [cite: 12]
     */
    private Long studentId;

    /**
     * 课程ID [cite: 12]
     */
    private Long courseId;

    /**
     * 学习进度百分比 [cite: 17]
     */
    private BigDecimal progress;

    /**
     * 累计学习时长(秒) [cite: 32]
     */
    private Integer watchTime;

    /**
     * 选课时间
     */
    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
