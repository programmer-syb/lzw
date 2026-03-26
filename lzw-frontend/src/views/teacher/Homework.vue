<template>
    <div class="notion-page" v-loading="loading">
        <header class="page-header">
            <h1 class="serif-title">作业与批改</h1>
            <p class="page-desc">发布课后作业，检验学生的学习成果并提供指导。</p>
        </header>

        <div class="split-layout">
            <aside class="course-sidebar">
                <h3 class="sidebar-title">我的课程</h3>
                <div class="course-list">
                    <div v-for="course in courseList" :key="course.id" class="course-item"
                        :class="{ active: activeCourseId === course.id }" @click="selectCourse(course.id)">
                        <el-icon>
                            <Reading />
                        </el-icon> {{ course.title }}
                    </div>
                </div>
            </aside>

            <main class="homework-main">
                <div v-if="activeCourseId">
                    <div class="main-header">
                        <h3>作业列表</h3>
                        <button class="notion-btn-primary" @click="openPublishDialog"><el-icon>
                                <Plus />
                            </el-icon> 发布新作业</button>
                    </div>

                    <div class="hw-grid">
                        <div v-for="hw in homeworkList" :key="hw.id" class="hw-card">
                            <h4 class="hw-title">{{ hw.title }}</h4>
                            <p class="hw-deadline">截止日期: {{ hw.deadline }}</p>
                            <div class="hw-actions">
                                <el-button link class="action-btn" @click="openGradingDrawer(hw)">批改作业</el-button>
                            </div>
                        </div>
                        <el-empty v-if="homeworkList.length === 0" description="该课程暂无作业" />
                    </div>
                </div>
                <div v-else class="empty-state">
                    <p>👈 请先从左侧选择一门课程</p>
                </div>
            </main>
        </div>

        <el-drawer v-model="gradingDrawer" title="学生提交情况" size="50%" class="notion-drawer">
            <div v-loading="drawerLoading" class="drawer-content">
                <div v-for="sub in submissionList" :key="sub.id" class="submission-card">
                    <div class="sub-header">
                        <span class="student-name">学生 ID: {{ sub.studentId }}</span>
                        <el-tag size="small" :type="sub.status === 2 ? 'success' : 'warning'">
                            {{ sub.status === 2 ? '已批改' : '待批改' }}
                        </el-tag>
                    </div>
                    <div class="sub-content">
                        <p><strong>提交内容：</strong>{{ sub.content }}</p>
                        <p v-if="sub.fileUrl"><strong>附件：</strong> <a :href="sub.fileUrl" target="_blank"
                                class="notion-link">查看附件</a></p>
                    </div>

                    <div v-if="sub.status === 1" class="grading-form">
                        <el-input-number v-model="sub.tempScore" :min="0" :max="100" placeholder="分数" size="small" />
                        <el-input v-model="sub.tempComment" placeholder="评语..." size="small"
                            style="flex: 1; margin: 0 10px;" />
                        <el-button type="primary" size="small" @click="submitGrade(sub)">确认打分</el-button>
                    </div>
                    <div v-else class="graded-info">
                        得分：<span class="score-text">{{ sub.score }}</span> | 评语：{{ sub.teacherComment }}
                    </div>
                </div>
                <el-empty v-if="submissionList.length === 0" description="暂无学生提交" />
            </div>
        </el-drawer>

        <el-dialog v-model="publishDialog" title="发布新作业" width="500px">
            <el-form label-position="top">
                <el-form-item label="作业标题"><el-input v-model="hwForm.title" placeholder="如：第一章课后练习" /></el-form-item>
                <el-form-item label="作业要求"><el-input v-model="hwForm.content" type="textarea"
                        :rows="3" /></el-form-item>
                <el-form-item label="截止日期"><el-date-picker v-model="hwForm.deadline" type="datetime"
                        value-format="YYYY-MM-DD HH:mm:ss" style="width: 100%" /></el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="publishDialog = false">取消</el-button>
                <el-button type="primary" class="notion-btn-primary" @click="handlePublish">发布</el-button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Plus, Reading } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const courseList = ref([])
const activeCourseId = ref(null)
const homeworkList = ref([])

const publishDialog = ref(false)
const hwForm = ref({ title: '', content: '', deadline: '' })

const gradingDrawer = ref(false)
const drawerLoading = ref(false)
const currentHw = ref(null)
const submissionList = ref([])

onMounted(async () => {
    loading.value = true
    try {
        const res = await request.get('/course/myList', { params: { size: 100 } })
        courseList.value = (res.records || []).filter(c => c.status === 1)
    } catch (e) { } finally { loading.value = false }
})

const selectCourse = async (courseId) => {
    activeCourseId.value = courseId
    fetchHomeworks()
}

const fetchHomeworks = async () => {
    try {
        homeworkList.value = await request.get(`/homework/list/${activeCourseId.value}`) || []
    } catch (e) { }
}

const openPublishDialog = () => {
    hwForm.value = { title: '', content: '', deadline: '' }
    publishDialog.value = true
}

const handlePublish = async () => {
    try {
        await request.post('/homework/publish', { ...hwForm.value, courseId: activeCourseId.value })
        ElMessage.success('发布成功')
        publishDialog.value = false
        fetchHomeworks()
    } catch (e) { }
}

const openGradingDrawer = async (hw) => {
    currentHw.value = hw
    gradingDrawer.value = true
    drawerLoading.value = true
    try {
        const res = await request.get(`/student-homework/list/${hw.id}`)
        // 给每个提交记录增加临时打分字段
        submissionList.value = (res || []).map(item => ({ ...item, tempScore: null, tempComment: '' }))
    } catch (e) { } finally { drawerLoading.value = false }
}

const submitGrade = async (sub) => {
    if (sub.tempScore === null) return ElMessage.warning('请打分')
    try {
        await request.put('/student-homework/grade', {
            id: sub.id,
            score: sub.tempScore,
            teacherComment: sub.tempComment,
            status: 2 // 变更为已批改
        })
        ElMessage.success('批改成功')
        sub.status = 2
        sub.score = sub.tempScore
        sub.teacherComment = sub.tempComment
    } catch (e) { }
}
</script>

<style scoped>
.notion-page {
    max-width: 1000px;
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
    width: 220px;
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
}

.course-item:hover {
    background: rgba(55, 53, 47, 0.04);
}

.course-item.active {
    background: rgba(35, 131, 226, 0.1);
    color: #2383e2;
    font-weight: 500;
}

.homework-main {
    flex: 1;
}

.main-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.hw-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 16px;
}

.hw-card {
    border: 1px solid rgba(55, 53, 47, 0.09);
    border-radius: 6px;
    padding: 16px;
    background: #fff;
    transition: box-shadow 0.2s;
}

.hw-card:hover {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.hw-title {
    margin: 0 0 8px 0;
    font-size: 15px;
    color: rgb(55, 53, 47);
}

.hw-deadline {
    font-size: 12px;
    color: #ff3b30;
    margin: 0 0 16px 0;
}

.action-btn {
    color: #2383e2;
}

.empty-state {
    text-align: center;
    padding: 50px;
    color: rgba(55, 53, 47, 0.4);
}

.submission-card {
    border: 1px solid #eaeaea;
    padding: 16px;
    border-radius: 6px;
    margin-bottom: 16px;
    background: #fafafa;
}

.sub-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 12px;
}

.student-name {
    font-weight: 600;
    font-size: 14px;
}

.sub-content {
    font-size: 13px;
    color: #555;
    line-height: 1.6;
    background: #fff;
    padding: 10px;
    border-radius: 4px;
    border: 1px solid #eee;
    margin-bottom: 12px;
}

.grading-form {
    display: flex;
    align-items: center;
    background: rgba(35, 131, 226, 0.05);
    padding: 10px;
    border-radius: 4px;
}

.graded-info {
    font-size: 13px;
    color: #666;
    background: #eaffea;
    padding: 10px;
    border-radius: 4px;
}

.score-text {
    font-size: 16px;
    font-weight: 700;
    color: #27c93f;
}

.notion-btn-primary {
    background: #2383e2;
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 4px;
    font-weight: 500;
}
</style>