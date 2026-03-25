package org.example.lzw.interceptor;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.lzw.common.Result;
import org.example.lzw.utils.JwtUtils;
import org.example.lzw.utils.UserContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class JwtInterceptor implements HandlerInterceptor {

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1. 放行前端的 OPTIONS 预检请求 (解决跨域机制带来的问题)
        if ("OPTIONS".equals(request.getMethod())) {
            return true;
        }

        // 2. 从请求头获取 Token (前端通常放在 Authorization 字段，并以 Bearer 开头)
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7); // 去除 "Bearer " 前缀
        }

        if (token == null || token.isEmpty()) {
            returnError(response, 401, "未登录，请先登录");
            return false;
        }

        // 3. 使用 JwtUtils 解析 Token
        Claims claims = JwtUtils.parseToken(token);
        if (claims == null) {
            returnError(response, 401, "Token无效或已过期，请重新登录");
            return false;
        }

        // 4. 获取用户 ID
        Long userId = claims.get("userId", Long.class);

        // 5. 校验 Redis 中是否存在该 Token (用于防止用户在其他地方退出登录后，旧Token仍能使用)
        String redisKey = "login:token:" + userId;
        String redisToken = (String) redisTemplate.opsForValue().get(redisKey);
        
        if (redisToken == null || !redisToken.equals(token)) {
            returnError(response, 401, "登录已失效，请重新登录");
            return false;
        }

        // 6. 校验通过，将 userId 存入当前线程上下文
        UserContext.setUserId(userId);
        
        // 7. 放行
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        // 请求处理完毕后，无论是否发生异常，都要清理 ThreadLocal，防止内存溢出
        UserContext.remove();
    }

    /**
     * 封装返回错误信息的 JSON
     */
    private void returnError(HttpServletResponse response, Integer code, String msg) throws Exception {
        response.setContentType("application/json;charset=UTF-8");
        Result<String> result = Result.error(code, msg);
        ObjectMapper mapper = new ObjectMapper();
        response.getWriter().write(mapper.writeValueAsString(result));
    }
}