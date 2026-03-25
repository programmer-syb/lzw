package org.example.lzw.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.example.lzw.common.Result;
import org.example.lzw.entity.StudentHomework;
import org.example.lzw.service.StudentHomeworkService;
import org.example.lzw.utils.UserContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/student-homework")
public class StudentHomeworkController {

    @Autowired
    private StudentHomeworkService studentHomeworkService;

    /**
     * 1. 学生提交作业 (支持文本和文件URL)
     */
    @PostMapping("/submit")
    public Result<String> submitHomework(@RequestBody StudentHomework studentHomework) {
        Long studentId = UserContext.getUserId();

        // 检查是否已经提交过
        LambdaQueryWrapper<StudentHomework> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudentHomework::getStudentId, studentId)
                .eq(StudentHomework::getHomeworkId, studentHomework.getHomeworkId());

        if (studentHomeworkService.count(wrapper) > 0) {
            return Result.error("您已提交过该作业，请勿重复提交");
        }

        studentHomework.setStudentId(studentId);
        studentHomework.setStatus(1); // 状态: 1-已提交待批改
        studentHomework.setSubmitTime(LocalDateTime.now());

        boolean saved = studentHomeworkService.save(studentHomework);
        return saved ? Result.success("作业提交成功") : Result.error("作业提交失败");
    }

    /**
     * 2. 学生查看自己的作业提交记录及评分评语
     */
    @GetMapping("/my/{homeworkId}")
    public Result<StudentHomework> getMySubmission(@PathVariable Long homeworkId) {
        Long studentId = UserContext.getUserId();

        LambdaQueryWrapper<StudentHomework> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudentHomework::getStudentId, studentId)
                .eq(StudentHomework::getHomeworkId, homeworkId);

        StudentHomework submission = studentHomeworkService.getOne(wrapper);
        return Result.success(submission);
    }

    /**
     * 3. 教师获取某次作业的所有学生提交记录 (用于批改列表)
     */
    @GetMapping("/list/{homeworkId}")
    public Result<List<StudentHomework>> getListByHomeworkId(@PathVariable Long homeworkId) {
        // 实际业务中，可以在这里加一层校验：当前登录的教师是否是该作业所属课程的创建者
        List<StudentHomework> list = studentHomeworkService.lambdaQuery()
                .eq(StudentHomework::getHomeworkId, homeworkId)
                .orderByDesc(StudentHomework::getSubmitTime)
                .list();
        return Result.success(list);
    }

    /**
     * 4. 教师批改作业 (打分并给出评语)
     */
    @PutMapping("/grade")
    public Result<String> gradeHomework(@RequestBody StudentHomework gradingInfo) {
        if (gradingInfo.getId() == null || gradingInfo.getScore() == null) {
            return Result.error("作业提交记录ID和分数不能为空");
        }

        StudentHomework record = studentHomeworkService.getById(gradingInfo.getId());
        if (record == null) {
            return Result.error("未找到该作业提交记录");
        }

        record.setScore(gradingInfo.getScore());
        record.setTeacherComment(gradingInfo.getTeacherComment());
        record.setStatus(2); // 状态: 2-已批改

        boolean updated = studentHomeworkService.updateById(record);
        return updated ? Result.success("批改成功") : Result.error("批改失败");
    }
}