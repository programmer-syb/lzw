package org.example.lzw.utils;

public class UserContext {
    // 使用 ThreadLocal 存储当前线程的用户 ID
    private static final ThreadLocal<Long> USER_THREAD_LOCAL = new ThreadLocal<>();

    public static void setUserId(Long userId) {
        USER_THREAD_LOCAL.set(userId);
    }

    public static Long getUserId() {
        return USER_THREAD_LOCAL.get();
    }

    public static void remove() {
        // 必须在使用完后清除，防止内存泄漏和线程池复用导致的数据错乱
        USER_THREAD_LOCAL.remove();
    }
}