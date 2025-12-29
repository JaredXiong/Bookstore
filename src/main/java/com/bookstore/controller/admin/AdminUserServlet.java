package com.bookstore.controller.admin;

import com.bookstore.entity.User;
import com.bookstore.service.UserService;
import com.bookstore.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users", "/admin/admins"})
public class AdminUserServlet extends HttpServlet {
    private final UserService userService = new UserServiceImpl();

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
            case "deleteAccount":
                deleteAccount(request, response);
                break;
            case "addAdmin":
                addAdmin(request, response);
                break;
            case "deleteUser":
                deleteUser(request, response);
                break;
            case "deleteAdmin":
                deleteAdmin(request, response);
                break;
            default:
                doGet(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        
        if (servletPath.equals("/admin/users")) {
            // 显示用户列表
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/admin/user/list.jsp").forward(request, response);
        } else if (servletPath.equals("/admin/admins")) {
            String tab = request.getParameter("tab");
            if (tab == null) {
                tab = "list";
            }
            
            if (tab.equals("list")) {
                // 显示管理员列表
                List<User> admins = userService.getAllAdmins();
                request.setAttribute("admins", admins);
            }
            
            request.setAttribute("currentTab", tab);
            request.getRequestDispatcher("/admin/list.jsp").forward(request, response);
        }
    }

    /**
     * 更新管理员个人信息
     */
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("admin");
        if (admin == null) {
            admin = (User) session.getAttribute("user");
        }
        
        if (admin != null) {
            // 获取更新的用户信息
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String postalCode = request.getParameter("postalCode");

            // 更新用户信息
            admin.setEmail(email);
            admin.setAddress(address);
            admin.setPostalCode(postalCode);

            // 调用 service更新数据库
            boolean success = userService.updateUser(admin);
            if (success) {
                // 更新 session中的用户信息
                session.setAttribute("admin", admin);
                session.setAttribute("user", admin);
                request.setAttribute("message", "个人信息更新成功");
            } else {
                request.setAttribute("message", "个人信息更新失败");
            }

            // 重新加载个人信息页面
            request.getRequestDispatcher("/admin/profile.jsp?tab=edit").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        }
    }

    /**
     * 注销管理员账号
     */
    private void deleteAccount(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("admin");
        if (admin == null) {
            admin = (User) session.getAttribute("user");
        }

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        // 检查是否是最后一个管理员
        boolean isLastAdmin = userService.isLastAdmin();
        
        if (isLastAdmin) {
            request.setAttribute("isLastAdmin", true);
            request.getRequestDispatcher("/admin/profile.jsp?tab=delete").forward(request, response);
            return;
        }

        // 删除管理员数据
        boolean success = userService.deleteUser(admin.getUserId());
        
        if (success) {
            // 销毁 session
            session.invalidate();
            // 跳转到登录页面
            request.setAttribute("message", "管理员账号注销成功");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        } else {
            request.setAttribute("message", "注销失败，请重试");
            request.getRequestDispatcher("/admin/profile.jsp?tab=delete").forward(request, response);
        }
    }
    
    /**
     * 添加管理员
     */
    private void addAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取管理员信息
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String postalCode = request.getParameter("postalCode");
        
        // 创建管理员对象
        User admin = new User();
        admin.setUsername(username);
        admin.setPassword(password);
        admin.setEmail(email);
        admin.setAddress(address);
        admin.setPostalCode(postalCode);
        
        // 添加管理员
        boolean success = userService.addAdmin(admin);
        
        if (success) {
            request.setAttribute("message", "管理员添加成功");
        } else {
            request.setAttribute("message", "管理员添加失败，用户名已存在");
        }
        
        // 显示添加管理员页面
        request.setAttribute("currentTab", "add");
        request.getRequestDispatcher("/admin/list.jsp").forward(request, response);
    }
    
    /**
     * 删除用户
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                Integer userId = Integer.parseInt(userIdStr);
                boolean success = userService.deleteUser(userId);
                if (success) {
                    request.setAttribute("message", "用户删除成功");
                } else {
                    request.setAttribute("message", "用户删除失败");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "无效的用户ID");
            }
        }
        
        // 重新加载用户列表
        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/user/list.jsp").forward(request, response);
    }
    
    /**
     * 删除管理员
     */
    private void deleteAdmin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                Integer userId = Integer.parseInt(userIdStr);
                
                // 检查是否是最后一个管理员
                if (userService.isLastAdmin()) {
                    request.setAttribute("message", "不能删除最后一个管理员");
                } else {
                    boolean success = userService.deleteUser(userId);
                    if (success) {
                        request.setAttribute("message", "管理员删除成功");
                    } else {
                        request.setAttribute("message", "管理员删除失败");
                    }
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "无效的管理员ID");
            }
        }
        
        // 重新加载管理员列表
        List<User> admins = userService.getAllAdmins();
        request.setAttribute("admins", admins);
        request.setAttribute("currentTab", "list");
        request.getRequestDispatcher("/admin/list.jsp").forward(request, response);
    }
}