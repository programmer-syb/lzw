package org.example.lzw.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import java.io.Serializable;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 教师发布作业表
 * </p>
 *
 * @author syb
 * @since 2026-03-25
 */
@Getter
@Setter
public class Homework implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 所属课程ID
     */
    private Long courseId;

    /**
     * 作业标题
     */
    private String title;

    /**
     * 作业内容要求
     */
    private String content;

    /**
     * 截止时间 [cite: 76]
     */
    private LocalDateTime deadline;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    @TableLogic
    private Byte isDeleted;
}
