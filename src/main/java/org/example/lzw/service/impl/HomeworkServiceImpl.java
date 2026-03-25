package org.example.lzw.service.impl;

import org.example.lzw.entity.Homework;
import org.example.lzw.mapper.HomeworkMapper;
import org.example.lzw.service.HomeworkService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 教师发布作业表 服务实现类
 * </p>
 *
 * @author syb
 * @since 2026-03-25
 */
@Service
public class HomeworkServiceImpl extends ServiceImpl<HomeworkMapper, Homework> implements HomeworkService {

}
