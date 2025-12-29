package com.bookstore.controller.admin;

import com.bookstore.entity.Book;
import com.bookstore.entity.Order;
import com.bookstore.entity.OrderItem;
import com.bookstore.entity.User;
import com.bookstore.service.BookService;
import com.bookstore.service.OrderItemService;
import com.bookstore.service.OrderService;
import com.bookstore.service.UserService;
import com.bookstore.service.impl.BookServiceImpl;
import com.bookstore.service.impl.OrderItemServiceImpl;
import com.bookstore.service.impl.OrderServiceImpl;
import com.bookstore.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.Serial;
import java.util.List;

@WebServlet(name = "AdminOrderServlet", urlPatterns = "/admin/order")
public class AdminOrderServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;
    
    private OrderService orderService;
    private OrderItemService orderItemService;
    private UserService userService;
    private BookService bookService;
    
    public void init() {
        orderService = new OrderServiceImpl();
        orderItemService = new OrderItemServiceImpl();
        userService = new UserServiceImpl();
        bookService = new BookServiceImpl();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "pending":
                listPendingOrders(request, response);
                break;
            case "ship":
                shipOrder(request, response);
                break;
            case "refund":
                refundOrder(request, response);
                break;
            case "detail":
                getOrderDetail(request, response);
                break;
            case "search":
                searchOrders(request, response);
                break;
            case "list":
            default:
                listAllOrders(request, response);
                break;
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * 获取所有订单
     */
    private void listAllOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Order> orders = orderService.getAllOrders();
        
        // 为每个订单添加用户信息
        for (Order order : orders) {
            User user = userService.findById(order.getUserId());
            request.setAttribute("user_" + order.getOrderId(), user);
        }
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/order/list.jsp").forward(request, response);
    }
    
    /**
     * 获取待处理订单（待支付、待发货、待退款）
     */
    private void listPendingOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Order> pendingOrders = orderService.getPendingOrders();
        
        // 为每个订单添加用户信息
        for (Order order : pendingOrders) {
            User user = userService.findById(order.getUserId());
            // 移除setUser调用，因为Order类中没有user属性
            request.setAttribute("user_" + order.getOrderId(), user);
        }
        
        request.setAttribute("orders", pendingOrders);
        request.setAttribute("isPending", true);
        request.getRequestDispatcher("/admin/order/list.jsp").forward(request, response);
    }
    
    /**
     * 发货
     */
    private void shipOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderId = request.getParameter("id");
        HttpSession session = request.getSession();
        
        if (orderId != null) {
            boolean success = orderService.updateOrderStatus(orderId, "待收货");
            
            if (success) {
                session.setAttribute("message", "订单发货成功");
            } else {
                session.setAttribute("error", "订单发货失败");
            }
        }
        
        // 重定向回订单列表
        response.sendRedirect(request.getContextPath() + "/admin/order?action=list");
    }
    
    /**
     * 退款
     */
    private void refundOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderId = request.getParameter("id");
        HttpSession session = request.getSession();
        
        if (orderId != null) {
            boolean success = orderService.updateOrderStatus(orderId, "已取消");
            
            if (success) {
                session.setAttribute("message", "订单退款成功");
            } else {
                session.setAttribute("error", "订单退款失败");
            }
        }
        
        // 重定向回订单列表
        response.sendRedirect(request.getContextPath() + "/admin/order?action=list");
    }
    
    /**
     * 查看订单详情
     */
    private void getOrderDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("id");
        
        if (orderId != null) {
            Order order = orderService.getOrderById(orderId);
            
            if (order != null) {
                // 获取订单项
                List<OrderItem> orderItems = orderItemService.getOrderItemsByOrderId(orderId);
                
                // 为每个订单项设置书籍信息
                for (OrderItem item : orderItems) {
                    Book book = bookService.getBookById(item.getBookId());
                    item.setBook(book);
                }
                
                // 获取用户信息
                User user = userService.findById(order.getUserId());
                
                request.setAttribute("order", order);
                request.setAttribute("orderItems", orderItems);
                request.setAttribute("user", user);
            } else {
                request.setAttribute("error", "订单不存在");
            }
        } else {
            request.setAttribute("error", "订单ID不能为空");
        }
        
        request.getRequestDispatcher("/admin/order/detail.jsp").forward(request, response);
    }
    
    /**
     * 搜索订单
     */
    private void searchOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        
        // 处理空字符串和空格
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }
        
        if (status != null) {
            status = status.trim();
            if (status.isEmpty()) {
                status = null;
            }
        }
        
        System.out.println("Searching for keyword: " + keyword + ", status: " + status);
        List<Order> orders = orderService.searchOrders(keyword, status);
        System.out.println("Found orders: " + orders);
        
        // 为每个订单添加用户信息
        for (Order order : orders) {
            User user = userService.findById(order.getUserId());
            request.setAttribute("user_" + order.getOrderId(), user);
        }
        
        // 保存搜索条件到request域，以便在页面上显示
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/order/list.jsp").forward(request, response);
    }
}