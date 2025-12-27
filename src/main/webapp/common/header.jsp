<%@ page import="com.bookstore.entity.User" %>
<%@ page import="com.bookstore.entity.ShoppingCart" %>
<%@ page import="com.bookstore.service.CartService" %>
<%@ page import="com.bookstore.service.impl.CartServiceImpl" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- 导航栏 -->
<nav class="navbar">
    <div class="container navbar-container">
        <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-logo">📚 求知书店</a>
        <ul class="navbar-menu">
            <li><a href="${pageContext.request.contextPath}/index.jsp">首页</a></li>
            <li><a href="${pageContext.request.contextPath}/user/book?action=list">图书分类</a></li>
            <li><a href="#">公告栏</a></li>
            <%
            // 获取购物车数量
            User user = (User) session.getAttribute("user");
            int cartCount = 0;
            if (user != null) {
                CartService cartService = new CartServiceImpl();
                List<ShoppingCart> cartItems = cartService.getCartItemsByUserId(user.getUserId());
                cartCount = cartItems.size();
            }
            %>
            <li><a href="${pageContext.request.contextPath}/user/cart?action=viewCart" class="cart-link">
                购物车 <span class="cart-count"><%= cartCount %></span>
            </a></li>
        </ul>

        <!-- 添加搜索栏 -->
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/user/book?action=search" method="get">
                <label>
                    <input type="text" name="keyword" class="search-input" placeholder="搜索图书...">
                    <button type="submit" class="search-btn">搜索</button>
                </label>
            </form>
        </div>

        <!-- 在用户已登录的情况下显示"我的"下拉菜单 -->
        <div class="navbar-right">
            <% if (session.getAttribute("user") == null) { %>
                <a href="${pageContext.request.contextPath}/user/login.jsp" class="btn btn-primary">登录</a>
                <a href="${pageContext.request.contextPath}/user/register.jsp" class="btn btn-secondary">注册</a>
            <% } else { %>
                <span class="welcome-text">欢迎您, <%= session.getAttribute("username") %></span>
                <div class="dropdown">
                    <a href="#" class="dropdown-toggle">我的 ▼</a>
                    <div class="dropdown-menu">
                        <a href="user/profile.jsp" class="dropdown-item">个人中心</a>
                        <a href="order/list.jsp" class="dropdown-item">订单信息</a>
                        <div class="dropdown-divider"></div>
                        <a href="${pageContext.request.contextPath}/user/logout" class="dropdown-item logout-item">退出</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</nav>