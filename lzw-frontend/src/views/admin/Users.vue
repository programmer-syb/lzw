<template>
    <div class="saas-page" v-loading="loading">
        <div class="page-header">
            <div class="header-left">
                <h1 class="page-title">用户管理 (Users)</h1>
                <p class="page-desc">Manage system access, roles, and account status.</p>
            </div>
            <div class="header-right">
                <button class="saas-btn-primary" @click="openAddTeacherDialog">
                    <el-icon><Plus /></el-icon> 注册教师账号
                </button>
            </div>
        </div>

        <div class="toolbar">
            <div class="toolbar-left">
                <el-radio-group v-model="queryParams.role" class="saas-radio-group" @change="fetchUsers">
                    <el-radio-button :label="null">All</el-radio-button>
                    <el-radio-button :label="2">Students</el-radio-button>
                    <el-radio-button :label="1">Teachers</el-radio-button>
                </el-radio-group>
            </div>
            <div class="toolbar-right">
                <el-input v-model="queryParams.keyword" placeholder="Search by name or username..." class="saas-search"
                    clearable @change="fetchUsers">
                    <template #prefix><el-icon>
                            <Search />
                        </el-icon></template>
                </el-input>
            </div>
        </div>

        <div class="saas-table-container">
            <el-table :data="userList" class="saas-table" style="width: 100%">
                <el-table-column prop="id" label="ID" width="80">
                    <template #default="scope"><span class="font-mono text-grey">{{ scope.row.id }}</span></template>
                </el-table-column>

                <el-table-column label="USER" min-width="200">
                    <template #default="scope">
                        <div class="user-cell">
                            <el-avatar :size="32"
                                :src="scope.row.avatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'" />
                            <div class="user-info">
                                <span class="user-name">{{ scope.row.nickname || scope.row.username }}</span>
                                <span class="user-username font-mono">@{{ scope.row.username }}</span>
                            </div>
                        </div>
                    </template>
                </el-table-column>

                <el-table-column prop="role" label="ROLE" width="120">
                    <template #default="scope">
                        <span class="saas-badge" :class="getRoleClass(scope.row.role)">
                            {{ getRoleName(scope.row.role) }}
                        </span>
                    </template>
                </el-table-column>

                <el-table-column label="STATUS" width="120">
                    <template #default="scope">
                        <el-switch v-model="scope.row.status" :active-value="1" :inactive-value="0"
                            style="--el-switch-on-color: #000;" @change="(val) => handleStatusChange(scope.row, val)" />
                    </template>
                </el-table-column>

                <el-table-column prop="createTime" label="CREATED AT" min-width="160">
                    <template #default="scope"><span class="font-mono text-grey">{{ scope.row.createTime
                    }}</span></template>
                </el-table-column>
            </el-table>
        </div>

        <div class="saas-pagination">
            <el-pagination v-model:current-page="queryParams.current" v-model:page-size="queryParams.size"
                layout="prev, pager, next" :total="total" @current-change="fetchUsers" />
        </div>

        <el-dialog v-model="dialogVisible" title="注册新教师" width="400px" class="saas-dialog">
            <el-form label-position="top">
                <el-form-item label="登录账号 (Username)">
                    <el-input v-model="teacherForm.username" placeholder="如：teacher_wang" class="saas-input" />
                </el-form-item>
                <el-form-item label="初始密码 (Password)">
                    <el-input v-model="teacherForm.password" placeholder="设置一个初始密码" type="password" show-password class="saas-input" />
                </el-form-item>
                <el-form-item label="教师姓名 (Display Name)">
                    <el-input v-model="teacherForm.nickname" placeholder="如：王老师" class="saas-input" />
                </el-form-item>
            </el-form>
            <template #footer>
                <button class="saas-btn" @click="dialogVisible = false">取消</button>
                <button class="saas-btn-primary ml-10" @click="handleAddTeacher">确认注册</button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { Search, Plus } from '@element-plus/icons-vue' // 引入了 Plus 图标
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const userList = ref([])
const total = ref(0)
const queryParams = reactive({ current: 1, size: 10, role: null, keyword: '' })

// 新增：控制弹窗和表单数据
const dialogVisible = ref(false)
const teacherForm = ref({ username: '', password: '', nickname: '', role: 1, status: 1 })

onMounted(() => fetchUsers())

const fetchUsers = async () => {
    loading.value = true
    try {
        const res = await request.get('/admin/user/list', { params: queryParams })
        // 前端兜底过滤：强制不展示管理员 (role === 0) 账号
        userList.value = (res.records || []).filter(u => u.role !== 0)
        total.value = res.total
    } catch (error) { } finally { loading.value = false }
}

const handleStatusChange = async (row, status) => {
    try {
        await request.put(`/admin/user/changeStatus/${row.id}/${status}`)
        ElMessage.success(`User ${row.username} status updated`)
    } catch (error) {
        row.status = status === 1 ? 0 : 1 // 恢复原状
    }
}

// 新增：打开弹窗
const openAddTeacherDialog = () => {
    teacherForm.value = { username: '', password: '', nickname: '', role: 1, status: 1 }
    dialogVisible.value = true
}

// 新增：提交注册
const handleAddTeacher = async () => {
    if (!teacherForm.value.username || !teacherForm.value.password) {
        return ElMessage.warning('账号和密码不能为空')
    }
    try {
        await request.post('/admin/user/add', teacherForm.value)
        ElMessage.success('教师账号注册成功！')
        dialogVisible.value = false
        fetchUsers() // 刷新表格
    } catch (error) { }
}

const getRoleName = (role) => ({ 0: 'Admin', 1: 'Teacher', 2: 'Student' }[role] || 'Unknown')
const getRoleClass = (role) => ({ 0: 'badge-black', 1: 'badge-blue', 2: 'badge-grey' }[role] || '')
</script>

<style scoped>
/* 全局 SaaS 页面公共样式将放在最后 */
.user-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}

.user-info {
    display: flex;
    flex-direction: column;
}

.user-name {
    font-weight: 600;
    color: #111;
    font-size: 14px;
}

.user-username {
    color: #888;
    font-size: 12px;
}

/* 补充一点右上角布局样式 */
.header-right {
    display: flex;
    align-items: center;
}
</style>

<style scoped>
/* ================= SaaS 通用样式 ================= */
.saas-page {
    max-width: 1000px;
    padding: 10px;
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-bottom: 32px;
}

.page-title {
    font-size: 24px;
    font-weight: 700;
    color: #111;
    margin: 0 0 8px 0;
    letter-spacing: -0.5px;
}

.page-desc {
    font-size: 14px;
    color: #666;
    margin: 0;
}

.font-mono {
    font-family: 'JetBrains Mono', monospace;
}

.text-grey {
    color: #888;
}

.fw-600 {
    font-weight: 600;
    color: #111;
}

.toolbar {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
}

/* 按钮与输入框 */
.saas-btn {
    background: #fff;
    border: 1px solid #eaeaea;
    color: #111;
    padding: 8px 16px;
    border-radius: 6px;
    font-weight: 500;
    font-size: 13px;
    cursor: pointer;
    transition: 0.2s;
}

.saas-btn:hover {
    background: #fafafa;
    border-color: #ccc;
}

.saas-btn-primary {
    background: #000;
    border: 1px solid #000;
    color: #fff;
    padding: 8px 16px;
    border-radius: 6px;
    font-weight: 500;
    font-size: 13px;
    cursor: pointer;
    transition: 0.2s;
    display: flex;
    align-items: center;
    gap: 6px;
}

.saas-btn-primary:hover {
    background: #333;
    border-color: #333;
}

.ml-10 {
    margin-left: 10px;
}

/* 覆盖 Element Plus 的表格，去除边框，极简风 */
.saas-table-container {
    background: #fff;
    border: 1px solid #eaeaea;
    border-radius: 8px;
    overflow: hidden;
}

:deep(.saas-table .el-table__inner-wrapper::before) {
    display: none;
    /* 移除底部灰线 */
}

:deep(.saas-table th.el-table__cell) {
    background: transparent;
    border-bottom: 1px solid #eaeaea;
    color: #888;
    font-weight: 600;
    font-size: 12px;
    letter-spacing: 0.5px;
    padding: 12px 0;
}

:deep(.saas-table td.el-table__cell) {
    border-bottom: 1px solid #f5f5f5;
    padding: 16px 0;
    font-size: 14px;
}

:deep(.saas-table .el-table__row:last-child td.el-table__cell) {
    border-bottom: none;
}

/* 徽章 Tags */
.saas-badge {
    display: inline-block;
    padding: 4px 8px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: 500;
}

.badge-black {
    background: #f0f0f0;
    color: #111;
    border: 1px solid #e0e0e0;
}

.badge-blue {
    background: #e6f7ff;
    color: #0070f3;
    border: 1px solid #bae0ff;
}

.badge-grey {
    background: #fafafa;
    color: #888;
    border: 1px solid #eaeaea;
}

/* 弹窗重写 */
:deep(.saas-dialog) {
    border-radius: 12px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

:deep(.saas-dialog .el-dialog__header) {
    padding: 24px 24px 10px;
    margin: 0;
}

:deep(.saas-dialog .el-dialog__title) {
    font-weight: 600;
    font-size: 18px;
    color: #111;
}

:deep(.saas-input .el-input__wrapper),
:deep(.saas-textarea .el-textarea__inner) {
    box-shadow: 0 0 0 1px #eaeaea inset;
    border-radius: 6px;
    transition: 0.2s;
}

:deep(.saas-input .el-input__wrapper.is-focus),
:deep(.saas-textarea .el-textarea__inner:focus) {
    box-shadow: 0 0 0 1px #000 inset !important;
}

/* Radio 按钮组重写 */
:deep(.saas-radio-group .el-radio-button__inner) {
    border: 1px solid #eaeaea;
    background: #fff;
    color: #666;
    font-size: 13px;
    box-shadow: none !important;
    transition: 0.2s;
}

:deep(.saas-radio-group .el-radio-button:first-child .el-radio-button__inner) {
    border-radius: 6px 0 0 6px;
}

:deep(.saas-radio-group .el-radio-button:last-child .el-radio-button__inner) {
    border-radius: 0 6px 6px 0;
}

:deep(.saas-radio-group .el-radio-button.is-active .el-radio-button__inner) {
    background: #f5f5f5;
    color: #111;
    font-weight: 600;
    border-color: #ccc;
    z-index: 1;
}

/* 操作文字按钮 */
.action-btn {
    font-size: 13px;
    font-weight: 500;
    color: #666;
}

.action-btn:hover {
    color: #111;
}

.action-btn.danger:hover {
    color: #ff4d4f;
}

.notice-cell {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.notice-title {
    font-size: 14px;
}

.notice-content {
    font-size: 13px;
}
</style>