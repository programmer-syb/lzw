package org.example.lzw.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.lzw.entity.Exam;
import org.example.lzw.mapper.ExamMapper;
import org.example.lzw.service.ExamService;
import org.springframework.stereotype.Service;

@Service
public class ExamServiceImpl
        extends ServiceImpl<ExamMapper, Exam>
        implements ExamService {
}