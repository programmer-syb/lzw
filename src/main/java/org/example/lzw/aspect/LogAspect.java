package org.example.lzw.aspect;

import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.example.lzw.entity.SysLog;
import org.example.lzw.service.SysLogService;
import org.example.lzw.utils.UserContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Aspect
@Component
public class LogAspect {

    @Autowired
    private SysLogService sysLogService;

    // 定义切点：拦截 controller 包下的所有类的所有方法
    @Pointcut("execution(* org.example.lzw.controller.*.*(..))")
    public void logPointCut() {
    }

    @Around("logPointCut()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        long beginTime = System.currentTimeMillis();
        
        // 执行目标方法
        Object result = point.proceed();
        
        long time = System.currentTimeMillis() - beginTime;
        
        // 保存日志
        saveLog(point, time);
        
        return result;
    }

    private void saveLog(ProceedingJoinPoint joinPoint, long time) {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) return;
        
        HttpServletRequest request = attributes.getRequest();
        
        SysLog sysLog = new SysLog();
        // 获取操作耗时
        sysLog.setDuration(time);
        // 获取请求URI和方法类型
        sysLog.setUri(request.getRequestURI());
        // 获取调用的类名和方法名
        String className = joinPoint.getTarget().getClass().getName();
        String methodName = joinPoint.getSignature().getName();
        sysLog.setMethod(className + "." + methodName + "()");
        // 获取IP
        sysLog.setIp(request.getRemoteAddr());
        // 获取当前用户ID (如果未登录则为 null)
        sysLog.setUserId(UserContext.getUserId());
        
        // 存入数据库
        sysLogService.save(sysLog);
    }
}