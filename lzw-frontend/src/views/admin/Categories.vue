<template>
    <div class="saas-page" v-loading="loading">
        <div class="page-header">
            <div class="header-left">
                <h1 class="page-title">分类管理</h1>
                <p class="page-desc">Define areas of study and organize platform content.</p>
            </div>
            <div class="header-right">
                <button class="saas-btn-primary" @click="openDialog()">创建分类</button>
            </div>
        </div>

        <div class="saas-table-container">
            <el-table :data="categoryList" class="saas-table" style="width: 100%">
                <el-table-column prop="id" label="ID" width="100">
                    <template #default="scope"><span class="font-mono text-grey">{{ scope.row.id }}</span></template>
                </el-table-column>

                <el-table-column prop="name" label="CATEGORY NAME" min-width="200">
                    <template #default="scope"><span class="fw-600">{{ scope.row.name }}</span></template>
                </el-table-column>

                <el-table-column prop="sort" label="SORT ORDER" width="150">
                    <template #default="scope"><span class="font-mono">{{ scope.row.sort }}</span></template>
                </el-table-column>

                <el-table-column label="ACTIONS" width="150" align="right">
                    <template #default="scope">
                        <el-button link class="action-btn" @click="openDialog(scope.row)">Edit</el-button>
                        <el-popconfirm title="Are you sure to delete?" @confirm="handleDelete(scope.row.id)">
                            <template #reference>
                                <el-button link class="action-btn danger">Delete</el-button>
                            </template>
                        </el-popconfirm>
                    </template>
                </el-table-column>
            </el-table>
        </div>

        <el-dialog v-model="dialogVisible" :title="form.id ? 'Edit Category' : 'New Category'" width="400px"
            class="saas-dialog">
            <el-form :model="form" label-position="top">
                <el-form-item label="Name">
                    <el-input v-model="form.name" placeholder="e.g. Computer Science" class="saas-input" />
                </el-form-item>
                <el-form-item label="Sort Order">
                    <el-input-number v-model="form.sort" :min="0" class="saas-input-number" />
                </el-form-item>
            </el-form>
            <template #footer>
                <button class="saas-btn" @click="dialogVisible = false">Cancel</button>
                <button class="saas-btn-primary ml-10" @click="handleSubmit">Save Changes</button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const categoryList = ref([])
const dialogVisible = ref(false)
const form = ref({ id: null, name: '', sort: 0 })

onMounted(() => fetchCategories())

const fetchCategories = async () => {
    loading.value = true
    try {
        const res = await request.get('/category/list')
        categoryList.value = res
    } catch (error) { } finally { loading.value = false }
}

const openDialog = (row) => {
    if (row) form.value = { ...row }
    else form.value = { id: null, name: '', sort: 0 }
    dialogVisible.value = true
}

const handleSubmit = async () => {
    if (!form.value.name) return ElMessage.warning('Name is required')
    try {
        if (form.value.id) await request.put('/category/update', form.value)
        else await request.post('/category/add', form.value)
        ElMessage.success('Saved successfully')
        dialogVisible.value = false
        fetchCategories()
    } catch (error) { }
}

const handleDelete = async (id) => {
    try {
        await request.delete(`/category/delete/${id}`)
        ElMessage.success('Deleted successfully')
        fetchCategories()
    } catch (error) { }
}
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