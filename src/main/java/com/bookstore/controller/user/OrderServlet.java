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
import java.util.*;

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

            // 计算订单总金额并创建订单项
            double totalAmount = 0;
            List<OrderItem> orderItems = new ArrayList<>();

            for (ShoppingCart cartItem : cartItems) {
                Book book = bookService.getBookById(cartItem.getBookId());
                if (book == null) {
                    request.setAttribute("errorMsg", "购物车中包含已下架商品");
                    request.getRequestDispatcher("/cart/index.jsp").forward(request, response);
                    return;
                }

                if (book.getStockNum() < cartItem.getQuantity()) {
                    request.setAttribute("errorMsg", "商品库存不足：" + book.getBookName());
                    request.getRequestDispatcher("/cart/index.jsp").forward(request, response);
                    return;
                }

                OrderItem orderItem = new OrderItem();
                orderItem.setBookId(book.getBookId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(book.getPrice());
                orderItems.add(orderItem);

                totalAmount += book.getPrice() * cartItem.getQuantity();
            }

            // 创建订单
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setTotalAmount(totalAmount);
            order.setDeliveryAddress(deliveryAddress);
            order.setOrderStatus("待支付");
            order.setCreateTime(new Date());

            // 生成订单ID
            String orderId = orderService.createOrderWithStockCheck(order, orderItems);

            // 清空购物车
            cartService.clearCart(user.getUserId());

            // 跳转到订单详情页面
            response.sendRedirect(request.getContextPath() + "/user/order?action=detail&orderId=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "创建订单失败：" + e.getMessage());
            request.getRequestDispatcher("/cart/index.jsp").forward(request, response);
        }
    }

    // 直接购买
    public void directBuy(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        try {
            String bookIdStr = request.getParameter("bookId");
            String quantityStr = request.getParameter("quantity");
            String deliveryAddress = request.getParameter("deliveryAddress");

            if (bookIdStr == null || quantityStr == null || deliveryAddress == null) {
                request.setAttribute("errorMsg", "参数错误");
                request.getRequestDispatcher("/book/index.jsp").forward(request, response);
                return;
            }

            int bookId = Integer.parseInt(bookIdStr);
            int quantity = Integer.parseInt(quantityStr);

            // 检查商品是否存在及库存
            Book book = bookService.getBookById(bookId);
            if (book == null) {
                request.setAttribute("errorMsg", "商品不存在");
                request.getRequestDispatcher("/book/index.jsp").forward(request, response);
                return;
            }

            if (book.getStockNum() < quantity) {
                request.setAttribute("errorMsg", "商品库存不足：" + book.getBookName());
                request.getRequestDispatcher("/book/index.jsp").forward(request, response);
                return;
            }

            // 创建订单
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setTotalAmount(book.getPrice() * quantity);
            order.setDeliveryAddress(deliveryAddress);
            order.setOrderStatus("待支付");
            order.setCreateTime(new Date());

            // 创建订单项
            List<OrderItem> orderItems = new ArrayList<>();
            OrderItem orderItem = new OrderItem();
            orderItem.setBookId(bookId);
            orderItem.setQuantity(quantity);
            orderItem.setPrice(book.getPrice());
            orderItems.add(orderItem);

            // 生成订单 ID
            String orderId = orderService.createOrderWithStockCheck(order, orderItems);

            // 跳转到订单详情页面
            response.sendRedirect(request.getContextPath() + "/user/order?action=detail&orderId=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "创建订单失败：" + e.getMessage());
            request.getRequestDispatcher("/book/index.jsp").forward(request, response);
        }
    }

    // 订单详情
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
            list(request, response);
            return;
        }

        Order order = orderService.getOrderById(orderId);
        if (order == null || !order.getUserId().equals(user.getUserId())) {
            request.setAttribute("errorMsg", "订单不存在或无权限操作");
            list(request, response);
            return;
        }

        List<OrderItem> orderItems = orderItemService.getOrderItemsByOrderId(orderId);
        String statusText = order.getOrderStatus();
        request.setAttribute("statusText", statusText);
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

        String status = request.getParameter("status");
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

    // 支付订单
    public void payOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            request.setAttribute("errorMsg", "只有待支付状态的订单才能支付");
            list(request, response);
            return;
        }

        boolean success = orderService.updateOrderStatus(orderId, "待发货");
        System.out.println(orderId);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user/order?action=list");
        } else {
            request.setAttribute("errorMsg", "支付失败");
            list(request, response);
        }
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

        if (!"待发货".equals(order.getOrderStatus())) {
            request.setAttribute("errorMsg", "只有待发货状态的订单才能确认收货");
            list(request, response);
            return;
        }

        boolean success = orderService.updateOrderStatus(orderId, "待收货");
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user/order?action=list");
        } else {
            request.setAttribute("errorMsg", "确认收货失败");
            list(request, response);
        }
    }

    // 申请退款
    public void applyRefund(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        if (!"待收货".equals(order.getOrderStatus())) {
            request.setAttribute("errorMsg", "只有待收货状态的订单才能申请退款");
            list(request, response);
            return;
        }

        boolean success = orderService.updateOrderStatus(orderId, "待退款");
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user/order?action=list");
        } else {
            request.setAttribute("errorMsg", "申请退款失败");
            list(request, response);
        }
    }

    // 完成评价
    public void completeComment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        if (!"待评价".equals(order.getOrderStatus())) {
            request.setAttribute("errorMsg", "只有待评价状态的订单才能完成评价");
            list(request, response);
            return;
        }

        boolean success = orderService.updateOrderStatus(orderId, "已完成");
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user/order?action=list");
        } else {
            request.setAttribute("errorMsg", "完成评价失败");
            list(request, response);
        }
    }

    // 填写地址页面
    public void fillAddress(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        String bookId = request.getParameter("bookId");
        String quantity = request.getParameter("quantity");
        String fromCart = request.getParameter("fromCart");

        // 存储订单来源信息
        request.setAttribute("fromCart", fromCart);

        if ("true".equals(fromCart)) {
            // 从购物车跳转过来
            List<ShoppingCart> cartItems = cartService.getCartItemsByUserId(user.getUserId());
            if (cartItems.isEmpty()) {
                request.setAttribute("errorMsg", "购物车为空，无法创建订单");
                request.getRequestDispatcher("/cart/index.jsp").forward(request, response);
                return;
            }

            // 计算总金额并存储购物车商品信息
            double totalAmount = 0;
            List<Map<String, Object>> bookList = new ArrayList<>();

            for (ShoppingCart cartItem : cartItems) {
                Book book = bookService.getBookById(cartItem.getBookId());
                if (book != null) {
                    Map<String, Object> bookInfo = new HashMap<>();
                    bookInfo.put("bookId", book.getBookId());
                    bookInfo.put("bookName", book.getBookName());
                    bookInfo.put("price", book.getPrice());
                    bookInfo.put("quantity", cartItem.getQuantity());
                    bookInfo.put("total", book.getPrice() * cartItem.getQuantity());

                    bookList.add(bookInfo);
                    totalAmount += book.getPrice() * cartItem.getQuantity();
                }
            }

            request.setAttribute("bookList", bookList);
            request.setAttribute("totalAmount", totalAmount);
        } else if (bookId != null && quantity != null) {
            // 从商品详情页跳转过来
            Book book = bookService.getBookById(Integer.parseInt(bookId));
            if (book != null) {
                int buyQuantity = Integer.parseInt(quantity);
                List<Map<String, Object>> bookList = new ArrayList<>();
                Map<String, Object> bookInfo = new HashMap<>();

                bookInfo.put("bookId", book.getBookId());
                bookInfo.put("bookName", book.getBookName());
                bookInfo.put("price", book.getPrice());
                bookInfo.put("quantity", buyQuantity);
                bookInfo.put("total", book.getPrice() * buyQuantity);

                bookList.add(bookInfo);

                request.setAttribute("bookList", bookList);
                request.setAttribute("totalAmount", book.getPrice() * buyQuantity);
                request.setAttribute("bookId", bookId);
                request.setAttribute("quantity", quantity);
            }
        }

        request.getRequestDispatcher("/order/fillAddress.jsp").forward(request, response);
    }
}