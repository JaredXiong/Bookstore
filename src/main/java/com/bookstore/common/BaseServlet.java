package com.bookstore.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Method;

public class BaseServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查请求的 URL是否指向 JSP文件
        String requestURI = request.getRequestURI();
        if (requestURI.endsWith(".jsp")) {
            // 如果是 JSP文件，直接调用父类的 service方法让容器处理
            super.doGet(request, response);
            return;
        }
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查请求的 URL是否指向 JSP文件
        String requestURI = request.getRequestURI();
        if (requestURI.endsWith(".jsp")) {
            // 如果是JSP文件，直接调用父类的service方法让容器处理
            super.doPost(request, response);
            return;
        }
        
        // 正常处理非 JSP请求
        String action = request.getParameter("action");
        // 如果没有指定action，则使用默认action
        if (action == null || action.isEmpty()) {
            action = getInitParameter("defaultAction");
        }

        if (action == null) {
            throw new IllegalArgumentException("缺少action参数");
        }

        try {
            Method method = this.getClass().getDeclaredMethod(action, HttpServletRequest.class, HttpServletResponse.class);
            method.invoke(this, request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("执行action方法时发生错误: " + action, e);
        }
    }
}