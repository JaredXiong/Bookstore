package com.bookstore.controller.user;

import com.bookstore.entity.User;
import com.bookstore.service.OrderService;
import com.bookstore.service.UserService;
import com.bookstore.service.impl.OrderServiceImpl;
import com.bookstore.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "UserServlet", urlPatterns = "/user/profile")
public class UserServlet extends HttpServlet {
    private final UserService userService = new UserServiceImpl();
    private final OrderService orderService = new OrderServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            doGet(request, response);
            return;
        }

        switch (action) {
            case "updateProfile":
                updateProfile(request, response);
                break;
            case "cancelUser":
                cancelUser(request, response);
                break;
            default:
                doGet(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "viewProfile";
        }

        switch (action) {
            case "updateProfile":
                updateProfile(request, response);
                break;
            case "cancelUser":
                cancelUser(request, response);
                break;
            case "viewProfile":
            default:
                viewProfile(request, response);
        }
    }

    /**
     * 查看用户个人信息
     */
    private void viewProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null) {
            request.setAttribute("user", user);
            request.getRequestDispatcher("/user/profile.jsp?menu=profile").forward(request, response);
            System.out.println("user: " + user);
        } else {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        }
    }

    /**
     * 更新用户个人信息
     */
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null) {
            // 获取更新的用户信息
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String postalCode = request.getParameter("postalCode");

            // 更新用户信息
            user.setEmail(email);
            user.setAddress(address);
            user.setPostalCode(postalCode);

            // 调用 service更新数据库
            boolean success = userService.updateUser(user);
            if (success) {
                // 更新 session中的用户信息
                session.setAttribute("user", user);
                request.setAttribute("message", "个人信息更新成功");
            } else {
                request.setAttribute("message", "个人信息更新失败");
            }

            // 重新加载个人信息页面
            request.setAttribute("user", user);
            request.getRequestDispatcher("/user/profile.jsp?menu=editProfile").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        }
    }

    /**
     * 注销用户
     */
    private void cancelUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        // 检查用户是否有未完成订单
        boolean hasUncompletedOrders = orderService.hasUncompletedOrders(user.getUserId());

        // 如果是POST请求（执行注销操作）
        if ("POST".equals(request.getMethod())) {
            if (!hasUncompletedOrders) {
                // 删除用户数据
                userService.deleteUser(user.getUserId());
                // 销毁 session
                session.invalidate();
                // 跳转到登录页面
                request.setAttribute("message", "用户注销成功");
                request.getRequestDispatcher("/user/login.jsp").forward(request, response);
                return;
            }
        }

        // 如果是GET请求或存在未完成订单，显示注销确认页面
        request.setAttribute("hasUncompletedOrders", hasUncompletedOrders);
        request.getRequestDispatcher("/user/profile.jsp?menu=cancelUser").forward(request, response);
    }
}