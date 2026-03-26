<template>
    <div class="notion-page" v-loading="loading">
        <header class="page-header">
            <h1 class="serif-title">消息收件箱</h1>
            <p class="page-desc">查看平台公告与您的课程变动通知。</p>
        </header>

        <div class="notices-container">
            <div v-for="notice in noticeList" :key="notice.id" class="notice-card"
                :class="{ 'system-type': notice.type === 1 }">
                <div class="notice-icon">
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
                        <el-tag size="small" :type="notice.type === 1 ? 'danger' : 'info'" effect="light">
                            {{ notice.type === 1 ? '全站公告' : '课程通知' }}
                        </el-tag>
                    </div>
                </div>
            </div>

            <el-empty v-if="noticeList.length === 0" description="收件箱空空如也" />
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
        // 拉取全量通知 (如果是学生端，这里后端可以按课程过滤，当前演示全量)
        const res = await request.get('/notice/list', { params: { size: 50 } })
        noticeList.value = res.records || []
    } catch (e) {
    } finally {
        loading.value = false
    }
})
</script>

<style scoped>
.notion-page {
    max-width: 800px;
    margin: 0 auto;
    padding: 40px 20px;
}

.serif-title {
    font-family: 'Noto Serif SC', serif;
    font-size: 2.2rem;
    color: rgb(55, 53, 47);
    margin: 0 0 10px 0;
}

.page-desc {
    color: rgba(55, 53, 47, 0.6);
    margin-bottom: 40px;
    font-size: 15px;
}

.notices-container {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.notice-card {
    display: flex;
    gap: 16px;
    padding: 20px;
    background: #ffffff;
    border: 1px solid rgba(55, 53, 47, 0.09);
    border-radius: 8px;
    transition: transform 0.2s, box-shadow 0.2s;
}

.notice-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

/* 系统公告加深背景 */
.notice-card.system-type {
    background: #fffaf0;
    border-color: #f7e0bc;
}

.notice-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: #f7f7f5;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 20px;
    color: rgba(55, 53, 47, 0.6);
    flex-shrink: 0;
}

.system-type .notice-icon {
    background: #ffebea;
    color: #ff3b30;
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
    font-size: 16px;
    color: rgb(55, 53, 47);
}

.notice-time {
    font-size: 12px;
    color: rgba(55, 53, 47, 0.4);
    font-family: 'Inter', monospace;
}

.notice-body {
    font-size: 14px;
    color: rgba(55, 53, 47, 0.8);
    line-height: 1.6;
    margin-bottom: 12px;
    white-space: pre-wrap;
}

.notice-footer {
    display: flex;
    justify-content: flex-start;
}
</style>