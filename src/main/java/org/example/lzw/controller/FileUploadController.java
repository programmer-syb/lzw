package org.example.lzw.controller;

import org.example.lzw.common.Result;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@RestController
@RequestMapping("/file")
public class FileUploadController {

    // 获取当前项目运行的根目录下的 uploads 文件夹
    private static final String UPLOAD_DIR = System.getProperty("user.dir") + "/uploads/";

    @PostMapping("/upload")
    public Result<String> upload(MultipartFile file, HttpServletRequest request) {
        if (file.isEmpty()) {
            return Result.error("上传文件不能为空");
        }

        try {
            // 1. 确保上传目录存在
            File dir = new File(UPLOAD_DIR);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // 2. 获取原始文件名并提取后缀 (例如: .jpg, .mp4)
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));

            // 3. 生成唯一的 UUID 文件名，防止重名覆盖
            String newFileName = UUID.randomUUID().toString().replace("-", "") + extension;

            // 4. 保存文件到本地磁盘
            File dest = new File(UPLOAD_DIR + newFileName);
            file.transferTo(dest);

            // 5. 动态拼接并返回可通过浏览器访问的静态 URL 
            // 格式: http://localhost:8080/uploads/xxxx.jpg
            String fileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/uploads/" + newFileName;
            
            return Result.success(fileUrl);
            
        } catch (IOException e) {
            e.printStackTrace();
            return Result.error("文件上传失败: " + e.getMessage());
        }
    }
}