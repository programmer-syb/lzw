package org.example.lzw.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.lzw.common.Result;
import org.example.lzw.entity.SysLog;
import org.example.lzw.service.SysLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/log")
public class SysLogController {

    @Autowired
    private SysLogService sysLogService;

    /**
     * 管理员获取系统运行日志
     */
    @GetMapping("/list")
    public Result<Page<SysLog>> getLogList(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size) {
        
        Page<SysLog> page = new Page<>(current, size);
        // 按时间倒序查询，最新的日志在最前面
        Page<SysLog> result = sysLogService.lambdaQuery()
                .orderByDesc(SysLog::getCreateTime)
                .page(page);
                
        return Result.success(result);
    }
}