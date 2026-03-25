package org.example.lzw.mapper;

import org.example.lzw.entity.Course;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 课程信息表 Mapper 接口
 * </p>
 *
 * @author syb
 * @since 2026-03-25
 */
@Mapper
public interface CourseMapper extends BaseMapper<Course> {

}
