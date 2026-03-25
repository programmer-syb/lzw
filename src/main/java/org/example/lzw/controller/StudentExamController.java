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
    @Transactional // 开启事务，保证交卷记录和答题明细同时成功或失败
    public Result<String> submitExam(@RequestBody ExamSubmitDTO submitDTO) {
        Long studentId = UserContext.getUserId();
        
        // 1. 生成主考试记录
        StudentExam studentExam = new StudentExam();
        studentExam.setExamId(submitDTO.getExamId());
        studentExam.setStudentId(studentId);
        studentExam.setSubmitTime(LocalDateTime.now());
        
        int totalScore = 0;
        boolean needManualGrading = false; // 是否需要手动批改(存在简答题)

        // 暂时保存主记录获取自增 ID
        studentExamService.save(studentExam);

        // 2. 遍历学生的每一道答题进行判分
        for (StudentExamAnswer studentAnswer : submitDTO.getAnswers()) {
            studentAnswer.setStudentExamId(studentExam.getId());
            
            // 查询原题的标准答案和分值
            ExamQuestion question = questionService.getById(studentAnswer.getQuestionId());
            
            if (question.getType() == 1) { 
                // 【客观题：单选题自动判分】
                if (question.getAnswer().equalsIgnoreCase(studentAnswer.getStudentAnswer())) {
                    studentAnswer.setScore(question.getScore());
                    totalScore += question.getScore();
                } else {
                    studentAnswer.setScore(0);
                }
            } else if (question.getType() == 2) {
                // 【主观题：简答题待批改】
                studentAnswer.setScore(0);
                needManualGrading = true;
            }
        }
        
        // 批量保存学生答题明细
        answerService.saveBatch(submitDTO.getAnswers());

        // 3. 更新主记录的状态和总分
        studentExam.setTotalScore(totalScore);
        studentExam.setStatus(needManualGrading ? 1 : 2); // 1-待批改，2-已出成绩
        studentExamService.updateById(studentExam);

        return needManualGrading ? Result.success("交卷成功，部分简答题等待教师批改") : Result.success("交卷成功，自动评分完成，得分为：" + totalScore);
    }
}