package org.example.lzw.controller;

import org.example.lzw.common.Result;
import org.example.lzw.entity.CourseCategory;
import org.example.lzw.service.CourseCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/category")
public class CourseCategoryController {

    @Autowired
    private CourseCategoryService categoryService;

    /**
     * 获取所有课程分类列表 (按照 sort 排序)
     */
    @GetMapping("/list")
    public Result<List<CourseCategory>> getList() {
        List<CourseCategory> list = categoryService.lambdaQuery()
                .orderByAsc(CourseCategory::getSort)
                .list();
        return Result.success(list);
    }

    /**
     * 新增课程分类
     */
    @PostMapping("/add")
    public Result<String> add(@RequestBody CourseCategory category) {
        boolean saved = categoryService.save(category);
        return saved ? Result.success("添加成功") : Result.error("添加失败");
    }

    /**
     * 修改课程分类
     */
    @PutMapping("/update")
    public Result<String> update(@RequestBody CourseCategory category) {
        if (category.getId() == null) {
            return Result.error("分类ID不能为空");
        }
        boolean updated = categoryService.updateById(category);
        return updated ? Result.success("修改成功") : Result.error("修改失败");
    }

    /**
     * 删除课程分类 (MyBatis-Plus 会自动执行逻辑删除)
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> delete(@PathVariable Long id) {
        boolean removed = categoryService.removeById(id);
        return removed ? Result.success("删除成功") : Result.error("删除失败");
    }
}