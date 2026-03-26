<template>
    <div class="saas-page" v-loading="loading">
        <div class="page-header">
            <div class="header-left">
                <h1 class="page-title">Content & Courses</h1>
                <p class="page-desc">Audit teacher publications and manage platform content compliance.</p>
            </div>
        </div>

        <div class="saas-table-container">
            <el-table :data="courseList" class="saas-table" style="width: 100%">
                <el-table-column label="COURSE DETAILS" min-width="300">
                    <template #default="scope">
                        <div class="course-cell">
                            <img :src="scope.row.cover || 'https://via.placeholder.com/60x40'"
                                class="course-cover-mini" />
                            <div class="course-info">
                                <span class="fw-600">{{ scope.row.title }}</span>
                                <span class="text-grey font-mono text-xs">Teacher ID: {{ scope.row.teacherId }}</span>
                            </div>
                        </div>
                    </template>
                </el-table-column>

                <el-table-column prop="status" label="STATUS" width="120">
                    <template #default="scope">
                        <span class="saas-badge" :class="scope.row.status === 1 ? 'badge-green' : 'badge-red'">
                            {{ scope.row.status === 1 ? 'Published' : 'Offline/Pending' }}
                        </span>
                    </template>
                </el-table-column>

                <el-table-column label="ACTIONS" width="220" align="right">
                    <template #default="scope">
                        <el-button link class="action-btn" @click="previewCourse(scope.row)">Preview</el-button>

                        <el-popconfirm v-if="scope.row.status === 0" title="Approve & Publish?"
                            @confirm="handleApprove(scope.row)">
                            <template #reference>
                                <el-button link class="action-btn success">Approve</el-button>
                            </template>
                        </el-popconfirm>

                        <el-button link class="action-btn danger" @click="openRejectDialog(scope.row)">
                            {{ scope.row.status === 1 ? 'Take Down' : 'Reject' }}
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
        </div>

        <el-dialog v-model="previewVisible" title="Course Preview" width="600px" class="saas-dialog">
            <div v-if="previewData" class="preview-content">
                <img :src="previewData.cover || 'https://via.placeholder.com/600x300'" class="preview-cover" />
                <div class="preview-body">
                    <h2 class="preview-title">{{ previewData.title }}</h2>
                    <div class="preview-tags">
                        <el-tag size="small" type="info">Teacher ID: {{ previewData.teacherId }}</el-tag>
                        <el-tag size="small" :type="previewData.status === 1 ? 'success' : 'danger'">
                            {{ previewData.status === 1 ? 'Published' : 'Pending' }}
                        </el-tag>
                    </div>
                    <div class="preview-section">
                        <h3>Introduction</h3>
                        <p>{{ previewData.intro || 'No introduction provided.' }}</p>
                    </div>
                </div>
            </div>
        </el-dialog>

        <el-dialog v-model="rejectVisible" :title="rejectData?.status === 1 ? 'Take Down Course' : 'Reject Course'"
            width="450px" class="saas-dialog">
            <el-form label-position="top">
                <el-form-item label="Reason for rejection / taking down">
                    <el-input v-model="rejectReason" type="textarea" :rows="4"
                        placeholder="Please specify why this course is rejected (e.g., 课程封面未上传, 视频内容违规...)"
                        class="saas-textarea" />
                </el-form-item>
            </el-form>
            <template #footer>
                <button class="saas-btn" @click="rejectVisible = false">Cancel</button>
                <button class="saas-btn-primary ml-10" style="background-color: #ff4d4f; border-color: #ff4d4f;"
                    @click="submitReject">Confirm</button>
            </template>
        </el-dialog>

    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const courseList = ref([])

onMounted(() => fetchCourses())

const fetchCourses = async () => {
    loading.value = true
    try {
        const res = await request.get('/course/admin/list', { params: { size: 100 } })
        courseList.value = res.records || []
    } catch (error) { } finally { loading.value = false }
}

// 预览功能
const previewVisible = ref(false)
const previewData = ref(null)
const previewCourse = (row) => {
    previewData.value = row
    previewVisible.value = true
}

// 独立出的同意功能
const handleApprove = async (row) => {
    try {
        await request.put(`/course/changeStatus/${row.id}/1`)
        ElMessage.success('Course Approved & Published')
        fetchCourses()
    } catch (error) { }
}

// === 驳回与下架逻辑 ===
const rejectVisible = ref(false)
const rejectData = ref(null)
const rejectReason = ref('')

// 打开填写理由的弹窗
const openRejectDialog = (row) => {
    rejectData.value = row
    rejectReason.value = ''
    rejectVisible.value = true
}

// 提交驳回并发送消息
const submitReject = async () => {
    if (!rejectReason.value.trim()) {
        return ElMessage.warning('Please provide a reason')
    }

    loading.value = true
    try {
        // 1. 将课程状态修改为 0 (下架/驳回)
        await request.put(`/course/changeStatus/${rejectData.value.id}/0`)

        // 2. 调用公告/通知接口发送驳回理由给教师
        // type: 2 表示课程通知
        await request.post('/notice/add', {
            title: `课程审核通知：【${rejectData.value.title}】已被驳回/下架`,
            content: `处理意见：${rejectReason.value}`,
            type: 2
        })

        ElMessage.success('Course rejected and notice sent to the teacher.')
        rejectVisible.value = false
        fetchCourses() // 刷新列表
    } catch (error) {
    } finally {
        loading.value = false
    }
}
</script>

<style scoped>
/* 保持原有样式不变 */
.course-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}

.course-cover-mini {
    width: 60px;
    height: 40px;
    border-radius: 4px;
    object-fit: cover;
    border: 1px solid #eaeaea;
}

.course-info {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.text-xs {
    font-size: 11px;
}

.badge-green {
    background: #eaffea;
    color: #27c93f;
    border: 1px solid #b7f5b7;
}

.badge-red {
    background: #ffebea;
    color: #ff3b30;
    border: 1px solid #ffbaba;
}

.success {
    color: #27c93f !important;
}

.success:hover {
    color: #1e9e30 !important;
}

.danger {
    color: #ff4d4f !important;
}

/* 预览弹窗样式 */
.preview-cover {
    width: 100%;
    height: 250px;
    object-fit: cover;
    border-radius: 8px 8px 0 0;
    display: block;
}

.preview-body {
    padding: 20px;
}

.preview-title {
    margin: 0 0 10px 0;
    font-size: 20px;
    color: #111;
}

.preview-tags {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
}

.preview-section h3 {
    font-size: 14px;
    color: #666;
    text-transform: uppercase;
    margin: 0 0 8px 0;
    border-bottom: 1px solid #eaeaea;
    padding-bottom: 4px;
}

.preview-section p {
    font-size: 14px;
    color: #333;
    line-height: 1.6;
    margin-bottom: 20px;
}
</style>