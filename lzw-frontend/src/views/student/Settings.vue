<template>
    <div class="settings-page">
        <div class="page-header">
            <h1 class="mac-title">系统设置</h1>
        </div>

        <div class="settings-container">
            <div class="settings-sidebar">
                <div class="menu-item active">外观与显示</div>
                <div class="menu-item">通用设置</div>
                <div class="menu-item">隐私与安全</div>
            </div>

            <div class="settings-content glass-panel mac-squircle">
                <div class="setting-group">
                    <h3 class="group-title">外观 (Appearance)</h3>

                    <div class="setting-item">
                        <div class="setting-info">
                            <span class="setting-name">暗黑模式</span>
                            <span class="setting-desc">开启后，系统界面将切换为深色主题以保护视力</span>
                        </div>
                        <el-switch v-model="isDarkMode" @change="toggleTheme" class="mac-switch"
                            style="--el-switch-on-color: #34c759;" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const isDarkMode = ref(false)

onMounted(() => {
    // 页面加载时，读取本地存储的主题设置
    const theme = localStorage.getItem('theme')
    if (theme === 'dark') {
        isDarkMode.value = true
        document.documentElement.classList.add('dark')
    }
})

// 切换主题模式
const toggleTheme = (val) => {
    if (val) {
        document.documentElement.classList.add('dark')
        localStorage.setItem('theme', 'dark')
    } else {
        document.documentElement.classList.remove('dark')
        localStorage.setItem('theme', 'light')
    }
}
</script>

<style scoped>
.settings-page {
    max-width: 1000px;
    margin: 0 auto;
    padding: 20px;
}

.page-header {
    margin-bottom: 30px;
}

.mac-title {
    font-size: 2.2rem;
    font-weight: 800;
    color: #1d1d1f;
    margin: 0;
}

.settings-container {
    display: flex;
    gap: 30px;
}

/* 左侧菜单 */
.settings-sidebar {
    width: 220px;
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.menu-item {
    padding: 10px 15px;
    border-radius: 8px;
    color: #515154;
    font-weight: 500;
    cursor: pointer;
    transition: 0.2s;
}

.menu-item:hover {
    background: rgba(0, 0, 0, 0.05);
}

.menu-item.active {
    background: #007aff;
    color: #fff;
    font-weight: 600;
}

/* 右侧内容 */
.settings-content {
    flex: 1;
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(20px);
    padding: 30px;
    border: 1px solid rgba(255, 255, 255, 0.6);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
}

.group-title {
    font-size: 13px;
    color: #86868b;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin: 0 0 15px 10px;
}

.setting-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #fff;
    padding: 15px 20px;
    border-radius: 12px;
    border: 1px solid rgba(0, 0, 0, 0.04);
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
}

.setting-info {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.setting-name {
    font-weight: 600;
    color: #1d1d1f;
    font-size: 15px;
}

.setting-desc {
    font-size: 12px;
    color: #86868b;
}

/* 暗黑模式适配扩展 (让 Mac 风容器在暗黑模式下也好看) */
:global(html.dark .mac-desktop) {
    background: linear-gradient(135deg, #1c1c1e 0%, #000000 100%);
}

:global(html.dark .mac-window),
:global(html.dark .glass-panel) {
    background: rgba(30, 30, 30, 0.7) !important;
    border-color: rgba(255, 255, 255, 0.1) !important;
}

:global(html.dark .mac-title),
:global(html.dark .setting-name),
:global(html.dark .user-brief h2) {
    color: #f5f5f7 !important;
}

:global(html.dark .setting-item),
:global(html.dark .mac-input .el-input__wrapper) {
    background: rgba(255, 255, 255, 0.05) !important;
    border-color: transparent !important;
}
</style>