package com.bookstore.controller.user;

import com.bookstore.tool.CookieUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/user/logout", "/user/LogoutServlet"})
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 销毁 session
        HttpSession session = request.getSession();
        session.invalidate();
        
        // 清除记住账号密码的Cookie
        CookieUtil.clearCookies(request, response, "remember_username", "remember_password");
        
        // 重定向到首页
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}