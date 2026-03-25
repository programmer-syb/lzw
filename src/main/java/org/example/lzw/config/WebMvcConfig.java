package org.example.lzw.config;

import org.example.lzw.interceptor.JwtInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private JwtInterceptor jwtInterceptor;

    // 1. 配置静态资源映射
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 将匹配 /uploads/** 的请求路由到本地绝对路径
        String uploadPath = System.getProperty("user.dir") + "/uploads/";
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadPath);
    }

    // 2. 拦截器配置
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/user/login",
                        "/user/register",
                        "/category/list",
                        "/uploads/**",     // 【新增】放行静态资源文件访问！
                        "/error",
                        "/favicon.ico",
                        "/course/public/**"
                );
    }
}