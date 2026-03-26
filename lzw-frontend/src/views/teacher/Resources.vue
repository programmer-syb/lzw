<template>
    <div class="notion-page" v-loading="loading">
        <header class="page-header">
            <h1 class="serif-title">教学资源库</h1>
            <p class="page-desc">集中管理您在各门课程中上传的视频、课件与文档资料。</p>
        </header>

        <div class="split-layout">
            <aside class="course-sidebar">
                <h3 class="sidebar-title">按课程筛选</h3>
                <div class="course-list">
                    <div class="course-item" :class="{ active: activeCourseId === null }" @click="selectCourse(null)">
                        <el-icon>
                            <Folder />
                        </el-icon> 全部资源
                    </div>
                    <div v-for="course in courseList" :key="course.id" class="course-item"
                        :class="{ active: activeCourseId === course.id }" @click="selectCourse(course.id)">
                        <el-icon>
                            <Reading />
                        </el-icon> {{ course.title }}
                    </div>
                </div>
            </aside>

            <main class="resource-main">
                <div class="main-header">
                    <h3>{{ activeCourseId ? '课程专属资源' : '我的所有资源' }}</h3>
                    <span class="file-count">共计 {{ displayResources.length }} 个文件</span>
                </div>

                <div class="resource-grid">
                    <div v-for="res in displayResources" :key="res.id" class="notion-file-card">
                        <div class="file-icon-box" :class="res.type">
                            <el-icon>
                                <VideoCamera v-if="res.type === 'video'" />
                                <Document v-else />
                            </el-icon>
                        </div>
                        <div class="file-info">
                            <h4 class="file-name" :title="res.name">{{ res.name }}</h4>
                            <p class="file-meta">
                                所属: {{ res.courseName }} - {{ res.chapterTitle }}
                            </p>
                            <p class="file-time">{{ res.createTime }}</p>
                        </div>
                        <div class="file-actions">
                            <el-button link class="action-btn" @click="openFile(res.url)">预览</el-button>
                            <el-popconfirm title="确定要删除此文件吗？" @confirm="handleDelete(res.id)">
                                <template #reference>
                                    <el-button link class="action-btn danger">删除</el-button>
                                </template>
                            </el-popconfirm>
                        </div>
                    </div>
                </div>

                <el-empty v-if="displayResources.length === 0" description="没有找到任何教学资源" />
            </main>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Folder, Reading, VideoCamera, Document } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const courseList = ref([])
const activeCourseId = ref(null)
const allResources = ref([]) // 存储所有资源的扁平化数组

onMounted(async () => {
    loading.value = true
    try {
        // 1. 获取该教师的所有课程 (不限状态)
        const res = await request.get('/course/myList', { params: { size: 100 } })
        courseList.value = (res.records || []).filter(c => c.status === 1)
        // 2. 聚合获取所有课程下的所有资源
        await fetchAllResources()
    } catch (e) {
    } finally {
        loading.value = false
    }
})

// 暴力聚合：一次性查出所有课程、章节下的资源并拍平
const fetchAllResources = async () => {
    let aggregated = []

    for (let course of courseList.value) {
        try {
            const chapters = await request.get(`/chapter/list/${course.id}`) || []
            for (let chapter of chapters) {
                const resources = await request.get(`/resource/list/${chapter.id}`) || []
                // 为每个资源打上课程和章节的标签，方便UI展示
                resources.forEach(r => {
                    r.courseId = course.id
                    r.courseName = course.title
                    r.chapterTitle = chapter.title
                    aggregated.push(r)
                })
            }
        } catch (e) {
            // 忽略单个课程查询的错误，继续查下一个
        }
    }

    // 按时间倒序排列
    allResources.value = aggregated.sort((a, b) => new Date(b.createTime) - new Date(a.createTime))
}

const selectCourse = (courseId) => {
    activeCourseId.value = courseId
}

// 计算属性：根据左侧选中的课程过滤展示列表
const displayResources = computed(() => {
    if (activeCourseId.value === null) {
        return allResources.value
    }
    return allResources.value.filter(r => r.courseId === activeCourseId.value)
})

const openFile = (url) => {
    window.open(url, '_blank')
}

const handleDelete = async (resId) => {
    try {
        await request.delete(`/resource/delete/${resId}`)
        ElMessage.success('资源已删除')
        // 从本地列表中移除，避免重新发大量请求聚合
        allResources.value = allResources.value.filter(r => r.id !== resId)
    } catch (e) { }
}
</script>

<style scoped>
.notion-page {
    max-width: 1100px;
    margin: 0 auto;
    padding: 20px;
}

.serif-title {
    font-family: 'Noto Serif SC', serif;
    font-size: 2rem;
    color: rgb(55, 53, 47);
    margin: 0 0 5px 0;
}

.page-desc {
    color: rgba(55, 53, 47, 0.6);
    margin-bottom: 30px;
}

.split-layout {
    display: flex;
    gap: 30px;
    min-height: 60vh;
}

.course-sidebar {
    width: 240px;
    border-right: 1px solid rgba(55, 53, 47, 0.09);
    padding-right: 20px;
}

.sidebar-title {
    font-size: 13px;
    color: rgba(55, 53, 47, 0.5);
    text-transform: uppercase;
    margin-bottom: 15px;
}

.course-item {
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
    color: rgb(55, 53, 47);
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 8px;
    transition: 0.2s;
    margin-bottom: 4px;
}

.course-item:hover {
    background: rgba(55, 53, 47, 0.04);
}

.course-item.active {
    background: rgba(35, 131, 226, 0.1);
    color: #2383e2;
    font-weight: 500;
}

.resource-main {
    flex: 1;
}

.main-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-bottom: 20px;
    border-bottom: 1px solid rgba(55, 53, 47, 0.05);
    padding-bottom: 10px;
}

.main-header h3 {
    margin: 0;
    font-size: 1.2rem;
    color: rgb(55, 53, 47);
}

.file-count {
    font-size: 13px;
    color: rgba(55, 53, 47, 0.5);
}

.resource-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 16px;
}

.notion-file-card {
    display: flex;
    flex-direction: column;
    padding: 16px;
    background: #ffffff;
    border: 1px solid rgba(55, 53, 47, 0.09);
    border-radius: 8px;
    transition: box-shadow 0.2s, transform 0.2s;
}

.notion-file-card:hover {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    transform: translateY(-2px);
}

.file-icon-box {
    width: 40px;
    height: 40px;
    border-radius: 8px;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 20px;
    margin-bottom: 12px;
}

.file-icon-box.video {
    background: rgba(35, 131, 226, 0.1);
    color: #2383e2;
}

.file-icon-box.pdf,
.file-icon-box.word,
.file-icon-box.ppt {
    background: rgba(224, 142, 54, 0.1);
    color: #e08e36;
}

.file-info {
    flex: 1;
}

.file-name {
    margin: 0 0 6px 0;
    font-size: 14px;
    color: rgb(55, 53, 47);
    font-weight: 600;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.file-meta {
    margin: 0 0 4px 0;
    font-size: 12px;
    color: rgba(55, 53, 47, 0.6);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.file-time {
    margin: 0;
    font-size: 11px;
    color: rgba(55, 53, 47, 0.4);
    font-family: 'Inter', monospace;
}

.file-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 12px;
    padding-top: 12px;
    border-top: 1px dashed rgba(55, 53, 47, 0.09);
}

.action-btn {
    color: #2383e2;
    font-size: 12px;
}

.action-btn.danger {
    color: #ff3b30;
}
</style>