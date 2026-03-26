<template>
    <div class="my-courses-page" v-loading="loading">
        <div class="page-header">
            <h1 class="mac-title">我的课程</h1>
            <p class="mac-subtitle">继续你的学习旅程，每天进步一点点</p>
        </div>

        <div v-if="courseList.length > 0" class="course-grid">
            <div v-for="(item, index) in courseList" :key="item.courseId" class="course-card mac-squircle glass-panel"
                :style="{ animationDelay: `${index * 80}ms` }">
                <div class="card-cover-box">
                    <img :src="item.detail?.cover || 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=600'"
                        class="cover-img" />
                    <div class="play-overlay" @click="goToDetail(item.courseId)">
                        <el-icon class="play-icon">
                            <VideoPlay />
                        </el-icon>
                    </div>
                </div>

                <div class="card-info">
                    <h3 class="course-title">{{ item.detail?.title || '加载中...' }}</h3>
                    <p class="teacher-name">{{ item.teacherName || '未知教师' }}</p>

                    <div class="progress-section">
                        <div class="progress-labels">
                            <span class="label">学习进度</span>
                            <span class="percent">{{ item.progress }}%</span>
                        </div>
                        <div class="mac-progress-bar">
                            <div class="mac-progress-inner" :style="{ width: item.progress + '%' }"></div>
                        </div>
                    </div>

                    <button class="mac-btn-solid full-width mt-15" @click="goToDetail(item.courseId)">
                        继续学习
                    </button>
                </div>
            </div>
        </div>

        <el-empty v-else-if="!loading" description="你还没有加入任何课程，快去探索发现吧！" class="mac-empty">
            <el-button type="primary" class="apple-btn-primary" round @click="router.push('/student/discovery')">
                去发现课程
            </el-button>
        </el-empty>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { VideoPlay } from '@element-plus/icons-vue'
import request from '../../utils/request'

const router = useRouter()
const loading = ref(false)
const courseList = ref([])

onMounted(async () => {
    loading.value = true
    try {
        // 1. 获取选课关系列表
        const res = await request.get('/student-course/myList', { params: { size: 100 } })
        const myCourses = res.records || []

        // 2. 遍历获取每门课的详情 (封面、标题等)
        const detailPromises = myCourses.map(async (courseInfo) => {
            try {
                const detailRes = await request.get(`/course/public/detail/${courseInfo.courseId}`)
                return {
                    ...courseInfo,
                    detail: detailRes.course,
                    teacherName: detailRes.teacherName
                }
            } catch (e) {
                return courseInfo
            }
        })

        courseList.value = await Promise.all(detailPromises)
    } catch (error) {
        console.error(error)
    } finally {
        loading.value = false
    }
})

const goToDetail = (id) => {
    router.push(`/student/course/${id}`)
}
</script>

<style scoped>
.my-courses-page {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

.page-header {
    margin-bottom: 30px;
}

.mac-title {
    font-size: 2.2rem;
    font-weight: 800;
    color: #1d1d1f;
    margin: 0;
    letter-spacing: -0.5px;
}

.mac-subtitle {
    color: #86868b;
    font-size: 1.1rem;
    margin-top: 5px;
}

/* 网格布局 */
.course-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 24px;
}

/* 卡片样式 */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }

    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.course-card {
    animation: fadeInUp 0.5s cubic-bezier(0.23, 1, 0.32, 1) both;
    overflow: hidden;
    background: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
    transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.course-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
}

.card-cover-box {
    position: relative;
    width: 100%;
    aspect-ratio: 16/9;
    overflow: hidden;
    cursor: pointer;
}

.cover-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.4s ease;
}

.course-card:hover .cover-img {
    transform: scale(1.05);
}

/* 悬浮播放遮罩 */
.play-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.3);
    backdrop-filter: blur(2px);
    display: flex;
    justify-content: center;
    align-items: center;
    opacity: 0;
    transition: opacity 0.3s ease;
}

.course-card:hover .play-overlay {
    opacity: 1;
}

.play-icon {
    font-size: 48px;
    color: #fff;
    filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.3));
}

.card-info {
    padding: 20px;
}

.course-title {
    font-size: 1.1rem;
    color: #1d1d1f;
    margin: 0 0 5px 0;
    font-weight: 700;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.teacher-name {
    font-size: 13px;
    color: #86868b;
    margin: 0 0 15px 0;
}

/* 苹果风进度条 */
.progress-section {
    margin-top: 15px;
}

.progress-labels {
    display: flex;
    justify-content: space-between;
    font-size: 12px;
    margin-bottom: 6px;
}

.progress-labels .label {
    color: #86868b;
}

.progress-labels .percent {
    color: #007aff;
    font-weight: 700;
}

.mac-progress-bar {
    width: 100%;
    height: 6px;
    background: rgba(0, 0, 0, 0.06);
    border-radius: 3px;
    overflow: hidden;
}

.mac-progress-inner {
    height: 100%;
    background: linear-gradient(90deg, #34a853, #27c93f);
    border-radius: 3px;
    transition: width 0.8s ease;
}

.mt-15 {
    margin-top: 15px;
}

.full-width {
    width: 100%;
    padding: 10px;
    border-radius: 12px;
    background: #f5f5f7;
    border: none;
    color: #1d1d1f;
    font-weight: 600;
    cursor: pointer;
    transition: 0.2s;
}

.full-width:hover {
    background: #e5e5ea;
    color: #007aff;
}
</style>