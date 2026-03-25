package org.example.lzw.controller;

import org.example.lzw.common.Result;
import org.example.lzw.entity.CourseChapter;
import org.example.lzw.service.CourseChapterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/chapter")
public class CourseChapterController {

    @Autowired
    private CourseChapterService chapterService;

    /**
     * 1. 获取指定课程的所有章节（按照 sort 字段升序排列）
     */
    @GetMapping("/list/{courseId}")
    public Result<List<CourseChapter>> getListByCourseId(@PathVariable Long courseId) {
        List<CourseChapter> list = chapterService.lambdaQuery()
                .eq(CourseChapter::getCourseId, courseId)
                .orderByAsc(CourseChapter::getSort)
                .list();
        return Result.success(list);
    }

    /**
     * 2. 教师为课程添加新章节
     */
    @PostMapping("/add")
    public Result<String> addChapter(@RequestBody CourseChapter chapter) {
        if (chapter.getCourseId() == null) {
            return Result.error("所属课程ID不能为空");
        }
        boolean saved = chapterService.save(chapter);
        return saved ? Result.success("章节添加成功") : Result.error("章节添加失败");
    }

    /**
     * 3. 修改章节信息（如：修改章节名称或排序）
     */
    @PutMapping("/update")
    public Result<String> updateChapter(@RequestBody CourseChapter chapter) {
        if (chapter.getId() == null) {
            return Result.error("章节ID不能为空");
        }
        boolean updated = chapterService.updateById(chapter);
        return updated ? Result.success("章节更新成功") : Result.error("章节更新失败");
    }

    /**
     * 4. 删除章节
     * 注意：实际严谨的业务中，删除章节前可能需要校验该章节下是否还有视频资源
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> deleteChapter(@PathVariable Long id) {
        boolean removed = chapterService.removeById(id);
        return removed ? Result.success("章节删除成功") : Result.error("章节删除失败");
    }
}