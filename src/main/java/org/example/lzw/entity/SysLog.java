package org.example.lzw.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("sys_log")
public class SysLog {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 操作人ID
     */
    private Long userId;

    /**
     * 请求IP
     */
    private String ip;

    /**
     * 请求方法
     */
    private String method;

    /**
     * 请求URI
     */
    private String uri;

    /**
     * 耗时(ms)
     */
    private Long duration;

    private LocalDateTime createTime;
}
