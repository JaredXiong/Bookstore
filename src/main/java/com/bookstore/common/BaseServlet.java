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
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 在doGet或doPost方法中
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