<template>
    <div class="exam-page" v-loading="loading">

        <div v-if="!examMode" class="exam-list-view">
            <div class="page-header">
                <h1 class="mac-title">在线测验</h1>
                <p class="mac-subtitle">验证所学，挑战自我</p>
            </div>

            <div class="exam-grid">
                <div v-for="(exam) in examList" :key="exam.id" class="exam-card glass-panel mac-squircle">
                    <div class="exam-icon"><el-icon>
                            <Trophy />
                        </el-icon></div>
                    <h3 class="exam-title">{{ exam.title }}</h3>
                    <div class="exam-meta">
                        <span>总分: {{ exam.totalScore }}</span>
                        <el-divider direction="vertical" />
                        <span>题目: {{ exam.questionCount || 10 }} 题</span>
                    </div>
                    <div class="exam-action">
                        <el-button v-if="!exam.studentScore" type="primary" class="apple-btn-primary full-width" round
                            @click="startExam(exam)">
                            开始测验
                        </el-button>
                        <div v-else class="score-display">
                            <span class="label">我的得分</span>
                            <span class="score">{{ exam.studentScore }}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div v-else class="exam-focus-mode">
            <div class="exam-paper mac-squircle">
                <div class="paper-header">
                    <h2>{{ currentExam.title }}</h2>
                    <div class="timer">专注答题中...</div>
                </div>

                <div class="paper-body">
                    <div v-for="(q, index) in questions" :key="q.id" class="question-block">
                        <div class="q-title">
                            <span class="q-num">{{ index + 1 }}.</span>
                            <span class="q-type">[{{ q.type === 1 ? '单选' : '简答' }}]</span>
                            {{ q.content }} <span class="q-score">({{ q.score }}分)</span>
                        </div>

                        <div v-if="q.type === 1" class="q-options">
                            <el-radio-group v-model="answers[q.id]" class="mac-exam-radio">
                                <el-radio v-for="(opt, oIdx) in parseOptions(q.options)" :key="oIdx"
                                    :label="opt.charAt(0)">
                                    {{ opt }}
                                </el-radio>
                            </el-radio-group>
                        </div>

                        <div v-else class="q-text">
                            <el-input v-model="answers[q.id]" type="textarea" :rows="3" placeholder="请输入你的解答..."
                                class="mac-textarea" />
                        </div>
                    </div>
                </div>

                <div class="paper-footer">
                    <el-button @click="examMode = false" class="mac-btn-plain round">退出</el-button>
                    <el-button type="primary" @click="submitExam" class="apple-btn-primary round">交卷并自动评分</el-button>
                </div>
            </div>
        </div>

    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { Trophy } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const examMode = ref(false)
const examList = ref([])
const currentExam = ref(null)
const questions = ref([])
const answers = reactive({}) // key 为 questionId, value 为答案

onMounted(() => {
    fetchExams()
})

// 1. 真实获取考试列表的逻辑
const fetchExams = async () => {
    loading.value = true
    try {
        // 第一步：获取我加入的所有课程
        const coursesRes = await request.get('/student-course/myList', { params: { size: 100 } })
        const myCourses = coursesRes.records || []

        let allExams = []
        // 第二步：遍历课程，获取每门课下“已发布”的考试
        for (let c of myCourses) {
            try {
                const examsRes = await request.get(`/exam/list/${c.courseId}`)
                const publishedExams = (examsRes || []).filter(e => e.status === 1) // 必须是已发布的

                // 第三步：查一下该学生对这个考试的成绩记录（如果后端有这个接口的话）
                for (let exam of publishedExams) {
                    exam.studentScore = null // 默认没考过
                    try {
                        // 假设后端有一个查询自己考试成绩的接口
                        const record = await request.get(`/student-exam/myRecord/${exam.id}`)
                        if (record && record.status === 2) {
                            exam.studentScore = record.totalScore // 已出成绩
                        } else if (record && record.status === 1) {
                            exam.studentScore = '批改中' // 等待教师批改简答题
                        }
                    } catch (err) {
                        // 没考过或者接口报错，跳过即可
                    }
                    allExams.push(exam)
                }
            } catch (e) {
                console.warn(`获取课程 ${c.courseId} 的考试失败`)
            }
        }

        // 按考试创建时间倒序排列
        examList.value = allExams.sort((a, b) => new Date(b.createTime) - new Date(a.createTime))
    } catch (e) {
        console.error('获取考试数据异常', e)
    } finally {
        loading.value = false
    }
}

// 解析 JSON 格式的选项
const parseOptions = (optionsStr) => {
    try { return JSON.parse(optionsStr) }
    catch (e) { return [] }
}

// 2. 真实获取试题逻辑 (剥离假数据)
const startExam = async (exam) => {
    loading.value = true
    currentExam.value = exam
    // 清空上次的答题记录
    for (let key in answers) delete answers[key]

    try {
        // 拉取题目 (调用你后端写好的接口)
        const res = await request.get(`/exam/question/list/${exam.id}`)
        questions.value = res || []

        if (questions.value.length === 0) {
            return ElMessage.warning('该考试暂无题目，请联系教师添加')
        }

        examMode.value = true // 题目拉取成功，切换为专注模式
    } catch (e) {
        ElMessage.error('拉取考题失败')
    } finally {
        loading.value = false
    }
}

// 3. 真实交卷逻辑 (剥离假数据)
const submitExam = () => {
    ElMessageBox.confirm('确认交卷吗？交卷后将立即进行客观题评分。', '交卷提示', {
        confirmButtonText: '确定交卷',
        cancelButtonText: '再检查一下',
        type: 'warning'
    }).then(async () => {
        loading.value = true

        // 构造提交给后端的 DTO 格式
        const submitDTO = {
            examId: currentExam.value.id,
            answers: Object.keys(answers).map(qId => ({
                questionId: parseInt(qId),
                studentAnswer: answers[qId]
            }))
        }

        try {
            // 真实调用交卷接口
            const resMsg = await request.post('/student-exam/submit', submitDTO)
            ElMessage.success(resMsg || '交卷成功！')
            examMode.value = false
            fetchExams() // 刷新列表，这样就能看到自己的分数或者“批改中”的状态了
        } catch (e) {
            // 错误由全局拦截器处理，这里不再用假数据弹窗
        } finally {
            loading.value = false
        }
    }).catch(() => { })
}
</script>

<style scoped>
.exam-page {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    min-height: 80vh;
}

/* 考试列表视图 */
.page-header {
    margin-bottom: 30px;
    text-align: center;
}

.mac-title {
    font-size: 2.5rem;
    font-weight: 800;
    color: #1d1d1f;
    letter-spacing: -1px;
    margin: 0;
}

.mac-subtitle {
    color: #86868b;
    font-size: 1.1rem;
}

.exam-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 24px;
}

.exam-card {
    padding: 30px 20px;
    text-align: center;
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
    transition: transform 0.3s;
}

.exam-card:hover {
    transform: translateY(-5px);
}

.exam-icon {
    width: 60px;
    height: 60px;
    background: linear-gradient(135deg, #ffbd2e, #ff9500);
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 0 auto 15px;
    color: #fff;
    font-size: 28px;
    box-shadow: 0 8px 16px rgba(255, 149, 0, 0.3);
}

.exam-title {
    font-size: 1.2rem;
    color: #1d1d1f;
    margin: 0 0 10px 0;
}

.exam-meta {
    color: #86868b;
    font-size: 13px;
    margin-bottom: 25px;
}

.full-width {
    width: 100%;
    padding: 12px !important;
    font-size: 1rem;
}

.score-display {
    background: #f5f5f7;
    border-radius: 20px;
    padding: 10px;
    display: flex;
    justify-content: center;
    align-items: baseline;
    gap: 8px;
}

.score-display .label {
    font-size: 12px;
    color: #86868b;
}

.score-display .score {
    font-size: 1.5rem;
    font-weight: 800;
    color: #007aff;
}

/* 沉浸式答题模式 */
.exam-focus-mode {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(245, 245, 247, 0.95);
    backdrop-filter: blur(10px);
    z-index: 999;
    display: flex;
    justify-content: center;
    padding: 40px 20px;
    overflow-y: auto;
}

.exam-paper {
    background: #fff;
    width: 100%;
    max-width: 800px;
    padding: 50px;
    border-radius: 24px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
    height: max-content;
}

.paper-header {
    text-align: center;
    border-bottom: 2px solid #f5f5f7;
    padding-bottom: 20px;
    margin-bottom: 40px;
}

.paper-header h2 {
    font-size: 2rem;
    margin: 0 0 10px 0;
    color: #1d1d1f;
}

.timer {
    color: #ff3b30;
    font-weight: 600;
    font-size: 14px;
}

.question-block {
    margin-bottom: 40px;
}

.q-title {
    font-size: 1.1rem;
    color: #1d1d1f;
    line-height: 1.6;
    margin-bottom: 15px;
    font-weight: 500;
}

.q-num {
    font-weight: 800;
    font-size: 1.2rem;
    color: #007aff;
}

.q-type {
    color: #86868b;
    font-size: 0.9rem;
}

.q-score {
    color: #ff9500;
    font-size: 0.9rem;
    font-weight: 600;
}

/* 答题卡 Apple 风格 Radio */
:deep(.mac-exam-radio) {
    display: flex;
    flex-direction: column;
    gap: 12px;
    align-items: flex-start;
}

:deep(.mac-exam-radio .el-radio) {
    margin: 0;
    padding: 15px 20px;
    border: 1px solid #e5e5ea;
    border-radius: 12px;
    width: 100%;
    transition: all 0.2s;
}

:deep(.mac-exam-radio .el-radio.is-checked) {
    background: rgba(0, 122, 255, 0.05);
    border-color: #007aff;
}

.paper-footer {
    display: flex;
    justify-content: space-between;
    border-top: 2px solid #f5f5f7;
    padding-top: 30px;
    margin-top: 20px;
}

.apple-btn-primary {
    background: #007aff !important;
    border: none !important;
    padding: 12px 30px !important;
    font-weight: 600;
}
</style>