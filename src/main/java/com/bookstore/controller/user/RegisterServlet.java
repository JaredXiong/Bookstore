package com.bookstore.controller.user;

import com.bookstore.entity.User;
import com.bookstore.service.UserService;
import com.bookstore.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/user/RegisterServlet", "/user/register"})
public class RegisterServlet extends HttpServlet {
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String postalCode = request.getParameter("postalCode");
        
        // 创建用户对象
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setAddress(address);
        user.setPostalCode(postalCode);
        
        // 调用service层进行注册
        boolean success = userService.register(user);
        
        if (success) {
            // 注册成功，重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        } else {
            // 注册失败，返回注册页面并显示错误信息
            request.setAttribute("errorMsg", "用户名已存在");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
        }
    }
}