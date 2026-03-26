<template>
    <div class="homework-page" v-loading="loading">
        <div class="page-header">
            <h1 class="mac-title">我的作业</h1>
            <p class="mac-subtitle">及时巩固，检验你的学习成果</p>
        </div>

        <div class="filter-segment">
            <el-radio-group v-model="filterStatus" class="mac-segmented-control">
                <el-radio-button label="all">全部作业</el-radio-button>
                <el-radio-button label="pending">待提交</el-radio-button>
                <el-radio-button label="submitted">待批改</el-radio-button>
                <el-radio-button label="graded">已批改</el-radio-button>
            </el-radio-group>
        </div>

        <div class="homework-list" v-if="filteredList.length > 0">
            <div v-for="(hw, index) in filteredList" :key="hw.id" class="mac-list-item glass-panel"
                :style="{ animationDelay: `${index * 50}ms` }">
                <div class="hw-info">
                    <div class="hw-header">
                        <span class="status-indicator" :class="getStatusClass(hw.submission?.status)"></span>
                        <span class="course-name">{{ hw.courseName || 'Java 核心技术实战' }}</span>
                    </div>
                    <h3 class="hw-title">{{ hw.title }}</h3>
                    <p class="hw-deadline">截止时间：{{ hw.deadline }}</p>
                </div>

                <div class="hw-action">
                    <button v-if="!hw.submission" class="mac-btn primary" @click="openSubmit(hw)">
                        去提交
                    </button>
                    <button v-else-if="hw.submission.status === 1" class="mac-btn secondary" disabled>
                        批改中...
                    </button>
                    <button v-else-if="hw.submission.status === 2" class="mac-btn success" @click="openResult(hw)">
                        查看成绩: {{ hw.submission.score }}分
                    </button>
                </div>
            </div>
        </div>

        <el-empty v-else description="太棒了，目前没有需要处理的作业！" class="mac-empty" />

        <el-dialog v-model="submitVisible" title="提交作业" width="500px" class="mac-dialog" destroy-on-close>
            <div class="dialog-hw-content">
                <h4>作业要求：</h4>
                <p>{{ currentHw?.content }}</p>
            </div>
            <el-form :model="submitForm" label-position="top">
                <el-form-item label="作业内容 / 思考">
                    <el-input v-model="submitForm.content" type="textarea" :rows="4" placeholder="在这里输入你的作业内容..."
                        class="mac-textarea" />
                </el-form-item>
                <el-form-item label="附件链接 (可选)">
                    <el-input v-model="submitForm.fileUrl" placeholder="如 Github 链接或网盘链接" class="mac-input" />
                </el-form-item>
            </el-form>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="submitVisible = false" class="mac-btn-plain">取消</el-button>
                    <el-button type="primary" @click="handleSubmit" class="mac-btn-solid">确认提交</el-button>
                </span>
            </template>
        </el-dialog>

        <el-dialog v-model="resultVisible" title="批改结果" width="400px" class="mac-dialog">
            <div class="result-display">
                <div class="score-circle">{{ currentHw?.submission?.score }}</div>
                <div class="teacher-comment">
                    <h4>教师评语：</h4>
                    <p>{{ currentHw?.submission?.teacherComment || '老师很懒，什么都没写。' }}</p>
                </div>
            </div>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const filterStatus = ref('all')
const homeworkList = ref([])

const submitVisible = ref(false)
const resultVisible = ref(false)
const currentHw = ref(null)
const submitForm = ref({ content: '', fileUrl: '' })

onMounted(() => {
    fetchHomeworkData()
})

// 模拟获取数据的组合逻辑 (实际业务中可能需要后端提供一个聚合接口)
const fetchHomeworkData = async () => {
    loading.value = true
    try {
        // 1. 获取我的选课
        const coursesRes = await request.get('/student-course/myList')
        const myCourses = coursesRes.records || []

        let allHw = []
        // 2. 获取每门课的作业 (如果后端没有聚合接口，前端可以并发请求)
        for (let c of myCourses) {
            const hws = await request.get(`/homework/list/${c.courseId}`)
            // 3. 获取这门课我是否提交过作业
            for (let hw of hws) {
                hw.courseName = '课程 ID: ' + c.courseId // 实际需要联表查课程名
                try {
                    const sub = await request.get(`/student-homework/my/${hw.id}`)
                    hw.submission = sub // 如果有数据，赋给 submission
                } catch (e) {
                    hw.submission = null
                }
                allHw.push(hw)
            }
        }
        // 按照创建时间倒序或截止时间排序
        homeworkList.value = allHw.sort((a, b) => b.id - a.id)
    } catch (error) {
        // 容错：如果没有数据或接口未通，给一点假数据展示 UI
        if (homeworkList.value.length === 0) {
            homeworkList.value = [
                { id: 1, title: '编写第一个 Hello World', content: '要求使用命令行编译并运行', deadline: '2026-12-31', submission: null },
                { id: 2, title: '绘制一套图标集', content: '基于24栅格', deadline: '2026-12-31', submission: { status: 1 } },
                { id: 3, title: '实现二叉树遍历', content: '写出前中后序', deadline: '2026-11-01', submission: { status: 2, score: 95, teacherComment: '代码很优雅！' } }
            ]
        }
    } finally {
        loading.value = false
    }
}

// 状态过滤计算属性
const filteredList = computed(() => {
    if (filterStatus.value === 'all') return homeworkList.value
    if (filterStatus.value === 'pending') return homeworkList.value.filter(h => !h.submission)
    if (filterStatus.value === 'submitted') return homeworkList.value.filter(h => h.submission?.status === 1)
    if (filterStatus.value === 'graded') return homeworkList.value.filter(h => h.submission?.status === 2)
    return homeworkList.value
})

const getStatusClass = (status) => {
    if (status === 1) return 'status-yellow'
    if (status === 2) return 'status-green'
    return 'status-red' // 未提交
}

const openSubmit = (hw) => {
    currentHw.value = hw
    submitForm.value = { content: '', fileUrl: '' }
    submitVisible.value = true
}

const handleSubmit = async () => {
    if (!submitForm.value.content) return ElMessage.warning('请输入作业内容')
    try {
        await request.post('/student-homework/submit', {
            homeworkId: currentHw.value.id,
            content: submitForm.value.content,
            fileUrl: submitForm.value.fileUrl
        })
        ElMessage.success('作业提交成功')
        submitVisible.value = false
        fetchHomeworkData() // 刷新列表
    } catch (error) { }
}

const openResult = (hw) => {
    currentHw.value = hw
    resultVisible.value = true
}
</script>

<style scoped>
.homework-page {
    max-width: 1000px;
    margin: 0 auto;
    padding: 20px;
}

.page-header {
    margin-bottom: 30px;
}

.mac-title {
    font-size: 2rem;
    font-weight: 700;
    color: #1d1d1f;
    margin: 0;
}

.mac-subtitle {
    color: #86868b;
    margin-top: 5px;
}

/* 苹果分段控制器 */
.filter-segment {
    margin-bottom: 24px;
}

:deep(.mac-segmented-control) {
    background: rgba(0, 0, 0, 0.05);
    padding: 4px;
    border-radius: 10px;
    display: inline-flex;
}

:deep(.mac-segmented-control .el-radio-button__inner) {
    border: none !important;
    background: transparent;
    color: #515154;
    border-radius: 8px !important;
    box-shadow: none !important;
}

:deep(.mac-segmented-control .el-radio-button__original-radio:checked + .el-radio-button__inner) {
    background: #fff;
    color: #1d1d1f;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1) !important;
    font-weight: 600;
}

/* 列表样式 */
.homework-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.mac-list-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 24px;
    border-radius: 16px;
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
    transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.mac-list-item:hover {
    transform: translateY(-3px) scale(1.01);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.06);
}

.hw-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 8px;
}

.status-indicator {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
}

.status-red {
    background: #ff5f56;
}

.status-yellow {
    background: #ffbd2e;
}

.status-green {
    background: #27c93f;
}

.course-name {
    font-size: 12px;
    color: #86868b;
    font-weight: 600;
}

.hw-title {
    margin: 0 0 4px 0;
    font-size: 1.1rem;
    color: #1d1d1f;
}

.hw-deadline {
    margin: 0;
    font-size: 13px;
    color: #ff3b30;
}

/* 按钮样式 */
.mac-btn {
    padding: 10px 20px;
    border-radius: 20px;
    border: none;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
}

.mac-btn.primary {
    background: #007aff;
    color: #fff;
    box-shadow: 0 2px 8px rgba(0, 122, 255, 0.3);
}

.mac-btn.primary:hover {
    background: #0062cc;
}

.mac-btn.secondary {
    background: rgba(0, 0, 0, 0.05);
    color: #86868b;
    cursor: not-allowed;
}

.mac-btn.success {
    background: #eaffea;
    color: #27c93f;
    border: 1px solid #b7f5b7;
}

.mac-btn.success:hover {
    background: #d4f8d4;
}

/* 弹窗样式重写 */
:deep(.mac-dialog) {
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
}

:deep(.mac-dialog .el-dialog__header) {
    background: #f5f5f7;
    margin: 0;
    padding: 15px 20px;
    border-bottom: 1px solid #e5e5ea;
}

.dialog-hw-content {
    background: rgba(0, 122, 255, 0.05);
    padding: 15px;
    border-radius: 12px;
    margin-bottom: 20px;
    color: #1d1d1f;
}

.dialog-hw-content h4 {
    margin: 0 0 5px 0;
    color: #007aff;
}

/* 成绩大圆圈 */
.result-display {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px 0;
}

.score-circle {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background: linear-gradient(135deg, #34c759, #30b050);
    color: #fff;
    font-size: 2.5rem;
    font-weight: 800;
    display: flex;
    justify-content: center;
    align-items: center;
    box-shadow: 0 10px 20px rgba(52, 199, 89, 0.3);
    margin-bottom: 20px;
}

.teacher-comment {
    width: 100%;
    background: #f5f5f7;
    padding: 15px;
    border-radius: 12px;
    text-align: center;
}
</style>