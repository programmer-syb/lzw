<template>
    <div class="profile-page" v-loading="loading">
        <div class="page-header">
            <h1 class="mac-title">个人中心</h1>
            <p class="mac-subtitle">管理您的智学账户信息</p>
        </div>

        <div class="profile-card glass-panel mac-squircle">
            <div class="avatar-section">
                <el-avatar :size="80"
                    :src="userInfoForm.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'"
                    class="mac-avatar" />
                <div class="user-brief">
                    <h2>{{ userInfoForm.nickname || userInfoForm.username }}</h2>
                    <p class="role-text">学生账户</p>
                </div>
            </div>

            <el-divider border-style="dashed" />

            <el-form :model="userInfoForm" label-position="top" class="mac-form">
                <div class="form-grid">
                    <el-form-item label="学号/账号 (不可修改)">
                        <el-input v-model="userInfoForm.username" disabled class="mac-input disabled-input" />
                    </el-form-item>
                    <el-form-item label="姓名/昵称">
                        <el-input v-model="userInfoForm.nickname" placeholder="请输入昵称" class="mac-input" />
                    </el-form-item>
                    <el-form-item label="手机号">
                        <el-input v-model="userInfoForm.phone" placeholder="请输入手机号" class="mac-input" />
                    </el-form-item>
                    <el-form-item label="邮箱">
                        <el-input v-model="userInfoForm.email" placeholder="请输入邮箱" class="mac-input" />
                    </el-form-item>
                    <el-form-item label="所属专业">
                        <el-input v-model="userInfoForm.major" placeholder="如：计算机科学与技术" class="mac-input" />
                    </el-form-item>
                </div>

                <div class="form-actions">
                    <el-button class="mac-btn-plain" @click="showPwdDialog = true">修改密码</el-button>
                    <el-button type="primary" class="apple-btn-primary round" @click="handleUpdateInfo">保存更改</el-button>
                </div>
            </el-form>
        </div>

        <el-dialog v-model="showPwdDialog" title="修改密码" width="400px" class="mac-dialog" destroy-on-close>
            <el-form :model="pwdForm" label-position="top">
                <el-form-item label="当前密码">
                    <el-input v-model="pwdForm.oldPassword" type="password" show-password placeholder="请输入原密码"
                        class="mac-input" />
                </el-form-item>
                <el-form-item label="新密码">
                    <el-input v-model="pwdForm.newPassword" type="password" show-password placeholder="请输入新密码"
                        class="mac-input" />
                </el-form-item>
                <el-form-item label="确认新密码">
                    <el-input v-model="pwdForm.confirmPassword" type="password" show-password placeholder="请再次输入新密码"
                        class="mac-input" />
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="showPwdDialog = false" class="mac-btn-plain">取消</el-button>
                <el-button type="primary" @click="handleUpdatePwd" class="mac-btn-solid danger-bg">确认修改</el-button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const router = useRouter()
const loading = ref(false)
const userInfoForm = ref({})

const showPwdDialog = ref(false)
const pwdForm = reactive({ oldPassword: '', newPassword: '', confirmPassword: '' })

onMounted(() => {
    fetchUserInfo()
})

const fetchUserInfo = async () => {
    loading.value = true
    try {
        const res = await request.get('/user/info')
        userInfoForm.value = res
    } catch (error) {
    } finally {
        loading.value = false
    }
}

const handleUpdateInfo = async () => {
    try {
        await request.put('/user/update', userInfoForm.value)
        ElMessage.success('个人信息保存成功')

        // 同步更新本地存储的简单用户信息，防止顶部导航栏昵称不同步
        const localUser = JSON.parse(localStorage.getItem('userInfo') || '{}')
        localUser.nickname = userInfoForm.value.nickname
        localStorage.setItem('userInfo', JSON.stringify(localUser))
        // 强制刷新一下页面或通过状态管理更新 header（这里选择最简单的重载）
        window.location.reload()
    } catch (error) { }
}

const handleUpdatePwd = async () => {
    if (!pwdForm.oldPassword || !pwdForm.newPassword) {
        return ElMessage.warning('密码不能为空')
    }
    if (pwdForm.newPassword !== pwdForm.confirmPassword) {
        return ElMessage.warning('两次输入的新密码不一致')
    }

    try {
        await request.put('/user/updatePassword', {
            oldPassword: pwdForm.oldPassword,
            newPassword: pwdForm.newPassword
        })
        ElMessage.success('密码修改成功，请重新登录')
        showPwdDialog.value = false

        // 密码修改后强制退出
        localStorage.removeItem('token')
        localStorage.removeItem('userInfo')
        router.push('/login')
    } catch (error) { }
}
</script>

<style scoped>
.profile-page {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}

.page-header {
    margin-bottom: 30px;
    text-align: center;
}

.mac-title {
    font-size: 2.2rem;
    font-weight: 800;
    color: #1d1d1f;
    margin: 0;
}

.mac-subtitle {
    color: #86868b;
    margin-top: 5px;
}

.profile-card {
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(20px);
    padding: 40px;
    border: 1px solid rgba(255, 255, 255, 0.6);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
}

.avatar-section {
    display: flex;
    align-items: center;
    gap: 20px;
    margin-bottom: 20px;
}

.mac-avatar {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    border: 2px solid #fff;
}

.user-brief h2 {
    margin: 0 0 5px 0;
    font-size: 1.5rem;
    color: #1d1d1f;
}

.role-text {
    margin: 0;
    color: #86868b;
    font-size: 13px;
    font-weight: 600;
}

.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0 20px;
}

.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 15px;
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid rgba(0, 0, 0, 0.05);
}

:deep(.mac-input .el-input__wrapper) {
    background: rgba(0, 0, 0, 0.03);
    border-radius: 10px;
    box-shadow: none !important;
    border: 1px solid transparent;
    transition: all 0.3s;
}

:deep(.mac-input .el-input__wrapper.is-focus) {
    background: #fff;
    border-color: #007aff;
    box-shadow: 0 0 0 3px rgba(0, 122, 255, 0.1) !important;
}

:deep(.disabled-input .el-input__wrapper) {
    background: rgba(0, 0, 0, 0.06);
    cursor: not-allowed;
}

.apple-btn-primary {
    background: #007aff !important;
    border: none !important;
    padding: 10px 25px !important;
    font-weight: 600;
}

.mac-btn-plain {
    border: none;
    background: rgba(0, 0, 0, 0.05);
    border-radius: 20px;
    font-weight: 600;
    color: #515154;
    padding: 10px 20px;
    transition: 0.2s;
}

.mac-btn-plain:hover {
    background: rgba(0, 0, 0, 0.1);
}

.danger-bg {
    background: #ff3b30 !important;
    color: #fff;
    border: none;
}

.danger-bg:hover {
    background: #d73329 !important;
}
</style>