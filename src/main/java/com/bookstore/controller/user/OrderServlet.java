package com.bookstore.controller.user;

import com.bookstore.common.BaseServlet;
import com.bookstore.entity.*;
import com.bookstore.service.*;
import com.bookstore.service.impl.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "OrderServlet", urlPatterns = "/user/order")
public class OrderServlet extends BaseServlet {
    private final OrderService orderService = new OrderServiceImpl();
    private final CartService cartService = new CartServiceImpl();
    private final BookService bookService = new BookServiceImpl();
    private final OrderItemService orderItemService = new OrderItemServiceImpl();
    
    // 创建订单
    public void createOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        try {
            String deliveryAddress = request.getParameter("deliveryAddress");
            
            // 获取用户购物车中的商品
            List<ShoppingCart> cartItems = cartService.getCartItemsByUserId(user.getUserId());
            if (cartItems.isEmpty()) {
                request.setAttribute("errorMsg", "购物车为空，无法创建订单");
                request.getRequestDispatcher("/cart/index.jsp").forward(request, response);
                return;
            }
            
            // 计算订单总金额
            double totalAmount = 0;
            for (ShoppingCart cartItem : cartItems) {
                Book book = bookService.getBookById(cartItem.getBookId());
                totalAmount += book.getPrice() * cartItem.getQuantity();
            }
            
            // 创建订单
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setTotalAmount(totalAmount);
            order.setDeliveryAddress(deliveryAddress);
            order.setOrderStatus("待支付");
            order.setCreateTime(new Date());
            
            String orderId = orderService.createOrder(order);
            if (orderId != null) {
                // 创建订单项
                for (ShoppingCart cartItem : cartItems) {
                    Book book = bookService.getBookById(cartItem.getBookId());
                    
                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderId(orderId);
                    orderItem.setBookId(cartItem.getBookId());
                    orderItem.setQuantity(cartItem.getQuantity());
                    orderItem.setPrice(book.getPrice());
                    
                    orderItemService.addOrderItem(orderItem);
                }
                
                // 清空购物车
                cartService.clearCart(user.getUserId());
                
                // 跳转到订单详情页面
                response.sendRedirect(request.getContextPath() + "/user/order?action=detail&orderId=" + orderId);
            } else {
                request.setAttribute("errorMsg", "创建订单失败");
                request.getRequestDispatcher("/cart/index.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "创建订单时发生错误：" + e.getMessage());
            request.getRequestDispatcher("/cart/index.jsp").forward(request, response);
        }
    }
    
    // 查看订单详情
    public void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            request.setAttribute("errorMsg", "订单编号不能为空");
            request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
            return;
        }
        
        Order order = orderService.getOrderById(orderId);
        if (order == null || !order.getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "订单不存在或无权限查看");
            request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
            return;
        }
        
        // 获取订单项
        List<OrderItem> orderItems = orderItemService.getOrderItemsByOrderId(orderId);
        
        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.getRequestDispatcher("/order/detail.jsp").forward(request, response);
    }
    
    // 查看用户订单列表
    public void list(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        String status = request.getParameter("status"); // 可选参数，按状态筛选
        List<Order> orders;
        
        if (status != null && !status.trim().isEmpty()) {
            orders = orderService.getOrdersByStatus(status);
        } else {
            orders = orderService.getOrdersByUserId(user.getUserId());
        }
        
        request.setAttribute("orders", orders);
        request.setAttribute("status", status);
        request.getRequestDispatcher("/order/list.jsp").forward(request, response);
    }
    
    // 取消订单
    public void cancelOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            request.setAttribute("errorMsg", "订单编号不能为空");
            list(request, response);
            return;
        }
        
        Order order = orderService.getOrderById(orderId);
        if (order == null || !order.getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "订单不存在或无权限操作");
            list(request, response);
            return;
        }
        
        if (!"待支付".equals(order.getOrderStatus())) {
            request.setAttribute("errorMsg", "只有待支付状态的订单才能取消");
            list(request, response);
            return;
        }
        
        boolean success = orderService.cancelOrder(orderId);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user/order?action=list");
        } else {
            request.setAttribute("errorMsg", "取消订单失败");
            list(request, response);
        }
    }
    
    // 确认收货
    public void confirmReceipt(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            request.setAttribute("errorMsg", "订单编号不能为空");
            list(request, response);
            return;
        }
        
        Order order = orderService.getOrderById(orderId);
        if (order == null || !order.getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "订单不存在或无权限操作");
            list(request, response);
            return;
        }
        
        if (!"已发货".equals(order.getOrderStatus())) {
            request.setAttribute("errorMsg", "只有已发货状态的订单才能确认收货");
            list(request, response);
            return;
        }
        
        boolean success = orderService.updateOrderStatus(orderId, "已完成");
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user/order?action=list");
        } else {
            request.setAttribute("errorMsg", "确认收货失败");
            list(request, response);
        }
    }
}