package org.example.lzw.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.lzw.entity.StudentExamAnswer;
import org.example.lzw.mapper.StudentExamAnswerMapper;
import org.example.lzw.service.StudentExamAnswerService;
import org.springframework.stereotype.Service;

@Service
public class StudentExamAnswerServiceImpl
        extends ServiceImpl<StudentExamAnswerMapper, StudentExamAnswer>
        implements StudentExamAnswerService {
}