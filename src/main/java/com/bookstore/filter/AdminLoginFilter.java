package com.bookstore.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AdminLoginFilter", urlPatterns = {"/admin/*"})
public class AdminLoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化方法
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        
        // 获取请求路径
        String path = request.getRequestURI();
        
        // 排除登录页面和登录Servlet
        if (path.endsWith("/admin/login.jsp") || path.endsWith("/admin/login") || path.endsWith("/admin/AdminLoginServlet")) {
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }
        
        // 获取session
        HttpSession session = request.getSession();
        
        // 检查管理员是否已登录
        if (session.getAttribute("admin") == null) {
            // 管理员未登录，重定向到登录页面
            request.setAttribute("errorMsg", "请先登录管理员账号");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }
        
        // 管理员已登录，继续执行
        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {
        // 销毁方法
    }
}