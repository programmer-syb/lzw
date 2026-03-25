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
        examService.save(exam);
        return Result.success("考试创建成功");
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
}