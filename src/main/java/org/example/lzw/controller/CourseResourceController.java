package org.example.lzw.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.lzw.common.Result;
import org.example.lzw.entity.CourseResource;
import org.example.lzw.service.CourseResourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/resource")
public class CourseResourceController {

    @Autowired
    private CourseResourceService resourceService;

    /**
     * 1. 获取指定章节下的所有教学资源
     */
    @GetMapping("/list/{chapterId}")
    public Result<List<CourseResource>> getListByChapterId(@PathVariable Long chapterId) {
        List<CourseResource> list = resourceService.lambdaQuery()
                .eq(CourseResource::getChapterId, chapterId)
                .orderByAsc(CourseResource::getCreateTime) // 按上传时间排序
                .list();
        return Result.success(list);
    }

    /**
     * 2. 关联教学资源
     * 前端先调用 /file/upload 接口上传视频或课件拿到 URL，再调用此接口将其与章节绑定
     */
    @PostMapping("/add")
    public Result<String> addResource(@RequestBody CourseResource resource) {
        if (resource.getChapterId() == null || resource.getUrl() == null || resource.getType() == null) {
            return Result.error("章节ID、资源类型和资源URL不能为空");
        }

        // type 字段建议由前端约定传值，例如: video, pdf, ppt, word
        boolean saved = resourceService.save(resource);
        return saved ? Result.success("资源添加成功") : Result.error("资源添加失败");
    }

    /**
     * 3. 更新资源信息（例如：重命名文件展示名称）
     */
    @PutMapping("/update")
    public Result<String> updateResource(@RequestBody CourseResource resource) {
        if (resource.getId() == null) {
            return Result.error("资源ID不能为空");
        }
        boolean updated = resourceService.updateById(resource);
        return updated ? Result.success("资源更新成功") : Result.error("资源更新失败");
    }

    /**
     * 4. 删除资源记录
     */
    @DeleteMapping("/delete/{id}")
    public Result<String> deleteResource(@PathVariable Long id) {
        boolean removed = resourceService.removeById(id);
        return removed ? Result.success("资源删除成功") : Result.error("资源删除失败");
    }

    /**
     * 5. 管理员接口：全局分页获取所有上传的教学资源
     */
    @GetMapping("/admin/list")
    public Result<Page<CourseResource>> getAdminResourceList(
            @RequestParam(defaultValue = "1") Integer current,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String type) {

        Page<CourseResource> page = new Page<>(current, size);
        LambdaQueryWrapper<CourseResource> wrapper = new LambdaQueryWrapper<>();

        // 资源名称搜索
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.like(CourseResource::getName, keyword);
        }
        // 按格式过滤 (video, pdf 等)
        if (type != null && !type.trim().isEmpty()) {
            wrapper.eq(CourseResource::getType, type);
        }

        wrapper.orderByDesc(CourseResource::getCreateTime);
        return Result.success(resourceService.page(page, wrapper));
    }
}