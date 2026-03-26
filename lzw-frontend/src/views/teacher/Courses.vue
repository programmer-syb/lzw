<template>
    <div class="notion-page" v-loading="loading">

        <transition name="fade-in" mode="out-in">
            <div v-if="viewMode === 'list'" class="list-view" key="list">
                <header class="page-header">
                    <div class="header-left">
                        <h1 class="serif-title">我的教学内容</h1>
                        <p class="page-desc">管理您发布的课程、章节与教学资源。</p>
                    </div>
                    <div class="header-right">
                        <button class="notion-btn-primary" @click="openEditor(null)">
                            <el-icon>
                                <Plus />
                            </el-icon> 新建课程
                        </button>
                    </div>
                </header>

                <div v-if="courseList.length > 0" class="course-grid">
                    <div v-for="course in courseList" :key="course.id" class="notion-course-card">
                        <div class="card-cover-wrapper" @click="openEditor(course)">
                            <img :src="course.cover || 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=600'"
                                class="cover-img" />
                            <div class="status-badge" :class="course.status === 1 ? 'published' : 'draft'">
                                {{ course.status === 1 ? '已发布' : '草稿 / 待审核' }}
                            </div>
                        </div>
                        <div class="card-body">
                            <h3 class="course-title" @click="openEditor(course)">{{ course.title }}</h3>
                            <p class="course-category">{{ getCategoryName(course.categoryId) }}</p>

                            <div class="card-actions">
                                <el-button link class="action-btn" @click="openEditor(course)">编辑内容</el-button>
                                <el-popconfirm title="确定要删除这门课程吗？" @confirm="handleDeleteCourse(course.id)">
                                    <template #reference>
                                        <el-button link class="action-btn danger">删除</el-button>
                                    </template>
                                </el-popconfirm>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-else class="empty-canvas">
                    <el-icon class="empty-icon">
                        <DocumentAdd />
                    </el-icon>
                    <p>您还没有创建任何课程</p>
                    <button class="notion-btn-secondary" @click="openEditor(null)">开始创作</button>
                </div>
            </div>

            <div v-else class="editor-view" key="editor">
                <div class="editor-toolbar">
                    <button class="icon-btn-text" @click="closeEditor">
                        <el-icon>
                            <ArrowLeft />
                        </el-icon> 返回列表
                    </button>
                    <div class="toolbar-actions">
                        <span class="save-status">{{ saveStatusText }}</span>
                        <el-button plain size="small" @click="handleSaveCourse">保存草稿</el-button>
                        <el-button type="primary" size="small" class="notion-btn-primary" @click="handlePublishCourse">
                            {{ currentCourse.status === 1 ? '更新发布' : '提交发布' }}
                        </el-button>
                    </div>
                </div>

                <div class="editor-canvas">
                    <div class="cover-upload-area" :style="{ backgroundImage: `url(${currentCourse.cover})` }">
                        <div class="cover-overlay">
                            <el-upload action="#" :show-file-list="false" :http-request="handleCoverUpload">
                                <button class="change-cover-btn"><el-icon>
                                        <Picture />
                                    </el-icon> 更换封面</button>
                            </el-upload>
                        </div>
                    </div>

                    <div class="doc-content">
                        <input v-model="currentCourse.title" class="notion-title-input" placeholder="无标题课程" />

                        <div class="meta-inputs">
                            <el-select v-model="currentCourse.categoryId" placeholder="选择课程分类" class="notion-select">
                                <el-option v-for="cat in categoryList" :key="cat.id" :label="cat.name"
                                    :value="cat.id" />
                            </el-select>
                        </div>

                        <textarea v-model="currentCourse.intro" class="notion-textarea intro" rows="2"
                            placeholder="添加一句话简介..."></textarea>

                        <div class="doc-section">
                            <h3 class="section-title">教学大纲 (Syllabus)</h3>
                            <textarea v-model="currentCourse.syllabus" class="notion-textarea syllabus" rows="6"
                                placeholder="在这里编写详细的教学大纲..."></textarea>
                        </div>

                        <el-divider border-style="dashed" />

                        <div class="doc-section">
                            <div class="section-header">
                                <h3 class="section-title">课程内容目录</h3>
                                <el-button size="small" plain @click="handleAddChapter" :disabled="!currentCourse.id">
                                    <el-icon>
                                        <Plus />
                                    </el-icon> 添加章节
                                </el-button>
                            </div>

                            <div v-if="!currentCourse.id" class="save-tip">
                                💡 请先点击右上角“保存草稿”创建课程，随后即可添加章节和上传视频。
                            </div>

                            <div v-else class="chapter-list">
                                <div v-for="(chapter, cIndex) in chapterList" :key="chapter.id" class="chapter-block">
                                    <div class="chapter-header">
                                        <span class="chapter-num">Chapter {{ cIndex + 1 }}</span>
                                        <input v-model="chapter.title" class="chapter-title-input"
                                            @blur="updateChapter(chapter)" />
                                        <el-button link class="action-btn danger text-xs"
                                            @click="deleteChapter(chapter.id)">删除</el-button>
                                    </div>

                                    <div class="resource-list">
                                        <div v-for="res in chapter.resources" :key="res.id" class="resource-item">
                                            <el-icon class="res-icon">
                                                <VideoCamera v-if="res.type === 'video'" />
                                                <Document v-else />
                                            </el-icon>
                                            <span class="res-name">{{ res.name }}</span>
                                            <el-button link class="action-btn danger text-xs"
                                                @click="deleteResource(res.id, chapter)">移除</el-button>
                                        </div>

                                        <div class="upload-resource-trigger">
                                            <el-button link class="add-res-btn" @click="openResourceDialog(chapter.id)">
                                                <el-icon>
                                                    <Paperclip />
                                                </el-icon> 添加视频或课件
                                            </el-button>
                                        </div>
                                    </div>
                                </div>
                                <el-empty v-if="chapterList.length === 0" description="暂无章节" :image-size="60" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </transition>

        <el-dialog v-model="resDialogVisible" title="添加教学资源" width="450px" class="notion-dialog" destroy-on-close>
            <el-form label-position="top">
                <el-form-item label="资源名称">
                    <el-input v-model="resForm.name" placeholder="例如：第一节课视频" class="notion-standard-input" />
                </el-form-item>
                <el-form-item label="资源类型">
                    <el-select v-model="resForm.type" style="width: 100%">
                        <el-option label="视频 (Video)" value="video" />
                        <el-option label="文档/PDF" value="pdf" />
                    </el-select>
                </el-form-item>

                <el-form-item label="上传文件">
                    <el-upload class="notion-drag-upload" drag action="#" :limit="1" :show-file-list="true"
                        :http-request="handleResourceFileUpload" :on-remove="() => resForm.url = ''">
                        <el-icon class="el-icon--upload"><upload-filled /></el-icon>
                        <div class="el-upload__text">
                            将文件拖到此处，或 <em>点击上传</em>
                        </div>
                        <template #tip>
                            <div class="el-upload__tip" style="color: #888;">支持 mp4, pdf, docx 格式</div>
                        </template>
                    </el-upload>
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="resDialogVisible = false" plain size="small">取消</el-button>
                <el-button type="primary" class="notion-btn-primary" size="small" @click="submitResource"
                    :disabled="isUploading">
                    {{ isUploading ? '文件上传中...' : '确认添加' }}
                </el-button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { Plus, DocumentAdd, ArrowLeft, Picture, VideoCamera, Document, Paperclip, UploadFilled } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'

// --- 全局状态 ---
const loading = ref(false)
const viewMode = ref('list') // 'list' | 'editor'
const courseList = ref([])
const categoryList = ref([])

// --- 编辑器状态 ---
const currentCourse = ref({})
const chapterList = ref([])
const saveStatusText = ref('已自动保存')

onMounted(() => {
    fetchCategories()
    fetchMyCourses()
})
const isUploading = ref(false)

// 真实的资源文件上传
const handleResourceFileUpload = async (options) => {
    const formData = new FormData()
    formData.append('file', options.file)

    isUploading.value = true
    try {
        const res = await request.post('/file/upload', formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        })
        // 后端返回文件的网络地址
        resForm.url = res
        ElMessage.success('文件上传服务器成功')
    } catch (e) {
        ElMessage.error('文件上传失败')
    } finally {
        isUploading.value = false
    }
}

// === 视图 1：列表逻辑 ===
const fetchCategories = async () => {
    try { categoryList.value = await request.get('/category/list') || [] } catch (e) { }
}

const getCategoryName = (id) => {
    const cat = categoryList.value.find(c => c.id === id)
    return cat ? cat.name : '未分类'
}

const fetchMyCourses = async () => {
    loading.value = true
    try {
        const res = await request.get('/course/myList', { params: { size: 100 } })
        courseList.value = res.records || []
    } catch (e) { } finally { loading.value = false }
}

const handleDeleteCourse = async (id) => {
    try {
        await request.delete(`/course/delete/${id}`)
        ElMessage.success('课程已删除')
        fetchMyCourses()
    } catch (e) { }
}

// === 视图 2：编辑器核心逻辑 ===
const openEditor = async (course) => {
    if (course) {
        currentCourse.value = { ...course }
        await fetchChaptersAndResources(course.id)
    } else {
        // 新建态
        currentCourse.value = { id: null, title: '', intro: '', syllabus: '', cover: '', categoryId: null, status: 0 }
        chapterList.value = []
    }
    viewMode.value = 'editor'
    window.scrollTo(0, 0)
}

const closeEditor = () => {
    viewMode.value = 'list'
    fetchMyCourses() // 刷新列表获取最新数据
}

// 模拟封面上传 (转为本地预览 URL，实际需调接口)
const handleCoverChange = (file) => {
    currentCourse.value.cover = URL.createObjectURL(file.raw)
    saveStatusText.value = '未保存'
}

// 保存课程基本信息
const handleSaveCourse = async () => {
    if (!currentCourse.value.title) return ElMessage.warning('课程名称不能为空')
    if (!currentCourse.value.categoryId) return ElMessage.warning('请选择课程分类')

    saveStatusText.value = '保存中...'
    try {
        if (currentCourse.value.id) {
            await request.put('/course/update', currentCourse.value)
        } else {
            await request.post('/course/add', currentCourse.value)
            // 新建成功后，需要重新获取自己的课找到刚才建的那个获取ID (简易处理)
            const res = await request.get('/course/myList', { params: { size: 1 } })
            if (res.records && res.records.length > 0) {
                currentCourse.value.id = res.records[0].id
            }
        }
        saveStatusText.value = '已保存'
        ElMessage.success('课程草稿已保存')
    } catch (e) {
        saveStatusText.value = '保存失败'
    }
}

// 提交发布 (将状态改为待审核或直接发布，取决于后端逻辑)
const handlePublishCourse = async () => {
    await handleSaveCourse()
    if (!currentCourse.value.id) return

    try {
        await request.put(`/course/changeStatus/${currentCourse.value.id}/0`)
        ElMessage.success('课程发布请求已提交！')
        currentCourse.value.status = 1
    } catch (e) { }
}

// === 章节与资源逻辑 ===
const fetchChaptersAndResources = async (courseId) => {
    try {
        const chapters = await request.get(`/chapter/list/${courseId}`) || []
        for (let chap of chapters) {
            chap.resources = await request.get(`/resource/list/${chap.id}`) || []
        }
        chapterList.value = chapters
    } catch (e) { }
}

const handleAddChapter = async () => {
    try {
        await request.post('/chapter/add', {
            courseId: currentCourse.value.id,
            title: '新建章节 ' + (chapterList.value.length + 1),
            sort: chapterList.value.length + 1
        })
        fetchChaptersAndResources(currentCourse.value.id)
    } catch (e) { }
}

const updateChapter = async (chapter) => {
    try { await request.put('/chapter/update', chapter) } catch (e) { }
}

const deleteChapter = async (chapterId) => {
    try {
        await request.delete(`/chapter/delete/${chapterId}`)
        fetchChaptersAndResources(currentCourse.value.id)
    } catch (e) { }
}

// 添加资源弹窗
const resDialogVisible = ref(false)
const resForm = reactive({ chapterId: null, name: '', type: 'video', url: '' })

const openResourceDialog = (chapterId) => {
    resForm.chapterId = chapterId
    resForm.name = ''
    resForm.url = ''
    resDialogVisible.value = true
}

const submitResource = async () => {
    if (!resForm.name) return ElMessage.warning('资源名称不能为空')
    if (!resForm.url) return ElMessage.warning('请先等待文件上传完成')
    try {
        await request.post('/resource/add', resForm)
        resDialogVisible.value = false
        fetchChaptersAndResources(currentCourse.value.id)
    } catch (e) { }
}

const deleteResource = async (resId, chapter) => {
    try {
        await request.delete(`/resource/delete/${resId}`)
        // 局部刷新
        chapter.resources = chapter.resources.filter(r => r.id !== resId)
    } catch (e) { }
}
// 真实的封面上传逻辑
const handleCoverUpload = async (options) => {
    const formData = new FormData()
    formData.append('file', options.file) // 后端参数名如果是 file 就用 file

    saveStatusText.value = '上传封面中...'
    try {
        // 调用我们在后端早就写好的通用上传接口
        const res = await request.post('/file/upload', formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        })

        // 假设后端上传成功后，直接返回了文件的网络 URL (res 即为 url 字符串)
        currentCourse.value.cover = res
        saveStatusText.value = '未保存'
        ElMessage.success('封面上传成功')
    } catch (e) {
        ElMessage.error('封面上传失败')
        saveStatusText.value = '已自动保存'
    }
}
</script>

<style scoped>
.notion-page {
    max-width: 1000px;
    margin: 0 auto;
    min-height: 100%;
}

/* === 视图 1：列表 === */
.page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-bottom: 30px;
}

.serif-title {
    font-family: 'Noto Serif SC', serif;
    font-size: 2rem;
    color: rgb(55, 53, 47);
    margin: 0 0 5px 0;
}

.page-desc {
    color: rgba(55, 53, 47, 0.6);
    margin: 0;
    font-size: 14px;
}

.course-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 24px;
}

.notion-course-card {
    border-radius: 8px;
    border: 1px solid rgba(55, 53, 47, 0.09);
    background: #fff;
    overflow: hidden;
    transition: transform 0.2s, box-shadow 0.2s;
}

.notion-course-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
}

.card-cover-wrapper {
    position: relative;
    height: 140px;
    cursor: pointer;
}

.cover-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-bottom: 1px solid rgba(55, 53, 47, 0.05);
}

.status-badge {
    position: absolute;
    top: 10px;
    right: 10px;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 11px;
    font-weight: 600;
}

.status-badge.published {
    background: rgba(255, 255, 255, 0.9);
    color: #2eaadc;
}

.status-badge.draft {
    background: rgba(255, 255, 255, 0.9);
    color: #e08e36;
}

.card-body {
    padding: 16px;
}

.course-title {
    font-size: 15px;
    font-weight: 600;
    margin: 0 0 4px 0;
    cursor: pointer;
    color: rgb(55, 53, 47);
}

.course-category {
    font-size: 12px;
    color: rgba(55, 53, 47, 0.5);
    margin: 0 0 16px 0;
}

.card-actions {
    display: flex;
    justify-content: space-between;
    border-top: 1px solid rgba(55, 53, 47, 0.05);
    padding-top: 12px;
}

.empty-canvas {
    text-align: center;
    padding: 100px 0;
    color: rgba(55, 53, 47, 0.4);
}

.empty-icon {
    font-size: 48px;
    margin-bottom: 16px;
}

/* === 视图 2：沉浸式编辑器 === */
.editor-toolbar {
    position: sticky;
    top: 0;
    z-index: 10;
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(10px);
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 0;
    margin-bottom: 20px;
}

.icon-btn-text {
    background: none;
    border: none;
    color: rgba(55, 53, 47, 0.6);
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 4px;
    font-weight: 500;
}

.icon-btn-text:hover {
    color: rgb(55, 53, 47);
}

.toolbar-actions {
    display: flex;
    align-items: center;
    gap: 12px;
}

.save-status {
    font-size: 12px;
    color: rgba(55, 53, 47, 0.4);
}

.editor-canvas {
    background: #fff;
    border-radius: 8px;
    border: 1px solid rgba(55, 53, 47, 0.09);
    overflow: hidden;
    margin-bottom: 50px;
}

.cover-upload-area {
    height: 200px;
    background-color: #f7f7f5;
    background-size: cover;
    background-position: center;
    position: relative;
}

.cover-overlay {
    position: absolute;
    right: 20px;
    bottom: 20px;
}

.change-cover-btn {
    background: rgba(255, 255, 255, 0.8);
    border: 1px solid rgba(0, 0, 0, 0.1);
    padding: 6px 12px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 12px;
    display: flex;
    align-items: center;
    gap: 6px;
    backdrop-filter: blur(4px);
}

.doc-content {
    padding: 40px 60px;
}

.notion-title-input {
    width: 100%;
    border: none;
    outline: none;
    font-family: 'Noto Serif SC', serif;
    font-size: 2.5rem;
    font-weight: 700;
    color: rgb(55, 53, 47);
    background: transparent;
    padding: 0;
    margin-bottom: 20px;
}

.notion-title-input::placeholder {
    color: rgba(55, 53, 47, 0.2);
}

.meta-inputs {
    margin-bottom: 24px;
}

:deep(.notion-select .el-input__wrapper) {
    box-shadow: none !important;
    background: rgba(55, 53, 47, 0.04);
    border-radius: 6px;
}

.notion-textarea {
    width: 100%;
    border: none;
    outline: none;
    font-family: 'Inter', sans-serif;
    font-size: 15px;
    color: rgb(55, 53, 47);
    background: transparent;
    resize: vertical;
    line-height: 1.6;
}

.notion-textarea.intro {
    font-size: 16px;
    color: rgba(55, 53, 47, 0.8);
    margin-bottom: 30px;
}

.notion-textarea::placeholder {
    color: rgba(55, 53, 47, 0.3);
}

.doc-section {
    margin-top: 40px;
}

.section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
}

.section-title {
    font-size: 1.2rem;
    font-weight: 600;
    margin: 0;
    color: rgb(55, 53, 47);
}

/* 章节列表 */
.save-tip {
    background: rgba(224, 142, 54, 0.1);
    color: #e08e36;
    padding: 12px 16px;
    border-radius: 6px;
    font-size: 13px;
}

.chapter-block {
    border: 1px solid rgba(55, 53, 47, 0.09);
    border-radius: 6px;
    margin-bottom: 16px;
    overflow: hidden;
}

.chapter-header {
    display: flex;
    align-items: center;
    background: #f7f7f5;
    padding: 12px 16px;
    gap: 12px;
    border-bottom: 1px solid rgba(55, 53, 47, 0.05);
}

.chapter-num {
    font-weight: 600;
    font-size: 13px;
    color: rgba(55, 53, 47, 0.5);
}

.chapter-title-input {
    flex: 1;
    border: none;
    outline: none;
    background: transparent;
    font-size: 14px;
    font-weight: 600;
    color: rgb(55, 53, 47);
}

.resource-list {
    padding: 8px 16px;
    background: #fff;
}

.resource-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 0;
    border-bottom: 1px dashed rgba(55, 53, 47, 0.09);
}

.resource-item:last-child {
    border-bottom: none;
}

.res-icon {
    color: #2383e2;
}

.res-name {
    flex: 1;
    font-size: 13px;
    color: rgba(55, 53, 47, 0.8);
}

.upload-resource-trigger {
    padding: 8px 0;
}

.add-res-btn {
    color: rgba(55, 53, 47, 0.5);
    font-size: 13px;
}

.add-res-btn:hover {
    color: #2383e2;
}

/* 通用 */
.action-btn {
    color: rgba(55, 53, 47, 0.6);
}

.action-btn:hover {
    color: rgb(55, 53, 47);
}

.action-btn.danger:hover {
    color: #ff4d4f;
}

.text-xs {
    font-size: 12px;
}

.notion-btn-primary {
    background: #2383e2;
    color: white;
    border: none;
    padding: 6px 14px;
    border-radius: 4px;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
}

.notion-btn-primary:hover {
    background: #1a6ab5;
}

.notion-btn-secondary {
    background: #f7f7f5;
    color: rgb(55, 53, 47);
    border: 1px solid rgba(55, 53, 47, 0.09);
    padding: 8px 16px;
    border-radius: 4px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
}

.notion-btn-secondary:hover {
    background: rgba(55, 53, 47, 0.04);
}

/* 过渡动画 */
.fade-in-enter-active,
.fade-in-leave-active {
    transition: opacity 0.2s, transform 0.2s;
}

.fade-in-enter-from,
.fade-in-leave-to {
    opacity: 0;
    transform: translateY(10px);
}
</style>