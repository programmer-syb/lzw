package org.example.lzw.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.example.lzw.common.Result;
import org.example.lzw.entity.CourseDiscussion;
import org.example.lzw.service.CourseDiscussionService;
import org.example.lzw.utils.UserContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/discussion")
public class CourseDiscussionController {

    @Autowired
    private CourseDiscussionService discussionService;

    /**
     * 1. 发帖或回复
     */
    @PostMapping("/post")
    public Result<String> postMessage(@RequestBody CourseDiscussion discussion) {
        if (discussion.getCourseId() == null || discussion.getContent() == null) {
            return Result.error("课程ID和内容不能为空");
        }
        
        // 自动注入当前操作人ID
        discussion.setUserId(UserContext.getUserId());
        
        // 如果没有传 parentId，默认为 0（主贴）
        if (discussion.getParentId() == null) {
            discussion.setParentId(0L);
        }

        boolean saved = discussionService.save(discussion);
        return saved ? Result.success("发布成功") : Result.error("发布失败");
    }

    /**
     * 2. 获取课程的主贴列表
     */
    @GetMapping("/list/main/{courseId}")
    public Result<List<CourseDiscussion>> getMainPosts(@PathVariable Long courseId) {
        List<CourseDiscussion> list = discussionService.lambdaQuery()
                .eq(CourseDiscussion::getCourseId, courseId)
                .eq(CourseDiscussion::getParentId, 0L) // 只查主贴
                .orderByDesc(CourseDiscussion::getCreateTime)
                .list();
        return Result.success(list);
    }

    /**
     * 3. 获取某个主贴下的所有回复
     */
    @GetMapping("/list/replies/{parentId}")
    public Result<List<CourseDiscussion>> getReplies(@PathVariable Long parentId) {
        List<CourseDiscussion> list = discussionService.lambdaQuery()
                .eq(CourseDiscussion::getParentId, parentId)
                .orderByAsc(CourseDiscussion::getCreateTime) // 回复按时间正序
                .list();
        return Result.success(list);
    }
}