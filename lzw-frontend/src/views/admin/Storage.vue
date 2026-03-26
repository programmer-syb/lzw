<template>
    <div class="saas-page" v-loading="loading">
        <div class="page-header">
            <div class="header-left">
                <h1 class="page-title">Storage & Media</h1>
                <p class="page-desc">Unified management for videos, PDFs, and uploaded assets.</p>
            </div>
            <div class="header-right">
                <span class="font-mono text-grey" style="font-size: 12px; margin-right: 10px;">Storage Used: 14.2 GB /
                    50 GB</span>
            </div>
        </div>

        <div class="saas-table-container">
            <el-table :data="resourceList" class="saas-table" style="width: 100%">
                <el-table-column label="FILE INFO" min-width="250">
                    <template #default="scope">
                        <div class="file-cell">
                            <el-icon class="file-icon" :class="scope.row.type">
                                <VideoCamera v-if="scope.row.type === 'video'" />
                                <Document v-else />
                            </el-icon>
                            <div class="file-meta">
                                <span class="fw-600">{{ scope.row.name }}</span>
                                <span class="font-mono text-xs text-grey">URL: {{ truncate(scope.row.url, 30) }}</span>
                            </div>
                        </div>
                    </template>
                </el-table-column>

                <el-table-column prop="type" label="FORMAT" width="100">
                    <template #default="scope">
                        <span class="saas-badge badge-black" style="text-transform: uppercase;">{{ scope.row.type
                        }}</span>
                    </template>
                </el-table-column>

                <el-table-column prop="createTime" label="UPLOADED AT" width="180">
                    <template #default="scope"><span class="font-mono text-grey">{{ scope.row.createTime
                    }}</span></template>
                </el-table-column>

                <el-table-column label="ACTIONS" width="150" align="right">
                    <template #default="scope">
                        <el-button link class="action-btn" @click="openFile(scope.row.url)">Open</el-button>
                        <el-popconfirm title="Permanently delete file?" @confirm="deleteResource(scope.row.id)">
                            <template #reference><el-button link class="action-btn danger">Delete</el-button></template>
                        </el-popconfirm>
                    </template>
                </el-table-column>
            </el-table>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { VideoCamera, Document } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'

const loading = ref(false)
const resourceList = ref([])

onMounted(() => fetchResources())

const fetchResources = async () => {
    loading.value = true
    try {
        // 调用真实的资源大盘接口
        const res = await request.get('/resource/admin/list', { params: { size: 100 } })
        resourceList.value = res.records || []
    } catch (error) { } finally { loading.value = false }
}

const deleteResource = async (id) => {
    try {
        // 真实调用删除接口
        await request.delete(`/resource/delete/${id}`)
        ElMessage.success('File permanently deleted from bucket')
        fetchResources() // 刷新列表
    } catch (error) { }
}

const openFile = (url) => window.open(url, '_blank')
const truncate = (text, len) => text?.length > len ? text.substring(0, len) + '...' : text
</script>

<style scoped>
.file-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}

.file-icon {
    font-size: 24px;
    padding: 8px;
    border-radius: 8px;
    background: #f5f5f5;
    color: #111;
}

.file-icon.video {
    background: #e6f7ff;
    color: #0070f3;
}

.file-icon.pdf {
    background: #ffebea;
    color: #ff3b30;
}

.file-meta {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.text-xs {
    font-size: 11px;
}
</style>