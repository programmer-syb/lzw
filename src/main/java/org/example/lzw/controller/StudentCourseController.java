package org.example.lzw.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.lzw.common.Result;
import org.example.lzw.entity.StudentCourse;
import org.example.lzw.service.StudentCourseService;
import org.example.lzw.utils.UserContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;

@RestController
@RequestMapping("/student-course")
public class StudentCourseController {

    @Autowired
    private StudentCourseService studentCourseService;

    /**
     * 1. 学生选课 (报名)
     */
    @PostMapping("/enroll/{courseId}")
    public Result<String> enrollCourse(@PathVariable Long courseId) {
        Long studentId = UserContext.getUserId();

        // 检查是否已经选过这门课，防止重复报名
        LambdaQueryWrapper<StudentCourse> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudentCourse::getStudentId, studentId)
                .eq(StudentCourse::getCourseId, courseId);

        if (studentCourseService.count(wrapper) > 0) {
            return Result.error("您已经报名过该课程，无需重复报名");
        }

        // 新增选课记录
        StudentCourse studentCourse = new StudentCourse();
        studentCourse.setStudentId(studentId);
        studentCourse.setCourseId(courseId);
        studentCourse.setProgress(new BigDecimal("0.00")); // 初始进度 0%
        studentCourse.setWatchTime(0); // 初始观看时长 0秒

        boolean saved = studentCourseService.save(studentCourse);
        return saved ? Result.success("选课成功") : Result.error("选课失败");
    }

    /**
     * 2. 获取我的选课列表 (带分页)
     * GET /student-course/myList?current=1&size=10
     */
    @GetMapping("/myList")
    public Result<Page<StudentCourse>> getMyCourses(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size) {

        Long studentId = UserContext.getUserId();
        Page<StudentCourse> page = new Page<>(current, size);

        LambdaQueryWrapper<StudentCourse> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudentCourse::getStudentId, studentId)
                .orderByDesc(StudentCourse::getCreateTime);

        Page<StudentCourse> resultPage = studentCourseService.page(page, wrapper);
        // 注意：这里只返回了关联关系和进度。
        // 实际前端渲染时，可能还需要显示课程封面和名称，通常有两种做法：
        // 1. 前端拿到 courseId 后再去单独查课程详情 (较慢)
        // 2. 后端在这里写个连表查询 (更推荐，但目前为了演示基础流程先保持单表)
        return Result.success(resultPage);
    }

    /**
     * 3. 更新学习进度 (前端在播放视频时定时调用)
     */
    @PutMapping("/updateProgress")
    public Result<String> updateProgress(@RequestBody StudentCourse updateInfo) {
        Long studentId = UserContext.getUserId();

        // 根据 studentId 和 courseId 找到对应的记录
        LambdaQueryWrapper<StudentCourse> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudentCourse::getStudentId, studentId)
                .eq(StudentCourse::getCourseId, updateInfo.getCourseId());

        StudentCourse record = studentCourseService.getOne(wrapper);
        if (record == null) {
            return Result.error("未找到该课程的选课记录");
        }

        // 更新观看时长和进度百分比
        record.setWatchTime(updateInfo.getWatchTime());
        record.setProgress(updateInfo.getProgress());

        boolean updated = studentCourseService.updateById(record);
        return updated ? Result.success("进度更新成功") : Result.error("进度更新失败");
    }

    /**
     * 学生退课功能
     */
    @DeleteMapping("/drop/{courseId}")
    public Result<String> dropCourse(@PathVariable Long courseId) {
        Long studentId = UserContext.getUserId();

        LambdaQueryWrapper<StudentCourse> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudentCourse::getStudentId, studentId)
                .eq(StudentCourse::getCourseId, courseId);

        boolean removed = studentCourseService.remove(wrapper);
        return removed ? Result.success("退课成功") : Result.error("退课失败或未选修该课程");
    }
}