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
 * 课程资源表
 * </p>
 *
 * @author syb
 * @since 2026-03-25
 */
@Getter
@Setter
@TableName("course_resource")
public class CourseResource implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 所属章节ID
     */
    private Long chapterId;

    /**
     * 资源名称
     */
    private String name;

    /**
     * 资源类型: video, pdf, ppt, word [cite: 72]
     */
    private String type;

    /**
     * 资源存储地址/播放地址
     */
    private String url;

    /**
     * 视频时长(秒)
     */
    private Integer duration;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    @TableLogic
    private Byte isDeleted;
}
