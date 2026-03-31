package org.example.lzw.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import java.io.Serializable;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 课程信息表
 * </p>
 *
 * @author syb
 * @since 2026-03-25
 */
@Getter
@Setter
public class Course implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 课程ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 课程名称 [cite: 66]
     */
    private String title;

    /**
     * 课程简介 [cite: 66]
     */
    private String intro;

    /**
     * 教学大纲 [cite: 11]
     */
    private String syllabus;

    /**
     * 课程封面图URL [cite: 66]
     */
    private String cover;

    /**
     * 授课教师ID [cite: 11]
     */
    private Long teacherId;

    /**
     * 课程分类ID
     */
    private Long categoryId;

    /**
     * 状态: 0-未发布/下架, 1-已发布 [cite: 69]
     */
    private Integer status;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime updateTime;

    @TableLogic
    private Byte isDeleted;
}
