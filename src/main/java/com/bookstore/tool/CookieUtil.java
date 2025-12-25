package com.bookstore.tool;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Cookie工具类，封装常用的Cookie操作
 */
public class CookieUtil {
    /**
     * 获取指定名称的Cookie值
     * @param request HttpServletRequest对象
     * @param name Cookie名称
     * @return Cookie值，如果不存在则返回null
     */
    public static String getCookieValue(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (name.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    /**
     * 设置Cookie
     * @param response HttpServletResponse对象
     * @param name Cookie名称
     * @param value Cookie值
     * @param maxAge 过期时间（秒）
     * @param path Cookie路径
     */
    public static void setCookie(HttpServletResponse response, String name, String value, int maxAge, String path) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAge);
        cookie.setPath(path);
        response.addCookie(cookie);
    }

    /**
     * 设置Cookie，使用默认路径（上下文路径）
     * @param request HttpServletRequest对象
     * @param response HttpServletResponse对象
     * @param name Cookie名称
     * @param value Cookie值
     * @param maxAge 过期时间（秒）
     */
    public static void setCookie(HttpServletRequest request, HttpServletResponse response, String name, String value, int maxAge) {
        setCookie(response, name, value, maxAge, request.getContextPath());
    }

    /**
     * 清除指定名称的Cookie
     * @param request HttpServletRequest对象
     * @param response HttpServletResponse对象
     * @param name Cookie名称
     */
    public static void clearCookie(HttpServletRequest request, HttpServletResponse response, String name) {
        setCookie(request, response, name, "", 0);
    }

    /**
     * 清除多个指定名称的Cookie
     * @param request HttpServletRequest对象
     * @param response HttpServletResponse对象
     * @param names Cookie名称数组
     */
    public static void clearCookies(HttpServletRequest request, HttpServletResponse response, String... names) {
        for (String name : names) {
            clearCookie(request, response, name);
        }
    }
}