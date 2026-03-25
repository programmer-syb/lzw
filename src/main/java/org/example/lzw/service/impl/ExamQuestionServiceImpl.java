package org.example.lzw.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.lzw.entity.ExamQuestion;
import org.example.lzw.mapper.ExamQuestionMapper;
import org.example.lzw.service.ExamQuestionService;
import org.springframework.stereotype.Service;

@Service
public class ExamQuestionServiceImpl
        extends ServiceImpl<ExamQuestionMapper, ExamQuestion>
        implements ExamQuestionService {
}