package org.example.lzw.config;

import org.example.lzw.common.Result;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 捕获所有 Exception 异常
     */
    @ExceptionHandler(Exception.class)
    public Result<String> handleException(Exception e) {
        // 在控制台打印完整的错误信息，方便后端调试
        e.printStackTrace();
        
        // 返回统一的 JSON 格式给前端
        return Result.error(500, "系统繁忙或发生异常: " + e.getMessage());
    }
}