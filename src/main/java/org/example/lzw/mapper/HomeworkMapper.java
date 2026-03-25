package org.example.lzw.mapper;

import org.example.lzw.entity.Homework;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 教师发布作业表 Mapper 接口
 * </p>
 *
 * @author syb
 * @since 2026-03-25
 */
@Mapper
public interface HomeworkMapper extends BaseMapper<Homework> {

}
