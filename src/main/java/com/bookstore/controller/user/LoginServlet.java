package com.bookstore.controller.user;

import com.bookstore.entity.User;
import com.bookstore.service.UserService;
import com.bookstore.service.impl.UserServiceImpl;

import com.bookstore.tool.CookieUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/user/LoginServlet", "/user/login"})
public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查是否有自动登陆的 Cookie
        Cookie[] cookies = request.getCookies();
        String username = null;
        String password = null;
        boolean hasRememberCookie = false;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("remember_username".equals(cookie.getName())) {
                    username = cookie.getValue();
                }
                if ("remember_password".equals(cookie.getName())) {
                    password = cookie.getValue();
                }
                if (username != null && password != null) {
                    hasRememberCookie = true;
                    break;
                }
            }
        }
        
        // 如果有自动登陆的 Cookie，自动登录
        if (hasRememberCookie) {
            User user = userService.login(username, password);
            if (user != null) {
                // 登录成功，将用户信息存入session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("username", user.getUsername());
                
                // 重定向到首页
                response.sendRedirect(request.getContextPath() + "/index.jsp");
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
        User user = userService.login(username, password);
        
        if (user != null) {
            // 登录成功，将用户信息存入session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            
            // 处理记住我功能
            if ("true".equals(remember)) {
                int maxAge = 30 * 24 * 60 * 60; // 30天
                CookieUtil.setCookie(request, response, "remember_username", username, maxAge);
                CookieUtil.setCookie(request, response, "remember_password", password, maxAge);
            } else {
                // 清除记住我Cookie
                CookieUtil.clearCookies(request, response, "remember_username", "remember_password");
            }
            
            // 重定向到首页
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            // 登录失败，返回登录页面并显示错误信息
            request.setAttribute("errorMsg", "用户名或密码错误");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }
    }
}