<template>
    <div class="mac-split-view" v-loading="loading">
        <div class="split-sidebar glass-panel">
            <div class="sidebar-header">
                <h2>课程讨论组</h2>
            </div>
            <div class="course-list">
                <div v-for="course in myCourses" :key="course.id" class="course-chat-item"
                    :class="{ 'is-active': activeCourseId === course.id }" @click="selectCourse(course.id)">
                    <div class="chat-icon">{{ course.title.charAt(0) }}</div>
                    <div class="chat-info">
                        <h4>{{ course.title }}</h4>
                        <p>进入讨论区交流</p>
                    </div>
                </div>
                <el-empty v-if="myCourses.length === 0" description="暂无课程" :image-size="60" />
            </div>
        </div>

        <div class="split-main glass-panel">
            <template v-if="activeCourseId">
                <div class="main-header">
                    <h3>{{ activeCourseName }} - 讨论区</h3>
                    <el-button type="primary" class="apple-btn-primary round" @click="showPostDialog = true">
                        <el-icon>
                            <EditPen />
                        </el-icon> 发起提问
                    </el-button>
                </div>

                <div class="post-list-container">
                    <div v-for="post in postList" :key="post.id" class="post-card">
                        <div class="post-header">
                            <el-avatar :size="32"
                                src="https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png" />
                            <div class="post-meta">
                                <span class="author">用户 ID: {{ post.userId }}</span>
                                <span class="time">{{ post.createTime }}</span>
                            </div>
                        </div>
                        <h4 class="post-title">{{ post.title }}</h4>
                        <p class="post-content">{{ post.content }}</p>
                        <div class="post-footer">
                            <span class="reply-btn" @click="openReplyDialog(post)">
                                <el-icon>
                                    <ChatDotRound />
                                </el-icon> 查看回复 ({{ post.replyCount || 0 }})
                            </span>
                        </div>
                    </div>

                    <el-empty v-if="postList.length === 0" description="这里静悄悄的，快来发第一个帖子吧！" />
                </div>
            </template>


            <div v-else class="empty-selection">
                <el-icon class="huge-icon">
                    <ChatLineRound />
                </el-icon>
                <p>请从左侧选择一个课程讨论组</p>
            </div>
        </div>

        <el-dialog v-model="showPostDialog" title="发起新讨论" width="500px" class="mac-dialog">
            <el-form :model="postForm" label-position="top">
                <el-form-item label="讨论标题">
                    <el-input v-model="postForm.title" placeholder="一句话概括你的问题" class="mac-input" />
                </el-form-item>
                <el-form-item label="详细内容">
                    <el-input v-model="postForm.content" type="textarea" :rows="5" placeholder="详细描述你的问题或见解..."
                        class="mac-textarea" />
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="showPostDialog = false" class="mac-btn-plain">取消</el-button>
                <el-button type="primary" @click="handlePost" class="mac-btn-solid">发布讨论</el-button>
            </template>
        </el-dialog>
        <el-dialog v-model="showReplyDialog" :title="currentPost?.title || '讨论详情'" width="600px" class="mac-dialog">
            <div class="original-post">
                <p class="op-content">{{ currentPost?.content }}</p>
                <span class="op-time">{{ currentPost?.createTime }}</span>
            </div>

            <el-divider border-style="dashed">共 {{ replyList.length }} 条回复</el-divider>

            <div class="reply-list-box" v-loading="replyLoading">
                <div v-for="reply in replyList" :key="reply.id" class="reply-item">
                    <div class="reply-avatar"><el-avatar :size="28">U</el-avatar></div>
                    <div class="reply-body">
                        <div class="reply-meta">
                            <span class="reply-author">用户ID: {{ reply.userId }}</span>
                            <span class="reply-time">{{ reply.createTime }}</span>
                        </div>
                        <div class="reply-content">{{ reply.content }}</div>
                    </div>
                </div>
                <el-empty v-if="replyList.length === 0" description="暂无回复，快来抢沙发！" :image-size="60" />
            </div>

            <div class="post-reply-box">
                <el-input v-model="replyContent" type="textarea" :rows="2" placeholder="写下你的回复..."
                    class="mac-textarea" />
                <el-button type="primary" class="apple-btn-primary round mt-10" @click="submitReply">发送回复</el-button>
            </div>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { EditPen, ChatLineRound, ChatDotRound } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const myCourses = ref([])
const activeCourseId = ref(null)
const postList = ref([])
const showReplyDialog = ref(false)
const replyLoading = ref(false)
const currentPost = ref(null)
const replyList = ref([])
const replyContent = ref('')

const showPostDialog = ref(false)
const postForm = ref({ title: '', content: '' })

onMounted(async () => {
    loading.value = true
    try {
        // 1. 获取选课列表
        const res = await request.get('/student-course/myList', { params: { size: 100 } })
        const enrolled = res.records || []

        // 2. 简易获取课程名称 (真实项目中后端应连表返回)
        const courses = []
        for (let c of enrolled) {
            try {
                const detail = await request.get(`/course/public/detail/${c.courseId}`)
                courses.push({ id: c.courseId, title: detail.course.title })
            } catch (e) { }
        }
        myCourses.value = courses

        // 默认选中第一个
        if (courses.length > 0) {
            selectCourse(courses[0].id)
        }
    } catch (error) {
        console.error(error)
    } finally {
        loading.value = false
    }
})

// 打开回复弹窗并加载回复
const openReplyDialog = async (post) => {
    currentPost.value = post
    showReplyDialog.value = true
    fetchReplies(post.id)
}

// 获取回复列表
const fetchReplies = async (parentId) => {
    replyLoading.value = true
    try {
        const res = await request.get(`/discussion/list/replies/${parentId}`)
        replyList.value = res || []
        // 顺便更新一下主贴的回复数量展示
        currentPost.value.replyCount = replyList.value.length
    } catch (error) {
    } finally {
        replyLoading.value = false
    }
}

// 提交新回复
const submitReply = async () => {
    if (!replyContent.value.trim()) return ElMessage.warning('回复内容不能为空')
    try {
        await request.post('/discussion/post', {
            courseId: activeCourseId.value,
            content: replyContent.value,
            parentId: currentPost.value.id // 绑定主贴ID
        })
        ElMessage.success('回复成功')
        replyContent.value = ''
        fetchReplies(currentPost.value.id) // 刷新回复列表
    } catch (error) { }
}

const activeCourseName = computed(() => {
    const c = myCourses.value.find(c => c.id === activeCourseId.value)
    return c ? c.title : ''
})

const selectCourse = async (courseId) => {
    activeCourseId.value = courseId
    loading.value = true
    try {
        const res = await request.get(`/discussion/list/main/${courseId}`)
        postList.value = res || []
    } catch (error) {
    } finally {
        loading.value = false
    }
}

const handlePost = async () => {
    if (!postForm.value.title || !postForm.value.content) return ElMessage.warning('标题和内容不能为空')
    try {
        await request.post('/discussion/post', {
            courseId: activeCourseId.value,
            title: postForm.value.title,
            content: postForm.value.content,
            parentId: 0 // 发主贴
        })
        ElMessage.success('发布成功')
        showPostDialog.value = false
        postForm.value = { title: '', content: '' }
        selectCourse(activeCourseId.value) // 刷新列表
    } catch (error) { }
}
</script>

<style scoped>
/* Mac 经典左右分栏布局 */
.mac-split-view {
    display: flex;
    height: calc(100vh - 120px);
    gap: 20px;
}

.split-sidebar {
    width: 280px;
    flex-shrink: 0;
    background: rgba(255, 255, 255, 0.7);
    border-radius: 16px;
    border: 1px solid rgba(255, 255, 255, 0.5);
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.sidebar-header {
    padding: 20px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.sidebar-header h2 {
    margin: 0;
    font-size: 1.2rem;
    color: #1d1d1f;
}

.course-list {
    flex: 1;
    overflow-y: auto;
    padding: 10px;
}

/* 类似 iMessage 的联系人项 */
.course-chat-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px;
    border-radius: 12px;
    cursor: pointer;
    transition: 0.2s;
    margin-bottom: 5px;
}

.course-chat-item:hover {
    background: rgba(0, 0, 0, 0.04);
}

.course-chat-item.is-active {
    background: #007aff;
    color: #fff;
}

.course-chat-item.is-active .chat-info h4,
.course-chat-item.is-active .chat-info p {
    color: #fff;
}

.chat-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: #e5e5ea;
    color: #86868b;
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: 700;
    font-size: 18px;
}

.chat-info h4 {
    margin: 0 0 4px 0;
    font-size: 14px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    width: 180px;
}

.chat-info p {
    margin: 0;
    font-size: 12px;
    color: #86868b;
}

/* 右侧内容区 */
.split-main {
    flex: 1;
    background: rgba(255, 255, 255, 0.7);
    border-radius: 16px;
    border: 1px solid rgba(255, 255, 255, 0.5);
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.main-header {
    padding: 20px 24px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(10px);
}

.main-header h3 {
    margin: 0;
    color: #1d1d1f;
}

.post-list-container {
    flex: 1;
    overflow-y: auto;
    padding: 24px;
    background: #fbfbfd;
}

/* 帖子卡片 */
.post-card {
    background: #fff;
    border-radius: 16px;
    padding: 20px;
    margin-bottom: 16px;
    border: 1px solid #e5e5ea;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
}

.post-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 12px;
}

.post-meta {
    display: flex;
    flex-direction: column;
}

.author {
    font-weight: 600;
    font-size: 14px;
    color: #1d1d1f;
}

.time {
    font-size: 12px;
    color: #86868b;
}

.post-title {
    margin: 0 0 8px 0;
    font-size: 1.1rem;
    color: #1d1d1f;
}

.post-content {
    margin: 0 0 16px 0;
    color: #515154;
    font-size: 14px;
    line-height: 1.6;
}

.post-footer {
    display: flex;
    justify-content: flex-end;
}

.reply-btn {
    color: #007aff;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
}

.reply-btn:hover {
    text-decoration: underline;
}

/* 空状态 */
.empty-selection {
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: #86868b;
}

.huge-icon {
    font-size: 64px;
    margin-bottom: 20px;
    opacity: 0.5;
}

.apple-btn-primary {
    background: #007aff !important;
    border: none !important;
}

.round {
    border-radius: 20px !important;
}

/* 回复弹窗相关样式 */
.original-post {
    background: rgba(0, 122, 255, 0.05);
    padding: 15px;
    border-radius: 12px;
    margin-bottom: 20px;
}

.op-content {
    margin: 0 0 10px 0;
    color: #1d1d1f;
    line-height: 1.5;
}

.op-time {
    font-size: 12px;
    color: #86868b;
}

.reply-list-box {
    max-height: 300px;
    overflow-y: auto;
    margin-bottom: 20px;
    padding-right: 10px;
}

.reply-item {
    display: flex;
    gap: 12px;
    margin-bottom: 16px;
}

.reply-body {
    flex: 1;
    background: #f5f5f7;
    padding: 12px 16px;
    border-radius: 12px;
    border-top-left-radius: 2px;
}

.reply-meta {
    display: flex;
    justify-content: space-between;
    margin-bottom: 6px;
    font-size: 12px;
}

.reply-author {
    font-weight: 600;
    color: #515154;
}

.reply-time {
    color: #86868b;
}

.reply-content {
    font-size: 14px;
    color: #1d1d1f;
    line-height: 1.5;
}

.post-reply-box {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    border-top: 1px solid rgba(0, 0, 0, 0.05);
    padding-top: 20px;
}

.mt-10 {
    margin-top: 10px;
}
</style>