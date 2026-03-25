package org.example.lzw.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.lzw.entity.StudentExam;
import org.example.lzw.mapper.StudentExamMapper;
import org.example.lzw.service.StudentExamService;
import org.springframework.stereotype.Service;

@Service
public class StudentExamServiceImpl
        extends ServiceImpl<StudentExamMapper, StudentExam>
        implements StudentExamService {
}