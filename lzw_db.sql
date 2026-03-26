/*
 Navicat Premium Data Transfer

 Source Server         : First
 Source Server Type    : MySQL
 Source Server Version : 50743
 Source Host           : localhost:3306
 Source Schema         : lzw_db

 Target Server Type    : MySQL
 Target Server Version : 50743
 File Encoding         : 65001

 Date: 26/03/2026 19:03:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '课程名称 [cite: 66]',
  `intro` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '课程简介 [cite: 66]',
  `syllabus` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '教学大纲 [cite: 11]',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '课程封面图URL [cite: 66]',
  `teacher_id` bigint(20) NOT NULL COMMENT '授课教师ID [cite: 11]',
  `category_id` bigint(20) NOT NULL COMMENT '课程分类ID',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态: 0-未发布/下架, 1-已发布 [cite: 69]',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(4) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, 'Java 核心技术实战', '从零开始掌握 Java 编程，深入理解 JVM、多线程与并发编程。', '1. 环境搭建\n2. 基础语法\n3. 面向对象\n4. 集合框架', 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600', 2, 1, 1, '2026-03-25 23:11:01', '2026-03-26 18:47:58', 0);
INSERT INTO `course` VALUES (2, 'Vue 3 + Vite 前端架构', '探索现代前端开发的最佳实践，掌握组合式 API 与响应式原理。', '1. Vue3 基础\n2. 组件化开发\n3. 全家桶实战', 'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?w=600', 2, 1, 1, '2026-03-25 23:11:01', '2026-03-25 23:11:01', 0);
INSERT INTO `course` VALUES (3, 'UI/UX 设计系统指南', '遵循 Apple 设计规范，打造极致的用户体验与视觉美感。', '1. 色彩理论\n2. 栅格系统\n3. 交互逻辑', 'https://images.unsplash.com/photo-1586717791821-3f44a563eb4c?w=600', 3, 2, 1, '2026-03-25 23:11:01', '2026-03-25 23:11:01', 0);
INSERT INTO `course` VALUES (4, 'Python 机器学习入门', '进入 AI 领域，学习常用算法、数据预处理及 Scikit-learn 实战。', '1. 数学基础\n2. 回归算法\n3. 神经网络', 'https://images.unsplash.com/photo-1527477321055-430197a5f3ad?w=600', 3, 3, 1, '2026-03-25 23:11:01', '2026-03-26 16:01:58', 0);
INSERT INTO `course` VALUES (5, '哈哈哈', '1111', '11111', 'http://localhost:8080/uploads/8b6999e17a99478ab6824ce07180e6bb.jpg', 2, 4, 1, '2026-03-26 16:29:48', '2026-03-26 17:44:28', 1);
INSERT INTO `course` VALUES (6, 'LZW', 'hhh', '1.hhhhh', 'http://localhost:8080/uploads/5e4b1c0481f84b96a68e3051490003ce.jpg', 2, 4, 1, '2026-03-26 17:45:07', '2026-03-26 18:47:59', 0);

-- ----------------------------
-- Table structure for course_category
-- ----------------------------
DROP TABLE IF EXISTS `course_category`;
CREATE TABLE `course_category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称(如:计算机、数学) [cite: 40]',
  `sort` int(11) NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(4) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_category
-- ----------------------------
INSERT INTO `course_category` VALUES (1, '开发技术', 1, '2026-03-25 23:10:52', '2026-03-25 23:10:52', 0);
INSERT INTO `course_category` VALUES (2, '设计美学', 2, '2026-03-25 23:10:52', '2026-03-25 23:10:52', 0);
INSERT INTO `course_category` VALUES (3, '人工智能', 3, '2026-03-25 23:10:52', '2026-03-25 23:10:52', 0);
INSERT INTO `course_category` VALUES (4, '语言学习', 4, '2026-03-25 23:10:52', '2026-03-25 23:10:52', 0);

-- ----------------------------
-- Table structure for course_chapter
-- ----------------------------
DROP TABLE IF EXISTS `course_chapter`;
CREATE TABLE `course_chapter`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL COMMENT '所属课程ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '章节名称',
  `sort` int(11) NULL DEFAULT 0 COMMENT '章节顺序',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(4) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程章节表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_chapter
-- ----------------------------
INSERT INTO `course_chapter` VALUES (1, 1, '第一章：Java 运行环境安装', 1, '2026-03-25 23:11:08', '2026-03-25 23:11:08', 0);
INSERT INTO `course_chapter` VALUES (2, 1, '第二章：变量与运算符', 2, '2026-03-25 23:11:08', '2026-03-25 23:11:08', 0);
INSERT INTO `course_chapter` VALUES (3, 3, '第一章：Figma 基础操作', 1, '2026-03-25 23:11:08', '2026-03-25 23:11:08', 0);
INSERT INTO `course_chapter` VALUES (4, 1, '新建章节 3', 3, '2026-03-26 16:27:16', '2026-03-26 16:27:19', 1);
INSERT INTO `course_chapter` VALUES (5, 1, '新建章节 3', 3, '2026-03-26 16:27:22', '2026-03-26 16:27:22', 0);
INSERT INTO `course_chapter` VALUES (6, 6, '新建章节 1', 1, '2026-03-26 17:45:08', '2026-03-26 17:45:08', 0);

-- ----------------------------
-- Table structure for course_discussion
-- ----------------------------
DROP TABLE IF EXISTS `course_discussion`;
CREATE TABLE `course_discussion`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL COMMENT '课程ID',
  `user_id` bigint(20) NOT NULL COMMENT '发帖人ID(可以是学生或教师)',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父节点ID(0表示主贴,非0表示回复)',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题(回复可为空)',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(4) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程讨论区表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_discussion
-- ----------------------------
INSERT INTO `course_discussion` VALUES (1, 1, 4, 0, '关于多线程的一个疑问', '在并发环境下，synchronized 和 ReentrantLock 有什么区别？', '2026-03-25 23:12:01', '2026-03-25 23:12:01', 0);
INSERT INTO `course_discussion` VALUES (2, 1, 2, 1, NULL, '这是一个很好的问题，ReentrantLock 提供了更灵活的加锁方式...', '2026-03-25 23:12:01', '2026-03-25 23:12:01', 0);
INSERT INTO `course_discussion` VALUES (3, 2, 4, 0, 'vue3脚手架问题', '老师，vue3脚手架搭建需要那些基础环境？', NULL, NULL, 0);
INSERT INTO `course_discussion` VALUES (4, 1, 4, 1, NULL, '一个测试', NULL, NULL, 0);

-- ----------------------------
-- Table structure for course_resource
-- ----------------------------
DROP TABLE IF EXISTS `course_resource`;
CREATE TABLE `course_resource`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chapter_id` bigint(20) NOT NULL COMMENT '所属章节ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资源名称',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资源类型: video, pdf, ppt, word [cite: 72]',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '资源存储地址/播放地址',
  `duration` int(11) NULL DEFAULT 0 COMMENT '视频时长(秒)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(4) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '课程资源表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_resource
-- ----------------------------
INSERT INTO `course_resource` VALUES (1, 1, 'JDK 17 安装视频', 'video', 'https://www.w3schools.com/html/mov_bbb.mp4', 600, '2026-03-25 23:11:18', '2026-03-25 23:11:18', 0);
INSERT INTO `course_resource` VALUES (2, 1, '环境配置文档.pdf', 'pdf', 'https://example.com/java-env.pdf', 0, '2026-03-25 23:11:18', '2026-03-26 18:11:49', 1);
INSERT INTO `course_resource` VALUES (3, 3, 'Figma 设计稿演示', 'video', 'https://www.w3schools.com/html/movie.mp4', 300, '2026-03-25 23:11:18', '2026-03-25 23:11:18', 0);
INSERT INTO `course_resource` VALUES (4, 1, 'PDF', 'pdf', 'http://localhost:8080/uploads/35b6167bc1cb4c1996667d52cccdb2f5.pdf', 0, '2026-03-26 18:14:34', '2026-03-26 18:14:54', 1);
INSERT INTO `course_resource` VALUES (5, 1, 'PDF', 'pdf', 'http://localhost:8080/uploads/eef8e4edbd5c4dff89f89ba7443398dc.pdf', 0, '2026-03-26 18:46:58', '2026-03-26 18:46:58', 0);

-- ----------------------------
-- Table structure for exam
-- ----------------------------
DROP TABLE IF EXISTS `exam`;
CREATE TABLE `exam`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL COMMENT '所属课程ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '考试名称',
  `total_score` int(11) NULL DEFAULT 100 COMMENT '总分',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态: 0-未发布, 1-已发布',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(4) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '在线考试表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam
-- ----------------------------
INSERT INTO `exam` VALUES (1, 1, 'Java 基础阶段测试', 100, NULL, NULL, 1, '2026-03-25 23:11:49', '2026-03-25 23:11:49', 0);
INSERT INTO `exam` VALUES (2, 1, '期中测试', 100, NULL, NULL, 0, '2026-03-26 18:30:11', '2026-03-26 18:30:11', 0);
INSERT INTO `exam` VALUES (3, 1, '期中测试', 100, NULL, NULL, 1, '2026-03-26 18:30:31', '2026-03-26 18:41:42', 0);

-- ----------------------------
-- Table structure for exam_question
-- ----------------------------
DROP TABLE IF EXISTS `exam_question`;
CREATE TABLE `exam_question`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `exam_id` bigint(20) NOT NULL COMMENT '所属考试ID',
  `type` tinyint(4) NOT NULL COMMENT '题目类型: 1-单选题, 2-简答题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '题目内容',
  `options` json NULL COMMENT '选项(JSON格式,如[\"A.xx\",\"B.xx\"],简答题为空)',
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标准答案(单选题填A/B/C/D, 简答题填参考要点)',
  `score` int(11) NOT NULL COMMENT '该题分值',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(4) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '考试题目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_question
-- ----------------------------
INSERT INTO `exam_question` VALUES (1, 1, 1, 'Java 中以下哪个关键字用于定义接口？', '[\"A. class\", \"B. extends\", \"C. interface\", \"D. implements\"]', 'C', 10, '2026-03-25 23:11:55', '2026-03-25 23:11:55', 0);
INSERT INTO `exam_question` VALUES (2, 1, 2, '请简述 JVM 的垃圾回收机制。', NULL, '主要通过可达性分析算法判断对象是否存活...', 20, '2026-03-25 23:11:55', '2026-03-25 23:11:55', 0);
INSERT INTO `exam_question` VALUES (3, 3, 1, '哈哈哈', '[\"A. 111\", \"B. 222\", \"C. 333\", \"D. hhh\"]', 'D', 30, '2026-03-26 18:40:19', '2026-03-26 18:40:19', 0);

-- ----------------------------
-- Table structure for homework
-- ----------------------------
DROP TABLE IF EXISTS `homework`;
CREATE TABLE `homework`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) NOT NULL COMMENT '所属课程ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '作业标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '作业内容要求',
  `deadline` datetime NOT NULL COMMENT '截止时间 [cite: 76]',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(4) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '教师发布作业表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of homework
-- ----------------------------
INSERT INTO `homework` VALUES (1, 1, '编写第一个 Hello World', '要求使用命令行编译并运行程序。', '2026-12-31 23:59:59', '2026-03-25 23:11:33', '2026-03-25 23:11:33', 0);
INSERT INTO `homework` VALUES (2, 3, '绘制一套图标集', '基于 24x24 栅格，绘制 5 个线性图标。', '2026-12-31 23:59:59', '2026-03-25 23:11:33', '2026-03-25 23:11:33', 0);

-- ----------------------------
-- Table structure for student_course
-- ----------------------------
DROP TABLE IF EXISTS `student_course`;
CREATE TABLE `student_course`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) NOT NULL COMMENT '学生ID [cite: 12]',
  `course_id` bigint(20) NOT NULL COMMENT '课程ID [cite: 12]',
  `progress` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '学习进度百分比 [cite: 17]',
  `watch_time` int(11) NULL DEFAULT 0 COMMENT '累计学习时长(秒) [cite: 32]',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '选课时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_course`(`student_id`, `course_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生选课及进度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_course
-- ----------------------------
INSERT INTO `student_course` VALUES (1, 4, 1, 45.50, 3600, '2026-03-25 23:11:26', '2026-03-25 23:11:26');
INSERT INTO `student_course` VALUES (2, 4, 2, 12.00, 1200, '2026-03-25 23:11:26', '2026-03-25 23:11:26');
INSERT INTO `student_course` VALUES (3, 5, 3, 80.00, 5400, '2026-03-25 23:11:26', '2026-03-25 23:11:26');
INSERT INTO `student_course` VALUES (4, 4, 3, 95.15, 12, '2026-03-26 14:25:33', '2026-03-26 14:25:33');

-- ----------------------------
-- Table structure for student_exam
-- ----------------------------
DROP TABLE IF EXISTS `student_exam`;
CREATE TABLE `student_exam`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `exam_id` bigint(20) NOT NULL COMMENT '考试ID',
  `student_id` bigint(20) NOT NULL COMMENT '学生ID',
  `total_score` int(11) NULL DEFAULT 0 COMMENT '学生得分',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态: 0-考试中, 1-已交卷待批改(含简答题), 2-已出成绩',
  `submit_time` datetime NULL DEFAULT NULL COMMENT '交卷时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_student_exam`(`exam_id`, `student_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生考试记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_exam
-- ----------------------------
INSERT INTO `student_exam` VALUES (1, 1, 4, 100, 2, '2026-03-25 23:35:13', NULL, '2026-03-26 18:59:14');
INSERT INTO `student_exam` VALUES (2, 3, 4, 30, 2, '2026-03-26 18:55:27', '2026-03-26 18:55:27', '2026-03-26 18:55:27');

-- ----------------------------
-- Table structure for student_exam_answer
-- ----------------------------
DROP TABLE IF EXISTS `student_exam_answer`;
CREATE TABLE `student_exam_answer`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `student_exam_id` bigint(20) NOT NULL COMMENT '学生考试记录ID',
  `question_id` bigint(20) NOT NULL COMMENT '题目ID',
  `student_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '学生填写的答案',
  `score` int(11) NULL DEFAULT 0 COMMENT '该题得分',
  `teacher_comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '教师评语(针对简答题)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生答题详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_exam_answer
-- ----------------------------
INSERT INTO `student_exam_answer` VALUES (1, 1, 1, 'C', 10, NULL, NULL, '2026-03-26 18:59:14');
INSERT INTO `student_exam_answer` VALUES (2, 1, 2, '当对象不被引用或者内存空间不够时触发的回收机制', 90, '不错', NULL, '2026-03-26 18:59:14');
INSERT INTO `student_exam_answer` VALUES (3, 2, 3, 'D', 30, NULL, '2026-03-26 18:55:27', '2026-03-26 18:55:27');

-- ----------------------------
-- Table structure for student_homework
-- ----------------------------
DROP TABLE IF EXISTS `student_homework`;
CREATE TABLE `student_homework`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) NOT NULL COMMENT '学生ID',
  `homework_id` bigint(20) NOT NULL COMMENT '作业ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '提交的文本内容 [cite: 21]',
  `file_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '提交的附件地址 [cite: 21]',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态: 0-未提交, 1-已提交待批改, 2-已批改 [cite: 22]',
  `score` decimal(5, 2) NULL DEFAULT NULL COMMENT '作业得分 [cite: 23]',
  `teacher_comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '教师评语 [cite: 23]',
  `submit_time` datetime NULL DEFAULT NULL COMMENT '提交时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生作业提交表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student_homework
-- ----------------------------
INSERT INTO `student_homework` VALUES (1, 4, 1, '我已经成功运行了程序，感觉 Java 很有趣！', NULL, 2, 95.00, '代码规范，继续保持。', NULL, '2026-03-25 23:11:40', '2026-03-25 23:11:40');
INSERT INTO `student_homework` VALUES (2, 5, 2, '这是我提交的图标作业。', NULL, 1, NULL, NULL, NULL, '2026-03-25 23:11:40', '2026-03-25 23:11:40');
INSERT INTO `student_homework` VALUES (3, 4, 2, 'hhh', '', 1, NULL, NULL, '2026-03-26 17:49:32', '2026-03-26 17:49:31', '2026-03-26 17:49:31');

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '操作人ID',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求IP',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求方法',
  `uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求URI',
  `duration` bigint(20) NULL DEFAULT NULL COMMENT '耗时(ms)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 965 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_log
-- ----------------------------
INSERT INTO `sys_log` VALUES (1, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 663, '2026-03-25 23:13:33');
INSERT INTO `sys_log` VALUES (2, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 11, '2026-03-25 23:14:03');
INSERT INTO `sys_log` VALUES (3, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 63, '2026-03-25 23:14:03');
INSERT INTO `sys_log` VALUES (4, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 2, '2026-03-25 23:14:27');
INSERT INTO `sys_log` VALUES (5, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 7, '2026-03-25 23:14:53');
INSERT INTO `sys_log` VALUES (6, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-25 23:14:53');
INSERT INTO `sys_log` VALUES (7, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 10, '2026-03-25 23:14:53');
INSERT INTO `sys_log` VALUES (8, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 26, '2026-03-25 23:14:56');
INSERT INTO `sys_log` VALUES (9, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 25, '2026-03-25 23:14:57');
INSERT INTO `sys_log` VALUES (10, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 14, '2026-03-25 23:14:59');
INSERT INTO `sys_log` VALUES (11, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 13, '2026-03-25 23:15:00');
INSERT INTO `sys_log` VALUES (12, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 32, '2026-03-25 23:15:02');
INSERT INTO `sys_log` VALUES (13, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 17, '2026-03-25 23:15:07');
INSERT INTO `sys_log` VALUES (14, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 6, '2026-03-25 23:15:09');
INSERT INTO `sys_log` VALUES (15, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-25 23:15:15');
INSERT INTO `sys_log` VALUES (16, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 6, '2026-03-25 23:15:15');
INSERT INTO `sys_log` VALUES (17, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 8, '2026-03-25 23:15:20');
INSERT INTO `sys_log` VALUES (18, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 14, '2026-03-25 23:15:20');
INSERT INTO `sys_log` VALUES (19, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 5, '2026-03-25 23:21:11');
INSERT INTO `sys_log` VALUES (20, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 5, '2026-03-25 23:21:11');
INSERT INTO `sys_log` VALUES (21, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-25 23:21:18');
INSERT INTO `sys_log` VALUES (22, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 6, '2026-03-25 23:21:18');
INSERT INTO `sys_log` VALUES (23, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-25 23:21:54');
INSERT INTO `sys_log` VALUES (24, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 12, '2026-03-25 23:21:54');
INSERT INTO `sys_log` VALUES (25, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-25 23:21:56');
INSERT INTO `sys_log` VALUES (26, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 6, '2026-03-25 23:21:56');
INSERT INTO `sys_log` VALUES (27, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 5, '2026-03-25 23:22:44');
INSERT INTO `sys_log` VALUES (28, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 6, '2026-03-25 23:22:44');
INSERT INTO `sys_log` VALUES (29, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 10, '2026-03-25 23:22:44');
INSERT INTO `sys_log` VALUES (30, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 7, '2026-03-25 23:23:24');
INSERT INTO `sys_log` VALUES (31, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-25 23:23:34');
INSERT INTO `sys_log` VALUES (32, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 4, '2026-03-25 23:23:34');
INSERT INTO `sys_log` VALUES (33, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 5, '2026-03-25 23:28:20');
INSERT INTO `sys_log` VALUES (34, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 6, '2026-03-25 23:28:20');
INSERT INTO `sys_log` VALUES (35, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 3, '2026-03-25 23:28:22');
INSERT INTO `sys_log` VALUES (36, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 6, '2026-03-25 23:28:22');
INSERT INTO `sys_log` VALUES (37, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 5, '2026-03-25 23:28:22');
INSERT INTO `sys_log` VALUES (38, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 1, '2026-03-25 23:28:22');
INSERT INTO `sys_log` VALUES (39, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 5, '2026-03-25 23:28:22');
INSERT INTO `sys_log` VALUES (40, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-25 23:28:59');
INSERT INTO `sys_log` VALUES (41, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 7, '2026-03-25 23:28:59');
INSERT INTO `sys_log` VALUES (42, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 2, '2026-03-25 23:29:00');
INSERT INTO `sys_log` VALUES (43, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/3', 1, '2026-03-25 23:29:00');
INSERT INTO `sys_log` VALUES (44, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/3', 2, '2026-03-25 23:29:00');
INSERT INTO `sys_log` VALUES (45, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 7, '2026-03-25 23:29:00');
INSERT INTO `sys_log` VALUES (46, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-25 23:29:06');
INSERT INTO `sys_log` VALUES (47, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 8, '2026-03-25 23:29:06');
INSERT INTO `sys_log` VALUES (48, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 2, '2026-03-25 23:29:07');
INSERT INTO `sys_log` VALUES (49, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 2, '2026-03-25 23:29:07');
INSERT INTO `sys_log` VALUES (50, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 2, '2026-03-25 23:29:07');
INSERT INTO `sys_log` VALUES (51, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-25 23:29:07');
INSERT INTO `sys_log` VALUES (52, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 4, '2026-03-25 23:29:07');
INSERT INTO `sys_log` VALUES (53, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-25 23:29:10');
INSERT INTO `sys_log` VALUES (54, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 7, '2026-03-25 23:29:10');
INSERT INTO `sys_log` VALUES (55, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 2, '2026-03-25 23:29:11');
INSERT INTO `sys_log` VALUES (56, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/2', 2, '2026-03-25 23:29:11');
INSERT INTO `sys_log` VALUES (57, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 3, '2026-03-25 23:29:11');
INSERT INTO `sys_log` VALUES (58, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 5, '2026-03-25 23:29:19');
INSERT INTO `sys_log` VALUES (59, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 9, '2026-03-25 23:29:19');
INSERT INTO `sys_log` VALUES (60, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/4', 3, '2026-03-25 23:29:32');
INSERT INTO `sys_log` VALUES (61, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/4', 3, '2026-03-25 23:29:32');
INSERT INTO `sys_log` VALUES (62, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 4, '2026-03-25 23:29:32');
INSERT INTO `sys_log` VALUES (63, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-25 23:29:35');
INSERT INTO `sys_log` VALUES (64, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 4, '2026-03-25 23:29:35');
INSERT INTO `sys_log` VALUES (65, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 3, '2026-03-25 23:29:37');
INSERT INTO `sys_log` VALUES (66, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 1, '2026-03-25 23:29:37');
INSERT INTO `sys_log` VALUES (67, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-25 23:29:37');
INSERT INTO `sys_log` VALUES (68, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 1, '2026-03-25 23:29:37');
INSERT INTO `sys_log` VALUES (69, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 5, '2026-03-25 23:29:37');
INSERT INTO `sys_log` VALUES (70, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-25 23:29:46');
INSERT INTO `sys_log` VALUES (71, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 5, '2026-03-25 23:29:46');
INSERT INTO `sys_log` VALUES (72, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-25 23:33:48');
INSERT INTO `sys_log` VALUES (73, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 5, '2026-03-25 23:33:48');
INSERT INTO `sys_log` VALUES (74, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-25 23:33:51');
INSERT INTO `sys_log` VALUES (75, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 8, '2026-03-25 23:33:51');
INSERT INTO `sys_log` VALUES (76, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 7, '2026-03-25 23:33:56');
INSERT INTO `sys_log` VALUES (77, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 5, '2026-03-25 23:33:56');
INSERT INTO `sys_log` VALUES (78, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/1', 4, '2026-03-25 23:33:56');
INSERT INTO `sys_log` VALUES (79, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 2, '2026-03-25 23:33:56');
INSERT INTO `sys_log` VALUES (80, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 8, '2026-03-25 23:34:07');
INSERT INTO `sys_log` VALUES (81, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.submitExam()', '/student-exam/submit', 31, '2026-03-25 23:35:12');
INSERT INTO `sys_log` VALUES (82, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 5, '2026-03-25 23:39:05');
INSERT INTO `sys_log` VALUES (83, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 4, '2026-03-25 23:39:05');
INSERT INTO `sys_log` VALUES (84, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 5, '2026-03-25 23:39:05');
INSERT INTO `sys_log` VALUES (85, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 3, '2026-03-25 23:39:11');
INSERT INTO `sys_log` VALUES (86, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 2, '2026-03-25 23:39:11');
INSERT INTO `sys_log` VALUES (87, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 2, '2026-03-25 23:39:11');
INSERT INTO `sys_log` VALUES (88, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 5, '2026-03-25 23:39:11');
INSERT INTO `sys_log` VALUES (89, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 3, '2026-03-25 23:39:13');
INSERT INTO `sys_log` VALUES (90, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 2, '2026-03-25 23:39:13');
INSERT INTO `sys_log` VALUES (91, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 5, '2026-03-25 23:41:41');
INSERT INTO `sys_log` VALUES (92, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 3, '2026-03-25 23:41:41');
INSERT INTO `sys_log` VALUES (93, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 2, '2026-03-25 23:41:41');
INSERT INTO `sys_log` VALUES (94, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 2, '2026-03-25 23:41:41');
INSERT INTO `sys_log` VALUES (95, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 6, '2026-03-25 23:43:44');
INSERT INTO `sys_log` VALUES (96, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 5, '2026-03-25 23:43:44');
INSERT INTO `sys_log` VALUES (97, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 2, '2026-03-25 23:43:44');
INSERT INTO `sys_log` VALUES (98, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 4, '2026-03-25 23:43:44');
INSERT INTO `sys_log` VALUES (99, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.getUserInfo()', '/user/info', 1, '2026-03-25 23:43:48');
INSERT INTO `sys_log` VALUES (100, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.updateInfo()', '/user/update', 4, '2026-03-25 23:44:07');
INSERT INTO `sys_log` VALUES (101, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.getUserInfo()', '/user/info', 3, '2026-03-25 23:44:07');
INSERT INTO `sys_log` VALUES (102, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 8, '2026-03-25 23:46:11');
INSERT INTO `sys_log` VALUES (103, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 7, '2026-03-25 23:46:12');
INSERT INTO `sys_log` VALUES (104, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 12, '2026-03-25 23:46:12');
INSERT INTO `sys_log` VALUES (105, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 8, '2026-03-25 23:46:14');
INSERT INTO `sys_log` VALUES (106, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 11, '2026-03-25 23:46:14');
INSERT INTO `sys_log` VALUES (107, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 10, '2026-03-25 23:46:16');
INSERT INTO `sys_log` VALUES (108, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 9, '2026-03-25 23:46:19');
INSERT INTO `sys_log` VALUES (109, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 10, '2026-03-25 23:46:22');
INSERT INTO `sys_log` VALUES (110, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 7, '2026-03-25 23:46:23');
INSERT INTO `sys_log` VALUES (111, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 6, '2026-03-25 23:46:23');
INSERT INTO `sys_log` VALUES (112, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 6, '2026-03-25 23:46:23');
INSERT INTO `sys_log` VALUES (113, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 3, '2026-03-25 23:46:23');
INSERT INTO `sys_log` VALUES (114, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 8, '2026-03-25 23:46:23');
INSERT INTO `sys_log` VALUES (115, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-25 23:46:35');
INSERT INTO `sys_log` VALUES (116, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 6, '2026-03-25 23:46:35');
INSERT INTO `sys_log` VALUES (117, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 5, '2026-03-25 23:46:35');
INSERT INTO `sys_log` VALUES (118, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 6, '2026-03-25 23:46:36');
INSERT INTO `sys_log` VALUES (119, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 4, '2026-03-25 23:46:36');
INSERT INTO `sys_log` VALUES (120, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 4, '2026-03-25 23:46:36');
INSERT INTO `sys_log` VALUES (121, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 3, '2026-03-25 23:46:36');
INSERT INTO `sys_log` VALUES (122, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 7, '2026-03-25 23:46:37');
INSERT INTO `sys_log` VALUES (123, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 9, '2026-03-25 23:46:38');
INSERT INTO `sys_log` VALUES (124, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 4, '2026-03-25 23:46:38');
INSERT INTO `sys_log` VALUES (125, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 4, '2026-03-25 23:46:38');
INSERT INTO `sys_log` VALUES (126, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 6, '2026-03-25 23:46:40');
INSERT INTO `sys_log` VALUES (127, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 6, '2026-03-25 23:46:40');
INSERT INTO `sys_log` VALUES (128, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/1', 4, '2026-03-25 23:46:41');
INSERT INTO `sys_log` VALUES (129, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 3, '2026-03-25 23:46:41');
INSERT INTO `sys_log` VALUES (130, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 5, '2026-03-25 23:46:50');
INSERT INTO `sys_log` VALUES (131, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 7, '2026-03-25 23:46:54');
INSERT INTO `sys_log` VALUES (132, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 6, '2026-03-25 23:46:54');
INSERT INTO `sys_log` VALUES (133, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 6, '2026-03-25 23:46:54');
INSERT INTO `sys_log` VALUES (134, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 4, '2026-03-25 23:46:54');
INSERT INTO `sys_log` VALUES (135, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 3, '2026-03-25 23:46:55');
INSERT INTO `sys_log` VALUES (136, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 6, '2026-03-25 23:46:56');
INSERT INTO `sys_log` VALUES (137, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.getUserInfo()', '/user/info', 2, '2026-03-25 23:47:01');
INSERT INTO `sys_log` VALUES (138, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.updateInfo()', '/user/update', 11, '2026-03-25 23:47:05');
INSERT INTO `sys_log` VALUES (139, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.getUserInfo()', '/user/info', 4, '2026-03-25 23:47:05');
INSERT INTO `sys_log` VALUES (140, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-25 23:47:18');
INSERT INTO `sys_log` VALUES (141, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 7, '2026-03-25 23:51:26');
INSERT INTO `sys_log` VALUES (142, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 6, '2026-03-25 23:51:28');
INSERT INTO `sys_log` VALUES (143, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 9, '2026-03-25 23:51:28');
INSERT INTO `sys_log` VALUES (144, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 9, '2026-03-25 23:51:30');
INSERT INTO `sys_log` VALUES (145, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 8, '2026-03-25 23:51:31');
INSERT INTO `sys_log` VALUES (146, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 9, '2026-03-25 23:51:32');
INSERT INTO `sys_log` VALUES (147, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 9, '2026-03-25 23:51:35');
INSERT INTO `sys_log` VALUES (148, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 8, '2026-03-25 23:51:37');
INSERT INTO `sys_log` VALUES (149, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 5, '2026-03-25 23:51:39');
INSERT INTO `sys_log` VALUES (150, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 6, '2026-03-25 23:51:39');
INSERT INTO `sys_log` VALUES (151, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-25 23:51:39');
INSERT INTO `sys_log` VALUES (152, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 3, '2026-03-25 23:51:39');
INSERT INTO `sys_log` VALUES (153, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 6, '2026-03-25 23:51:39');
INSERT INTO `sys_log` VALUES (154, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 5, '2026-03-25 23:51:55');
INSERT INTO `sys_log` VALUES (155, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 10, '2026-03-25 23:51:55');
INSERT INTO `sys_log` VALUES (156, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 7, '2026-03-25 23:51:57');
INSERT INTO `sys_log` VALUES (157, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 5, '2026-03-25 23:51:57');
INSERT INTO `sys_log` VALUES (158, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 4, '2026-03-25 23:51:57');
INSERT INTO `sys_log` VALUES (159, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 7, '2026-03-25 23:52:00');
INSERT INTO `sys_log` VALUES (160, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 3, '2026-03-25 23:52:00');
INSERT INTO `sys_log` VALUES (161, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/1', 3, '2026-03-25 23:52:00');
INSERT INTO `sys_log` VALUES (162, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 3, '2026-03-25 23:52:00');
INSERT INTO `sys_log` VALUES (163, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 7, '2026-03-25 23:52:07');
INSERT INTO `sys_log` VALUES (164, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 9, '2026-03-25 23:52:11');
INSERT INTO `sys_log` VALUES (165, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 5, '2026-03-25 23:52:11');
INSERT INTO `sys_log` VALUES (166, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 5, '2026-03-25 23:52:11');
INSERT INTO `sys_log` VALUES (167, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 7, '2026-03-25 23:52:11');
INSERT INTO `sys_log` VALUES (168, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 2, '2026-03-25 23:52:12');
INSERT INTO `sys_log` VALUES (169, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 4, '2026-03-25 23:52:13');
INSERT INTO `sys_log` VALUES (170, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.getUserInfo()', '/user/info', 2, '2026-03-25 23:52:16');
INSERT INTO `sys_log` VALUES (171, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.updateInfo()', '/user/update', 5, '2026-03-25 23:52:20');
INSERT INTO `sys_log` VALUES (172, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.getUserInfo()', '/user/info', 2, '2026-03-25 23:52:20');
INSERT INTO `sys_log` VALUES (173, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-25 23:52:32');
INSERT INTO `sys_log` VALUES (174, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 2409, '2026-03-26 14:15:57');
INSERT INTO `sys_log` VALUES (175, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 27, '2026-03-26 14:15:58');
INSERT INTO `sys_log` VALUES (176, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 173, '2026-03-26 14:15:58');
INSERT INTO `sys_log` VALUES (177, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.getUserInfo()', '/user/info', 10, '2026-03-26 14:16:20');
INSERT INTO `sys_log` VALUES (178, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 17, '2026-03-26 14:16:31');
INSERT INTO `sys_log` VALUES (179, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 24, '2026-03-26 14:16:31');
INSERT INTO `sys_log` VALUES (180, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 16, '2026-03-26 14:16:40');
INSERT INTO `sys_log` VALUES (181, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 18, '2026-03-26 14:16:40');
INSERT INTO `sys_log` VALUES (182, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 10, '2026-03-26 14:16:40');
INSERT INTO `sys_log` VALUES (183, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 4, '2026-03-26 14:16:40');
INSERT INTO `sys_log` VALUES (184, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 19, '2026-03-26 14:16:40');
INSERT INTO `sys_log` VALUES (185, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 25, '2026-03-26 14:16:53');
INSERT INTO `sys_log` VALUES (186, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 10, '2026-03-26 14:16:53');
INSERT INTO `sys_log` VALUES (187, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 15, '2026-03-26 14:16:53');
INSERT INTO `sys_log` VALUES (188, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 9, '2026-03-26 14:16:54');
INSERT INTO `sys_log` VALUES (189, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/2', 3, '2026-03-26 14:16:54');
INSERT INTO `sys_log` VALUES (190, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 13, '2026-03-26 14:16:54');
INSERT INTO `sys_log` VALUES (191, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 13, '2026-03-26 14:16:57');
INSERT INTO `sys_log` VALUES (192, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 8, '2026-03-26 14:16:57');
INSERT INTO `sys_log` VALUES (193, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 8, '2026-03-26 14:16:57');
INSERT INTO `sys_log` VALUES (194, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 14, '2026-03-26 14:17:22');
INSERT INTO `sys_log` VALUES (195, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 9, '2026-03-26 14:17:22');
INSERT INTO `sys_log` VALUES (196, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/1', 10, '2026-03-26 14:17:22');
INSERT INTO `sys_log` VALUES (197, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 6, '2026-03-26 14:17:22');
INSERT INTO `sys_log` VALUES (198, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-26 14:17:42');
INSERT INTO `sys_log` VALUES (199, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 8, '2026-03-26 14:17:42');
INSERT INTO `sys_log` VALUES (200, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 13, '2026-03-26 14:17:42');
INSERT INTO `sys_log` VALUES (201, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 8, '2026-03-26 14:17:42');
INSERT INTO `sys_log` VALUES (202, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 5, '2026-03-26 14:17:44');
INSERT INTO `sys_log` VALUES (203, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 5, '2026-03-26 14:17:45');
INSERT INTO `sys_log` VALUES (204, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 5, '2026-03-26 14:17:51');
INSERT INTO `sys_log` VALUES (205, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 6, '2026-03-26 14:17:57');
INSERT INTO `sys_log` VALUES (206, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 11, '2026-03-26 14:18:09');
INSERT INTO `sys_log` VALUES (207, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.postMessage()', '/discussion/post', 8, '2026-03-26 14:18:50');
INSERT INTO `sys_log` VALUES (208, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 5, '2026-03-26 14:18:50');
INSERT INTO `sys_log` VALUES (209, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 8, '2026-03-26 14:18:52');
INSERT INTO `sys_log` VALUES (210, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 6, '2026-03-26 14:18:54');
INSERT INTO `sys_log` VALUES (211, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 5, '2026-03-26 14:18:55');
INSERT INTO `sys_log` VALUES (212, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 14, '2026-03-26 14:22:32');
INSERT INTO `sys_log` VALUES (213, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 6, '2026-03-26 14:22:32');
INSERT INTO `sys_log` VALUES (214, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/1', 18, '2026-03-26 14:22:32');
INSERT INTO `sys_log` VALUES (215, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 3, '2026-03-26 14:22:32');
INSERT INTO `sys_log` VALUES (216, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 15, '2026-03-26 14:22:35');
INSERT INTO `sys_log` VALUES (217, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 7, '2026-03-26 14:22:35');
INSERT INTO `sys_log` VALUES (218, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 7, '2026-03-26 14:22:35');
INSERT INTO `sys_log` VALUES (219, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 7, '2026-03-26 14:22:38');
INSERT INTO `sys_log` VALUES (220, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 5, '2026-03-26 14:22:38');
INSERT INTO `sys_log` VALUES (221, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 5, '2026-03-26 14:22:38');
INSERT INTO `sys_log` VALUES (222, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 3, '2026-03-26 14:22:38');
INSERT INTO `sys_log` VALUES (223, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-26 14:22:38');
INSERT INTO `sys_log` VALUES (224, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 6, '2026-03-26 14:24:12');
INSERT INTO `sys_log` VALUES (225, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 12, '2026-03-26 14:24:12');
INSERT INTO `sys_log` VALUES (226, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 15, '2026-03-26 14:24:13');
INSERT INTO `sys_log` VALUES (227, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 15, '2026-03-26 14:24:15');
INSERT INTO `sys_log` VALUES (228, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 11, '2026-03-26 14:24:17');
INSERT INTO `sys_log` VALUES (229, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 15, '2026-03-26 14:24:18');
INSERT INTO `sys_log` VALUES (230, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 8, '2026-03-26 14:24:31');
INSERT INTO `sys_log` VALUES (231, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/2', 4, '2026-03-26 14:24:31');
INSERT INTO `sys_log` VALUES (232, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 9, '2026-03-26 14:24:31');
INSERT INTO `sys_log` VALUES (233, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 11, '2026-03-26 14:24:35');
INSERT INTO `sys_log` VALUES (234, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 14, '2026-03-26 14:24:35');
INSERT INTO `sys_log` VALUES (235, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 7, '2026-03-26 14:24:37');
INSERT INTO `sys_log` VALUES (236, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 5, '2026-03-26 14:24:37');
INSERT INTO `sys_log` VALUES (237, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 5, '2026-03-26 14:24:37');
INSERT INTO `sys_log` VALUES (238, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 14:24:37');
INSERT INTO `sys_log` VALUES (239, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-26 14:24:37');
INSERT INTO `sys_log` VALUES (240, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 8, '2026-03-26 14:25:25');
INSERT INTO `sys_log` VALUES (241, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 16, '2026-03-26 14:25:25');
INSERT INTO `sys_log` VALUES (242, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 12, '2026-03-26 14:25:27');
INSERT INTO `sys_log` VALUES (243, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/3', 4, '2026-03-26 14:25:27');
INSERT INTO `sys_log` VALUES (244, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/3', 5, '2026-03-26 14:25:27');
INSERT INTO `sys_log` VALUES (245, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-26 14:25:27');
INSERT INTO `sys_log` VALUES (246, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 7, '2026-03-26 14:25:31');
INSERT INTO `sys_log` VALUES (247, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 12, '2026-03-26 14:25:31');
INSERT INTO `sys_log` VALUES (248, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 8, '2026-03-26 14:25:32');
INSERT INTO `sys_log` VALUES (249, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/3', 4, '2026-03-26 14:25:32');
INSERT INTO `sys_log` VALUES (250, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/3', 5, '2026-03-26 14:25:32');
INSERT INTO `sys_log` VALUES (251, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-26 14:25:32');
INSERT INTO `sys_log` VALUES (252, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.enrollCourse()', '/student-course/enroll/3', 12, '2026-03-26 14:25:33');
INSERT INTO `sys_log` VALUES (253, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 7, '2026-03-26 14:25:46');
INSERT INTO `sys_log` VALUES (254, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 13, '2026-03-26 14:25:46');
INSERT INTO `sys_log` VALUES (255, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-26 14:25:47');
INSERT INTO `sys_log` VALUES (256, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 6, '2026-03-26 14:25:47');
INSERT INTO `sys_log` VALUES (257, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 7, '2026-03-26 14:25:47');
INSERT INTO `sys_log` VALUES (258, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 9, '2026-03-26 14:25:47');
INSERT INTO `sys_log` VALUES (259, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 7, '2026-03-26 14:25:49');
INSERT INTO `sys_log` VALUES (260, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/3', 8, '2026-03-26 14:25:49');
INSERT INTO `sys_log` VALUES (261, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/3', 3, '2026-03-26 14:25:49');
INSERT INTO `sys_log` VALUES (262, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 11, '2026-03-26 14:25:49');
INSERT INTO `sys_log` VALUES (263, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-26 14:25:56');
INSERT INTO `sys_log` VALUES (264, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 5, '2026-03-26 14:25:56');
INSERT INTO `sys_log` VALUES (265, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 5, '2026-03-26 14:25:56');
INSERT INTO `sys_log` VALUES (266, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 5, '2026-03-26 14:25:56');
INSERT INTO `sys_log` VALUES (267, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 7, '2026-03-26 14:25:57');
INSERT INTO `sys_log` VALUES (268, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/3', 7, '2026-03-26 14:25:57');
INSERT INTO `sys_log` VALUES (269, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/3', 5, '2026-03-26 14:25:57');
INSERT INTO `sys_log` VALUES (270, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 11, '2026-03-26 14:25:57');
INSERT INTO `sys_log` VALUES (271, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 11, '2026-03-26 14:26:18');
INSERT INTO `sys_log` VALUES (272, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 8, '2026-03-26 14:26:18');
INSERT INTO `sys_log` VALUES (273, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 8, '2026-03-26 14:26:18');
INSERT INTO `sys_log` VALUES (274, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 8, '2026-03-26 14:26:18');
INSERT INTO `sys_log` VALUES (275, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 12, '2026-03-26 14:30:06');
INSERT INTO `sys_log` VALUES (276, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 6, '2026-03-26 14:30:06');
INSERT INTO `sys_log` VALUES (277, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 7, '2026-03-26 14:30:06');
INSERT INTO `sys_log` VALUES (278, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 5, '2026-03-26 14:30:06');
INSERT INTO `sys_log` VALUES (279, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/3', 4, '2026-03-26 14:30:06');
INSERT INTO `sys_log` VALUES (280, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 6, '2026-03-26 14:30:10');
INSERT INTO `sys_log` VALUES (281, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 4, '2026-03-26 14:30:11');
INSERT INTO `sys_log` VALUES (282, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 13, '2026-03-26 14:36:39');
INSERT INTO `sys_log` VALUES (283, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 8, '2026-03-26 14:36:39');
INSERT INTO `sys_log` VALUES (284, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 8, '2026-03-26 14:36:39');
INSERT INTO `sys_log` VALUES (285, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 9, '2026-03-26 14:36:39');
INSERT INTO `sys_log` VALUES (286, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/3', 4, '2026-03-26 14:36:39');
INSERT INTO `sys_log` VALUES (287, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 4, '2026-03-26 14:36:41');
INSERT INTO `sys_log` VALUES (288, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getReplies()', '/discussion/list/replies/1', 6, '2026-03-26 14:36:42');
INSERT INTO `sys_log` VALUES (289, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.postMessage()', '/discussion/post', 12, '2026-03-26 14:36:55');
INSERT INTO `sys_log` VALUES (290, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getReplies()', '/discussion/list/replies/1', 4, '2026-03-26 14:36:55');
INSERT INTO `sys_log` VALUES (291, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 4, '2026-03-26 14:37:00');
INSERT INTO `sys_log` VALUES (292, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 4, '2026-03-26 14:37:02');
INSERT INTO `sys_log` VALUES (293, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 9, '2026-03-26 14:38:31');
INSERT INTO `sys_log` VALUES (294, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/3', 3, '2026-03-26 14:38:31');
INSERT INTO `sys_log` VALUES (295, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/2', 5, '2026-03-26 14:38:31');
INSERT INTO `sys_log` VALUES (296, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 6, '2026-03-26 14:38:31');
INSERT INTO `sys_log` VALUES (297, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/1', 6, '2026-03-26 14:38:31');
INSERT INTO `sys_log` VALUES (298, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 3, '2026-03-26 14:38:31');
INSERT INTO `sys_log` VALUES (299, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 7, '2026-03-26 14:38:49');
INSERT INTO `sys_log` VALUES (300, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 8, '2026-03-26 14:41:37');
INSERT INTO `sys_log` VALUES (301, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 7, '2026-03-26 14:41:37');
INSERT INTO `sys_log` VALUES (302, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 6, '2026-03-26 14:41:37');
INSERT INTO `sys_log` VALUES (303, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 7, '2026-03-26 14:41:37');
INSERT INTO `sys_log` VALUES (304, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 7, '2026-03-26 14:41:39');
INSERT INTO `sys_log` VALUES (305, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 4, '2026-03-26 14:41:39');
INSERT INTO `sys_log` VALUES (306, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 6, '2026-03-26 14:41:39');
INSERT INTO `sys_log` VALUES (307, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 4, '2026-03-26 14:41:39');
INSERT INTO `sys_log` VALUES (308, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 8, '2026-03-26 14:41:39');
INSERT INTO `sys_log` VALUES (309, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-26 14:41:48');
INSERT INTO `sys_log` VALUES (310, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 6, '2026-03-26 14:41:48');
INSERT INTO `sys_log` VALUES (311, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 5, '2026-03-26 14:41:48');
INSERT INTO `sys_log` VALUES (312, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 5, '2026-03-26 14:41:48');
INSERT INTO `sys_log` VALUES (313, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 5, '2026-03-26 14:41:50');
INSERT INTO `sys_log` VALUES (314, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 3, '2026-03-26 14:41:50');
INSERT INTO `sys_log` VALUES (315, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 4, '2026-03-26 14:41:50');
INSERT INTO `sys_log` VALUES (316, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 14:41:50');
INSERT INTO `sys_log` VALUES (317, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 9, '2026-03-26 14:41:50');
INSERT INTO `sys_log` VALUES (318, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 9, '2026-03-26 14:41:56');
INSERT INTO `sys_log` VALUES (319, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 5, '2026-03-26 14:41:56');
INSERT INTO `sys_log` VALUES (320, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 5, '2026-03-26 14:41:56');
INSERT INTO `sys_log` VALUES (321, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 5, '2026-03-26 14:41:56');
INSERT INTO `sys_log` VALUES (322, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 6, '2026-03-26 14:41:57');
INSERT INTO `sys_log` VALUES (323, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/3', 4, '2026-03-26 14:41:57');
INSERT INTO `sys_log` VALUES (324, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/3', 4, '2026-03-26 14:41:57');
INSERT INTO `sys_log` VALUES (325, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 9, '2026-03-26 14:41:57');
INSERT INTO `sys_log` VALUES (326, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.updateProgress()', '/student-course/updateProgress', 18, '2026-03-26 14:42:19');
INSERT INTO `sys_log` VALUES (327, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.updateProgress()', '/student-course/updateProgress', 11, '2026-03-26 14:42:20');
INSERT INTO `sys_log` VALUES (328, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.updateProgress()', '/student-course/updateProgress', 8, '2026-03-26 14:42:20');
INSERT INTO `sys_log` VALUES (329, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 9, '2026-03-26 14:42:25');
INSERT INTO `sys_log` VALUES (330, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 6, '2026-03-26 14:42:25');
INSERT INTO `sys_log` VALUES (331, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 6, '2026-03-26 14:42:25');
INSERT INTO `sys_log` VALUES (332, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 6, '2026-03-26 14:42:25');
INSERT INTO `sys_log` VALUES (333, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 1869, '2026-03-26 14:54:45');
INSERT INTO `sys_log` VALUES (334, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 33, '2026-03-26 14:54:46');
INSERT INTO `sys_log` VALUES (335, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 15, '2026-03-26 15:08:55');
INSERT INTO `sys_log` VALUES (336, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 141, '2026-03-26 15:08:58');
INSERT INTO `sys_log` VALUES (337, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.changeStatus()', '/admin/user/changeStatus/1/0', 24, '2026-03-26 15:09:01');
INSERT INTO `sys_log` VALUES (338, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.changeStatus()', '/admin/user/changeStatus/1/1', 5, '2026-03-26 15:09:03');
INSERT INTO `sys_log` VALUES (339, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 27, '2026-03-26 15:09:07');
INSERT INTO `sys_log` VALUES (340, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 18, '2026-03-26 15:09:09');
INSERT INTO `sys_log` VALUES (341, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 12, '2026-03-26 15:09:10');
INSERT INTO `sys_log` VALUES (342, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 21, '2026-03-26 15:09:12');
INSERT INTO `sys_log` VALUES (343, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 16, '2026-03-26 15:09:15');
INSERT INTO `sys_log` VALUES (344, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 17, '2026-03-26 15:09:52');
INSERT INTO `sys_log` VALUES (345, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 15, '2026-03-26 15:09:57');
INSERT INTO `sys_log` VALUES (346, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 6, '2026-03-26 15:11:18');
INSERT INTO `sys_log` VALUES (347, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 10, '2026-03-26 15:32:26');
INSERT INTO `sys_log` VALUES (348, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 11, '2026-03-26 15:34:25');
INSERT INTO `sys_log` VALUES (349, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 8, '2026-03-26 15:34:27');
INSERT INTO `sys_log` VALUES (350, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 20, '2026-03-26 15:34:28');
INSERT INTO `sys_log` VALUES (351, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 10, '2026-03-26 15:35:27');
INSERT INTO `sys_log` VALUES (352, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 7, '2026-03-26 15:35:29');
INSERT INTO `sys_log` VALUES (353, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 11, '2026-03-26 15:35:29');
INSERT INTO `sys_log` VALUES (354, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 10, '2026-03-26 15:37:46');
INSERT INTO `sys_log` VALUES (355, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 17, '2026-03-26 15:37:47');
INSERT INTO `sys_log` VALUES (356, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 17, '2026-03-26 15:37:54');
INSERT INTO `sys_log` VALUES (357, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 12, '2026-03-26 15:37:55');
INSERT INTO `sys_log` VALUES (358, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 6, '2026-03-26 15:37:56');
INSERT INTO `sys_log` VALUES (359, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 7, '2026-03-26 15:37:58');
INSERT INTO `sys_log` VALUES (360, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 11, '2026-03-26 15:38:19');
INSERT INTO `sys_log` VALUES (361, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 14, '2026-03-26 15:38:20');
INSERT INTO `sys_log` VALUES (362, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 11, '2026-03-26 15:38:21');
INSERT INTO `sys_log` VALUES (363, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 16, '2026-03-26 15:38:24');
INSERT INTO `sys_log` VALUES (364, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 5, '2026-03-26 15:38:26');
INSERT INTO `sys_log` VALUES (365, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 10, '2026-03-26 15:38:28');
INSERT INTO `sys_log` VALUES (366, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 8, '2026-03-26 15:38:36');
INSERT INTO `sys_log` VALUES (367, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 4, '2026-03-26 15:40:46');
INSERT INTO `sys_log` VALUES (368, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.addNotice()', '/notice/add', 4, '2026-03-26 15:41:07');
INSERT INTO `sys_log` VALUES (369, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 6, '2026-03-26 15:41:07');
INSERT INTO `sys_log` VALUES (370, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-26 15:41:10');
INSERT INTO `sys_log` VALUES (371, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 6, '2026-03-26 15:41:27');
INSERT INTO `sys_log` VALUES (372, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 3, '2026-03-26 15:41:41');
INSERT INTO `sys_log` VALUES (373, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 7, '2026-03-26 15:41:42');
INSERT INTO `sys_log` VALUES (374, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 5, '2026-03-26 15:41:46');
INSERT INTO `sys_log` VALUES (375, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 6, '2026-03-26 15:41:47');
INSERT INTO `sys_log` VALUES (376, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 670, '2026-03-26 15:46:22');
INSERT INTO `sys_log` VALUES (377, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 21, '2026-03-26 15:46:23');
INSERT INTO `sys_log` VALUES (378, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 47, '2026-03-26 15:46:27');
INSERT INTO `sys_log` VALUES (379, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 14, '2026-03-26 15:46:28');
INSERT INTO `sys_log` VALUES (380, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 9, '2026-03-26 15:46:29');
INSERT INTO `sys_log` VALUES (381, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getAdminResourceList()', '/resource/admin/list', 7, '2026-03-26 15:46:31');
INSERT INTO `sys_log` VALUES (382, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 12, '2026-03-26 15:46:53');
INSERT INTO `sys_log` VALUES (383, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 10, '2026-03-26 15:47:43');
INSERT INTO `sys_log` VALUES (384, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 6, '2026-03-26 15:48:37');
INSERT INTO `sys_log` VALUES (385, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-26 15:48:39');
INSERT INTO `sys_log` VALUES (386, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getAdminResourceList()', '/resource/admin/list', 6, '2026-03-26 15:48:41');
INSERT INTO `sys_log` VALUES (387, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 6, '2026-03-26 15:48:42');
INSERT INTO `sys_log` VALUES (388, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getAdminResourceList()', '/resource/admin/list', 5, '2026-03-26 15:48:47');
INSERT INTO `sys_log` VALUES (389, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 5, '2026-03-26 15:48:56');
INSERT INTO `sys_log` VALUES (390, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-26 15:48:57');
INSERT INTO `sys_log` VALUES (391, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 6, '2026-03-26 15:48:58');
INSERT INTO `sys_log` VALUES (392, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 10, '2026-03-26 15:50:51');
INSERT INTO `sys_log` VALUES (393, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 11, '2026-03-26 15:56:52');
INSERT INTO `sys_log` VALUES (394, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 12, '2026-03-26 15:57:11');
INSERT INTO `sys_log` VALUES (395, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 18, '2026-03-26 15:57:12');
INSERT INTO `sys_log` VALUES (396, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 8, '2026-03-26 15:57:13');
INSERT INTO `sys_log` VALUES (397, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 11, '2026-03-26 15:57:14');
INSERT INTO `sys_log` VALUES (398, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 1883, '2026-03-26 15:58:58');
INSERT INTO `sys_log` VALUES (399, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 28, '2026-03-26 15:58:59');
INSERT INTO `sys_log` VALUES (400, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysLogController.getLogList()', '/admin/log/list', 162, '2026-03-26 15:59:01');
INSERT INTO `sys_log` VALUES (401, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 26, '2026-03-26 15:59:12');
INSERT INTO `sys_log` VALUES (402, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getAdminResourceList()', '/resource/admin/list', 18, '2026-03-26 15:59:16');
INSERT INTO `sys_log` VALUES (403, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 12, '2026-03-26 15:59:19');
INSERT INTO `sys_log` VALUES (404, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 17, '2026-03-26 15:59:20');
INSERT INTO `sys_log` VALUES (405, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 173, '2026-03-26 16:00:02');
INSERT INTO `sys_log` VALUES (406, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 14, '2026-03-26 16:00:04');
INSERT INTO `sys_log` VALUES (407, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 15, '2026-03-26 16:00:05');
INSERT INTO `sys_log` VALUES (408, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 18, '2026-03-26 16:01:30');
INSERT INTO `sys_log` VALUES (409, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.changeStatus()', '/course/changeStatus/4/1', 17, '2026-03-26 16:01:58');
INSERT INTO `sys_log` VALUES (410, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 15, '2026-03-26 16:01:58');
INSERT INTO `sys_log` VALUES (411, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 6, '2026-03-26 16:07:53');
INSERT INTO `sys_log` VALUES (412, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-26 16:08:01');
INSERT INTO `sys_log` VALUES (413, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 2, '2026-03-26 16:08:04');
INSERT INTO `sys_log` VALUES (414, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 8, '2026-03-26 16:11:50');
INSERT INTO `sys_log` VALUES (415, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 12, '2026-03-26 16:11:51');
INSERT INTO `sys_log` VALUES (416, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 11, '2026-03-26 16:12:00');
INSERT INTO `sys_log` VALUES (417, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 8, '2026-03-26 16:12:07');
INSERT INTO `sys_log` VALUES (418, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 7, '2026-03-26 16:22:25');
INSERT INTO `sys_log` VALUES (419, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 6, '2026-03-26 16:26:28');
INSERT INTO `sys_log` VALUES (420, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-26 16:26:31');
INSERT INTO `sys_log` VALUES (421, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 9, '2026-03-26 16:26:31');
INSERT INTO `sys_log` VALUES (422, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 3, '2026-03-26 16:26:35');
INSERT INTO `sys_log` VALUES (423, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 16:26:35');
INSERT INTO `sys_log` VALUES (424, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 16:26:35');
INSERT INTO `sys_log` VALUES (425, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.addChapter()', '/chapter/add', 10, '2026-03-26 16:27:16');
INSERT INTO `sys_log` VALUES (426, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 3, '2026-03-26 16:27:16');
INSERT INTO `sys_log` VALUES (427, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 16:27:16');
INSERT INTO `sys_log` VALUES (428, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 16:27:16');
INSERT INTO `sys_log` VALUES (429, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/4', 2, '2026-03-26 16:27:16');
INSERT INTO `sys_log` VALUES (430, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.deleteChapter()', '/chapter/delete/4', 10, '2026-03-26 16:27:19');
INSERT INTO `sys_log` VALUES (431, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 1, '2026-03-26 16:27:19');
INSERT INTO `sys_log` VALUES (432, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 2, '2026-03-26 16:27:19');
INSERT INTO `sys_log` VALUES (433, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 16:27:19');
INSERT INTO `sys_log` VALUES (434, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.addChapter()', '/chapter/add', 9, '2026-03-26 16:27:22');
INSERT INTO `sys_log` VALUES (435, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 5, '2026-03-26 16:27:22');
INSERT INTO `sys_log` VALUES (436, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 16:27:22');
INSERT INTO `sys_log` VALUES (437, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 1, '2026-03-26 16:27:23');
INSERT INTO `sys_log` VALUES (438, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 1, '2026-03-26 16:27:23');
INSERT INTO `sys_log` VALUES (439, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 5, '2026-03-26 16:27:45');
INSERT INTO `sys_log` VALUES (440, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 5, '2026-03-26 16:27:45');
INSERT INTO `sys_log` VALUES (441, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 5, '2026-03-26 16:27:45');
INSERT INTO `sys_log` VALUES (442, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 6, '2026-03-26 16:27:48');
INSERT INTO `sys_log` VALUES (443, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 3, '2026-03-26 16:27:48');
INSERT INTO `sys_log` VALUES (444, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 5, '2026-03-26 16:27:48');
INSERT INTO `sys_log` VALUES (445, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 7, '2026-03-26 16:27:48');
INSERT INTO `sys_log` VALUES (446, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 6, '2026-03-26 16:27:49');
INSERT INTO `sys_log` VALUES (447, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 3, '2026-03-26 16:27:49');
INSERT INTO `sys_log` VALUES (448, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 16:27:49');
INSERT INTO `sys_log` VALUES (449, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 3, '2026-03-26 16:27:49');
INSERT INTO `sys_log` VALUES (450, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 2, '2026-03-26 16:27:49');
INSERT INTO `sys_log` VALUES (451, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 6, '2026-03-26 16:27:49');
INSERT INTO `sys_log` VALUES (452, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.updateCourse()', '/course/update', 1, '2026-03-26 16:28:25');
INSERT INTO `sys_log` VALUES (453, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.changeStatus()', '/course/changeStatus/1/1', 1, '2026-03-26 16:28:25');
INSERT INTO `sys_log` VALUES (454, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 16:28:29');
INSERT INTO `sys_log` VALUES (455, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 6, '2026-03-26 16:28:56');
INSERT INTO `sys_log` VALUES (456, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 11, '2026-03-26 16:28:57');
INSERT INTO `sys_log` VALUES (457, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-26 16:28:58');
INSERT INTO `sys_log` VALUES (458, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 3, '2026-03-26 16:28:58');
INSERT INTO `sys_log` VALUES (459, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 4, '2026-03-26 16:29:01');
INSERT INTO `sys_log` VALUES (460, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 16:29:01');
INSERT INTO `sys_log` VALUES (461, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 16:29:01');
INSERT INTO `sys_log` VALUES (462, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 3, '2026-03-26 16:29:01');
INSERT INTO `sys_log` VALUES (463, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 6, '2026-03-26 16:29:02');
INSERT INTO `sys_log` VALUES (464, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.addCourse()', '/course/add', 4, '2026-03-26 16:29:48');
INSERT INTO `sys_log` VALUES (465, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 4, '2026-03-26 16:29:48');
INSERT INTO `sys_log` VALUES (466, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 9, '2026-03-26 16:29:51');
INSERT INTO `sys_log` VALUES (467, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/5', 1, '2026-03-26 16:29:53');
INSERT INTO `sys_log` VALUES (468, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.updateCourse()', '/course/update', 6, '2026-03-26 16:29:57');
INSERT INTO `sys_log` VALUES (469, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.changeStatus()', '/course/changeStatus/5/1', 2, '2026-03-26 16:29:57');
INSERT INTO `sys_log` VALUES (470, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 6, '2026-03-26 16:30:00');
INSERT INTO `sys_log` VALUES (471, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 16:30:11');
INSERT INTO `sys_log` VALUES (472, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 5, '2026-03-26 16:30:17');
INSERT INTO `sys_log` VALUES (473, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 14, '2026-03-26 16:30:18');
INSERT INTO `sys_log` VALUES (474, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 5, '2026-03-26 16:30:20');
INSERT INTO `sys_log` VALUES (475, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 8, '2026-03-26 16:30:27');
INSERT INTO `sys_log` VALUES (476, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 16:30:30');
INSERT INTO `sys_log` VALUES (477, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 3, '2026-03-26 16:31:46');
INSERT INTO `sys_log` VALUES (478, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-26 16:31:47');
INSERT INTO `sys_log` VALUES (479, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 4, '2026-03-26 16:31:47');
INSERT INTO `sys_log` VALUES (480, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-26 16:31:57');
INSERT INTO `sys_log` VALUES (481, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 7, '2026-03-26 16:31:57');
INSERT INTO `sys_log` VALUES (482, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/5', 7, '2026-03-26 16:32:02');
INSERT INTO `sys_log` VALUES (483, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/5', 2, '2026-03-26 16:32:02');
INSERT INTO `sys_log` VALUES (484, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 6, '2026-03-26 16:32:02');
INSERT INTO `sys_log` VALUES (485, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-26 16:32:05');
INSERT INTO `sys_log` VALUES (486, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 5, '2026-03-26 16:32:05');
INSERT INTO `sys_log` VALUES (487, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 6, '2026-03-26 16:32:11');
INSERT INTO `sys_log` VALUES (488, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/3', 2, '2026-03-26 16:32:11');
INSERT INTO `sys_log` VALUES (489, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/3', 3, '2026-03-26 16:32:11');
INSERT INTO `sys_log` VALUES (490, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 5, '2026-03-26 16:32:11');
INSERT INTO `sys_log` VALUES (491, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-26 16:32:13');
INSERT INTO `sys_log` VALUES (492, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 8, '2026-03-26 16:32:13');
INSERT INTO `sys_log` VALUES (493, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 6, '2026-03-26 16:33:27');
INSERT INTO `sys_log` VALUES (494, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 5, '2026-03-26 16:33:28');
INSERT INTO `sys_log` VALUES (495, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 4, '2026-03-26 16:33:29');
INSERT INTO `sys_log` VALUES (496, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 8, '2026-03-26 17:05:40');
INSERT INTO `sys_log` VALUES (497, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 16, '2026-03-26 17:05:40');
INSERT INTO `sys_log` VALUES (498, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 6, '2026-03-26 17:05:42');
INSERT INTO `sys_log` VALUES (499, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 10, '2026-03-26 17:05:42');
INSERT INTO `sys_log` VALUES (500, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-26 17:39:27');
INSERT INTO `sys_log` VALUES (501, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 5, '2026-03-26 17:39:27');
INSERT INTO `sys_log` VALUES (502, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-26 17:39:29');
INSERT INTO `sys_log` VALUES (503, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 6, '2026-03-26 17:39:29');
INSERT INTO `sys_log` VALUES (504, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 1, '2026-03-26 17:42:15');
INSERT INTO `sys_log` VALUES (505, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 5, '2026-03-26 17:42:15');
INSERT INTO `sys_log` VALUES (506, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-26 17:42:21');
INSERT INTO `sys_log` VALUES (507, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 4, '2026-03-26 17:42:21');
INSERT INTO `sys_log` VALUES (508, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/5', 3, '2026-03-26 17:42:23');
INSERT INTO `sys_log` VALUES (509, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.FileUploadController.upload()', '/file/upload', 3, '2026-03-26 17:42:28');
INSERT INTO `sys_log` VALUES (510, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.updateCourse()', '/course/update', 12, '2026-03-26 17:42:33');
INSERT INTO `sys_log` VALUES (511, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.changeStatus()', '/course/changeStatus/5/1', 2, '2026-03-26 17:42:33');
INSERT INTO `sys_log` VALUES (512, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 5, '2026-03-26 17:42:34');
INSERT INTO `sys_log` VALUES (513, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 5, '2026-03-26 17:42:59');
INSERT INTO `sys_log` VALUES (514, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 6, '2026-03-26 17:43:00');
INSERT INTO `sys_log` VALUES (515, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 3, '2026-03-26 17:43:02');
INSERT INTO `sys_log` VALUES (516, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 17:43:09');
INSERT INTO `sys_log` VALUES (517, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 3, '2026-03-26 17:43:19');
INSERT INTO `sys_log` VALUES (518, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-26 17:43:19');
INSERT INTO `sys_log` VALUES (519, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 4, '2026-03-26 17:43:19');
INSERT INTO `sys_log` VALUES (520, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/5', 6, '2026-03-26 17:43:21');
INSERT INTO `sys_log` VALUES (521, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/5', 1, '2026-03-26 17:43:21');
INSERT INTO `sys_log` VALUES (522, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 7, '2026-03-26 17:43:21');
INSERT INTO `sys_log` VALUES (523, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-26 17:43:24');
INSERT INTO `sys_log` VALUES (524, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 3, '2026-03-26 17:43:24');
INSERT INTO `sys_log` VALUES (525, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 17:43:28');
INSERT INTO `sys_log` VALUES (526, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 5, '2026-03-26 17:43:44');
INSERT INTO `sys_log` VALUES (527, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 8, '2026-03-26 17:43:45');
INSERT INTO `sys_log` VALUES (528, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-26 17:44:25');
INSERT INTO `sys_log` VALUES (529, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 5, '2026-03-26 17:44:25');
INSERT INTO `sys_log` VALUES (530, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.deleteCourse()', '/course/delete/5', 9, '2026-03-26 17:44:28');
INSERT INTO `sys_log` VALUES (531, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 3, '2026-03-26 17:44:28');
INSERT INTO `sys_log` VALUES (532, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.FileUploadController.upload()', '/file/upload', 1, '2026-03-26 17:44:40');
INSERT INTO `sys_log` VALUES (533, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.addCourse()', '/course/add', 8, '2026-03-26 17:45:07');
INSERT INTO `sys_log` VALUES (534, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 3, '2026-03-26 17:45:07');
INSERT INTO `sys_log` VALUES (535, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.addChapter()', '/chapter/add', 10, '2026-03-26 17:45:08');
INSERT INTO `sys_log` VALUES (536, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/6', 1, '2026-03-26 17:45:08');
INSERT INTO `sys_log` VALUES (537, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/6', 2, '2026-03-26 17:45:08');
INSERT INTO `sys_log` VALUES (538, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.updateCourse()', '/course/update', 3, '2026-03-26 17:45:23');
INSERT INTO `sys_log` VALUES (539, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.updateCourse()', '/course/update', 4, '2026-03-26 17:45:24');
INSERT INTO `sys_log` VALUES (540, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.changeStatus()', '/course/changeStatus/6/0', 1, '2026-03-26 17:45:24');
INSERT INTO `sys_log` VALUES (541, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 8, '2026-03-26 17:45:25');
INSERT INTO `sys_log` VALUES (542, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 17:45:32');
INSERT INTO `sys_log` VALUES (543, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 5, '2026-03-26 17:45:41');
INSERT INTO `sys_log` VALUES (544, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 6, '2026-03-26 17:45:42');
INSERT INTO `sys_log` VALUES (545, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.AdminUserController.getUserList()', '/admin/user/list', 3, '2026-03-26 17:45:44');
INSERT INTO `sys_log` VALUES (546, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 3, '2026-03-26 17:45:44');
INSERT INTO `sys_log` VALUES (547, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 17:45:58');
INSERT INTO `sys_log` VALUES (548, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 4, '2026-03-26 17:46:07');
INSERT INTO `sys_log` VALUES (549, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 10, '2026-03-26 17:46:08');
INSERT INTO `sys_log` VALUES (550, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-26 17:46:09');
INSERT INTO `sys_log` VALUES (551, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 3, '2026-03-26 17:46:09');
INSERT INTO `sys_log` VALUES (552, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-26 17:46:11');
INSERT INTO `sys_log` VALUES (553, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 8, '2026-03-26 17:46:11');
INSERT INTO `sys_log` VALUES (554, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 6, '2026-03-26 17:46:13');
INSERT INTO `sys_log` VALUES (555, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/6', 2, '2026-03-26 17:46:15');
INSERT INTO `sys_log` VALUES (556, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 2, '2026-03-26 17:46:16');
INSERT INTO `sys_log` VALUES (557, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 1, '2026-03-26 17:46:17');
INSERT INTO `sys_log` VALUES (558, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 2, '2026-03-26 17:46:18');
INSERT INTO `sys_log` VALUES (559, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getListByHomeworkId()', '/student-homework/list/1', 4, '2026-03-26 17:46:19');
INSERT INTO `sys_log` VALUES (560, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 1, '2026-03-26 17:46:24');
INSERT INTO `sys_log` VALUES (561, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 2, '2026-03-26 17:46:25');
INSERT INTO `sys_log` VALUES (562, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 3, '2026-03-26 17:46:25');
INSERT INTO `sys_log` VALUES (563, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 3, '2026-03-26 17:46:43');
INSERT INTO `sys_log` VALUES (564, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 1, '2026-03-26 17:46:45');
INSERT INTO `sys_log` VALUES (565, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 2, '2026-03-26 17:46:45');
INSERT INTO `sys_log` VALUES (566, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 4, '2026-03-26 17:46:46');
INSERT INTO `sys_log` VALUES (567, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 6, '2026-03-26 17:46:52');
INSERT INTO `sys_log` VALUES (568, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 3, '2026-03-26 17:47:04');
INSERT INTO `sys_log` VALUES (569, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 1, '2026-03-26 17:47:12');
INSERT INTO `sys_log` VALUES (570, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 6, '2026-03-26 17:47:12');
INSERT INTO `sys_log` VALUES (571, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 4, '2026-03-26 17:47:16');
INSERT INTO `sys_log` VALUES (572, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-26 17:47:18');
INSERT INTO `sys_log` VALUES (573, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 3, '2026-03-26 17:47:18');
INSERT INTO `sys_log` VALUES (574, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 4, '2026-03-26 17:48:07');
INSERT INTO `sys_log` VALUES (575, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 4, '2026-03-26 17:48:51');
INSERT INTO `sys_log` VALUES (576, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 2, '2026-03-26 17:48:52');
INSERT INTO `sys_log` VALUES (577, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getListByHomeworkId()', '/student-homework/list/1', 2, '2026-03-26 17:48:53');
INSERT INTO `sys_log` VALUES (578, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 1, '2026-03-26 17:48:54');
INSERT INTO `sys_log` VALUES (579, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 2, '2026-03-26 17:48:55');
INSERT INTO `sys_log` VALUES (580, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getListByHomeworkId()', '/student-homework/list/1', 3, '2026-03-26 17:48:56');
INSERT INTO `sys_log` VALUES (581, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 5, '2026-03-26 17:49:20');
INSERT INTO `sys_log` VALUES (582, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-26 17:49:20');
INSERT INTO `sys_log` VALUES (583, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 5, '2026-03-26 17:49:20');
INSERT INTO `sys_log` VALUES (584, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 5, '2026-03-26 17:49:23');
INSERT INTO `sys_log` VALUES (585, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/3', 3, '2026-03-26 17:49:23');
INSERT INTO `sys_log` VALUES (586, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/2', 2, '2026-03-26 17:49:23');
INSERT INTO `sys_log` VALUES (587, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 2, '2026-03-26 17:49:23');
INSERT INTO `sys_log` VALUES (588, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/1', 2, '2026-03-26 17:49:23');
INSERT INTO `sys_log` VALUES (589, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 1, '2026-03-26 17:49:23');
INSERT INTO `sys_log` VALUES (590, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.submitHomework()', '/student-homework/submit', 17, '2026-03-26 17:49:31');
INSERT INTO `sys_log` VALUES (591, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 5, '2026-03-26 17:49:31');
INSERT INTO `sys_log` VALUES (592, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/3', 2, '2026-03-26 17:49:31');
INSERT INTO `sys_log` VALUES (593, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/2', 2, '2026-03-26 17:49:31');
INSERT INTO `sys_log` VALUES (594, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 2, '2026-03-26 17:49:31');
INSERT INTO `sys_log` VALUES (595, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/1', 2, '2026-03-26 17:49:31');
INSERT INTO `sys_log` VALUES (596, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 1, '2026-03-26 17:49:31');
INSERT INTO `sys_log` VALUES (597, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 5, '2026-03-26 17:49:51');
INSERT INTO `sys_log` VALUES (598, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 8, '2026-03-26 17:49:52');
INSERT INTO `sys_log` VALUES (599, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 17:49:53');
INSERT INTO `sys_log` VALUES (600, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 1, '2026-03-26 17:49:55');
INSERT INTO `sys_log` VALUES (601, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 1, '2026-03-26 17:49:55');
INSERT INTO `sys_log` VALUES (602, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/6', 0, '2026-03-26 17:49:56');
INSERT INTO `sys_log` VALUES (603, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 17:50:05');
INSERT INTO `sys_log` VALUES (604, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 3, '2026-03-26 17:50:13');
INSERT INTO `sys_log` VALUES (605, 3, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 9, '2026-03-26 17:50:13');
INSERT INTO `sys_log` VALUES (606, 3, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 2, '2026-03-26 17:50:16');
INSERT INTO `sys_log` VALUES (607, 3, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/3', 3, '2026-03-26 17:50:17');
INSERT INTO `sys_log` VALUES (608, 3, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/4', 2, '2026-03-26 17:50:17');
INSERT INTO `sys_log` VALUES (609, 3, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/3', 2, '2026-03-26 17:50:18');
INSERT INTO `sys_log` VALUES (610, 3, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getListByHomeworkId()', '/student-homework/list/2', 1, '2026-03-26 17:50:19');
INSERT INTO `sys_log` VALUES (611, 3, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 6, '2026-03-26 17:50:29');
INSERT INTO `sys_log` VALUES (612, 3, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 2, '2026-03-26 17:50:59');
INSERT INTO `sys_log` VALUES (613, 3, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 0, '2026-03-26 17:51:09');
INSERT INTO `sys_log` VALUES (614, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 3, '2026-03-26 17:51:17');
INSERT INTO `sys_log` VALUES (615, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 6, '2026-03-26 17:51:17');
INSERT INTO `sys_log` VALUES (616, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-26 17:51:19');
INSERT INTO `sys_log` VALUES (617, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 3, '2026-03-26 17:51:19');
INSERT INTO `sys_log` VALUES (618, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 3, '2026-03-26 17:51:19');
INSERT INTO `sys_log` VALUES (619, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-26 17:51:20');
INSERT INTO `sys_log` VALUES (620, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 2, '2026-03-26 17:51:20');
INSERT INTO `sys_log` VALUES (621, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 4, '2026-03-26 17:51:22');
INSERT INTO `sys_log` VALUES (622, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 2, '2026-03-26 17:51:24');
INSERT INTO `sys_log` VALUES (623, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 5, '2026-03-26 17:51:24');
INSERT INTO `sys_log` VALUES (624, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 3, '2026-03-26 17:51:26');
INSERT INTO `sys_log` VALUES (625, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 5, '2026-03-26 17:58:05');
INSERT INTO `sys_log` VALUES (626, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 17:59:24');
INSERT INTO `sys_log` VALUES (627, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 4, '2026-03-26 17:59:25');
INSERT INTO `sys_log` VALUES (628, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/2', 2, '2026-03-26 17:59:26');
INSERT INTO `sys_log` VALUES (629, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 3, '2026-03-26 17:59:27');
INSERT INTO `sys_log` VALUES (630, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 2, '2026-03-26 17:59:32');
INSERT INTO `sys_log` VALUES (631, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/2', 3, '2026-03-26 17:59:34');
INSERT INTO `sys_log` VALUES (632, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 3, '2026-03-26 17:59:38');
INSERT INTO `sys_log` VALUES (633, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 18:00:40');
INSERT INTO `sys_log` VALUES (634, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 8, '2026-03-26 18:01:08');
INSERT INTO `sys_log` VALUES (635, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 6, '2026-03-26 18:01:10');
INSERT INTO `sys_log` VALUES (636, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/6', 3, '2026-03-26 18:01:10');
INSERT INTO `sys_log` VALUES (637, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/6', 3, '2026-03-26 18:01:10');
INSERT INTO `sys_log` VALUES (638, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 4, '2026-03-26 18:01:10');
INSERT INTO `sys_log` VALUES (639, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 18:01:10');
INSERT INTO `sys_log` VALUES (640, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 18:01:10');
INSERT INTO `sys_log` VALUES (641, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 2, '2026-03-26 18:01:10');
INSERT INTO `sys_log` VALUES (642, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/2', 2, '2026-03-26 18:01:10');
INSERT INTO `sys_log` VALUES (643, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 4, '2026-03-26 18:01:27');
INSERT INTO `sys_log` VALUES (644, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 18:01:27');
INSERT INTO `sys_log` VALUES (645, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 3, '2026-03-26 18:01:28');
INSERT INTO `sys_log` VALUES (646, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 18:01:28');
INSERT INTO `sys_log` VALUES (647, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 1, '2026-03-26 18:01:29');
INSERT INTO `sys_log` VALUES (648, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 2, '2026-03-26 18:01:29');
INSERT INTO `sys_log` VALUES (649, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 18:01:49');
INSERT INTO `sys_log` VALUES (650, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/6', 2, '2026-03-26 18:01:49');
INSERT INTO `sys_log` VALUES (651, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/6', 2, '2026-03-26 18:01:49');
INSERT INTO `sys_log` VALUES (652, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 18:01:52');
INSERT INTO `sys_log` VALUES (653, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 18:01:55');
INSERT INTO `sys_log` VALUES (654, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/6', 3, '2026-03-26 18:01:55');
INSERT INTO `sys_log` VALUES (655, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/6', 2, '2026-03-26 18:01:55');
INSERT INTO `sys_log` VALUES (656, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 4, '2026-03-26 18:01:55');
INSERT INTO `sys_log` VALUES (657, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 18:01:55');
INSERT INTO `sys_log` VALUES (658, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 18:01:55');
INSERT INTO `sys_log` VALUES (659, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 2, '2026-03-26 18:01:55');
INSERT INTO `sys_log` VALUES (660, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/2', 2, '2026-03-26 18:01:55');
INSERT INTO `sys_log` VALUES (661, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 9, '2026-03-26 18:02:45');
INSERT INTO `sys_log` VALUES (662, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 4, '2026-03-26 18:02:45');
INSERT INTO `sys_log` VALUES (663, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 18:02:45');
INSERT INTO `sys_log` VALUES (664, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 18:02:45');
INSERT INTO `sys_log` VALUES (665, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 2, '2026-03-26 18:02:45');
INSERT INTO `sys_log` VALUES (666, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/2', 2, '2026-03-26 18:02:45');
INSERT INTO `sys_log` VALUES (667, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 6, '2026-03-26 18:02:48');
INSERT INTO `sys_log` VALUES (668, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 18:02:48');
INSERT INTO `sys_log` VALUES (669, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 3, '2026-03-26 18:02:58');
INSERT INTO `sys_log` VALUES (670, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 18:02:58');
INSERT INTO `sys_log` VALUES (671, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/6', 3, '2026-03-26 18:02:59');
INSERT INTO `sys_log` VALUES (672, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/6', 2, '2026-03-26 18:02:59');
INSERT INTO `sys_log` VALUES (673, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 1788, '2026-03-26 18:08:59');
INSERT INTO `sys_log` VALUES (674, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 44, '2026-03-26 18:09:00');
INSERT INTO `sys_log` VALUES (675, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 136, '2026-03-26 18:09:02');
INSERT INTO `sys_log` VALUES (676, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 11, '2026-03-26 18:09:02');
INSERT INTO `sys_log` VALUES (677, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/2', 5, '2026-03-26 18:09:03');
INSERT INTO `sys_log` VALUES (678, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 8, '2026-03-26 18:09:04');
INSERT INTO `sys_log` VALUES (679, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 10, '2026-03-26 18:09:05');
INSERT INTO `sys_log` VALUES (680, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/2', 3, '2026-03-26 18:09:07');
INSERT INTO `sys_log` VALUES (681, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 3, '2026-03-26 18:09:19');
INSERT INTO `sys_log` VALUES (682, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 12, '2026-03-26 18:10:41');
INSERT INTO `sys_log` VALUES (683, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 25, '2026-03-26 18:10:41');
INSERT INTO `sys_log` VALUES (684, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/6', 8, '2026-03-26 18:10:41');
INSERT INTO `sys_log` VALUES (685, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/6', 10, '2026-03-26 18:10:41');
INSERT INTO `sys_log` VALUES (686, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 15, '2026-03-26 18:11:43');
INSERT INTO `sys_log` VALUES (687, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 6, '2026-03-26 18:11:45');
INSERT INTO `sys_log` VALUES (688, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 6, '2026-03-26 18:11:45');
INSERT INTO `sys_log` VALUES (689, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 5, '2026-03-26 18:11:45');
INSERT INTO `sys_log` VALUES (690, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 2, '2026-03-26 18:11:45');
INSERT INTO `sys_log` VALUES (691, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.deleteResource()', '/resource/delete/2', 4, '2026-03-26 18:11:49');
INSERT INTO `sys_log` VALUES (692, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 6, '2026-03-26 18:14:21');
INSERT INTO `sys_log` VALUES (693, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 14, '2026-03-26 18:14:21');
INSERT INTO `sys_log` VALUES (694, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 5, '2026-03-26 18:14:23');
INSERT INTO `sys_log` VALUES (695, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 4, '2026-03-26 18:14:23');
INSERT INTO `sys_log` VALUES (696, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 18:14:23');
INSERT INTO `sys_log` VALUES (697, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 3, '2026-03-26 18:14:23');
INSERT INTO `sys_log` VALUES (698, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.FileUploadController.upload()', '/file/upload', 8, '2026-03-26 18:14:32');
INSERT INTO `sys_log` VALUES (699, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.addResource()', '/resource/add', 6, '2026-03-26 18:14:34');
INSERT INTO `sys_log` VALUES (700, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 6, '2026-03-26 18:14:34');
INSERT INTO `sys_log` VALUES (701, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 5, '2026-03-26 18:14:34');
INSERT INTO `sys_log` VALUES (702, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 3, '2026-03-26 18:14:34');
INSERT INTO `sys_log` VALUES (703, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 3, '2026-03-26 18:14:34');
INSERT INTO `sys_log` VALUES (704, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 15, '2026-03-26 18:14:36');
INSERT INTO `sys_log` VALUES (705, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 5, '2026-03-26 18:14:36');
INSERT INTO `sys_log` VALUES (706, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 5, '2026-03-26 18:14:37');
INSERT INTO `sys_log` VALUES (707, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 3, '2026-03-26 18:14:37');
INSERT INTO `sys_log` VALUES (708, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 4, '2026-03-26 18:14:37');
INSERT INTO `sys_log` VALUES (709, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/2', 3, '2026-03-26 18:14:37');
INSERT INTO `sys_log` VALUES (710, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.deleteResource()', '/resource/delete/4', 9, '2026-03-26 18:14:54');
INSERT INTO `sys_log` VALUES (711, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 12, '2026-03-26 18:17:30');
INSERT INTO `sys_log` VALUES (712, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 4, '2026-03-26 18:17:31');
INSERT INTO `sys_log` VALUES (713, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/2', 3, '2026-03-26 18:17:31');
INSERT INTO `sys_log` VALUES (714, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 4, '2026-03-26 18:17:32');
INSERT INTO `sys_log` VALUES (715, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 15, '2026-03-26 18:19:20');
INSERT INTO `sys_log` VALUES (716, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 14, '2026-03-26 18:19:47');
INSERT INTO `sys_log` VALUES (717, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 12, '2026-03-26 18:22:23');
INSERT INTO `sys_log` VALUES (718, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysNoticeController.getNoticeList()', '/notice/list', 13, '2026-03-26 18:22:24');
INSERT INTO `sys_log` VALUES (719, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 10, '2026-03-26 18:22:32');
INSERT INTO `sys_log` VALUES (720, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 7, '2026-03-26 18:22:32');
INSERT INTO `sys_log` VALUES (721, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 18:22:32');
INSERT INTO `sys_log` VALUES (722, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 18:22:32');
INSERT INTO `sys_log` VALUES (723, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 2, '2026-03-26 18:22:32');
INSERT INTO `sys_log` VALUES (724, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/2', 3, '2026-03-26 18:22:32');
INSERT INTO `sys_log` VALUES (725, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 5, '2026-03-26 18:22:34');
INSERT INTO `sys_log` VALUES (726, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 11, '2026-03-26 18:22:34');
INSERT INTO `sys_log` VALUES (727, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 3, '2026-03-26 18:23:27');
INSERT INTO `sys_log` VALUES (728, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 7, '2026-03-26 18:23:33');
INSERT INTO `sys_log` VALUES (729, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 12, '2026-03-26 18:23:34');
INSERT INTO `sys_log` VALUES (730, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 21, '2026-03-26 18:23:34');
INSERT INTO `sys_log` VALUES (731, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.getUserInfo()', '/user/info', 4, '2026-03-26 18:23:36');
INSERT INTO `sys_log` VALUES (732, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 18:24:49');
INSERT INTO `sys_log` VALUES (733, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 8, '2026-03-26 18:24:56');
INSERT INTO `sys_log` VALUES (734, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 15, '2026-03-26 18:24:57');
INSERT INTO `sys_log` VALUES (735, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 15, '2026-03-26 18:25:16');
INSERT INTO `sys_log` VALUES (736, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.getUserInfo()', '/user/info', 5, '2026-03-26 18:25:19');
INSERT INTO `sys_log` VALUES (737, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 12, '2026-03-26 18:25:33');
INSERT INTO `sys_log` VALUES (738, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 8, '2026-03-26 18:25:34');
INSERT INTO `sys_log` VALUES (739, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 4, '2026-03-26 18:25:35');
INSERT INTO `sys_log` VALUES (740, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 11, '2026-03-26 18:26:32');
INSERT INTO `sys_log` VALUES (741, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 10, '2026-03-26 18:28:14');
INSERT INTO `sys_log` VALUES (742, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 8, '2026-03-26 18:28:22');
INSERT INTO `sys_log` VALUES (743, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/2', 2, '2026-03-26 18:29:45');
INSERT INTO `sys_log` VALUES (744, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 5, '2026-03-26 18:29:51');
INSERT INTO `sys_log` VALUES (745, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.addExam()', '/exam/add', 20, '2026-03-26 18:30:11');
INSERT INTO `sys_log` VALUES (746, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 4, '2026-03-26 18:30:11');
INSERT INTO `sys_log` VALUES (747, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/2', 3, '2026-03-26 18:30:13');
INSERT INTO `sys_log` VALUES (748, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 3, '2026-03-26 18:30:13');
INSERT INTO `sys_log` VALUES (749, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/2', 3, '2026-03-26 18:30:14');
INSERT INTO `sys_log` VALUES (750, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 4, '2026-03-26 18:30:17');
INSERT INTO `sys_log` VALUES (751, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.addExam()', '/exam/add', 10, '2026-03-26 18:30:31');
INSERT INTO `sys_log` VALUES (752, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 4, '2026-03-26 18:30:31');
INSERT INTO `sys_log` VALUES (753, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 8, '2026-03-26 18:31:14');
INSERT INTO `sys_log` VALUES (754, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 9, '2026-03-26 18:31:14');
INSERT INTO `sys_log` VALUES (755, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 10, '2026-03-26 18:31:16');
INSERT INTO `sys_log` VALUES (756, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 4, '2026-03-26 18:31:17');
INSERT INTO `sys_log` VALUES (757, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 1759, '2026-03-26 18:38:50');
INSERT INTO `sys_log` VALUES (758, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 43, '2026-03-26 18:38:51');
INSERT INTO `sys_log` VALUES (759, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 126, '2026-03-26 18:38:53');
INSERT INTO `sys_log` VALUES (760, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 14, '2026-03-26 18:38:53');
INSERT INTO `sys_log` VALUES (761, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 8, '2026-03-26 18:38:53');
INSERT INTO `sys_log` VALUES (762, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 4, '2026-03-26 18:38:53');
INSERT INTO `sys_log` VALUES (763, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 5, '2026-03-26 18:38:53');
INSERT INTO `sys_log` VALUES (764, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/2', 4, '2026-03-26 18:38:53');
INSERT INTO `sys_log` VALUES (765, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 18, '2026-03-26 18:38:56');
INSERT INTO `sys_log` VALUES (766, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 12, '2026-03-26 18:38:57');
INSERT INTO `sys_log` VALUES (767, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/3', 9, '2026-03-26 18:39:03');
INSERT INTO `sys_log` VALUES (768, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 7, '2026-03-26 18:39:14');
INSERT INTO `sys_log` VALUES (769, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/3', 6, '2026-03-26 18:39:38');
INSERT INTO `sys_log` VALUES (770, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.addQuestion()', '/exam/question/add', 22, '2026-03-26 18:40:18');
INSERT INTO `sys_log` VALUES (771, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/3', 5, '2026-03-26 18:40:18');
INSERT INTO `sys_log` VALUES (772, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 3, '2026-03-26 18:40:29');
INSERT INTO `sys_log` VALUES (773, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 10, '2026-03-26 18:40:37');
INSERT INTO `sys_log` VALUES (774, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 11, '2026-03-26 18:40:38');
INSERT INTO `sys_log` VALUES (775, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 18, '2026-03-26 18:40:38');
INSERT INTO `sys_log` VALUES (776, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 14, '2026-03-26 18:40:40');
INSERT INTO `sys_log` VALUES (777, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/3', 7, '2026-03-26 18:40:40');
INSERT INTO `sys_log` VALUES (778, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/2', 7, '2026-03-26 18:40:40');
INSERT INTO `sys_log` VALUES (779, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 4, '2026-03-26 18:40:40');
INSERT INTO `sys_log` VALUES (780, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/1', 5, '2026-03-26 18:40:40');
INSERT INTO `sys_log` VALUES (781, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 3, '2026-03-26 18:40:40');
INSERT INTO `sys_log` VALUES (782, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 12, '2026-03-26 18:40:50');
INSERT INTO `sys_log` VALUES (783, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 8, '2026-03-26 18:40:50');
INSERT INTO `sys_log` VALUES (784, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 8, '2026-03-26 18:40:50');
INSERT INTO `sys_log` VALUES (785, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 12, '2026-03-26 18:40:50');
INSERT INTO `sys_log` VALUES (786, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/3', 7, '2026-03-26 18:40:50');
INSERT INTO `sys_log` VALUES (787, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/1', 7, '2026-03-26 18:40:52');
INSERT INTO `sys_log` VALUES (788, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseDiscussionController.getMainPosts()', '/discussion/list/main/2', 5, '2026-03-26 18:40:52');
INSERT INTO `sys_log` VALUES (789, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 18:41:13');
INSERT INTO `sys_log` VALUES (790, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 4, '2026-03-26 18:41:22');
INSERT INTO `sys_log` VALUES (791, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 8, '2026-03-26 18:41:30');
INSERT INTO `sys_log` VALUES (792, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 17, '2026-03-26 18:41:31');
INSERT INTO `sys_log` VALUES (793, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 10, '2026-03-26 18:41:32');
INSERT INTO `sys_log` VALUES (794, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 6, '2026-03-26 18:41:34');
INSERT INTO `sys_log` VALUES (795, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/3', 4, '2026-03-26 18:41:37');
INSERT INTO `sys_log` VALUES (796, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.updateExam()', '/exam/update', 14, '2026-03-26 18:41:42');
INSERT INTO `sys_log` VALUES (797, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 4, '2026-03-26 18:41:47');
INSERT INTO `sys_log` VALUES (798, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 10, '2026-03-26 18:41:52');
INSERT INTO `sys_log` VALUES (799, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 4, '2026-03-26 18:41:53');
INSERT INTO `sys_log` VALUES (800, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 3, '2026-03-26 18:41:54');
INSERT INTO `sys_log` VALUES (801, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/6', 2, '2026-03-26 18:41:54');
INSERT INTO `sys_log` VALUES (802, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 4, '2026-03-26 18:41:55');
INSERT INTO `sys_log` VALUES (803, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 11, '2026-03-26 18:42:23');
INSERT INTO `sys_log` VALUES (804, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 2, '2026-03-26 18:42:28');
INSERT INTO `sys_log` VALUES (805, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 7, '2026-03-26 18:42:35');
INSERT INTO `sys_log` VALUES (806, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 7, '2026-03-26 18:42:35');
INSERT INTO `sys_log` VALUES (807, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 13, '2026-03-26 18:42:35');
INSERT INTO `sys_log` VALUES (808, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 5, '2026-03-26 18:42:42');
INSERT INTO `sys_log` VALUES (809, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 11, '2026-03-26 18:45:13');
INSERT INTO `sys_log` VALUES (810, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 7, '2026-03-26 18:45:13');
INSERT INTO `sys_log` VALUES (811, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 7, '2026-03-26 18:45:13');
INSERT INTO `sys_log` VALUES (812, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 6, '2026-03-26 18:45:13');
INSERT INTO `sys_log` VALUES (813, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 7, '2026-03-26 18:45:18');
INSERT INTO `sys_log` VALUES (814, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 5, '2026-03-26 18:45:18');
INSERT INTO `sys_log` VALUES (815, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 7, '2026-03-26 18:45:18');
INSERT INTO `sys_log` VALUES (816, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 3, '2026-03-26 18:45:18');
INSERT INTO `sys_log` VALUES (817, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 3, '2026-03-26 18:45:18');
INSERT INTO `sys_log` VALUES (818, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 9, '2026-03-26 18:45:18');
INSERT INTO `sys_log` VALUES (819, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 11, '2026-03-26 18:45:27');
INSERT INTO `sys_log` VALUES (820, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 8, '2026-03-26 18:45:27');
INSERT INTO `sys_log` VALUES (821, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 8, '2026-03-26 18:45:27');
INSERT INTO `sys_log` VALUES (822, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 8, '2026-03-26 18:45:27');
INSERT INTO `sys_log` VALUES (823, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 5, '2026-03-26 18:45:30');
INSERT INTO `sys_log` VALUES (824, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 10, '2026-03-26 18:45:30');
INSERT INTO `sys_log` VALUES (825, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 6, '2026-03-26 18:45:34');
INSERT INTO `sys_log` VALUES (826, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 4, '2026-03-26 18:45:34');
INSERT INTO `sys_log` VALUES (827, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 18:45:34');
INSERT INTO `sys_log` VALUES (828, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 3, '2026-03-26 18:45:34');
INSERT INTO `sys_log` VALUES (829, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 6, '2026-03-26 18:45:34');
INSERT INTO `sys_log` VALUES (830, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 12, '2026-03-26 18:45:34');
INSERT INTO `sys_log` VALUES (831, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 11, '2026-03-26 18:45:39');
INSERT INTO `sys_log` VALUES (832, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 11, '2026-03-26 18:45:39');
INSERT INTO `sys_log` VALUES (833, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 9, '2026-03-26 18:45:59');
INSERT INTO `sys_log` VALUES (834, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 14, '2026-03-26 18:45:59');
INSERT INTO `sys_log` VALUES (835, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 5, '2026-03-26 18:46:01');
INSERT INTO `sys_log` VALUES (836, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 9, '2026-03-26 18:46:01');
INSERT INTO `sys_log` VALUES (837, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 8, '2026-03-26 18:46:03');
INSERT INTO `sys_log` VALUES (838, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 4, '2026-03-26 18:46:03');
INSERT INTO `sys_log` VALUES (839, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 4, '2026-03-26 18:46:03');
INSERT INTO `sys_log` VALUES (840, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 18:46:03');
INSERT INTO `sys_log` VALUES (841, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 2, '2026-03-26 18:46:03');
INSERT INTO `sys_log` VALUES (842, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/2', 3, '2026-03-26 18:46:03');
INSERT INTO `sys_log` VALUES (843, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 5, '2026-03-26 18:46:05');
INSERT INTO `sys_log` VALUES (844, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 9, '2026-03-26 18:46:05');
INSERT INTO `sys_log` VALUES (845, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 4, '2026-03-26 18:46:10');
INSERT INTO `sys_log` VALUES (846, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 3, '2026-03-26 18:46:10');
INSERT INTO `sys_log` VALUES (847, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 18:46:10');
INSERT INTO `sys_log` VALUES (848, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 2, '2026-03-26 18:46:10');
INSERT INTO `sys_log` VALUES (849, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.FileUploadController.upload()', '/file/upload', 7, '2026-03-26 18:46:57');
INSERT INTO `sys_log` VALUES (850, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.addResource()', '/resource/add', 11, '2026-03-26 18:46:58');
INSERT INTO `sys_log` VALUES (851, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 9, '2026-03-26 18:46:59');
INSERT INTO `sys_log` VALUES (852, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 4, '2026-03-26 18:46:59');
INSERT INTO `sys_log` VALUES (853, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 2, '2026-03-26 18:46:59');
INSERT INTO `sys_log` VALUES (854, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 3, '2026-03-26 18:46:59');
INSERT INTO `sys_log` VALUES (855, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.updateCourse()', '/course/update', 11, '2026-03-26 18:47:01');
INSERT INTO `sys_log` VALUES (856, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.changeStatus()', '/course/changeStatus/1/0', 2, '2026-03-26 18:47:01');
INSERT INTO `sys_log` VALUES (857, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 9, '2026-03-26 18:47:20');
INSERT INTO `sys_log` VALUES (858, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 7, '2026-03-26 18:47:21');
INSERT INTO `sys_log` VALUES (859, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 11, '2026-03-26 18:47:21');
INSERT INTO `sys_log` VALUES (860, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 19, '2026-03-26 18:47:26');
INSERT INTO `sys_log` VALUES (861, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 12, '2026-03-26 18:47:27');
INSERT INTO `sys_log` VALUES (862, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 9, '2026-03-26 18:47:36');
INSERT INTO `sys_log` VALUES (863, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 3, '2026-03-26 18:47:36');
INSERT INTO `sys_log` VALUES (864, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/2', 7, '2026-03-26 18:47:36');
INSERT INTO `sys_log` VALUES (865, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/3', 7, '2026-03-26 18:47:36');
INSERT INTO `sys_log` VALUES (866, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 18:47:42');
INSERT INTO `sys_log` VALUES (867, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 7, '2026-03-26 18:47:48');
INSERT INTO `sys_log` VALUES (868, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.DataStatisticsController.getDashboardData()', '/admin/statistics/dashboard', 19, '2026-03-26 18:47:48');
INSERT INTO `sys_log` VALUES (869, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 10, '2026-03-26 18:47:50');
INSERT INTO `sys_log` VALUES (870, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.changeStatus()', '/course/changeStatus/1/1', 10, '2026-03-26 18:47:58');
INSERT INTO `sys_log` VALUES (871, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 8, '2026-03-26 18:47:58');
INSERT INTO `sys_log` VALUES (872, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.changeStatus()', '/course/changeStatus/6/1', 4, '2026-03-26 18:47:59');
INSERT INTO `sys_log` VALUES (873, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getAdminCourseList()', '/course/admin/list', 9, '2026-03-26 18:47:59');
INSERT INTO `sys_log` VALUES (874, 1, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 1, '2026-03-26 18:48:02');
INSERT INTO `sys_log` VALUES (875, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 7, '2026-03-26 18:48:11');
INSERT INTO `sys_log` VALUES (876, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 6, '2026-03-26 18:48:11');
INSERT INTO `sys_log` VALUES (877, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 11, '2026-03-26 18:48:11');
INSERT INTO `sys_log` VALUES (878, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getCourseDetail()', '/course/public/detail/1', 6, '2026-03-26 18:48:14');
INSERT INTO `sys_log` VALUES (879, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseChapterController.getListByCourseId()', '/chapter/list/1', 6, '2026-03-26 18:48:14');
INSERT INTO `sys_log` VALUES (880, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/1', 5, '2026-03-26 18:48:14');
INSERT INTO `sys_log` VALUES (881, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/2', 4, '2026-03-26 18:48:14');
INSERT INTO `sys_log` VALUES (882, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseResourceController.getListByChapterId()', '/resource/list/5', 3, '2026-03-26 18:48:14');
INSERT INTO `sys_log` VALUES (883, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 8, '2026-03-26 18:48:14');
INSERT INTO `sys_log` VALUES (884, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 8, '2026-03-26 18:48:58');
INSERT INTO `sys_log` VALUES (885, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/3', 2, '2026-03-26 18:48:58');
INSERT INTO `sys_log` VALUES (886, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 6, '2026-03-26 18:48:58');
INSERT INTO `sys_log` VALUES (887, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/2', 5, '2026-03-26 18:48:58');
INSERT INTO `sys_log` VALUES (888, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/3', 4, '2026-03-26 18:49:13');
INSERT INTO `sys_log` VALUES (889, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/1', 6, '2026-03-26 18:49:16');
INSERT INTO `sys_log` VALUES (890, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-26 18:49:19');
INSERT INTO `sys_log` VALUES (891, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/3', 3, '2026-03-26 18:49:19');
INSERT INTO `sys_log` VALUES (892, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 3, '2026-03-26 18:49:19');
INSERT INTO `sys_log` VALUES (893, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/2', 3, '2026-03-26 18:49:19');
INSERT INTO `sys_log` VALUES (894, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 675, '2026-03-26 18:55:12');
INSERT INTO `sys_log` VALUES (895, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseCategoryController.getList()', '/category/list', 9, '2026-03-26 18:55:12');
INSERT INTO `sys_log` VALUES (896, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getPublicCourseList()', '/course/public/list', 62, '2026-03-26 18:55:12');
INSERT INTO `sys_log` VALUES (897, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 10, '2026-03-26 18:55:14');
INSERT INTO `sys_log` VALUES (898, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/3', 5, '2026-03-26 18:55:14');
INSERT INTO `sys_log` VALUES (899, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/2', 5, '2026-03-26 18:55:14');
INSERT INTO `sys_log` VALUES (900, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/1', 3, '2026-03-26 18:55:14');
INSERT INTO `sys_log` VALUES (901, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentHomeworkController.getMySubmission()', '/student-homework/my/1', 4, '2026-03-26 18:55:14');
INSERT INTO `sys_log` VALUES (902, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.HomeworkController.getListByCourseId()', '/homework/list/2', 1, '2026-03-26 18:55:14');
INSERT INTO `sys_log` VALUES (903, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 8, '2026-03-26 18:55:18');
INSERT INTO `sys_log` VALUES (904, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/3', 2, '2026-03-26 18:55:18');
INSERT INTO `sys_log` VALUES (905, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 5, '2026-03-26 18:55:18');
INSERT INTO `sys_log` VALUES (906, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getMyExamRecord()', '/student-exam/myRecord/3', 5, '2026-03-26 18:55:18');
INSERT INTO `sys_log` VALUES (907, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getMyExamRecord()', '/student-exam/myRecord/1', 2, '2026-03-26 18:55:18');
INSERT INTO `sys_log` VALUES (908, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/2', 3, '2026-03-26 18:55:18');
INSERT INTO `sys_log` VALUES (909, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/3', 5, '2026-03-26 18:55:20');
INSERT INTO `sys_log` VALUES (910, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getQuestions()', '/exam/question/list/3', 6, '2026-03-26 18:55:23');
INSERT INTO `sys_log` VALUES (911, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.submitExam()', '/student-exam/submit', 28, '2026-03-26 18:55:26');
INSERT INTO `sys_log` VALUES (912, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 8, '2026-03-26 18:55:26');
INSERT INTO `sys_log` VALUES (913, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/3', 2, '2026-03-26 18:55:26');
INSERT INTO `sys_log` VALUES (914, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 4, '2026-03-26 18:55:26');
INSERT INTO `sys_log` VALUES (915, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getMyExamRecord()', '/student-exam/myRecord/3', 2, '2026-03-26 18:55:26');
INSERT INTO `sys_log` VALUES (916, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getMyExamRecord()', '/student-exam/myRecord/1', 3, '2026-03-26 18:55:26');
INSERT INTO `sys_log` VALUES (917, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/2', 2, '2026-03-26 18:55:26');
INSERT INTO `sys_log` VALUES (918, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentCourseController.getMyCourses()', '/student-course/myList', 5, '2026-03-26 18:56:55');
INSERT INTO `sys_log` VALUES (919, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/3', 1, '2026-03-26 18:56:55');
INSERT INTO `sys_log` VALUES (920, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 2, '2026-03-26 18:56:55');
INSERT INTO `sys_log` VALUES (921, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getMyExamRecord()', '/student-exam/myRecord/3', 3, '2026-03-26 18:56:55');
INSERT INTO `sys_log` VALUES (922, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getMyExamRecord()', '/student-exam/myRecord/1', 2, '2026-03-26 18:56:55');
INSERT INTO `sys_log` VALUES (923, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/2', 2, '2026-03-26 18:56:55');
INSERT INTO `sys_log` VALUES (924, 4, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.logout()', '/user/logout', 2, '2026-03-26 18:57:48');
INSERT INTO `sys_log` VALUES (925, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 5, '2026-03-26 18:57:56');
INSERT INTO `sys_log` VALUES (926, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 13, '2026-03-26 18:57:56');
INSERT INTO `sys_log` VALUES (927, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 8, '2026-03-26 18:57:58');
INSERT INTO `sys_log` VALUES (928, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/6', 3, '2026-03-26 18:57:59');
INSERT INTO `sys_log` VALUES (929, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 2, '2026-03-26 18:58:00');
INSERT INTO `sys_log` VALUES (930, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 15, '2026-03-26 18:58:04');
INSERT INTO `sys_log` VALUES (931, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/6', 1, '2026-03-26 18:58:04');
INSERT INTO `sys_log` VALUES (932, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 2, '2026-03-26 18:58:04');
INSERT INTO `sys_log` VALUES (933, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/2', 2, '2026-03-26 18:58:04');
INSERT INTO `sys_log` VALUES (934, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 10, '2026-03-26 18:58:05');
INSERT INTO `sys_log` VALUES (935, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 18:58:06');
INSERT INTO `sys_log` VALUES (936, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/6', 1, '2026-03-26 18:58:06');
INSERT INTO `sys_log` VALUES (937, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 2, '2026-03-26 18:58:06');
INSERT INTO `sys_log` VALUES (938, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/2', 1, '2026-03-26 18:58:06');
INSERT INTO `sys_log` VALUES (939, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 5, '2026-03-26 18:58:07');
INSERT INTO `sys_log` VALUES (940, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/6', 2, '2026-03-26 18:58:08');
INSERT INTO `sys_log` VALUES (941, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 4, '2026-03-26 18:58:14');
INSERT INTO `sys_log` VALUES (942, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 7, '2026-03-26 18:58:15');
INSERT INTO `sys_log` VALUES (943, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/6', 1, '2026-03-26 18:58:15');
INSERT INTO `sys_log` VALUES (944, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 2, '2026-03-26 18:58:15');
INSERT INTO `sys_log` VALUES (945, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/2', 2, '2026-03-26 18:58:15');
INSERT INTO `sys_log` VALUES (946, NULL, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.SysUserController.login()', '/user/login', 641, '2026-03-26 18:58:51');
INSERT INTO `sys_log` VALUES (947, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.TeacherStatisticsController.getTeacherDashboard()', '/teacher/statistics/dashboard', 22, '2026-03-26 18:58:51');
INSERT INTO `sys_log` VALUES (948, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.CourseController.getMyCourseList()', '/course/myList', 47, '2026-03-26 18:58:53');
INSERT INTO `sys_log` VALUES (949, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/6', 5, '2026-03-26 18:58:53');
INSERT INTO `sys_log` VALUES (950, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/1', 4, '2026-03-26 18:58:53');
INSERT INTO `sys_log` VALUES (951, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.ExamController.getExamListByCourseId()', '/exam/list/2', 1, '2026-03-26 18:58:53');
INSERT INTO `sys_log` VALUES (952, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getExamSubmissions()', '/student-exam/teacher/list/3', 5, '2026-03-26 18:58:54');
INSERT INTO `sys_log` VALUES (953, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getSubmissionDetail()', '/student-exam/teacher/detail/2', 6, '2026-03-26 18:58:56');
INSERT INTO `sys_log` VALUES (954, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getExamSubmissions()', '/student-exam/teacher/list/2', 2, '2026-03-26 18:58:58');
INSERT INTO `sys_log` VALUES (955, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getExamSubmissions()', '/student-exam/teacher/list/1', 2, '2026-03-26 18:58:59');
INSERT INTO `sys_log` VALUES (956, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getSubmissionDetail()', '/student-exam/teacher/detail/1', 3, '2026-03-26 18:59:01');
INSERT INTO `sys_log` VALUES (957, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.gradeSubmission()', '/student-exam/teacher/grade', 15, '2026-03-26 18:59:14');
INSERT INTO `sys_log` VALUES (958, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getExamSubmissions()', '/student-exam/teacher/list/1', 4, '2026-03-26 18:59:14');
INSERT INTO `sys_log` VALUES (959, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getExamSubmissions()', '/student-exam/teacher/list/2', 3, '2026-03-26 18:59:16');
INSERT INTO `sys_log` VALUES (960, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getExamSubmissions()', '/student-exam/teacher/list/2', 2, '2026-03-26 19:00:00');
INSERT INTO `sys_log` VALUES (961, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getExamSubmissions()', '/student-exam/teacher/list/1', 3, '2026-03-26 19:00:01');
INSERT INTO `sys_log` VALUES (962, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getExamSubmissions()', '/student-exam/teacher/list/3', 3, '2026-03-26 19:00:02');
INSERT INTO `sys_log` VALUES (963, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getExamSubmissions()', '/student-exam/teacher/list/2', 2, '2026-03-26 19:00:03');
INSERT INTO `sys_log` VALUES (964, 2, '0:0:0:0:0:0:0:1', 'org.example.lzw.controller.StudentExamController.getExamSubmissions()', '/student-exam/teacher/list/2', 1, '2026-03-26 19:00:10');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `type` tinyint(4) NULL DEFAULT 1 COMMENT '类型: 1-系统公告, 2-课程通知 [cite: 28]',
  `sender_id` bigint(20) NULL DEFAULT NULL COMMENT '发送者ID(管理员或教师)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(4) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统公告通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '欢迎来到智学教育平台', '系统现已正式上线，祝大家学习愉快！', 1, 1, '2026-03-25 23:12:07', '2026-03-25 23:12:07', 0);
INSERT INTO `sys_notice` VALUES (2, 'Vue 实战课更新通知', '第二章节内容已上传，请同学们及时学习。', 2, 2, '2026-03-25 23:12:07', '2026-03-25 23:12:07', 0);
INSERT INTO `sys_notice` VALUES (3, 'test', 'tttt', 1, 1, '2026-03-26 15:41:07', '2026-03-26 15:41:07', 0);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录账号(学号/工号/用户名)',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `role` tinyint(4) NOT NULL COMMENT '角色: 0-管理员, 1-教师, 2-学生',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名/昵称 [cite: 6]',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像URL [cite: 6]',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号 [cite: 4]',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱 [cite: 4]',
  `major` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '专业(学生专属) [cite: 6]',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用 [cite: 35]',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint(4) NULL DEFAULT 0 COMMENT '逻辑删除: 0-未删除, 1-已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '123456', 0, '系统管理员', 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin', NULL, NULL, '系统管理', 1, '2026-03-25 23:10:44', '2026-03-26 15:09:04', 0);
INSERT INTO `sys_user` VALUES (2, 'teacher1', '123456', 1, '张教授', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix', NULL, NULL, '计算机科学', 1, '2026-03-25 23:10:44', '2026-03-25 23:10:44', 0);
INSERT INTO `sys_user` VALUES (3, 'teacher2', '123456', 1, 'Emily White', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Emily', NULL, NULL, '艺术设计', 1, '2026-03-25 23:10:44', '2026-03-25 23:10:44', 0);
INSERT INTO `sys_user` VALUES (4, 'lzw', '123456', 2, '小明', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Aneka', '12388888888', NULL, '软件工程', 1, '2026-03-25 23:10:44', '2026-03-26 14:13:07', 0);
INSERT INTO `sys_user` VALUES (5, 'student2', '123456', 2, 'Sarah', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah', NULL, NULL, '数字媒体', 1, '2026-03-25 23:10:44', '2026-03-25 23:10:44', 0);

SET FOREIGN_KEY_CHECKS = 1;
