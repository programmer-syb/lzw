package org.example.lzw.service.impl;

import org.example.lzw.entity.Course;
import org.example.lzw.mapper.CourseMapper;
import org.example.lzw.service.CourseService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 课程信息表 服务实现类
 * </p>
 *
 * @author syb
 * @since 2026-03-25
 */
@Service
public class CourseServiceImpl extends ServiceImpl<CourseMapper, Course> implements CourseService {

}
