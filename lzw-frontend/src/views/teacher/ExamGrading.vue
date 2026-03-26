<template>
    <div class="notion-page" v-loading="loading">
        <header class="page-header">
            <h1 class="serif-title">阅卷中心</h1>
            <p class="page-desc">批改学生提交的试卷，客观题已由系统自动判分。</p>
        </header>

        <div class="split-layout">
            <aside class="course-sidebar">
                <h3 class="sidebar-title">进行中的考试</h3>
                <div v-for="course in courseList" :key="course.id" class="course-group">
                    <div class="group-label">{{ course.title }}</div>
                    <div v-for="exam in course.exams" :key="exam.id" class="course-item"
                        :class="{ active: activeExamId === exam.id }" @click="selectExam(exam)">
                        <el-icon>
                            <DocumentChecked />
                        </el-icon> {{ exam.title }}
                    </div>
                </div>
            </aside>

            <main class="grading-main">
                <div v-if="activeExamId">
                    <div class="main-header">
                        <h3>{{ activeExamName }} - 提交情况</h3>
                    </div>

                    <el-table :data="submissionList" class="notion-table">
                        <el-table-column prop="studentId" label="学生 ID" width="120" />
                        <el-table-column prop="submitTime" label="交卷时间" width="180" />
                        <el-table-column label="当前状态">
                            <template #default="scope">
                                <el-tag :type="scope.row.status === 2 ? 'success' : 'warning'" size="small">
                                    {{ scope.row.status === 2 ? '已出分: ' + scope.row.totalScore : '待批改' }}
                                </el-tag>
                            </template>
                        </el-table-column>
                        <el-table-column align="right">
                            <template #default="scope">
                                <el-button link type="primary" @click="openGradingSheet(scope.row)">
                                    {{ scope.row.status === 2 ? '查看详情' : '进入阅卷' }}
                                </el-button>
                            </template>
                        </el-table-column>
                    </el-table>
                </div>
                <div v-else class="empty-state">
                    <p>👈 请从左侧选择一场考试查看提交情况</p>
                </div>
            </main>
        </div>

        <el-dialog v-model="sheetVisible" title="试卷批改详情" width="800px" class="notion-dialog" destroy-on-close>
            <div v-loading="sheetLoading" class="grading-sheet">
                <div v-for="(ans, index) in detailedAnswers" :key="ans.id" class="q-grading-card">
                    <div class="q-info">
                        <span class="q-num">Q{{ index + 1 }}</span>
                        <span class="q-type-tag">{{ ans.questionType === 1 ? '单选' : '简答' }}</span>
                    </div>

                    <div class="student-answer-box">
                        <div class="label">学生答案：</div>
                        <div class="content">{{ ans.studentAnswer || '(未作答)' }}</div>
                    </div>

                    <div v-if="ans.questionType === 2" class="teacher-grading-area">
                        <div class="grading-inputs">
                            <el-input-number v-model="ans.score" :min="0" size="small" placeholder="得分" />
                            <el-input v-model="ans.teacherComment" placeholder="给学生的评语..." size="small"
                                style="flex:1; margin-left:10px" />
                        </div>
                    </div>
                    <div v-else class="auto-grade-info">
                        系统自动评分：<span class="score">{{ ans.score }} 分</span>
                    </div>
                </div>
            </div>
            <template #footer>
                <el-button @click="sheetVisible = false">关闭</el-button>
                <el-button type="primary" class="notion-btn-primary" @click="submitFinalGrade">保存批改结果</el-button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { DocumentChecked } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const courseList = ref([])
const activeExamId = ref(null)
const activeExamName = ref('')
const submissionList = ref([])

const sheetVisible = ref(false)
const sheetLoading = ref(false)
const detailedAnswers = ref([])
const currentStudentExamId = ref(null)

onMounted(async () => {
    loading.value = true
    try {
        // 获取有权限的课程及其考试
        const res = await request.get('/course/myList', { params: { size: 100 } })
        const myCourses = (res.records || []).filter(c => c.status === 1)

        for (let c of myCourses) {
            c.exams = await request.get(`/exam/list/${c.id}`) || []
        }
        courseList.value = myCourses
    } catch (e) { } finally { loading.value = false }
})

const selectExam = async (exam) => {
    activeExamId.value = exam.id
    activeExamName.value = exam.title
    loading.value = true
    try {
        const res = await request.get(`/student-exam/teacher/list/${exam.id}`)
        submissionList.value = res || []
    } catch (e) { } finally { loading.value = false }
}

const openGradingSheet = async (record) => {
    currentStudentExamId.value = record.id
    sheetVisible.value = true
    sheetLoading.value = true
    try {
        const answers = await request.get(`/student-exam/teacher/detail/${record.id}`)
        // 注入题目类型（实际业务中建议后端 DTO 直接带出）
        detailedAnswers.value = answers.map(a => ({ ...a, questionType: a.studentAnswer?.length > 1 ? 2 : 1 }))
    } catch (e) { } finally { sheetLoading.value = false }
}

const submitFinalGrade = async () => {
    try {
        await request.put('/student-exam/teacher/grade', detailedAnswers.value)
        ElMessage.success('批改保存成功！成绩已同步给学生。')
        sheetVisible.value = false
        // 刷新列表
        const exam = { id: activeExamId.value, title: activeExamName.value }
        selectExam(exam)
    } catch (e) { }
}
</script>

<style scoped>
/* 延续 Notion 分栏样式 */
.split-layout {
    display: flex;
    gap: 30px;
    min-height: 70vh;
}

.course-sidebar {
    width: 260px;
    border-right: 1px solid rgba(55, 53, 47, 0.09);
}

.course-group {
    margin-bottom: 20px;
}

.group-label {
    font-size: 11px;
    font-weight: 700;
    color: rgba(55, 53, 47, 0.4);
    text-transform: uppercase;
    padding: 0 12px 8px;
}

.grading-main {
    flex: 1;
}

.q-grading-card {
    border: 1px solid #eee;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 16px;
    background: #fafafa;
}

.q-info {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 12px;
}

.q-num {
    font-weight: 800;
    color: #2383e2;
}

.q-type-tag {
    font-size: 11px;
    background: #eee;
    padding: 2px 6px;
    border-radius: 4px;
}

.student-answer-box {
    background: #fff;
    border: 1px solid #eee;
    padding: 12px;
    border-radius: 6px;
    margin-bottom: 15px;
}

.student-answer-box .label {
    font-size: 12px;
    color: #888;
    margin-bottom: 5px;
}

.student-answer-box .content {
    font-size: 14px;
    color: #333;
    line-height: 1.6;
}

.auto-grade-info {
    font-size: 13px;
    color: #666;
}

.auto-grade-info .score {
    font-weight: 700;
    color: #27c93f;
}

.teacher-grading-area {
    border-top: 1px dashed #ddd;
    padding-top: 15px;
}

.grading-inputs {
    display: flex;
    align-items: center;
}
</style>