package org.example.lzw.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.example.lzw.common.Result;
import org.example.lzw.entity.Course;
import org.example.lzw.entity.Homework;
import org.example.lzw.entity.StudentCourse;
import org.example.lzw.entity.StudentHomework;
import org.example.lzw.service.CourseService;
import org.example.lzw.service.HomeworkService;
import org.example.lzw.service.StudentCourseService;
import org.example.lzw.service.StudentHomeworkService;
import org.example.lzw.utils.UserContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/teacher/statistics")
public class TeacherStatisticsController {

    @Autowired
    private CourseService courseService;
    @Autowired
    private StudentCourseService studentCourseService;
    @Autowired
    private HomeworkService homeworkService;
    @Autowired
    private StudentHomeworkService studentHomeworkService;

    @GetMapping("/dashboard")
    public Result<Map<String, Object>> getTeacherDashboard() {
        Long teacherId = UserContext.getUserId();
        Map<String, Object> data = new HashMap<>();

        // 1. 我发布的课程总数
        List<Course> myCourses = courseService.lambdaQuery().eq(Course::getTeacherId, teacherId).list();
        data.put("totalCourses", myCourses.size());

        if (myCourses.isEmpty()) {
            data.put("totalStudents", 0);
            data.put("totalHomeworkSubmissions", 0);
            return Result.success(data);
        }

        // 提取我的所有课程 ID
        List<Long> courseIds = myCourses.stream().map(Course::getId).collect(Collectors.toList());

        // 2. 学习我课程的总人次
        long totalStudents = studentCourseService.lambdaQuery().in(StudentCourse::getCourseId, courseIds).count();
        data.put("totalStudents", totalStudents);

        // 3. 我发布的作业总被提交的次数
        List<Homework> myHomeworks = homeworkService.lambdaQuery().in(Homework::getCourseId, courseIds).list();
        if (!myHomeworks.isEmpty()) {
            List<Long> hwIds = myHomeworks.stream().map(Homework::getId).collect(Collectors.toList());
            long totalSubmissions = studentHomeworkService.lambdaQuery().in(StudentHomework::getHomeworkId, hwIds).count();
            data.put("totalHomeworkSubmissions", totalSubmissions);
        } else {
            data.put("totalHomeworkSubmissions", 0);
        }

        return Result.success(data);
    }
}