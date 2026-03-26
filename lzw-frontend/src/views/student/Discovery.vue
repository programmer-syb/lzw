<template>
    <div class="discovery-page" v-loading="loading" element-loading-background="#fbfbfd">
        <div class="filter-header">
            <div class="header-left">
                <h1 class="page-title">探索新知</h1>
                <p class="page-subtitle">遇见为你定制的精彩课程</p>
            </div>

            <div class="header-right">
                <el-input v-model="queryParams.keyword" class="apple-search" placeholder="搜索您感兴趣的课程..."
                    :prefix-icon="Search" clearable @change="handleSearch" />
            </div>
        </div>

        <div class="category-tabs-container">
            <el-radio-group v-model="queryParams.categoryId" class="mac-radio-tabs" @change="handleSearch">
                <el-radio-button :label="null">全部</el-radio-button>
                <el-radio-button v-for="cat in categoryList" :key="cat.id" :label="cat.id">
                    {{ cat.name }}
                </el-radio-button>
            </el-radio-group>
        </div>

        <div v-if="courseList.length > 0" class="course-grid">
            <div v-for="(course, index) in courseList" :key="course.id" class="course-card-wrapper"
                :style="{ animationDelay: `${index * 80}ms` }">
                <div class="course-card mac-squircle-card" @click="goToDetail(course.id)">
                    <div class="card-cover-wrapper">
                        <img :src="course.cover || 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=600&auto=format&fit=crop'"
                            class="card-cover" alt="course cover" />
                        <div class="card-overlay">
                            <span class="category-tag">{{ getCategoryName(course.categoryId) }}</span>
                        </div>
                    </div>

                    <div class="card-body">
                        <h3 class="course-title">{{ course.title }}</h3>
                        <p class="course-intro">{{ truncate(course.intro, 40) }}</p>

                        <div class="card-footer">
                            <div class="students-info">
                                <el-icon>
                                    <Reading />
                                </el-icon>
                                <span>3.2k 人已选</span>
                            </div>
                            <button class="mac-btn-link">查看详情</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <el-empty v-else-if="!loading" description="暂时没有找到相关课程，换个关键词试试？" class="mac-empty" />

        <div class="pagination-container">
            <el-pagination v-model:current-page="queryParams.current" v-model:page-size="queryParams.size"
                layout="prev, pager, next" :total="total" background class="mac-pagination"
                @current-change="handlePageChange" />
        </div>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Search, Reading } from '@element-plus/icons-vue'
import request from '../../utils/request' 

const loading = ref(false)
const total = ref(0)
const courseList = ref([])
const categoryList = ref([]) 
const router = useRouter()

// 查询参数 (对接后端 Page 结构)
const queryParams = reactive({
    current: 1, // 当前页码
    size: 10,   // 每页条数
    categoryId: null, // 当前选中的分类ID
    keyword: '' // 搜索关键词
})

// 初始化
onMounted(() => {
    fetchCategories()
    fetchCourseList()
})

// 1. 获取分类列表供过滤 (调用我们写好的通用分类接口)
const fetchCategories = async () => {
    try {
        const res = await request.get('/category/list')
        categoryList.value = res
    } catch (error) {
        console.error('获取分类失败', error)
    }
}

// 2. 获取公共课程列表 (调用 /course/public/list 接口)
const fetchCourseList = async () => {
    loading.value = true
    try {
        // 组装查询字符串
        const params = {
            current: queryParams.current,
            size: queryParams.size,
            categoryId: queryParams.categoryId,
            keyword: queryParams.keyword
        }
        const res = await request.get('/course/public/list', { params })

        // MyBatis-Plus 分页返回对象为 { records: [], total: ... }
        courseList.value = res.records
        total.value = res.total

    } catch (error) {
        console.error('获取课程失败', error)
    } finally {
        // 延迟 300ms 关闭加载，让动画看起来更细腻
        setTimeout(() => { loading.value = false }, 300)
    }
}

// 搜索处理
const handleSearch = () => {
    queryParams.current = 1 // 搜索时重置为第一页
    fetchCourseList()
}

// 页码处理
const handlePageChange = (val) => {
    queryParams.current = val
    fetchCourseList()
    // 滚动到顶部，获得丝滑体验
    window.scrollTo({ top: 0, behavior: 'smooth' })
}

// 工具：文本截断
const truncate = (text, length) => {
    if (!text) return ''
    return text.length > length ? text.substring(0, length) + '...' : text
}

// 工具：根据ID转换分类名称
const getCategoryName = (id) => {
    if (!id) return '未知分类'
    const category = categoryList.value.find(item => item.id === id)
    return category ? category.name : '其它'
}
const goToDetail = (id) => {
  router.push(`/student/course/${id}`)
}
</script>

<style scoped>
.discovery-page {
    padding: 10px;
    /* Layout 已经有了 padding，这里加一点内部的间距 */
    box-sizing: border-box;
}

/* ================= 1. 顶部 Header (苹果 Filter Bar 风) ================= */
.filter-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

.page-title {
    font-size: 2.2rem;
    font-weight: 700;
    margin: 0;
    color: #1d1d1f;
    letter-spacing: -1px;
}

.page-subtitle {
    color: #86868b;
    margin: 5px 0 0 0;
    font-size: 1.1rem;
}

/* 重写 Element Plus 搜索框样式，使其变“圆”变“毛玻璃” */
:deep(.apple-search) {
    width: 320px;
}

:deep(.apple-search .el-input__wrapper) {
    background-color: rgba(0, 0, 0, 0.04) !important;
    backdrop-filter: blur(5px);
    border-radius: 20px !important;
    /* 彻底圆角 */
    box-shadow: none !important;
    border: 1px solid transparent;
    transition: all 0.3s cubic-bezier(0.25, 1, 0.5, 1);
}

:deep(.apple-search .el-input__wrapper.is-focus) {
    background-color: #ffffff !important;
    border-color: #007aff;
    box-shadow: 0 0 0 3px rgba(0, 122, 255, 0.1) !important;
}

/* ================= 2. 分类标签栏 (Mac 系统偏好设置风) ================= */
.category-tabs-container {
    margin-bottom: 30px;
    overflow-x: auto;
    /* 允许分类过多时横向滚动 */
    padding-bottom: 10px;
}

:deep(.mac-radio-tabs) {
    background: rgba(0, 0, 0, 0.04);
    padding: 3px;
    border-radius: 12px;
    border: 1px solid rgba(0, 0, 0, 0.02);
    display: inline-flex;
}

:deep(.mac-radio-tabs .el-radio-button__inner) {
    border: none !important;
    border-radius: 9px !important;
    /* Squircle 圆角 */
    background: transparent !important;
    color: #515154 !important;
    font-weight: 600;
    font-size: 14px;
    padding: 8px 18px;
    transition: all 0.25s ease;
}

:deep(.mac-radio-tabs .el-radio-button__original-radio:checked + .el-radio-button__inner) {
    background: #ffffff !important;
    color: #007aff !important;
    /* 选中时变成苹果蓝 */
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 1px rgba(0, 0, 0, 0.06) !important;
}

/* ================= 3. 瀑布流响应式卡片 (核心艺术品区) ================= */
/* 使用 CSS Grid 实现纯 CSS Masonry (瀑布流)，高端，兼容性好 */
.course-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    /* 响应式布局 */
    gap: 24px;
    padding-bottom: 50px;
}

/* 卡片入场动画 */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }

    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.course-card-wrapper {
    animation: fadeInUp 0.6s cubic-bezier(0.23, 1, 0.32, 1) both;
}

/* 高端 Mac Squircle 玻璃拟态卡片 */
.course-card {
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-radius: 20px;
    /* 大圆角 Squircle */
    overflow: hidden;
    border: 1px solid rgba(255, 255, 255, 0.3);
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.02), 0 1px 2px rgba(0, 0, 0, 0.03);
    transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    display: flex;
    flex-direction: column;
    cursor: pointer;
    height: 100%;
}

/* 核心！悬浮时的 3D 位移特效，配合阻尼感 */
.course-card:hover {
    transform: translateY(-8px) scale(1.02) rotateX(2deg) rotateY(1deg);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.07), 0 1px 3px rgba(0, 0, 0, 0.04);
    border-color: rgba(255, 255, 255, 0.6);
}

/* 课程封面区域 */
.card-cover-wrapper {
    width: 100%;
    aspect-ratio: 16 / 9;
    /* 强制锁定比例，适合瀑布流展示 */
    overflow: hidden;
    position: relative;
}

.card-cover {
    width: 100%;
    height: 100%;
    object-fit: cover;
    /* 裁剪适应 */
    transition: transform 0.6s ease;
}

.course-card:hover .card-cover {
    transform: scale(1.1);
    /* 封面轻微放大 */
}

/* 封面上的遮罩层与分类标签 */
.card-overlay {
    position: absolute;
    top: 12px;
    right: 12px;
    z-index: 2;
}

.category-tag {
    background: rgba(0, 122, 255, 0.8);
    backdrop-filter: blur(5px);
    color: #fff;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* 课程卡片内容区 */
.card-body {
    padding: 18px;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}

.course-title {
    font-size: 1.15rem;
    font-weight: 700;
    color: #1d1d1f;
    margin: 0 0 8px 0;
    transition: color 0.3s;
}

.course-card:hover .course-title {
    color: #007aff;
}

.course-intro {
    font-size: 13px;
    color: #86868b;
    line-height: 1.5;
    margin: 0 0 20px 0;
    flex-grow: 1;
    /* 使intro占据剩余空间，让footer对齐底部 */
}

/* 卡片底部 (Footer) */
.card-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 12px;
    border-top: 1px solid rgba(0, 0, 0, 0.04);
}

.students-info {
    display: flex;
    align-items: center;
    gap: 6px;
    color: #86868b;
    font-size: 12px;
}

.students-info .el-icon {
    font-size: 14px;
}

.mac-btn-link {
    background: none;
    border: none;
    color: #007aff;
    font-weight: 600;
    font-size: 13px;
    padding: 0;
    cursor: pointer;
    transition: opacity 0.3s;
}

.mac-btn-link:hover {
    opacity: 0.7;
}

/* ================= 4. 空状态 & 5. 分页 ================= */
.mac-empty {
    padding: 100px 0;
}

:deep(.mac-empty .el-empty__description p) {
    color: #86868b;
    font-weight: 500;
}

.pagination-container {
    display: flex;
    justify-content: center;
    margin-top: 30px;
    padding-bottom: 40px;
}

:deep(.mac-pagination.is-background .el-pager li) {
    background-color: transparent !important;
    color: #515154 !important;
    border-radius: 8px !important;
    transition: background 0.25s;
}

:deep(.mac-pagination.is-background .el-pager li.is-active) {
    background-color: #007aff !important;
    color: #ffffff !important;
}
</style>