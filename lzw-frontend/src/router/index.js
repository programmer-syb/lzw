import { createRouter, createWebHistory } from 'vue-router'

const routes = [
    {
        path: '/',
        redirect: '/login'
    },
    {
        path: '/login',
        name: 'Login',
        component: () => import('../views/login/Index.vue')
    },
    {
        path: '/student',
        name: 'StudentLayout',
        component: () => import('../views/student/Layout.vue'),
        meta: { requireAuth: true, role: 2 },
        redirect: '/student/discovery',
        children: [
            {
                path: 'discovery',
                name: 'StudentDiscovery',
                component: () => import('../views/student/Discovery.vue')
            },
            {
                path: 'course/:id',
                name: 'CourseDetail',
                component: () => import('../views/student/CourseDetail.vue'),
                meta: { requireAuth: true, role: 2 }
            },
            {
                path: 'homework',
                component: () => import('../views/student/Homework.vue')
            },
            {
                path: 'exam',
                component: () => import('../views/student/Exam.vue')
            },
            {
                path: 'my-courses',
                component: () => import('../views/student/MyCourses.vue')
            },
            {
                path: 'discussion',
                component: () => import('../views/student/Discussion.vue')
            },
            {
                path: 'profile',
                name: 'StudentProfile',
                component: () => import('../views/student/Profile.vue')
            },
            {
                path: 'settings',
                name: 'StudentSettings',
                component: () => import('../views/student/Settings.vue')
            },
            {
                path: 'notices',
                name: 'StudentNotices',
                component: () => import('../views/student/Notices.vue')
            }
        ]
    },
    {
        path: '/admin',
        name: 'AdminLayout',
        component: () => import('../views/admin/Layout.vue'),
        meta: { requireAuth: true, role: 0 },
        redirect: '/admin/dashboard',
        children: [
            {
                path: 'dashboard',
                name: 'AdminDashboard',
                component: () => import('../views/admin/Dashboard.vue')
            },
            {
                path: 'users',
                component: () => import('../views/admin/Users.vue')
            },
            {
                path: 'categories',
                component: () => import('../views/admin/Categories.vue')
            },
            {
                path: 'notices',
                component: () => import('../views/admin/Notices.vue')
            },
            {
                path: 'courses',
                component: () => import('../views/admin/Courses.vue')
            },
            {
                path: 'storage',
                component: () => import('../views/admin/Storage.vue')
            },
            {
                path: 'logs',
                component: () => import('../views/admin/Logs.vue')
            }
        ]
    },
    {
        path: '/teacher',
        name: 'TeacherLayout',
        component: () => import('../views/teacher/Layout.vue'),
        meta: { requireAuth: true, role: 1 },
        redirect: '/teacher/dashboard',
        children: [
            {
                path: 'dashboard',
                name: 'TeacherDashboard',
                component: () => import('../views/teacher/Dashboard.vue')
            },
            {
                path: 'courses',
                name: 'TeacherCourses',
                component: () => import('../views/teacher/Courses.vue')
            },
            {   path: 'homework', 
                component: () => import('../views/teacher/Homework.vue') 
            },
            {   path: 'exams', 
                component: () => import('../views/teacher/Exams.vue') 
            },
            {   path: 'resources', 
                component: () => import('../views/teacher/Resources.vue') 
            },
            {
                path: 'profile',
                name: 'TeacherProfile',
                component: () => import('../views/teacher/Profile.vue')
            },
            {
                path: 'notices',
                name: 'TeacherNotices',
                component: () => import('../views/teacher/Notices.vue')
            },
            {   path: 'grading', 
                name: 'TeacherGrading', 
                component: () => import('../views/teacher/ExamGrading.vue') 
            }
        ]
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

// 路由全局前置守卫：校验登录状态
router.beforeEach((to, from, next) => {
    const token = localStorage.getItem('token')
    const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')

    // 如果访问的是登录页，直接放行
    if (to.path === '/login') {
        return next()
    }

    // 检查该路由是否需要登录
    if (to.meta.requireAuth) {
        if (!token) {
            // 没 token，踢回登录
            return next('/login')
        }

        // 简单的角色越权校验
        if (to.meta.role !== undefined && to.meta.role !== userInfo.role) {
            // 如果角色不匹配，比如学生想访问 /admin，阻止它 (实际业务中可以跳转到 403 页面)
            console.warn('无权访问该角色页面')
            return next(false)
        }
    }

    next()
})

export default router