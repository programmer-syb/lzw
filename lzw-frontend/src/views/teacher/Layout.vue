<template>
    <div class="notion-layout">
        <aside class="notion-sidebar">
            <div class="sidebar-header">
                <div class="workspace-switcher">
                    <div class="workspace-icon">📚</div>
                    <div class="workspace-name">Lzw Educator</div>
                </div>
            </div>

            <div class="sidebar-scroll">
                <div class="nav-group">
                    <div class="nav-title">工作台</div>
                    <router-link to="/teacher/dashboard" class="notion-nav-item" active-class="active">
                        <el-icon>
                            <DataBoard />
                        </el-icon> 数据概览
                    </router-link>
                </div>

                <div class="nav-group">
                    <div class="nav-title">教学创作</div>
                    <router-link to="/teacher/courses" class="notion-nav-item" active-class="active">
                        <el-icon>
                            <Collection />
                        </el-icon> 课程与章节管理
                    </router-link>
                    <router-link to="/teacher/resources" class="notion-nav-item" active-class="active">
                        <el-icon>
                            <FolderOpened />
                        </el-icon> 教学资源库
                    </router-link>
                </div>

                <div class="nav-group">
                    <div class="nav-title">互动与考核</div>
                    <router-link to="/teacher/homework" class="notion-nav-item" active-class="active">
                        <el-icon>
                            <EditPen />
                        </el-icon> 作业批改
                    </router-link>
                    <router-link to="/teacher/grading" class="notion-nav-item" active-class="active">
                        <el-icon>
                            <Checked />
                        </el-icon> 试卷批改
                    </router-link>
                    <router-link to="/teacher/exams" class="notion-nav-item" active-class="active">
                        <el-icon>
                            <DocumentChecked />
                        </el-icon> 试卷与题库
                    </router-link>
                </div>
            </div>

            <div class="sidebar-footer">
                <el-dropdown trigger="click" class="full-width" @command="handleCommand">
                    <div class="user-profile-btn">
                        <el-avatar :size="24"
                            :src="userInfo.avatar || 'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix'" />
                        <span class="username">{{ userInfo.nickname || userInfo.username }}</span>
                        <el-icon class="arrow">
                            <ArrowRight />
                        </el-icon>
                    </div>
                    <template #dropdown>
                        <el-dropdown-menu class="notion-dropdown">
                            <el-dropdown-item command="profile">个人资料</el-dropdown-item>
                            <el-dropdown-item divided command="logout" class="danger-text">退出登录</el-dropdown-item>
                        </el-dropdown-menu>
                    </template>
                </el-dropdown>
            </div>
        </aside>

        <main class="notion-main">
            <header class="notion-topbar">
                <div class="topbar-left">
                    <span class="breadcrumb-text">Teacher Workspace</span>
                </div>
                <div class="topbar-right">
                    <button class="icon-btn" @click="$router.push('/teacher/notices')">
                        <el-icon>
                            <Bell />
                        </el-icon>
                    </button>
                    <button class="notion-btn-primary" @click="$router.push('/teacher/courses')">新建课程</button>
                </div>
            </header>

            <div class="notion-content">
                <router-view v-slot="{ Component }">
                    <transition name="fade-in" mode="out-in">
                        <component :is="Component" />
                    </transition>
                </router-view>
            </div>
        </main>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { DataBoard, Collection, FolderOpened, EditPen, DocumentChecked, Bell, ArrowRight } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'

const router = useRouter()
const userInfo = ref({})

onMounted(() => {
    const storedUser = localStorage.getItem('userInfo')
    if (storedUser) {
        userInfo.value = JSON.parse(storedUser)
    }
})

const handleCommand = (command) => {
    if (command === 'logout') {
        ElMessageBox.confirm('确定要退出教师工作台吗？', '提示', {
            confirmButtonText: '退出', cancelButtonText: '取消', type: 'warning'
        }).then(async () => {
            try { await request.post('/user/logout') } catch (e) { }
            localStorage.removeItem('token')
            localStorage.removeItem('userInfo')
            router.push('/login')
            ElMessage.success('已安全退出')
        }).catch(() => { })
    } else if (command === 'profile') {
        // 跳转到个人中心页面
        router.push('/teacher/profile')
    }
}
</script>

<style scoped>
/* 引入衬线字体 (用于标题) 和 无衬线字体 (用于正文) */
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@500;700&family=Inter:wght@400;500;600&display=swap');

.notion-layout {
    display: flex;
    height: 100vh;
    width: 100vw;
    background-color: #ffffff;
    /* 纯白底色 */
    color: rgb(55, 53, 47);
    /* Notion 经典字体颜色 */
    font-family: 'Inter', -apple-system, sans-serif;
    overflow: hidden;
}

/* ================= 侧边栏 ================= */
.notion-sidebar {
    width: 250px;
    background-color: #f7f7f5;
    /* 极其柔和的米灰色 */
    border-right: 1px solid rgba(55, 53, 47, 0.09);
    display: flex;
    flex-direction: column;
    transition: width 0.3s;
}

.sidebar-header {
    padding: 16px;
}

.workspace-switcher {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 6px 8px;
    border-radius: 6px;
    cursor: pointer;
    transition: background 0.2s;
}

.workspace-switcher:hover {
    background: rgba(55, 53, 47, 0.08);
}

.workspace-icon {
    font-size: 20px;
}

.workspace-name {
    font-weight: 600;
    font-size: 14px;
}

.sidebar-scroll {
    flex: 1;
    overflow-y: auto;
    padding: 10px 0;
}

.nav-group {
    margin-bottom: 24px;
}

.nav-title {
    font-size: 11px;
    font-weight: 600;
    color: rgba(55, 53, 47, 0.5);
    padding: 0 16px;
    margin-bottom: 4px;
    letter-spacing: 0.5px;
}

.notion-nav-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 6px 16px;
    color: rgba(55, 53, 47, 0.8);
    text-decoration: none;
    font-size: 14px;
    font-weight: 500;
    transition: background 0.2s;
    margin: 0 8px;
    border-radius: 6px;
}

.notion-nav-item .el-icon {
    font-size: 16px;
    color: rgba(55, 53, 47, 0.5);
}

.notion-nav-item:hover {
    background: rgba(55, 53, 47, 0.08);
}

.notion-nav-item.active {
    background: rgba(55, 53, 47, 0.08);
    font-weight: 600;
    color: rgb(55, 53, 47);
}

.notion-nav-item.active .el-icon {
    color: rgb(55, 53, 47);
}

.sidebar-footer {
    padding: 12px;
    border-top: 1px solid rgba(55, 53, 47, 0.09);
}

.user-profile-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 6px;
    border-radius: 6px;
    cursor: pointer;
    transition: background 0.2s;
    width: 100%;
    box-sizing: border-box;
}

.user-profile-btn:hover {
    background: rgba(55, 53, 47, 0.08);
}

.user-profile-btn .username {
    flex: 1;
    font-size: 13px;
    font-weight: 500;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.user-profile-btn .arrow {
    font-size: 12px;
    color: rgba(55, 53, 47, 0.4);
}

/* ================= 主内容区 ================= */
.notion-main {
    flex: 1;
    display: flex;
    flex-direction: column;
    background: #ffffff;
}

.notion-topbar {
    height: 52px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 24px;
    border-bottom: 1px solid rgba(55, 53, 47, 0.09);
}

.breadcrumb-text {
    font-size: 14px;
    color: rgba(55, 53, 47, 0.6);
}

.topbar-right {
    display: flex;
    align-items: center;
    gap: 12px;
}

.icon-btn {
    background: transparent;
    border: none;
    font-size: 18px;
    color: rgba(55, 53, 47, 0.6);
    cursor: pointer;
    width: 32px;
    height: 32px;
    border-radius: 4px;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: 0.2s;
}

.icon-btn:hover {
    background: rgba(55, 53, 47, 0.08);
    color: rgb(55, 53, 47);
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
    transition: background 0.2s;
}

.notion-btn-primary:hover {
    background: #1a6ab5;
}

.notion-content {
    flex: 1;
    overflow-y: auto;
    padding: 40px 60px;
    /* 大量留白 */
}

/* 路由动画 */
.fade-in-enter-active,
.fade-in-leave-active {
    transition: opacity 0.2s ease, transform 0.2s ease;
}

.fade-in-enter-from,
.fade-in-leave-to {
    opacity: 0;
    transform: translateY(5px);
}
</style>