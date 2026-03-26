<template>
    <div class="notion-page" v-loading="loading">
        <header class="page-header">
            <h1 class="serif-title">个人资料</h1>
            <p class="page-desc">管理您的教师名片与账户安全。</p>
        </header>

        <div class="profile-content">
            <section class="notion-section">
                <h3 class="section-title">名片信息</h3>
                <div class="profile-card">
                    <div class="avatar-wrapper">
                        <el-avatar :size="80"
                            :src="userInfoForm.avatar || 'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix'" />
                        <el-button size="small" plain class="mt-10">更换头像</el-button>
                    </div>
                    <div class="info-form">
                        <div class="form-row">
                            <label>教工号</label>
                            <input v-model="userInfoForm.username" disabled class="notion-input disabled" />
                        </div>
                        <div class="form-row">
                            <label>姓名</label>
                            <input v-model="userInfoForm.nickname" class="notion-input" />
                        </div>
                        <div class="form-row">
                            <label>所属院系/专业</label>
                            <input v-model="userInfoForm.major" class="notion-input" />
                        </div>
                        <div class="form-row">
                            <label>联系邮箱</label>
                            <input v-model="userInfoForm.email" class="notion-input" />
                        </div>
                        <div class="form-actions">
                            <button class="notion-btn-primary" @click="handleUpdateInfo">保存更改</button>
                        </div>
                    </div>
                </div>
            </section>

            <el-divider border-style="dashed" />

            <section class="notion-section">
                <h3 class="section-title">账户安全</h3>
                <div class="security-card">
                    <div class="security-info">
                        <h4>登录密码</h4>
                        <p>建议定期更改密码以保障账户安全。</p>
                    </div>
                    <button class="notion-btn-secondary" @click="showPwdDialog = true">修改密码</button>
                </div>
            </section>
        </div>

        <el-dialog v-model="showPwdDialog" title="修改密码" width="400px" class="notion-dialog" destroy-on-close>
            <el-form label-position="top">
                <el-form-item label="当前密码">
                    <el-input v-model="pwdForm.oldPassword" type="password" show-password />
                </el-form-item>
                <el-form-item label="新密码">
                    <el-input v-model="pwdForm.newPassword" type="password" show-password />
                </el-form-item>
            </el-form>
            <template #footer>
                <el-button @click="showPwdDialog = false" plain size="small">取消</el-button>
                <el-button type="primary" @click="handleUpdatePwd" class="notion-btn-primary"
                    size="small">确认修改</el-button>
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
const pwdForm = reactive({ oldPassword: '', newPassword: '' })

onMounted(async () => {
    loading.value = true
    try {
        userInfoForm.value = await request.get('/user/info')
    } catch (e) { } finally { loading.value = false }
})

const handleUpdateInfo = async () => {
    try {
        await request.put('/user/update', userInfoForm.value)
        ElMessage.success('资料已更新')
        const localUser = JSON.parse(localStorage.getItem('userInfo') || '{}')
        localUser.nickname = userInfoForm.value.nickname
        localStorage.setItem('userInfo', JSON.stringify(localUser))
    } catch (e) { }
}

const handleUpdatePwd = async () => {
    if (!pwdForm.oldPassword || !pwdForm.newPassword) return ElMessage.warning('密码不能为空')
    try {
        await request.put('/user/updatePassword', pwdForm)
        ElMessage.success('密码修改成功，请重新登录')
        localStorage.clear()
        router.push('/login')
    } catch (e) { }
}
</script>

<style scoped>
.notion-page {
    max-width: 800px;
    margin: 0 auto;
    padding: 40px 20px;
}

.serif-title {
    font-family: 'Noto Serif SC', serif;
    font-size: 2.2rem;
    color: rgb(55, 53, 47);
    margin: 0 0 10px 0;
}

.page-desc {
    color: rgba(55, 53, 47, 0.6);
    margin-bottom: 40px;
    font-size: 15px;
}

.section-title {
    font-size: 1.2rem;
    font-weight: 600;
    color: rgb(55, 53, 47);
    margin-bottom: 20px;
}

.profile-card {
    display: flex;
    gap: 40px;
}

.avatar-wrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 120px;
}

.mt-10 {
    margin-top: 15px;
}

.info-form {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.form-row {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.form-row label {
    font-size: 13px;
    color: rgba(55, 53, 47, 0.6);
    font-weight: 500;
}

.notion-input {
    padding: 10px 12px;
    border: 1px solid rgba(55, 53, 47, 0.16);
    border-radius: 4px;
    font-family: 'Inter', sans-serif;
    font-size: 14px;
    outline: none;
    transition: 0.2s;
}

.notion-input:focus {
    border-color: #2383e2;
    box-shadow: 0 0 0 2px rgba(35, 131, 226, 0.2);
}

.notion-input.disabled {
    background: #f7f7f5;
    color: rgba(55, 53, 47, 0.5);
    cursor: not-allowed;
}

.form-actions {
    margin-top: 10px;
    display: flex;
    justify-content: flex-end;
}

.notion-btn-primary {
    background: #2383e2;
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 4px;
    font-weight: 500;
    cursor: pointer;
}

.notion-btn-primary:hover {
    background: #1a6ab5;
}

.security-card {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    border: 1px solid rgba(55, 53, 47, 0.09);
    border-radius: 6px;
    background: #fafafa;
}

.security-info h4 {
    margin: 0 0 6px 0;
    color: rgb(55, 53, 47);
}

.security-info p {
    margin: 0;
    font-size: 13px;
    color: rgba(55, 53, 47, 0.6);
}

.notion-btn-secondary {
    background: white;
    border: 1px solid rgba(55, 53, 47, 0.16);
    padding: 6px 14px;
    border-radius: 4px;
    cursor: pointer;
}
</style>