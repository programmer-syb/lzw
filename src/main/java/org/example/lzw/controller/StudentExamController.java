package org.example.lzw.controller;

import org.example.lzw.common.Result;
import org.example.lzw.entity.ExamQuestion;
import org.example.lzw.entity.StudentExam;
import org.example.lzw.entity.StudentExamAnswer;
import org.example.lzw.entity.dto.ExamSubmitDTO;
import org.example.lzw.service.ExamQuestionService;
import org.example.lzw.service.StudentExamService;
import org.example.lzw.service.StudentExamAnswerService;
import org.example.lzw.utils.UserContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/student-exam")
public class StudentExamController {

    @Autowired
    private StudentExamService studentExamService;
    @Autowired
    private StudentExamAnswerService answerService;
    @Autowired
    private ExamQuestionService questionService;

    /**
     * 学生交卷与自动判分逻辑
     */
    @PostMapping("/submit")
    @Transactional // 开启事务，保证考试主记录和答题明细的一致性
    public Result<String> submitExam(@RequestBody ExamSubmitDTO submitDTO) {
        // 1. 获取当前登录学生 ID
        Long studentId = UserContext.getUserId();
        if (studentId == null) {
            return Result.error("未获取到登录信息，请重新登录");
        }

        // 2. 初始化考试主记录
        StudentExam studentExam = new StudentExam();
        studentExam.setExamId(submitDTO.getExamId());
        studentExam.setStudentId(studentId);
        studentExam.setSubmitTime(LocalDateTime.now());
        studentExam.setStatus(0); // 初始状态：考试中/处理中

        // 插入记录以获取自增的主考试记录 ID
        studentExamService.save(studentExam);

        int totalScore = 0; // 累计客观题得分
        boolean needManualGrading = false; // 是否包含需要人工批改的简答题

        // 3. 处理每一道题目的答案
        List<StudentExamAnswer> answers = submitDTO.getAnswers();
        for (StudentExamAnswer studentAnswer : answers) {
            // 关联主记录 ID
            studentAnswer.setStudentExamId(studentExam.getId());

            // 查询题目信息以获取标准答案和分值
            ExamQuestion question = questionService.getById(studentAnswer.getQuestionId());
            if (question == null) continue;

            // 根据题目类型判分
            if (question.getType() == 1) {
                // 【客观题：单选题】
                // 忽略大小写对比答案
                if (question.getAnswer().equalsIgnoreCase(studentAnswer.getStudentAnswer())) {
                    studentAnswer.setScore(question.getScore());
                    totalScore += question.getScore();
                } else {
                    studentAnswer.setScore(0);
                }
            } else if (question.getType() == 2) {
                // 【主观题：简答题】
                // 简答题初始分数为0，标记需要人工批改
                studentAnswer.setScore(0);
                needManualGrading = true;
            }
        }

        // 4. 批量保存学生答题明细
        answerService.saveBatch(answers);

        // 5. 更新主记录的状态和总分
        studentExam.setTotalScore(totalScore);
        // 如果有简答题，状态设为 1-已交卷待批改；否则设为 2-已出成绩
        studentExam.setStatus(needManualGrading ? 1 : 2);
        studentExamService.updateById(studentExam);

        // 6. 返回结果信息
        if (needManualGrading) {
            return Result.success("交卷成功！由于包含简答题，请等待教师批改。当前客观题得分：" + totalScore);
        } else {
            return Result.success("交卷成功！自动评分完成，您的最终得分为：" + totalScore);
        }
    }

    /**
     * 获取当前学生在某个考试中的记录/成绩
     */
    @GetMapping("/myRecord/{examId}")
    public Result<StudentExam> getMyExamRecord(@PathVariable Long examId) {
        Long studentId = UserContext.getUserId();
        StudentExam record = studentExamService.lambdaQuery()
                .eq(StudentExam::getExamId, examId)
                .eq(StudentExam::getStudentId, studentId)
                .one();
        return Result.success(record);
    }

    /**
     * 教师获取某场考试的所有学生提交记录
     */
    @GetMapping("/teacher/list/{examId}")
    public Result<List<StudentExam>> getExamSubmissions(@PathVariable Long examId) {
        List<StudentExam> list = studentExamService.lambdaQuery()
                .eq(StudentExam::getExamId, examId)
                .orderByDesc(StudentExam::getSubmitTime)
                .list();
        return Result.success(list);
    }

    /**
     * 教师获取某个学生的具体答题详情 (用于批改)
     */
    @GetMapping("/teacher/detail/{studentExamId}")
    public Result<List<StudentExamAnswer>> getSubmissionDetail(@PathVariable Long studentExamId) {
        List<StudentExamAnswer> detail = answerService.lambdaQuery()
                .eq(StudentExamAnswer::getStudentExamId, studentExamId)
                .list();
        return Result.success(detail);
    }

    /**
     * 教师提交批改结果
     */
    @PutMapping("/teacher/grade")
    @Transactional
    public Result<String> gradeSubmission(@RequestBody List<StudentExamAnswer> answers) {
        if (answers == null || answers.isEmpty()) return Result.error("提交数据为空");

        // 更新每一道题的分数和评语
        answerService.updateBatchById(answers);

        // 重新计算总分
        Long studentExamId = answers.get(0).getStudentExamId();
        int finalScore = answers.stream().mapToInt(StudentExamAnswer::getScore).sum();

        // 更新主表状态为 2 (已出成绩)
        studentExamService.lambdaUpdate()
                .set(StudentExam::getTotalScore, finalScore)
                .set(StudentExam::getStatus, 2)
                .eq(StudentExam::getId, studentExamId)
                .update();

        return Result.success("批改成功，成绩已发布");
    }
}