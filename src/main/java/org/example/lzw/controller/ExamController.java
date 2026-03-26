package org.example.lzw.controller;

import org.example.lzw.common.Result;
import org.example.lzw.entity.Exam;
import org.example.lzw.entity.ExamQuestion;
import org.example.lzw.service.ExamService;
import org.example.lzw.service.ExamQuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/exam")
public class ExamController {

    @Autowired
    private ExamService examService;
    @Autowired
    private ExamQuestionService questionService;

    // --- 考试基本信息管理 ---
    @PostMapping("/add")
    public Result<String> addExam(@RequestBody Exam exam) {
        if (exam.getCourseId() == null || exam.getTitle() == null) {
            return Result.error("课程ID和考试名称不能为空");
        }
        exam.setStatus(0); // 默认草稿状态
        boolean saved = examService.save(exam);
        return saved ? Result.success("考试创建成功") : Result.error("考试创建失败");
    }

    // --- 题目管理 ---
    @PostMapping("/question/add")
    public Result<String> addQuestion(@RequestBody ExamQuestion question) {
        questionService.save(question);
        return Result.success("题目添加成功");
    }

    @GetMapping("/question/list/{examId}")
    public Result<List<ExamQuestion>> getQuestions(@PathVariable Long examId) {
        List<ExamQuestion> list = questionService.lambdaQuery()
                .eq(ExamQuestion::getExamId, examId)
                .list();
        // 如果是学生调这个接口，实际需要将答案字段 (answer) 置空再返回，防止作弊
        return Result.success(list);
    }

    /**
     * 教师获取某门课程下的考试/测验列表
     */
    @GetMapping("/list/{courseId}")
    public Result<List<Exam>> getExamListByCourseId(@PathVariable Long courseId) {
        List<Exam> list = examService.lambdaQuery()
                .eq(Exam::getCourseId, courseId)
                // 按创建时间倒序排列
                .orderByDesc(Exam::getCreateTime)
                .list();
        return Result.success(list);
    }
    /**
     * 更新考试信息（前端用于发布：status=1）
     */
    @PutMapping("/update")
    public Result<String> updateExam(@RequestBody Exam exam) {
        if (exam.getId() == null) {
            return Result.error("考试ID不能为空");
        }
        boolean updated = examService.updateById(exam);
        return updated ? Result.success("考试状态更新成功") : Result.error("考试状态更新失败");
    }
}