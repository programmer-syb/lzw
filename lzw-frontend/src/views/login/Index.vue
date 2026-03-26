<template>
    <div class="auth-container" @mousemove="handleMouseMove">
        <div class="custom-cursor" :style="{ transform: `translate(${cursorX}px, ${cursorY}px)` }"></div>

        <div class="ambient-orb orb-1"></div>
        <div class="ambient-orb orb-2"></div>
        <div class="ambient-orb orb-3"></div>

        <div class="flip-scene">
            <div class="flip-card" :class="{ 'is-flipped': !isLogin }">

                <div class="card-face card-front glass-panel">
                    <h2 class="title">Welcome Back</h2>
                    <p class="subtitle">登录您的智学账户</p>

                    <el-form :model="loginForm" ref="loginRef" class="glass-form">
                        <el-form-item>
                            <el-input v-model="loginForm.username" placeholder="学号 / 工号 / 管理员账号" :prefix-icon="User" />
                        </el-form-item>
                        <el-form-item>
                            <el-input v-model="loginForm.password" type="password" placeholder="密码" show-password
                                :prefix-icon="Lock" @keyup.enter="handleLogin" />
                        </el-form-item>
                        <el-button class="glass-btn primary-btn" :loading="loading" @click="handleLogin">
                            登 录
                        </el-button>
                    </el-form>

                    <div class="toggle-text">
                        还没有账号？
                        <span class="toggle-link hover-spring" @click="isLogin = false">立即注册 &rarr;</span>
                    </div>
                </div>

                <div class="card-face card-back glass-panel">
                    <h2 class="title">Join Us</h2>
                    <p class="subtitle">开启你的学习之旅</p>

                    <el-form :model="registerForm" ref="registerRef" class="glass-form">
                        <el-form-item>
                            <el-input v-model="registerForm.username" placeholder="设置账号 (学号)" :prefix-icon="User" />
                        </el-form-item>
                        <el-form-item>
                            <el-input v-model="registerForm.password" type="password" placeholder="设置密码" show-password
                                :prefix-icon="Lock" />
                        </el-form-item>
                        <el-form-item>
                            <el-input v-model="registerForm.nickname" placeholder="您的姓名/昵称" :prefix-icon="Edit" />
                        </el-form-item>
                        <el-button class="glass-btn primary-btn" :loading="loading" @click="handleRegister">
                            注 册 (学生身份)
                        </el-button>
                    </el-form>

                    <div class="toggle-text">
                        已有账号？
                        <span class="toggle-link hover-spring" @click="isLogin = true">&larr; 返回登录</span>
                    </div>
                </div>

            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, Edit } from '@element-plus/icons-vue'
import request from '../../utils/request' // 引入我们封装的 axios

const router = useRouter()

// --- 状态控制 ---
const isLogin = ref(true) // true为登录面，false为注册面
const loading = ref(false)

// --- 表单数据 ---
const loginForm = reactive({
    username: '',
    password: ''
})

const registerForm = reactive({
    username: '',
    password: '',
    nickname: '',
    phone: '',
    email: ''
})

// --- 物理阻尼鼠标跟随逻辑 (Lerp 线性插值) ---
const targetX = ref(0)
const targetY = ref(0)
const cursorX = ref(-100) // 初始藏在屏幕外
const cursorY = ref(-100)
let animationFrameId = null

const handleMouseMove = (e) => {
    targetX.value = e.clientX
    targetY.value = e.clientY
}

const renderCursor = () => {
    // 核心公式：当前位置 += (目标位置 - 当前位置) * 阻尼系数
    // 0.15 这个值越小，拖尾感/弹簧感越重；越大越跟手
    cursorX.value += (targetX.value - cursorX.value) * 0.15
    cursorY.value += (targetY.value - cursorY.value) * 0.15
    animationFrameId = requestAnimationFrame(renderCursor)
}

onMounted(() => {
    renderCursor()
})

onUnmounted(() => {
    cancelAnimationFrame(animationFrameId)
})

// --- 业务逻辑：登录 ---
const handleLogin = async () => {
    if (!loginForm.username || !loginForm.password) {
        return ElMessage.warning('请输入账号和密码')
    }

    loading.value = true
    try {
        // 请求后端 /user/login 接口
        const res = await request.post('/user/login', loginForm)

        // 登录成功，存储 Token 和 用户信息
        localStorage.setItem('token', res.token)
        localStorage.setItem('userInfo', JSON.stringify({
            userId: res.userId,
            username: res.username,
            role: res.role,
            nickname: res.nickname
        }))

        ElMessage.success(`欢迎回来，${res.nickname || res.username}`)

        // 弹簧动画有点帅，我们给 0.5 秒延迟再跳转，让用户看清成功的瞬间
        setTimeout(() => {
            // 角色路由分发: 0-管理, 1-教师, 2-学生
            if (res.role === 0) router.push('/admin')
            else if (res.role === 1) router.push('/teacher')
            else router.push('/student')
        }, 500)

    } catch (error) {
        // 错误已经在 request 拦截器里处理弹窗了
        console.error(error)
    } finally {
        loading.value = false
    }
}

// --- 业务逻辑：注册 ---
const handleRegister = async () => {
    if (!registerForm.username || !registerForm.password) {
        return ElMessage.warning('账号和密码不能为空')
    }

    loading.value = true
    try {
        await request.post('/user/register', registerForm)
        ElMessage.success('注册成功！快去登录吧')
        // 触发 3D 翻转回登录页
        isLogin.value = true
        // 把注册的账号自动填入登录框
        loginForm.username = registerForm.username
        loginForm.password = registerForm.password
    } catch (error) {
        console.error(error)
    } finally {
        loading.value = false
    }
}
</script>

<style scoped>
/* ================= 全局容器与暗黑背景 ================= */
.auth-container {
    position: relative;
    width: 100vw;
    height: 100vh;
    background-color: #0f172a;
    /* 极光深色底 */
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: 'Helvetica Neue', sans-serif;
    cursor: none;
    /* 隐藏原生鼠标，使用自定义跟随器 */
}

/* ================= 自定义阻尼鼠标跟随器 ================= */
.custom-cursor {
    position: absolute;
    top: 0;
    left: 0;
    width: 32px;
    height: 32px;
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.5);
    border-radius: 50%;
    pointer-events: none;
    /* 鼠标事件穿透，不挡点击 */
    z-index: 9999;
    transform: translate(-50%, -50%);
    backdrop-filter: invert(20%);
    /* 增加一点反色高级感 */
    box-shadow: 0 0 20px rgba(99, 102, 241, 0.5);
}

/* ================= 环境光球 (动态流体背景) ================= */
.ambient-orb {
    position: absolute;
    border-radius: 50%;
    filter: blur(80px);
    opacity: 0.6;
    animation: float 20s infinite alternate;
}

.orb-1 {
    width: 400px;
    height: 400px;
    background: #4f46e5;
    /* 靛蓝色 */
    top: -100px;
    left: -100px;
}

.orb-2 {
    width: 500px;
    height: 500px;
    background: #c026d3;
    /* 紫红色 */
    bottom: -150px;
    right: -100px;
    animation-delay: -5s;
}

.orb-3 {
    width: 300px;
    height: 300px;
    background: #06b6d4;
    /* 青蓝色 */
    top: 40%;
    left: 30%;
    animation-delay: -10s;
}

@keyframes float {
    0% {
        transform: translate(0, 0) scale(1);
    }

    50% {
        transform: translate(100px, 50px) scale(1.2);
    }

    100% {
        transform: translate(-50px, 100px) scale(0.9);
    }
}

/* ================= 3D 翻转弹簧卡片引擎 ================= */
.flip-scene {
    width: 420px;
    height: 550px;
    perspective: 1500px;
    /* 3D 透视深度 */
    z-index: 10;
}

.flip-card {
    width: 100%;
    height: 100%;
    position: relative;
    transition: transform 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    /* 核心！物理弹簧曲线 */
    transform-style: preserve-3d;
}

.flip-card.is-flipped {
    transform: rotateY(180deg);
}

.card-face {
    position: absolute;
    width: 100%;
    height: 100%;
    backface-visibility: hidden;
    /* 隐藏背面 */
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 40px;
    box-sizing: border-box;
}

.card-front {
    transform: rotateY(0deg);
}

.card-back {
    transform: rotateY(180deg);
}

/* ================= 玻璃拟态 UI 设计 ================= */
.glass-panel {
    background: rgba(255, 255, 255, 0.03);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-top: 1px solid rgba(255, 255, 255, 0.2);
    border-left: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 24px;
    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
}

/* 排版美化 */
.title {
    color: #fff;
    font-size: 2.2rem;
    font-weight: 700;
    margin: 0 0 10px 0;
    letter-spacing: 1px;
}

.subtitle {
    color: rgba(255, 255, 255, 0.6);
    font-size: 0.95rem;
    margin-bottom: 40px;
}

/* 覆盖 Element Plus 的输入框，使其变成玻璃质感 */
:deep(.el-input__wrapper) {
    background-color: rgba(255, 255, 255, 0.05) !important;
    box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.1) inset !important;
    border-radius: 12px;
    transition: all 0.3s ease;
}

:deep(.el-input__wrapper.is-focus) {
    background-color: rgba(255, 255, 255, 0.1) !important;
    box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.3) inset, 0 0 15px rgba(255, 255, 255, 0.1) !important;
}

:deep(.el-input__inner) {
    color: #fff !important;
    height: 45px;
}

:deep(.el-input__inner::placeholder) {
    color: rgba(255, 255, 255, 0.3);
}

/* 玻璃按钮 */
.glass-btn {
    width: 100%;
    height: 48px;
    border-radius: 12px;
    font-size: 1.1rem;
    font-weight: 600;
    letter-spacing: 2px;
    margin-top: 10px;
    border: none;
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0));
    backdrop-filter: blur(10px);
    color: #fff;
    border: 1px solid rgba(255, 255, 255, 0.18);
    box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    /* 按钮也加弹簧物理 */
    cursor: none;
    /* 配合全局自定义鼠标 */
}

.glass-btn:hover {
    transform: translateY(-3px) scale(1.02);
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0.05));
    box-shadow: 0 12px 40px 0 rgba(0, 0, 0, 0.3);
}

.glass-btn:active {
    transform: translateY(1px) scale(0.98);
}

/* 底部切换文本 */
.toggle-text {
    text-align: center;
    margin-top: 25px;
    color: rgba(255, 255, 255, 0.5);
    font-size: 0.9rem;
}

.toggle-link {
    color: #fff;
    font-weight: 600;
    cursor: none;
    /* 配合全局自定义鼠标 */
    display: inline-block;
    transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275), color 0.3s;
}

.toggle-link:hover {
    color: #a5b4fc;
    transform: translateX(5px);
}
</style>