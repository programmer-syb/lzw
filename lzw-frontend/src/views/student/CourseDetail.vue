<template>
    <div class="course-detail-container" v-loading="loading">
        <header class="detail-header">
            <div class="header-content">
                <el-button @click="router.back()" :icon="ArrowLeft" circle class="mac-back-btn" />
                <div class="header-info">
                    <h1 class="course-title">{{ course.title }}</h1>
                    <div class="teacher-meta">
                        <el-avatar :size="24" :src="teacherAvatar" />
                        <span>{{ teacherName }}</span>
                        <el-divider direction="vertical" />
                        <el-tag size="small" effect="plain" round>{{ categoryName }}</el-tag>
                    </div>
                </div>
                <div class="header-actions">
                    <el-button v-if="!isEnrolled" type="primary" round class="apple-btn-primary" @click="handleEnroll">
                        立即加入学习
                    </el-button>
                    <div v-else class="enrolled-status-group">
                        <el-tag type="success" effect="light" round size="large">已加入学习</el-tag>
                        <el-button type="danger" plain round size="small" class="ml-10" @click="handleDropCourse">
                            退出课程
                        </el-button>
                    </div>
                </div>
            </div>
        </header>

        <div class="main-layout">
            <div class="content-left">
                <div class="video-section mac-squircle">
                    <div v-if="activeResource.url" class="player-wrapper">
                        <video ref="videoPlayer" controls :src="activeResource.url" class="main-video"
                            @timeupdate="handleTimeUpdate" @loadedmetadata="handleLoadedMetadata"></video>
                    </div>
                    <div v-else class="video-placeholder">
                        <img :src="course.cover" class="placeholder-bg" />
                        <div class="placeholder-mask">
                            <el-icon class="play-icon">
                                <VideoPlay />
                            </el-icon>
                            <p>{{ isEnrolled ? '请从右侧选择章节开始学习' : '报名后即可开启学习之旅' }}</p>
                        </div>
                    </div>
                </div>

                <div class="detail-tabs-wrapper">
                    <el-tabs v-model="activeTab" class="mac-tabs">
                        <el-tab-pane label="课程简介" name="intro">
                            <div class="rich-text-content">
                                <p>{{ course.intro }}</p>
                                <div class="syllabus-section">
                                    <h3>教学大纲 [cite: 11]</h3>
                                    <pre class="syllabus-pre">{{ course.syllabus }}</pre>
                                </div>
                            </div>
                        </el-tab-pane>
                        <el-tab-pane label="讨论交流" name="discussion">
                            <p class="empty-tip">讨论区火热建设中...</p>
                        </el-tab-pane>
                    </el-tabs>
                </div>
            </div>

            <aside class="sidebar-right glass-panel mac-squircle">
                <div class="sidebar-header">
                    <h3>课程章节</h3>
                    <span class="progress-text" v-if="isEnrolled">学习进度: {{ currentProgress }}% [cite: 17]</span>
                </div>

                <el-scrollbar class="chapter-scroll">
                    <div v-for="(chapter, index) in chapterList" :key="chapter.id" class="chapter-item">
                        <div class="chapter-title">第 {{ index + 1 }} 章：{{ chapter.title }}</div>
                        <div class="resource-list">
                            <div v-for="res in chapter.resources" :key="res.id" class="resource-link"
                                :class="{ 'is-active': activeResource.id === res.id, 'is-locked': !isEnrolled }"
                                @click="playResource(res)">
                                <el-icon>
                                    <VideoCamera v-if="res.type === 'video'" />
                                    <Document v-else />
                                </el-icon>
                                <span class="res-name">{{ res.name }}</span>
                                <span class="res-duration" v-if="res.duration">{{ formatDuration(res.duration) }}</span>
                            </div>
                        </div>
                    </div>
                </el-scrollbar>
            </aside>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
    ArrowLeft, VideoPlay, VideoCamera, Document, Reading
} from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'

const route = useRoute()
const router = useRouter()
const courseId = route.params.id

// --- 数据定义 ---
const loading = ref(false)
const course = ref({})
const teacherName = ref('')
const teacherAvatar = ref('')
const categoryName = ref('')
const chapterList = ref([])
const isEnrolled = ref(false)
const currentProgress = ref(0)
const activeTab = ref('intro')
const activeResource = ref({}) // 当前播放的资源

// --- 初始化获取数据 ---
onMounted(async () => {
    await fetchCourseDetail()
    await fetchChapters()
    checkEnrollment()
})

// 1. 获取课程及教师详情 [cite: 11]
const fetchCourseDetail = async () => {
    loading.value = true
    try {
        const res = await request.get(`/course/public/detail/${courseId}`)
        course.value = res.course
        teacherName.value = res.teacherName
        teacherAvatar.value = res.teacherAvatar
        // 这里简单转换分类名
        categoryName.value = '专业课程'
    } catch (e) {
        ElMessage.error('课程加载失败')
    } finally {
        loading.value = false
    }
}

// 2. 获取章节及资源列表
const fetchChapters = async () => {
    try {
        // 获取章节
        const chapters = await request.get(`/chapter/list/${courseId}`)
        // 循环获取每个章节下的资源 [cite: 72]
        for (let chap of chapters) {
            chap.resources = await request.get(`/resource/list/${chap.id}`)
        }
        chapterList.value = chapters
    } catch (e) {
        console.error(e)
    }
}

// 3. 检查是否选课 [cite: 12]
const checkEnrollment = async () => {
    try {
        const res = await request.get('/student-course/myList')
        const myCourse = res.records.find(c => c.courseId == courseId)
        if (myCourse) {
            isEnrolled.value = true
            currentProgress.value = myCourse.progress
        }
    } catch (e) { }
}

// 4. 选课操作 [cite: 12]
const handleEnroll = async () => {
    try {
        await request.post(`/student-course/enroll/${courseId}`)
        ElMessage.success('加入学习成功！')
        isEnrolled.value = true
    } catch (e) { }
}

// 5. 播放资源
const playResource = (res) => {
    if (!isEnrolled.value) {
        return ElMessage.warning('请先点击上方按钮加入学习')
    }
    if (res.type === 'video') {
        activeResource.value = res
    } else {
        window.open(res.url) // PDF等资源直接打开
    }
}

// 6. 进度记录 (每分钟向后端上报一次) 
const lastUploadedTime = ref(0);
const handleTimeUpdate = async (e) => {
    const video = e.target;
    const currentTime = Math.floor(video.currentTime); // 当前播放秒数 
    const duration = video.duration; // 视频总时长

    // 1. 每隔 60 秒上报一次，或者当视频播放结束时上报
    if (currentTime - lastUploadedTime.value >= 60 || currentTime === Math.floor(duration)) {
        lastUploadedTime.value = currentTime;

        // 2. 计算进度百分比 (保留两位小数) 
        const progressPercent = ((currentTime / duration) * 100).toFixed(2);

        try {
            // 3. 调用后端接口更新进度 [cite: 16]
            await request.put('/student-course/updateProgress', {
                courseId: courseId,
                progress: progressPercent,
                watchTime: currentTime
            });

            // 4. 同步更新本地显示的进度文字
            currentProgress.value = progressPercent;

            console.log(`进度已同步: ${progressPercent}%`);
        } catch (error) {
            console.error('进度上报失败', error);
        }
    }
}

const formatDuration = (sec) => {
    const m = Math.floor(sec / 60)
    const s = sec % 60
    return `${m}:${s < 10 ? '0' + s : s}`
}

// 7. 退课操作
const handleDropCourse = () => {
    ElMessageBox.confirm('确定要退出该课程吗？退出后你的学习进度将被清空。', '退课确认', {
        confirmButtonText: '确定退出',
        cancelButtonText: '取消',
        type: 'warning',
        customClass: 'mac-message-box'
    }).then(async () => {
        try {
            await request.delete(`/student-course/drop/${courseId}`)
            ElMessage.success('已成功退出该课程')
            // 重置状态为未选课
            isEnrolled.value = false
            currentProgress.value = 0
            activeResource.value = {} // 清除当前播放资源
        } catch (e) {
            // 错误由 request 拦截器处理
        }
    }).catch(() => { })
}
const handleLoadedMetadata = (e) => {
  const video = e.target;
  // 如果当前课程有历史播放记录且进度未完成，自动跳转
  // 假设从 checkEnrollment 中获取到了历史 watchTime
  if (historyWatchTime > 0 && historyWatchTime < video.duration) {
    video.currentTime = historyWatchTime;
    ElMessage.info(`已为您自动跳转到上次学习位置：${formatDuration(historyWatchTime)}`);
  }
}
</script>

<style scoped>
.course-detail-container {
    max-width: 1400px;
    margin: 0 auto;
}

/* ================= 1. Header 苹果式微光 ================= */
.detail-header {
    padding: 20px 0;
    margin-bottom: 20px;
}

.header-content {
    display: flex;
    align-items: center;
    gap: 20px;
}

.mac-back-btn {
    background: rgba(0, 0, 0, 0.05) !important;
    border: none !important;
    color: #1d1d1f !important;
}

.header-info {
    flex: 1;
}

.course-title {
    font-size: 1.8rem;
    font-weight: 700;
    margin: 0 0 8px 0;
    color: #1d1d1f;
}

.teacher-meta {
    display: flex;
    align-items: center;
    gap: 12px;
    color: #86868b;
    font-size: 0.9rem;
}

.apple-btn-primary {
    background-color: #007aff !important;
    border: none !important;
    padding: 12px 30px !important;
    font-weight: 600;
    box-shadow: 0 4px 12px rgba(0, 122, 255, 0.3);
}

/* ================= 2. 布局主体 ================= */
.main-layout {
    display: grid;
    grid-template-columns: 1fr 350px;
    gap: 24px;
}

/* 播放器区域 */
.video-section {
    width: 100%;
    aspect-ratio: 16 / 9;
    background: #000;
    overflow: hidden;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.main-video {
    width: 100%;
    height: 100%;
}

.video-placeholder {
    position: relative;
    width: 100%;
    height: 100%;
}

.placeholder-bg {
    width: 100%;
    height: 100%;
    object-fit: cover;
    filter: blur(10px);
}

.placeholder-mask {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.4);
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: #fff;
}

.play-icon {
    font-size: 80px;
    opacity: 0.8;
    margin-bottom: 20px;
}

/* 详情 Tabs */
.detail-tabs-wrapper {
    margin-top: 30px;
}

.rich-text-content {
    line-height: 1.8;
    color: #1d1d1f;
}

.syllabus-pre {
    background: #f5f5f7;
    padding: 20px;
    border-radius: 12px;
    font-family: inherit;
    white-space: pre-wrap;
}

/* ================= 3. 侧边栏章节 (毛玻璃) ================= */
.sidebar-right {
    height: calc(100vh - 250px);
    position: sticky;
    top: 20px;
    display: flex;
    flex-direction: column;
    background: rgba(255, 255, 255, 0.6) !important;
}

.sidebar-header {
    padding: 20px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.sidebar-header h3 {
    margin: 0;
    font-size: 1.1rem;
}

.progress-text {
    font-size: 12px;
    color: #007aff;
    font-weight: 600;
}

.chapter-scroll {
    flex: 1;
    padding: 10px;
}

.chapter-item {
    margin-bottom: 20px;
}

.chapter-title {
    font-weight: 700;
    font-size: 0.95rem;
    color: #86868b;
    padding: 0 10px 10px;
}

.resource-link {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 15px;
    border-radius: 10px;
    cursor: pointer;
    transition: all 0.2s;
    margin-bottom: 5px;
    font-size: 14px;
}

.resource-link:hover {
    background: rgba(0, 122, 255, 0.05);
}

.resource-link.is-active {
    background: rgba(0, 122, 255, 0.1);
    color: #007aff;
    font-weight: 600;
}

.resource-link.is-locked {
    opacity: 0.5;
    cursor: not-allowed;
}

.res-duration {
    margin-left: auto;
    font-size: 12px;
    color: #86868b;
}

/* 公共：大圆角 */
.mac-squircle {
    border-radius: 20px;
}

.enrolled-status-group {
    display: flex;
    align-items: center;
}

.ml-10 {
    margin-left: 10px;
}
</style>