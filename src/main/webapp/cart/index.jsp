<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.bookstore.entity.ShoppingCart" %>
<%@ page import="com.bookstore.entity.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<html>
<head>
    <title>购物车</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <style>
        .cart-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        .cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .cart-items {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
        }
        .cart-item {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        .cart-item:last-child {
            border-bottom: none;
        }
        .cart-item-image {
            width: 80px;
            height: 120px;
            object-fit: cover;
            margin-right: 20px;
        }
        .cart-item-info {
            flex: 1;
        }
        .cart-item-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .cart-item-author {
            color: #666;
            margin-bottom: 5px;
        }
        .cart-item-time {
            color: #999;
            font-size: 12px;
        }
        .cart-item-price {
            font-size: 20px;
            color: #e74c3c;
            margin-right: 30px;
        }
        .cart-item-quantity {
            display: flex;
            align-items: center;
            margin-right: 30px;
        }
        .quantity-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background-color: white;
            cursor: pointer;
        }
        .quantity-input {
            width: 50px;
            height: 30px;
            text-align: center;
            border: 1px solid #ddd;
            margin: 0 5px;
        }
        .cart-item-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .cart-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }
        .total-amount {
            font-size: 24px;
            font-weight: bold;
            color: #e74c3c;
        }
    </style>
</head>
<body>
<!-- 引入导航栏 -->
<%@ include file="../common/header.jsp" %>

<div class="cart-container">
    <div class="cart-header">
        <h2>我的购物车</h2>
        <a href="${pageContext.request.contextPath}/user/cart?action=clearCart" class="btn btn-danger" onclick="return confirm('确定要清空购物车吗？')">
            清空购物车
        </a>
    </div>

    <div class="cart-items">
        <% 
            List<ShoppingCart> cartItems = (List<ShoppingCart>) request.getAttribute("cartItems");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            if (cartItems != null && !cartItems.isEmpty()) {
                for (ShoppingCart cartItem : cartItems) {
                    Book book = (Book) cartItem.getBook();
        %>
        <div class="cart-item">
            <img src="${pageContext.request.contextPath}<%= book.getCoverImage() %>" alt="<%= book.getBookName() %>" class="cart-item-image">
            <div class="cart-item-info">
                <div class="cart-item-title"><%= book.getBookName() %></div>
                <div class="cart-item-author">作者：<%= book.getAuthor() %></div>
                <div class="cart-item-time">加入时间：<%= sdf.format(cartItem.getAddedTime()) %></div>
            </div>
            <div class="cart-item-price">¥<%= book.getPrice() %></div>
            <div class="cart-item-quantity">
                <button class="quantity-btn" onclick="updateQuantity(<%= cartItem.getCartId() %>, <%= cartItem.getQuantity() - 1 %>)">-</button>
                <input type="number" class="quantity-input" value="<%= cartItem.getQuantity() %>" min="1" max="<%= book.getStockNum() %>" 
                       onchange="updateQuantity(<%= cartItem.getCartId() %>, this.value)">
                <button class="quantity-btn" onclick="updateQuantity(<%= cartItem.getCartId() %>, <%= cartItem.getQuantity() + 1 %>)">+</button>
            </div>
            <div class="cart-item-actions">
                <a href="${pageContext.request.contextPath}/user/cart?action=removeFromCart&cartId=<%= cartItem.getCartId() %>" class="btn btn-danger btn-sm">删除</a>
                <a href="#" class="btn btn-primary btn-sm">购买</a>
            </div>
        </div>
        <% 
                }
            } else {
        %>
        <div style="text-align: center; padding: 50px; color: #999;">
            <p>您的购物车是空的</p>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">去购物</a>
        </div>
        <% 
            }
        %>
    </div>

    <div class="cart-footer">
        <% 
            Double totalAmount = (Double) request.getAttribute("totalAmount");
            if (totalAmount != null && totalAmount > 0) {
        %>
        <div class="total-amount">总计：¥<%= totalAmount %></div>
        <a href="#" class="btn btn-primary btn-lg">结算</a>
        <% 
            }
        %>
    </div>
</div>

<script>
function updateQuantity(cartId, quantity) {
    if (quantity < 1) return;
    window.location.href = '${pageContext.request.contextPath}/user/cart?action=updateCart&cartId=' + cartId + '&quantity=' + quantity;
}
</script>

<!-- 引入页脚 -->
<%@ include file="../common/footer.jsp" %>
</body>
</html>