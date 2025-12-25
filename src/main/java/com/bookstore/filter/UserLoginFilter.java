package com.bookstore.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "UserLoginFilter", urlPatterns = {
        "/user/profile.jsp", 
        "/cart/*", 
        "/order/*"
})
public class UserLoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化方法
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        
        // 获取session
        HttpSession session = request.getSession();
        
        // 检查用户是否已登录
        if (session.getAttribute("user") == null) {
            // 用户未登录，重定向到登录页面
            request.setAttribute("errorMsg", "请先登录");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            return;
        }
        
        // 用户已登录，继续执行
        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {
        // 销毁方法
    }
}