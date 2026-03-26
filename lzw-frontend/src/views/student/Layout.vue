<template>
    <div class="mac-desktop">
        <div class="mac-window">

            <aside class="mac-sidebar">
                <div class="mac-traffic-lights">
                    <span class="light red"></span>
                    <span class="light yellow"></span>
                    <span class="light green"></span>
                </div>

                <nav class="mac-nav">
                    <div class="nav-group">学习中心</div>
                    <router-link to="/student/discovery" class="nav-item" active-class="is-active">
                        <el-icon>
                            <Compass />
                        </el-icon>
                        <span>发现课程</span>
                    </router-link>
                    <router-link to="/student/my-courses" class="nav-item" active-class="is-active">
                        <el-icon>
                            <Reading />
                        </el-icon>
                        <span>我的课程</span>
                    </router-link>

                    <div class="nav-group" style="margin-top: 20px;">互动与考核</div>
                    <router-link to="/student/homework" class="nav-item" active-class="is-active">
                        <el-icon>
                            <DocumentChecked />
                        </el-icon>
                        <span>我的作业</span>
                    </router-link>
                    <router-link to="/student/exam" class="nav-item" active-class="is-active">
                        <el-icon>
                            <Trophy />
                        </el-icon>
                        <span>在线测验</span>
                    </router-link>
                    <router-link to="/student/discussion" class="nav-item" active-class="is-active">
                        <el-icon>
                            <ChatDotSquare />
                        </el-icon>
                        <span>讨论区</span>
                    </router-link>
                </nav>
            </aside>

            <div class="mac-main">
                <header class="mac-topbar">
                    <div class="breadcrumb">
                        <span class="path-current">学生控制台</span>
                    </div>

                    <div class="user-actions">
                        <div class="icon-btn"><el-icon>
                                <Search />
                            </el-icon></div>
                        <div class="icon-btn" style="cursor: pointer;" @click="$router.push('/student/notices')">
                            <el-icon>
                                <Bell />
                            </el-icon>
                        </div>

                        <el-dropdown trigger="click" @command="handleCommand">
                            <div class="user-profile">
                                <el-avatar :size="32"
                                    :src="userInfo.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'" />
                                <span class="user-name">{{ userInfo.nickname || userInfo.username }}</span>
                                <el-icon class="el-icon--right"><arrow-down /></el-icon>
                            </div>
                            <template #dropdown>
                                <el-dropdown-menu class="mac-dropdown">
                                    <el-dropdown-item command="profile">个人资料</el-dropdown-item>
                                    <el-dropdown-item command="settings">系统设置</el-dropdown-item>
                                    <el-dropdown-item divided command="logout"
                                        class="danger-text">退出登录</el-dropdown-item>
                                </el-dropdown-menu>
                            </template>
                        </el-dropdown>
                    </div>
                </header>

                <main class="mac-content-scroll">
                    <router-view v-slot="{ Component }">
                        <transition name="fade-slide" mode="out-in">
                            <component :is="Component" />
                        </transition>
                    </router-view>
                </main>
            </div>

        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
    Compass, Reading, DocumentChecked, Trophy,
    ChatDotSquare, Search, Bell, ArrowDown
} from '@element-plus/icons-vue'
import request from '../../utils/request'

const router = useRouter()
const userInfo = ref({})

onMounted(() => {
    // 从本地存储获取用户信息展示在右上角
    const storedUser = localStorage.getItem('userInfo')
    if (storedUser) {
        userInfo.value = JSON.parse(storedUser)
    }
})

// 处理下拉菜单点击
const handleCommand = (command) => {
    if (command === 'logout') {
        handleLogout();
    } else if (command === 'profile') {
        // 跳转到个人中心页面
        router.push('/student/profile')
    } else if (command === 'settings') {
        // 跳转到系统设置页面
        router.push('/student/settings')
    }
}

// 退出登录逻辑
const handleLogout = () => {
    ElMessageBox.confirm('确定要退出当前账号吗？', '提示', {
        confirmButtonText: '退出',
        cancelButtonText: '取消',
        type: 'warning',
        customClass: 'mac-message-box' // 自定义弹窗样式类
    }).then(async () => {
        try {
            // 告诉后端销毁 Token
            await request.post('/user/logout')
        } catch (e) {
            console.warn('后端登出异常，强制清除本地缓存')
        } finally {
            // 无论后端是否成功，前端必须清除缓存并跳转
            localStorage.removeItem('token')
            localStorage.removeItem('userInfo')
            router.push('/login')
            ElMessage.success('已安全退出')
        }
    }).catch(() => { })
}
</script>

<style scoped>
/* 引入苹果默认字体栈 */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap');

.mac-desktop {
    width: 100vw;
    height: 100vh;
    /* 苹果经典的桌面壁纸色调 (浅灰蓝) */
    background: linear-gradient(135deg, #e5eaf5 0%, #f0f2f5 100%);
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Inter", "Helvetica Neue", Arial, sans-serif;
    padding: 20px;
    box-sizing: border-box;
}

/* Mac 悬浮应用窗口 */
.mac-window {
    width: 100%;
    max-width: 1440px;
    height: 100%;
    background: rgba(255, 255, 255, 0.75);
    backdrop-filter: blur(25px);
    /* 毛玻璃特效 */
    -webkit-backdrop-filter: blur(25px);
    border-radius: 16px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08),
        0 1px 3px rgba(0, 0, 0, 0.05),
        inset 0 1px 1px rgba(255, 255, 255, 0.8);
    display: flex;
    overflow: hidden;
    border: 1px solid rgba(255, 255, 255, 0.5);
}

/* ================= 左侧边栏 ================= */
.mac-sidebar {
    width: 240px;
    background: rgba(245, 245, 247, 0.5);
    /* 极浅的灰色 */
    border-right: 1px solid rgba(0, 0, 0, 0.06);
    display: flex;
    flex-direction: column;
    padding: 16px 12px;
}

/* 交通灯 */
.mac-traffic-lights {
    display: flex;
    gap: 8px;
    padding: 4px 8px 24px;
}

.light {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.1);
}

.red {
    background: #ff5f56;
    border: 1px solid #e0443e;
}

.yellow {
    background: #ffbd2e;
    border: 1px solid #dea123;
}

.green {
    background: #27c93f;
    border: 1px solid #1aab29;
}

/* 导航栏 */
.mac-nav {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.nav-group {
    font-size: 12px;
    font-weight: 600;
    color: #86868b;
    padding: 0 12px;
    margin-bottom: 6px;
}

.nav-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 8px 12px;
    border-radius: 8px;
    color: #1d1d1f;
    text-decoration: none;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.2s ease;
}

.nav-item .el-icon {
    font-size: 18px;
    color: #007aff;
    /* 苹果蓝 */
}

.nav-item:hover {
    background: rgba(0, 0, 0, 0.04);
}

.nav-item.is-active {
    background: #007aff;
    color: #ffffff;
    box-shadow: 0 2px 6px rgba(0, 122, 255, 0.3);
}

.nav-item.is-active .el-icon {
    color: #ffffff;
}

/* ================= 右侧主体区域 ================= */
.mac-main {
    flex: 1;
    display: flex;
    flex-direction: column;
    background: #ffffff;
}

/* 顶栏 */
.mac-topbar {
    height: 60px;
    padding: 0 24px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid rgba(0, 0, 0, 0.06);
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(10px);
}

.path-current {
    font-size: 16px;
    font-weight: 600;
    color: #1d1d1f;
}

.user-actions {
    display: flex;
    align-items: center;
    gap: 16px;
}

.icon-btn {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #1d1d1f;
    cursor: pointer;
    transition: background 0.2s;
}

.icon-btn:hover {
    background: rgba(0, 0, 0, 0.05);
}

/* 用户信息下拉 */
.user-profile {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 4px 8px;
    border-radius: 20px;
    cursor: pointer;
    transition: background 0.2s;
}

.user-profile:hover {
    background: rgba(0, 0, 0, 0.04);
}

.user-name {
    font-size: 14px;
    font-weight: 500;
    color: #1d1d1f;
}

/* 路由内容区 */
.mac-content-scroll {
    flex: 1;
    padding: 24px;
    overflow-y: auto;
    background: #fbfbfd;
    /* 苹果官网常用的极光白底色 */
}

/* 页面切换动画 */
.fade-slide-enter-active,
.fade-slide-leave-active {
    transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.fade-slide-enter-from {
    opacity: 0;
    transform: translateY(15px);
}

.fade-slide-leave-to {
    opacity: 0;
    transform: translateY(-15px);
}

/* 覆盖 Element Plus 的下拉菜单样式 */
:deep(.mac-dropdown) {
    border-radius: 12px !important;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12) !important;
}

:deep(.danger-text) {
    color: #ff3b30 !important;
}
</style>