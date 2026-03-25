package org.example.lzw.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.example.lzw.common.Result;
import org.example.lzw.entity.Course;
import org.example.lzw.entity.SysUser;
import org.example.lzw.entity.StudentCourse;
import org.example.lzw.service.CourseService;
import org.example.lzw.service.SysUserService;
import org.example.lzw.service.StudentCourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/admin/statistics")
public class DataStatisticsController {

    @Autowired
    private SysUserService sysUserService;

    @Autowired
    private CourseService courseService;
    
    @Autowired
    private StudentCourseService studentCourseService;

    /**
     * 获取管理员首页数据看板的统计信息
     */
    @GetMapping("/dashboard")
    public Result<Map<String, Object>> getDashboardData() {
        Map<String, Object> data = new HashMap<>();

        // 1. 平台用户数量统计 (按角色分类)
        long studentCount = sysUserService.count(new LambdaQueryWrapper<SysUser>().eq(SysUser::getRole, 2));
        long teacherCount = sysUserService.count(new LambdaQueryWrapper<SysUser>().eq(SysUser::getRole, 1));
        
        Map<String, Long> userStats = new HashMap<>();
        userStats.put("totalStudents", studentCount);
        userStats.put("totalTeachers", teacherCount);
        data.put("users", userStats);

        // 2. 课程数量统计
        long totalCourses = courseService.count();
        long publishedCourses = courseService.count(new LambdaQueryWrapper<Course>().eq(Course::getStatus, 1));
        
        Map<String, Long> courseStats = new HashMap<>();
        courseStats.put("total", totalCourses);
        courseStats.put("published", publishedCourses);
        data.put("courses", courseStats);

        // 3. 学习活跃度统计 (总选课人次)
        long totalEnrollments = studentCourseService.count();
        data.put("totalEnrollments", totalEnrollments);

        // 这里还可以根据需求，通过自定义 Mapper XML 编写更复杂的 SQL 聚合查询，
        // 例如：查询“最受欢迎的 Top 5 课程”、“近七天的系统访问量”等。

        return Result.success(data);
    }
}