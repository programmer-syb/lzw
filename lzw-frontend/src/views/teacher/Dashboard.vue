<template>
    <div class="notion-page" v-loading="loading">
        <header class="page-header">
            <h1 class="serif-title">早上好，{{ userInfo.nickname || '老师' }}</h1>
            <p class="page-desc">这是您在 Lzw 平台的教学数据概览。</p>
        </header>

        <div class="metrics-container">
            <div class="notion-card">
                <div class="card-icon blue-bg"><el-icon>
                        <Reading />
                    </el-icon></div>
                <div class="card-content">
                    <div class="card-label">已发布的课程</div>
                    <div class="card-value">{{ dashboardData.totalCourses || 0 }} <span class="unit">门</span></div>
                </div>
            </div>

            <div class="notion-card">
                <div class="card-icon green-bg"><el-icon>
                        <User />
                    </el-icon></div>
                <div class="card-content">
                    <div class="card-label">累计选课人次</div>
                    <div class="card-value">{{ dashboardData.totalStudents || 0 }} <span class="unit">人次</span></div>
                </div>
            </div>

            <div class="notion-card">
                <div class="card-icon orange-bg"><el-icon>
                        <DocumentChecked />
                    </el-icon></div>
                <div class="card-content">
                    <div class="card-label">收到的作业提交</div>
                    <div class="card-value">{{ dashboardData.totalHomeworkSubmissions || 0 }} <span
                            class="unit">份</span></div>
                </div>
            </div>
        </div>

        <div class="quick-actions-callout">
            <div class="callout-icon">💡</div>
            <div class="callout-text">
                <strong>想开启新的教学计划？</strong>
                您可以点击右上角的“新建课程”按钮，或者在<router-link to="/teacher/courses" class="notion-link">课程管理</router-link>中规划新的章节大纲。
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Reading, User, DocumentChecked } from '@element-plus/icons-vue'
import request from '../../utils/request'

const loading = ref(false)
const userInfo = ref({})
const dashboardData = ref({})

onMounted(async () => {
    const storedUser = localStorage.getItem('userInfo')
    if (storedUser) {
        userInfo.value = JSON.parse(storedUser)
    }

    loading.value = true
    try {
        const res = await request.get('/teacher/statistics/dashboard')
        dashboardData.value = res || {}
    } catch (error) {
    } finally {
        loading.value = false
    }
})
</script>

<style scoped>
.notion-page {
    max-width: 900px;
    /* 限制最大宽度，模仿文档阅读体验 */
    margin: 0 auto;
}

.page-header {
    margin-bottom: 40px;
}

.serif-title {
    font-family: 'Noto Serif SC', 'Times New Roman', serif;
    /* 学术衬线体 */
    font-size: 2.2rem;
    font-weight: 700;
    color: rgb(55, 53, 47);
    margin: 0 0 10px 0;
    line-height: 1.2;
}

.page-desc {
    font-size: 15px;
    color: rgba(55, 53, 47, 0.65);
    margin: 0;
}

.metrics-container {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-bottom: 40px;
}

.notion-card {
    display: flex;
    align-items: center;
    gap: 16px;
    padding: 24px;
    border-radius: 8px;
    border: 1px solid rgba(55, 53, 47, 0.09);
    background: #ffffff;
    transition: box-shadow 0.2s, transform 0.2s;
}

.notion-card:hover {
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
    transform: translateY(-2px);
}

.card-icon {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 24px;
}

.blue-bg {
    background: rgba(35, 131, 226, 0.1);
    color: #2383e2;
}

.green-bg {
    background: rgba(46, 170, 220, 0.1);
    color: #2eaadc;
}

.orange-bg {
    background: rgba(224, 142, 54, 0.1);
    color: #e08e36;
}

.card-content {
    flex: 1;
}

.card-label {
    font-size: 13px;
    color: rgba(55, 53, 47, 0.6);
    margin-bottom: 4px;
    font-weight: 500;
}

.card-value {
    font-size: 28px;
    font-weight: 700;
    color: rgb(55, 53, 47);
    line-height: 1;
}

.unit {
    font-size: 14px;
    font-weight: 400;
    color: rgba(55, 53, 47, 0.5);
}

/* Notion Callout 块样式 */
.quick-actions-callout {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 16px 20px;
    border-radius: 4px;
    background: #f7f7f5;
    /* 灰色背景块 */
    border: 1px solid rgba(55, 53, 47, 0.05);
}

.callout-icon {
    font-size: 20px;
    line-height: 1.4;
}

.callout-text {
    font-size: 14px;
    line-height: 1.6;
    color: rgb(55, 53, 47);
}

.callout-text strong {
    font-weight: 600;
}

.notion-link {
    color: #2383e2;
    text-decoration: none;
    border-bottom: 1px solid rgba(35, 131, 226, 0.3);
    transition: 0.2s;
}

.notion-link:hover {
    border-bottom-color: #2383e2;
}
</style>