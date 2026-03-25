package org.example.lzw.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 课程分类表
 * </p>
 *
 * @author syb
 * @since 2026-03-25
 */
@Getter
@Setter
@TableName("course_category")
public class CourseCategory implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 分类ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 分类名称(如:计算机、数学) [cite: 40]
     */
    private String name;

    /**
     * 排序
     */
    private Integer sort;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    @TableLogic
    private Byte isDeleted;
}
