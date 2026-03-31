<template>
    <div class="saas-page" v-loading="loading">
        <div class="page-header">
            <div class="header-left">
                <h1 class="page-title">运行日志</h1>
                <p class="page-desc">Monitor API latency, user access traces, and system exceptions.</p>
            </div>
        </div>

        <div class="saas-table-container">
            <el-table :data="logList" class="saas-table" style="width: 100%; font-family: 'JetBrains Mono', monospace;">
                <el-table-column prop="id" label="LOG ID" width="100">
                    <template #default="scope"><span class="text-grey">#{{ scope.row.id }}</span></template>
                </el-table-column>

                <el-table-column label="REQUEST" min-width="250">
                    <template #default="scope">
                        <div class="log-cell">
                            <span class="method-badge"
                                :class="scope.row.method?.includes('GET') ? 'get' : 'post'">HTTP</span>
                            <span class="uri-text">{{ scope.row.uri || scope.row.method }}</span>
                        </div>
                    </template>
                </el-table-column>

                <el-table-column label="LATENCY" width="120">
                    <template #default="scope">
                        <span class="latency-badge" :class="getLatencyClass(scope.row.duration)">
                            {{ scope.row.duration }}ms
                        </span>
                    </template>
                </el-table-column>

                <el-table-column prop="ip" label="CLIENT IP" width="150">
                    <template #default="scope"><span class="text-grey">{{ scope.row.ip || '127.0.0.1'
                            }}</span></template>
                </el-table-column>

                <el-table-column prop="createTime" label="TIMESTAMP" width="180">
                    <template #default="scope"><span class="text-grey">{{ scope.row.createTime }}</span></template>
                </el-table-column>
            </el-table>
        </div>

        <div class="saas-pagination">
            <el-pagination v-model:current-page="queryParams.current" v-model:page-size="queryParams.size"
                layout="total, prev, pager, next" :total="total" @current-change="fetchLogs" />
        </div>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import request from '../../utils/request'

const loading = ref(false)
const logList = ref([])
const total = ref(0) // 记录总条数

// 新增：分页查询参数
const queryParams = reactive({
    current: 1,
    size: 10
})

onMounted(() => {
    fetchLogs()
})

const fetchLogs = async () => {
    loading.value = true
    try {
        // 传入分页参数
        const res = await request.get('/admin/log/list', { params: queryParams })
        logList.value = res.records || []
        total.value = res.total || 0
    } catch (error) {
    } finally {
        loading.value = false
    }
}

const getLatencyClass = (ms) => {
    if (ms > 1000) return 'danger-ms'
    if (ms > 500) return 'warn-ms'
    return 'good-ms'
}
</script>

<style scoped>
.log-cell {
    display: flex;
    align-items: center;
    gap: 8px;
}

.method-badge {
    font-size: 10px;
    font-weight: 700;
    padding: 2px 6px;
    border-radius: 4px;
}

.method-badge.get {
    background: #e6f7ff;
    color: #0070f3;
}

.method-badge.post {
    background: #eaffea;
    color: #27c93f;
}

.uri-text {
    font-size: 13px;
    color: #111;
}

.latency-badge {
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
}

.good-ms {
    color: #888;
}

.warn-ms {
    background: #fffbe6;
    color: #faad14;
}

.danger-ms {
    background: #ffebea;
    color: #ff3b30;
}

/* 底部留白给分页 */
.saas-pagination {
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;
}
</style>