<template>
    <div class="saas-admin-layout">
        <aside class="saas-sidebar">
            <div class="sidebar-brand">
                <div class="brand-logo">
                    <div class="cube"></div>
                </div>
                <span class="brand-name">Lzw Workspace</span>
                <el-tag size="small" type="info" class="version-tag">Admin</el-tag>
            </div>

            <nav class="saas-nav">

                <div class="nav-section">数据概览</div>
                <router-link to="/admin/dashboard" class="nav-item" active-class="active">
                    <el-icon>
                        <Odometer />
                    </el-icon> 统计大屏
                </router-link>

                <div class="nav-section">平台管理</div>
                <router-link to="/admin/users" class="nav-item" active-class="active">
                    <el-icon>
                        <User />
                    </el-icon> 用户管理
                </router-link>
                <router-link to="/admin/courses" class="nav-item" active-class="active">
                    <el-icon>
                        <Reading />
                    </el-icon> 课程审核
                </router-link>
                <router-link to="/admin/categories" class="nav-item" active-class="active">
                    <el-icon>
                        <Collection />
                    </el-icon> 分类管理
                </router-link>

                <div class="nav-section">系统运维</div>
                <router-link to="/admin/storage" class="nav-item" active-class="active">
                    <el-icon>
                        <Box />
                    </el-icon> 资源存储
                </router-link>
                <router-link to="/admin/notices" class="nav-item" active-class="active">
                    <el-icon>
                        <Bell />
                    </el-icon> 系统公告
                </router-link>
                <router-link to="/admin/logs" class="nav-item" active-class="active">
                    <el-icon>
                        <Monitor />
                    </el-icon> 运行日志
                </router-link>
            </nav>

            <div class="sidebar-footer">
                <div class="user-mini-card">
                    <el-avatar :size="28"
                        :src="userInfo.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'" />
                    <div class="user-info-text">
                        <span class="name">{{ userInfo.nickname || 'Admin' }}</span>
                        <span class="role">Administrator</span>
                    </div>
                    <el-button link @click="handleLogout" class="logout-btn"><el-icon>
                            <SwitchButton />
                        </el-icon></el-button>
                </div>
            </div>
        </aside>

        <div class="saas-main">
            <header class="saas-header">
                <div class="header-breadcrumbs">
                    <span class="breadcrumb-item">Admin</span>
                    <span class="separator">/</span>
                    <span class="breadcrumb-current">{{ currentRouteName }}</span>
                </div>
                <div class="header-tools">
                    <div class="tool-btn"><el-icon>
                            <Search />
                        </el-icon></div>
                    <div class="tool-btn"><el-icon>
                            <Setting />
                        </el-icon></div>
                </div>
            </header>

            <main class="saas-content">
                <router-view v-slot="{ Component }">
                    <transition name="fade-fast" mode="out-in">
                        <component :is="Component" :key="route.path" />
                    </transition>
                </router-view>
            </main>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Odometer, User, Collection, Bell, Search, Setting, SwitchButton } from '@element-plus/icons-vue'
import { ElMessageBox, ElMessage } from 'element-plus'
import request from '../../utils/request'

const router = useRouter()
const route = useRoute()
const userInfo = ref({})

onMounted(() => {
    const storedUser = localStorage.getItem('userInfo')
    if (storedUser) userInfo.value = JSON.parse(storedUser)
})

const currentRouteName = computed(() => {
    const map = {
        '/admin/dashboard': 'Dashboard',
        '/admin/users': 'Users Management',
        '/admin/categories': 'Categories',
        '/admin/notices': 'System Notices'
    }
    return map[route.path] || 'Workspace'
})

const handleLogout = () => {
    ElMessageBox.confirm('确认退出管理员终端?', 'Logout', {
        confirmButtonText: 'Confirm', cancelButtonText: 'Cancel', type: 'warning'
    }).then(async () => {
        try { await request.post('/user/logout') } catch (e) { }
        localStorage.removeItem('token')
        localStorage.removeItem('userInfo')
        router.push('/login')
        ElMessage.success('已退出')
    }).catch(() => { })
}
</script>

<style scoped>
/* 引入等宽字体和系统字体 */
@import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;700&family=Inter:wght@400;500;600&display=swap');

.saas-admin-layout {
    display: flex;
    height: 100vh;
    width: 100vw;
    background-color: #fafafa;
    font-family: 'Inter', -apple-system, sans-serif;
    color: #111;
    overflow: hidden;
}

/* ================= 极简侧边栏 ================= */
.saas-sidebar {
    width: 260px;
    background-color: #fff;
    border-right: 1px solid #eaeaea;
    display: flex;
    flex-direction: column;
}

.sidebar-brand {
    height: 70px;
    display: flex;
    align-items: center;
    padding: 0 24px;
    gap: 12px;
    border-bottom: 1px solid #eaeaea;
}

.brand-logo .cube {
    width: 24px;
    height: 24px;
    background: #000;
    border-radius: 4px;
}

.brand-name {
    font-weight: 600;
    font-size: 15px;
    letter-spacing: -0.5px;
}

.version-tag {
    border-radius: 4px;
    border: none;
    background: #f0f0f0;
    color: #666;
    font-family: 'JetBrains Mono', monospace;
}

.saas-nav {
    flex: 1;
    padding: 24px 12px;
    overflow-y: auto;
}

.nav-section {
    font-size: 11px;
    font-weight: 600;
    color: #888;
    letter-spacing: 1px;
    margin: 16px 0 8px 12px;
}

.nav-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 12px;
    margin-bottom: 4px;
    color: #444;
    text-decoration: none;
    font-size: 14px;
    font-weight: 500;
    border-radius: 6px;
    transition: all 0.2s ease;
}

.nav-item .el-icon {
    font-size: 16px;
    color: #888;
    transition: color 0.2s;
}

.nav-item:hover {
    background-color: #f5f5f5;
    color: #000;
}

.nav-item:hover .el-icon {
    color: #000;
}

.nav-item.active {
    background-color: #000;
    color: #fff;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.nav-item.active .el-icon {
    color: #fff;
}

.sidebar-footer {
    padding: 16px;
    border-top: 1px solid #eaeaea;
}

.user-mini-card {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 8px;
    border-radius: 8px;
    transition: background 0.2s;
}

.user-mini-card:hover {
    background: #f5f5f5;
}

.user-info-text {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.user-info-text .name {
    font-size: 13px;
    font-weight: 600;
    color: #111;
}

.user-info-text .role {
    font-size: 11px;
    color: #888;
}

.logout-btn {
    color: #888;
}

.logout-btn:hover {
    color: #ff4d4f;
}

/* ================= 右侧主体 ================= */
.saas-main {
    flex: 1;
    display: flex;
    flex-direction: column;
    background: #fafafa;
}

.saas-header {
    height: 70px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 32px;
    border-bottom: 1px solid #eaeaea;
    background: #fff;
}

.header-breadcrumbs {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
}

.breadcrumb-item {
    color: #666;
}

.separator {
    color: #ccc;
}

.breadcrumb-current {
    color: #000;
    font-weight: 600;
}

.header-tools {
    display: flex;
    gap: 16px;
}

.tool-btn {
    color: #666;
    cursor: pointer;
    transition: color 0.2s;
}

.tool-btn:hover {
    color: #000;
}

.saas-content {
    flex: 1;
    padding: 32px;
    overflow-y: auto;
}

.fade-fast-enter-active,
.fade-fast-leave-active {
    transition: opacity 0.15s ease;
}

.fade-fast-enter-from,
.fade-fast-leave-to {
    opacity: 0;
}
</style>