import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '../router'

// 1. 创建 axios 实例
const request = axios.create({
  // 假设你的 Spring Boot 后端跑在 8080 端口
  baseURL: 'http://localhost:8080', 
  timeout: 10000 // 请求超时时间 10s
})

// 2. 请求拦截器：自动携带 Token
request.interceptors.request.use(
  config => {
    // 从 localStorage 中获取 token (我们在登录成功时会存进去)
    const token = localStorage.getItem('token')
    if (token) {
      // 按照后端的 JwtInterceptor 要求，加上 Bearer 前缀
      config.headers['Authorization'] = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 3. 响应拦截器：统一处理错误和 401
request.interceptors.response.use(
  response => {
    // 我们后端的 Result 类结构是 { code, msg, data }
    const res = response.data
    
    // 如果 code 是 200，说明业务成功，直接返回数据部分
    if (res.code === 200) {
      return res.data
    } else {
      // 业务报错，弹出后端返回的错误信息
      ElMessage.error(res.msg || '系统异常')
      return Promise.reject(new Error(res.msg || 'Error'))
    }
  },
  error => {
    // 捕获 HTTP 状态码异常 (如后端的 401 拦截)
    if (error.response && error.response.status === 401) {
      ElMessage.warning('登录已过期或未登录，请重新登录')
      localStorage.removeItem('token') // 清除失效的 token
      localStorage.removeItem('userInfo')
      router.push('/login') // 踢回登录页
    } else {
      ElMessage.error(error.message || '网络异常')
    }
    return Promise.reject(error)
  }
)

export default request