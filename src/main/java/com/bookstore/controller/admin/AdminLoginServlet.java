package com.bookstore.controller.admin;

import com.bookstore.entity.User;
import com.bookstore.service.AdminService;
import com.bookstore.service.impl.AdminServiceImpl;

import com.bookstore.tool.CookieUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin/AdminLoginServlet", "/admin/login"})
public class AdminLoginServlet extends HttpServlet {
    private AdminService adminService = new AdminServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查是否有记住我的Cookie
        Cookie[] cookies = request.getCookies();
        String username = null;
        String password = null;
        boolean hasRememberCookie = false;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("admin_remember_username".equals(cookie.getName())) {
                    username = cookie.getValue();
                }
                if ("admin_remember_password".equals(cookie.getName())) {
                    password = cookie.getValue();
                }
                if (username != null && password != null) {
                    hasRememberCookie = true;
                    break;
                }
            }
        }
        
        // 如果有记住我的Cookie，自动登录
        if (hasRememberCookie) {
            User admin = adminService.login(username, password);
            if (admin != null) {
                // 登录成功，将管理员信息存入session
                HttpSession session = request.getSession();
                session.setAttribute("admin", admin);
                session.setAttribute("username", admin.getUsername());
                
                // 重定向到管理员首页
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
        }
        
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // 获取参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");
        
        // 调用service层进行登录验证
        User admin = adminService.login(username, password);
        
        if (admin != null) {
            // 登录成功，将管理员信息存入session
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);
            session.setAttribute("username", admin.getUsername());
            
            // 处理记住我功能
            // 设置管理员记住我Cookie
            if ("true".equals(remember)) {
                int maxAge = 30 * 24 * 60 * 60; // 30天
                CookieUtil.setCookie(request, response, "admin_remember_username", username, maxAge);
                CookieUtil.setCookie(request, response, "admin_remember_password", password, maxAge);
            } else {
                // 清除管理员记住我Cookie
                CookieUtil.clearCookies(request, response, "admin_remember_username", "admin_remember_password");
            }
            
            // 重定向到管理员首页
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
        } else {
            // 登录失败，返回登录页面并显示错误信息
            request.setAttribute("errorMsg", "用户名或密码错误，或您不是管理员");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}