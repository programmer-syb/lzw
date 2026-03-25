package org.example.lzw.entity.dto;

import lombok.Data;
import org.example.lzw.entity.StudentExamAnswer;
import java.util.List;

@Data
public class ExamSubmitDTO {
    private Long examId;
    // 学生的答题列表
    private List<StudentExamAnswer> answers; 
}