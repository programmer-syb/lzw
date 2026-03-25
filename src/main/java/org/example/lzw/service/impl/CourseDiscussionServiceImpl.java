package org.example.lzw.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.lzw.entity.CourseDiscussion;
import org.example.lzw.mapper.CourseDiscussionMapper;
import org.example.lzw.service.CourseDiscussionService;
import org.springframework.stereotype.Service;

@Service
public class CourseDiscussionServiceImpl
        extends ServiceImpl<CourseDiscussionMapper, CourseDiscussion>
        implements CourseDiscussionService {
}