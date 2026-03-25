package org.example.lzw.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.lzw.common.Result;
import org.example.lzw.entity.Course;
import org.example.lzw.entity.StudentCourse;
import org.example.lzw.entity.SysUser;
import org.example.lzw.service.CourseService;
import org.example.lzw.service.StudentCourseService;
import org.example.lzw.service.SysUserService;
import org.example.lzw.utils.UserContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/course")
public class CourseController {

    @Autowired
    private CourseService courseService;
    @Autowired
    private SysUserService sysUserService;
    @Autowired
    private StudentCourseService studentCourseService;

    /**
     * 1. 教师发布(创建)新课程
     */
    @PostMapping("/add")
    public Result<String> addCourse(@RequestBody Course course) {
        // 从当前线程上下文中获取登录用户的 ID 作为教师 ID
        Long teacherId = UserContext.getUserId();
        if (teacherId == null) {
            return Result.error("获取当前用户信息失败，请重新登录");
        }

        course.setTeacherId(teacherId);
        // 默认状态 0-未发布 (可以根据需求后续修改为 1)
        course.setStatus(0);

        boolean saved = courseService.save(course);
        return saved ? Result.success("课程创建成功") : Result.error("课程创建失败");
    }

    /**
     * 2. 获取当前教师的课程列表 (带分页)
     * GET /course/myList?current=1&size=10
     */
    @GetMapping("/myList")
    public Result<Page<Course>> getMyCourseList(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size) {

        Long teacherId = UserContext.getUserId();

        Page<Course> page = new Page<>(current, size);
        LambdaQueryWrapper<Course> wrapper = new LambdaQueryWrapper<>();
        // 只查询当前登录教师自己创建的课程，并按创建时间倒序
        wrapper.eq(Course::getTeacherId, teacherId)
                .orderByDesc(Course::getCreateTime);

        Page<Course> resultPage = courseService.page(page, wrapper);
        return Result.success(resultPage);
    }

    /**
     * 3. 教师修改课程信息 (如：更新封面、大纲、分类等)
     */
    @PutMapping("/update")
    public Result<String> updateCourse(@RequestBody Course course) {
        if (course.getId() == null) {
            return Result.error("课程ID不能为空");
        }

        // 严谨起见：可以校验该课程是否属于当前操作的教师
        Course existingCourse = courseService.getById(course.getId());
        if (existingCourse == null || !existingCourse.getTeacherId().equals(UserContext.getUserId())) {
            return Result.error("无权修改此课程");
        }

        boolean updated = courseService.updateById(course);
        return updated ? Result.success("课程更新成功") : Result.error("课程更新失败");
    }

    /**
     * 4. 教师下架/删除课程 (逻辑删除)
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> deleteCourse(@PathVariable Long id) {
        Course existingCourse = courseService.getById(id);
        if (existingCourse == null || !existingCourse.getTeacherId().equals(UserContext.getUserId())) {
            return Result.error("无权删除此课程");
        }

        boolean removed = courseService.removeById(id);
        return removed ? Result.success("课程删除成功") : Result.error("课程删除失败");
    }

    /**
     * 5. 更新课程状态 (上架/下架)
     */
    @PutMapping("/changeStatus/{id}/{status}")
    public Result<String> changeStatus(@PathVariable Long id, @PathVariable Integer status) {
        Course course = new Course();
        course.setId(id);
        course.setStatus(status);
        boolean updated = courseService.updateById(course);
        return updated ? Result.success("状态更新成功") : Result.error("状态更新失败");
    }

    /**
     * 6. 公共接口：分页条件查询已发布的课程 (供大厅展示和搜索)
     */
    @GetMapping("/public/list")
    public Result<Page<Course>> getPublicCourseList(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String keyword) {

        Page<Course> page = new Page<>(current, size);
        LambdaQueryWrapper<Course> wrapper = new LambdaQueryWrapper<>();

        // 只查询状态为 1 (已发布) 的课程
        wrapper.eq(Course::getStatus, 1);

        // 可选分类过滤
        if (categoryId != null) {
            wrapper.eq(Course::getCategoryId, categoryId);
        }
        // 可选关键词模糊搜索 (匹配标题或简介)
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.and(w -> w.like(Course::getTitle, keyword).or().like(Course::getIntro, keyword));
        }

        wrapper.orderByDesc(Course::getCreateTime);
        return Result.success(courseService.page(page, wrapper));
    }

    /**
     * 7. 公共接口：获取课程详细信息 (包含教师姓名)
     */
    @GetMapping("/public/detail/{id}")
    public Result<java.util.Map<String, Object>> getCourseDetail(@PathVariable Long id) {
        Course course = courseService.getById(id);
        if (course == null || course.getStatus() == 0) {
            return Result.error("该课程不存在或已下架");
        }

        // 查询教师信息
        SysUser teacher = sysUserService.getById(course.getTeacherId());

        // 组装返回数据
        java.util.Map<String, Object> detail = new java.util.HashMap<>();
        detail.put("course", course);
        detail.put("teacherName", teacher != null ? teacher.getNickname() : "未知教师");
        detail.put("teacherAvatar", teacher != null ? teacher.getAvatar() : null);

        return Result.success(detail);
    }
    /**
     * 8.教师查看某课程的选课学生及进度
     */
    @GetMapping("/students/{courseId}")
    public Result<List<org.example.lzw.entity.dto.StudentProgressDTO>> getCourseStudents(@PathVariable Long courseId) {
        // 1. 校验该课程是否是当前教师的
        Course course = courseService.getById(courseId);
        if (course == null || !course.getTeacherId().equals(UserContext.getUserId())) {
            return Result.error("无权查看此课程的学生信息");
        }

        // 2. 查询选课记录
        List<StudentCourse> scList = studentCourseService.lambdaQuery()
                .eq(StudentCourse::getCourseId, courseId)
                .list();

        // 3. 关联查询学生信息并组装 DTO
        List<org.example.lzw.entity.dto.StudentProgressDTO> resultList = new java.util.ArrayList<>();
        for (StudentCourse sc : scList) {
            SysUser student = sysUserService.getById(sc.getStudentId());
            if (student != null) {
                org.example.lzw.entity.dto.StudentProgressDTO dto = new org.example.lzw.entity.dto.StudentProgressDTO();
                dto.setStudentId(student.getId());
                dto.setNickname(student.getNickname());
                dto.setAvatar(student.getAvatar());
                dto.setMajor(student.getMajor());
                dto.setProgress(sc.getProgress());
                dto.setWatchTime(sc.getWatchTime());
                resultList.add(dto);
            }
        }
        return Result.success(resultList);
    }
}