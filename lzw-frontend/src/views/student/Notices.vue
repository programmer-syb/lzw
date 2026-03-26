<template>
    <div class="notices-page" v-loading="loading">
        <div class="page-header">
            <h1 class="mac-title">消息中心</h1>
            <p class="mac-subtitle">系统公告与您的课程动态都在这里</p>
        </div>

        <div class="notices-container">
            <div v-for="notice in noticeList" :key="notice.id" class="mac-notice-card glass-panel"
                :class="{ 'is-system': notice.type === 1 }">
                <div class="notice-icon-wrapper">
                    <el-icon v-if="notice.type === 1">
                        <BellFilled />
                    </el-icon>
                    <el-icon v-else>
                        <Message />
                    </el-icon>
                </div>

                <div class="notice-content">
                    <div class="notice-header">
                        <h3 class="notice-title">{{ notice.title }}</h3>
                        <span class="notice-time">{{ notice.createTime }}</span>
                    </div>
                    <div class="notice-body">
                        {{ notice.content }}
                    </div>
                    <div class="notice-footer">
                        <el-tag size="small" :type="notice.type === 1 ? 'danger' : 'info'" round effect="dark">
                            {{ notice.type === 1 ? '全站公告' : '课程通知' }}
                        </el-tag>
                    </div>
                </div>
            </div>

            <el-empty v-if="noticeList.length === 0" description="目前没有任何消息" class="mac-empty" />
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { BellFilled, Message } from '@element-plus/icons-vue'
import request from '../../utils/request'

const loading = ref(false)
const noticeList = ref([])

onMounted(async () => {
    loading.value = true
    try {
        const res = await request.get('/notice/list', { params: { size: 50 } })
        noticeList.value = res.records || []
    } catch (e) {
    } finally {
        loading.value = false
    }
})
</script>

<style scoped>
.notices-page {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}

.page-header {
    margin-bottom: 30px;
    text-align: center;
}

.mac-title {
    font-size: 2.2rem;
    font-weight: 800;
    color: #1d1d1f;
    margin: 0;
}

.mac-subtitle {
    color: #86868b;
    margin-top: 5px;
}

.notices-container {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

/* Mac 毛玻璃卡片 */
.mac-notice-card {
    display: flex;
    gap: 16px;
    padding: 20px;
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.5);
    border-radius: 16px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
    transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.mac-notice-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.06);
}

/* 系统公告特殊高亮 */
.mac-notice-card.is-system {
    background: rgba(255, 59, 48, 0.05);
    border-color: rgba(255, 59, 48, 0.1);
}

.notice-icon-wrapper {
    width: 46px;
    height: 46px;
    border-radius: 50%;
    background: #f5f5f7;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 22px;
    color: #86868b;
    flex-shrink: 0;
    box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
}

.is-system .notice-icon-wrapper {
    background: linear-gradient(135deg, #ff3b30, #ff6b22);
    color: white;
}

.notice-content {
    flex: 1;
}

.notice-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 8px;
}

.notice-title {
    margin: 0;
    font-size: 1.1rem;
    font-weight: 600;
    color: #1d1d1f;
}

.notice-time {
    font-size: 12px;
    color: #86868b;
}

.notice-body {
    font-size: 14px;
    color: #515154;
    line-height: 1.6;
    margin-bottom: 12px;
    white-space: pre-wrap;
}

.notice-footer {
    display: flex;
    justify-content: flex-start;
}
</style>