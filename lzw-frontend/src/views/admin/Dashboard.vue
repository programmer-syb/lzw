<template>
    <div class="saas-dashboard" v-loading="loading">
        <div class="dashboard-header">
            <h1 class="page-title">Workspace Overview</h1>
            <p class="page-desc">Real-time statistics for the Lzw education platform.</p>
        </div>

        <div class="metrics-grid">
            <div class="metric-card">
                <div class="metric-header">
                    <span class="metric-title">Total Students</span>
                    <el-icon class="metric-icon">
                        <User />
                    </el-icon>
                </div>
                <div class="metric-value font-mono">{{ dashboardData.users?.totalStudents || 0 }}</div>
                <div class="metric-trend positive">
                    <span class="trend-icon">↑</span> 12% from last month
                </div>
            </div>

            <div class="metric-card">
                <div class="metric-header">
                    <span class="metric-title">Active Teachers</span>
                    <el-icon class="metric-icon">
                        <Briefcase />
                    </el-icon>
                </div>
                <div class="metric-value font-mono">{{ dashboardData.users?.totalTeachers || 0 }}</div>
                <div class="metric-trend neutral">
                    <span class="trend-icon">-</span> No change
                </div>
            </div>

            <div class="metric-card highlight-card">
                <div class="metric-header">
                    <span class="metric-title">Published Courses</span>
                    <el-icon class="metric-icon">
                        <Reading />
                    </el-icon>
                </div>
                <div class="metric-value font-mono">{{ dashboardData.courses?.published || 0 }} <span
                        class="sub-value">/ {{ dashboardData.courses?.total || 0 }}</span></div>
                <div class="metric-trend light">
                    Total published across all categories
                </div>
            </div>

            <div class="metric-card">
                <div class="metric-header">
                    <span class="metric-title">Course Enrollments</span>
                    <el-icon class="metric-icon">
                        <DataLine />
                    </el-icon>
                </div>
                <div class="metric-value font-mono">{{ dashboardData.totalEnrollments || 0 }}</div>
                <div class="metric-trend positive">
                    <span class="trend-icon">↑</span> Highly active
                </div>
            </div>
        </div>

        <div class="charts-section">
            <div class="chart-container">
                <div class="chart-header">
                    <h3>Platform Activity (Last 7 Days)</h3>
                    <el-button size="small" class="saas-btn">Export Report</el-button>
                </div>
                <div ref="activityChartRef" class="echarts-box"></div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, nextTick } from 'vue'
import { User, Briefcase, Reading, DataLine } from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import request from '../../utils/request'

const loading = ref(false)
const dashboardData = ref({})
const activityChartRef = ref(null)
let activityChart = null

onMounted(async () => {
    await fetchData()
    initChart()
    window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
    window.removeEventListener('resize', handleResize)
    if (activityChart) activityChart.dispose()
})

const handleResize = () => {
    if (activityChart) activityChart.resize()
}

const fetchData = async () => {
    loading.value = true
    try {
        const res = await request.get('/admin/statistics/dashboard')
        dashboardData.value = res
    } catch (e) {
        console.error(e)
    } finally {
        loading.value = false
    }
}

// 初始化 ECharts (极简冷峻风格)
const initChart = async () => {
    await nextTick()
    if (!activityChartRef.value) return

    activityChart = echarts.init(activityChartRef.value)
    const option = {
        backgroundColor: 'transparent',
        tooltip: { trigger: 'axis', axisPointer: { type: 'line', lineStyle: { color: '#eaeaea' } } },
        grid: { left: '2%', right: '4%', bottom: '3%', top: '10%', containLabel: true },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            axisLine: { lineStyle: { color: '#eaeaea' } },
            axisLabel: { color: '#888', fontFamily: 'Inter' }
        },
        yAxis: {
            type: 'value',
            splitLine: { lineStyle: { color: '#f5f5f5', type: 'dashed' } },
            axisLabel: { color: '#888', fontFamily: 'JetBrains Mono' }
        },
        series: [
            {
                name: 'Active Users',
                type: 'line',
                smooth: true,
                showSymbol: false,
                lineStyle: { width: 3, color: '#000' }, // 极客纯黑线条
                areaStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        { offset: 0, color: 'rgba(0,0,0,0.1)' },
                        { offset: 1, color: 'rgba(0,0,0,0)' }
                    ])
                },
                // 模拟一点波动数据
                data: [120, 132, 101, 134, 90, 230, 210]
            }
        ]
    }
    activityChart.setOption(option)
}
</script>

<style scoped>
.saas-dashboard {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
}

.dashboard-header {
    margin-bottom: 32px;
}

.page-title {
    font-size: 24px;
    font-weight: 700;
    color: #000;
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

/* Bento Box 网格 */
.metrics-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 24px;
    margin-bottom: 32px;
}

/* 数据卡片基础样式 */
.metric-card {
    background: #fff;
    border: 1px solid #eaeaea;
    border-radius: 12px;
    padding: 24px;
    display: flex;
    flex-direction: column;
    transition: box-shadow 0.2s, transform 0.2s;
}

.metric-card:hover {
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.04);
    transform: translateY(-2px);
}

.metric-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
}

.metric-title {
    font-size: 13px;
    font-weight: 500;
    color: #666;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.metric-icon {
    color: #888;
    font-size: 18px;
}

.metric-value {
    font-size: 36px;
    font-weight: 700;
    color: #000;
    margin-bottom: 12px;
    line-height: 1;
}

.sub-value {
    font-size: 18px;
    color: #999;
}

.metric-trend {
    font-size: 13px;
    display: flex;
    align-items: center;
    gap: 4px;
    font-weight: 500;
}

.trend-icon {
    font-weight: bold;
}

.positive {
    color: #0070f3;
}

/* Vercel 蓝 */
.neutral {
    color: #888;
}

.light {
    color: rgba(255, 255, 255, 0.8);
}

/* 高亮卡片 (反色设计) */
.highlight-card {
    background: #000;
    border-color: #000;
}

.highlight-card .metric-title {
    color: #888;
}

.highlight-card .metric-icon {
    color: #fff;
}

.highlight-card .metric-value {
    color: #fff;
}

/* 图表区域 */
.charts-section {
    background: #fff;
    border: 1px solid #eaeaea;
    border-radius: 12px;
    padding: 24px;
}

.chart-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

.chart-header h3 {
    margin: 0;
    font-size: 16px;
    font-weight: 600;
    color: #000;
}

.echarts-box {
    width: 100%;
    height: 350px;
}

/* 按钮样式重写 */
.saas-btn {
    background: #fff;
    border: 1px solid #eaeaea;
    color: #000;
    border-radius: 6px;
    font-weight: 500;
    transition: all 0.2s;
}

.saas-btn:hover {
    border-color: #000;
    color: #000;
    background: #fafafa;
}
</style>