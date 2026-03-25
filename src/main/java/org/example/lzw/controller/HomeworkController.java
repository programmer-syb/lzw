package org.example.lzw.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.example.lzw.common.Result;
import org.example.lzw.entity.Homework;
import org.example.lzw.service.HomeworkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/homework")
public class HomeworkController {

    @Autowired
    private HomeworkService homeworkService;

    /**
     * 1. 教师发布作业
     */
    @PostMapping("/publish")
    public Result<String> publishHomework(@RequestBody Homework homework) {
        if (homework.getCourseId() == null || homework.getTitle() == null || homework.getDeadline() == null) {
            return Result.error("课程ID、作业标题和截止时间不能为空");
        }

        boolean saved = homeworkService.save(homework);
        return saved ? Result.success("作业发布成功") : Result.error("作业发布失败");
    }

    /**
     * 2. 查询某课程下的所有作业列表
     * 这个接口不仅教师可以用来查看自己发布的作业，学生进入课程后也能查看到作业列表
     */
    @GetMapping("/list/{courseId}")
    public Result<List<Homework>> getListByCourseId(@PathVariable Long courseId) {
        List<Homework> list = homeworkService.lambdaQuery()
                .eq(Homework::getCourseId, courseId)
                .orderByDesc(Homework::getCreateTime) // 按发布时间倒序排列
                .list();
        return Result.success(list);
    }

    /**
     * 3. 教师修改作业 (修改标题、内容要求、截止时间等)
     */
    @PutMapping("/update")
    public Result<String> updateHomework(@RequestBody Homework homework) {
        if (homework.getId() == null) {
            return Result.error("作业ID不能为空");
        }
        boolean updated = homeworkService.updateById(homework);
        return updated ? Result.success("作业修改成功") : Result.error("作业修改失败");
    }

    /**
     * 4. 教师删除作业 (逻辑删除)
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> deleteHomework(@PathVariable Long id) {
        boolean removed = homeworkService.removeById(id);
        return removed ? Result.success("作业删除成功") : Result.error("作业删除失败");
    }
}