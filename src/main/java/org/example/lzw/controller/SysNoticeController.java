package org.example.lzw.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.lzw.common.Result;
import org.example.lzw.entity.SysNotice;
import org.example.lzw.service.SysNoticeService;
import org.example.lzw.utils.UserContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/notice")
public class SysNoticeController {

    @Autowired
    private SysNoticeService noticeService;

    @PostMapping("/add")
    public Result<String> addNotice(@RequestBody SysNotice notice) {
        notice.setSenderId(UserContext.getUserId());
        boolean saved = noticeService.save(notice);
        return saved ? Result.success("公告发布成功") : Result.error("公告发布失败");
    }

    @GetMapping("/list")
    public Result<Page<SysNotice>> getNoticeList(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size) {
        Page<SysNotice> page = new Page<>(current, size);
        return Result.success(noticeService.page(page));
    }

    @DeleteMapping("/delete/{id}")
    public Result<String> deleteNotice(@PathVariable Long id) {
        boolean removed = noticeService.removeById(id);
        return removed ? Result.success("删除成功") : Result.error("删除失败");
    }
}