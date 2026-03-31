<template>
    <div class="notion-page" v-loading="loading">
        <header class="page-header">
            <h1 class="serif-title">试卷与题库</h1>
            <p class="page-desc">构建在线测验，系统支持客观题自动批改。</p>
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

            <main class="exam-main">
                <div v-if="activeCourseId">
                    <div class="main-header">
                        <h3>考试安排</h3>
                        <button class="notion-btn-primary" @click="openExamDialog"><el-icon>
                                <Plus />
                            </el-icon> 创建考试</button>
                    </div>

                    <div v-if="!activeExam" class="exam-grid">
                        <div v-for="exam in examList" :key="exam.id" class="hw-card">
                            <h4 class="hw-title">{{ exam.title }}</h4>
                            <p class="hw-deadline">总分: {{ exam.totalScore }} | 状态: {{ exam.status === 1 ? '已发布' : '草稿'
                                }}</p>
                            <div class="hw-actions">
                                <el-button link class="action-btn" @click="openQuestionManager(exam)">管理题目</el-button>
                                <el-button link type="success" v-if="exam.status === 0"
                                    @click="publishExam(exam)">发布考试</el-button>
                            </div>
                        </div>
                        <el-empty v-if="examList.length === 0" description="暂无考试" />
                    </div>

                    <div v-else class="question-manager">
                        <div class="qm-header">
                            <el-button link @click="activeExam = null"><el-icon>
                                    <ArrowLeft />
                                </el-icon> 返回试卷列表</el-button>
                            <span class="qm-title">【{{ activeExam.title }}】的题库</span>
                        </div>

                        <div class="q-list">
                            <div v-for="(q, index) in questionList" :key="q.id" class="q-item">
                                <div class="q-header">
                                    <span class="q-num">第 {{ index + 1 }} 题 [{{ q.type === 1 ? '单选' : '简答' }}]</span>
                                    <span class="q-score">{{ q.score }} 分</span>
                                </div>
                                <div class="q-content">{{ q.content }}</div>
                                <div class="q-answer">答案：{{ q.answer }}</div>
                            </div>
                        </div>

                        <div class="add-q-box">
                            <h4>新增题目</h4>
                            <el-form label-position="top">
                                <el-form-item label="题目类型">
                                    <el-radio-group v-model="qForm.type">
                                        <el-radio :label="1">单选题 (系统自动判分)</el-radio>
                                        <el-radio :label="2">简答题 (教师手动批改)</el-radio>
                                    </el-radio-group>
                                </el-form-item>
                                <el-form-item label="题目内容">
                                    <el-input v-model="qForm.content" type="textarea" :rows="2" />
                                </el-form-item>

                                <template v-if="qForm.type === 1">
                                    <el-form-item label="选项设计 (JSON格式，例如：[&quot;A. 接口&quot;, &quot;B. 类&quot;])">
                                        <el-input v-model="qForm.options"
                                            placeholder='["A. 选项A", "B. 选项B", "C. 选项C", "D. 选项D"]' />
                                    </el-form-item>
                                    <el-form-item label="正确选项 (必须与上方字母一致)">
                                        <el-input v-model="qForm.answer" placeholder="例如：A" style="width: 150px" />
                                    </el-form-item>
                                </template>

                                <template v-if="qForm.type === 2">
                                    <el-form-item label="参考答案要点">
                                        <el-input v-model="qForm.answer" type="textarea" :rows="2" />
                                    </el-form-item>
                                </template>

                                <el-form-item label="分值">
                                    <el-input-number v-model="qForm.score" :min="1" />
                                </el-form-item>

                                <el-button type="primary" class="notion-btn-primary"
                                    @click="handleAddQuestion">确认添加题目</el-button>
                            </el-form>
                        </div>
                    </div>
                </div>
                <div v-else class="empty-state">
                    <p>👈 请先从左侧选择一门课程</p>
                </div>
            </main>
        </div>

        <el-dialog v-model="examDialog" title="创建新考试" width="450px">
            <el-form label-position="top">
                <el-form-item label="考试名称">
                    <el-input v-model="examForm.title" placeholder="如：期中测验" />
                </el-form-item>
                <el-form-item label="总分">
                    <el-input-number v-model="examForm.totalScore" :min="1" />
                </el-form-item>
                <el-form-item label="开始时间">
                    <el-date-picker v-model="examForm.startTime" type="datetime" placeholder="选择开始时间"
                        value-format="YYYY-MM-DD HH:mm:ss" style="width: 100%" />
                </el-form-item>
                <el-form-item label="结束时间">
                    <el-date-picker v-model="examForm.endTime" type="datetime" placeholder="选择结束时间"
                        value-format="YYYY-MM-DD HH:mm:ss" style="width: 100%" />
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="examDialog = false">取消</el-button>
                <el-button type="primary" class="notion-btn-primary" @click="handleCreateExam">创建</el-button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Plus, Reading, ArrowLeft } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const courseList = ref([])
const activeCourseId = ref(null)

const examList = ref([])
const activeExam = ref(null)
const questionList = ref([])

const examDialog = ref(false)
const examForm = ref({ title: '', totalScore: 100, startTime: '', endTime: '' })
const qForm = ref({ type: 1, content: '', options: '', answer: '', score: 10 })

onMounted(async () => {
    loading.value = true
    try {
        const res = await request.get('/course/myList', { params: { size: 100 } })
        courseList.value = (res.records || []).filter(c => c.status === 1)
    } catch (e) { } finally { loading.value = false }
})

const selectCourse = (courseId) => {
    activeCourseId.value = courseId
    activeExam.value = null
    fetchExams()
}

const fetchExams = async () => {
    try {
        const res = await request.get(`/exam/list/${activeCourseId.value}`)
        examList.value = res || []
    } catch (e) { }
}

const openExamDialog = () => {
    examForm.value = { title: '', totalScore: 100, startTime: '', endTime: '' }
    examDialog.value = true
}

const handleCreateExam = async () => {
    // 1. 非空校验
    if (!examForm.value.title || !examForm.value.startTime || !examForm.value.endTime) {
        return ElMessage.warning('请填写完整的考试名称和起止时间')
    }
    
    // 2. 时间逻辑校验
    const start = new Date(examForm.value.startTime).getTime()
    const end = new Date(examForm.value.endTime).getTime()
    if (end <= start) {
        return ElMessage.warning('结束时间必须晚于开始时间！')
    }

    try {
        await request.post('/exam/add', { ...examForm.value, courseId: activeCourseId.value })
        ElMessage.success('创建成功')
        examDialog.value = false
        fetchExams()
    } catch (e) { }
}

const publishExam = async (exam) => {
    try {
        await request.put('/exam/update', { id: exam.id, status: 1 })
        exam.status = 1
        ElMessage.success('考试已发布，学生可见')
    } catch (e) { }
}

const openQuestionManager = async (exam) => {
    activeExam.value = exam
    qForm.value = { type: 1, content: '', options: '', answer: '', score: 10 }
    try {
        const res = await request.get(`/exam/question/list/${exam.id}`)
        questionList.value = res || []
    } catch (e) { }
}

const handleAddQuestion = async () => {
    if (!qForm.value.content || !qForm.value.answer) return ElMessage.warning('题目内容和答案必填')
    try {
        await request.post('/exam/question/add', { ...qForm.value, examId: activeExam.value.id })
        ElMessage.success('题目添加成功')
        openQuestionManager(activeExam.value) // 刷新题目列表
    } catch (e) { }
}
</script>

<style scoped>
/* 样式复用 Homework.vue 的分栏结构 */
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

.exam-main {
    flex: 1;
}

.main-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.exam-grid {
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
    color: #888;
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

.notion-btn-primary {
    background: #2383e2;
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 4px;
    font-weight: 500;
}

/* 题目管理特有样式 */
.qm-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px dashed rgba(55, 53, 47, 0.09);
}

.qm-title {
    font-weight: 600;
    font-size: 16px;
}

.q-item {
    background: #fafafa;
    border: 1px solid #eaeaea;
    padding: 16px;
    border-radius: 6px;
    margin-bottom: 12px;
}

.q-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
    font-size: 12px;
    color: #666;
    font-weight: 600;
}

.q-score {
    color: #e08e36;
}

.q-content {
    font-size: 14px;
    color: #111;
    margin-bottom: 8px;
}

.q-answer {
    font-size: 13px;
    color: #27c93f;
    background: #eaffea;
    padding: 4px 8px;
    border-radius: 4px;
    display: inline-block;
}

.add-q-box {
    background: rgba(35, 131, 226, 0.05);
    border: 1px solid rgba(35, 131, 226, 0.1);
    padding: 20px;
    border-radius: 8px;
    margin-top: 30px;
}

.add-q-box h4 {
    margin: 0 0 15px 0;
    color: #2383e2;
}
</style>