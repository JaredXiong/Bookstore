<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<html>
<head>
    <title>填写订单信息</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <style>
        .order-container {
            max-width: 900px;
            margin: 30px auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .order-header {
            border-bottom: 2px solid #3498db;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .order-header h2 {
            color: #2c3e50;
            margin: 0;
            font-size: 24px;
        }
        .order-book-list {
            margin-bottom: 40px;
            padding: 0 10px;
        }
        .order-book-list h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: 600;
        }
        .order-book-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
            border-bottom: 1px solid #eee;
            transition: background-color 0.3s ease;
        }
        .order-book-item:hover {
            background-color: #f8f9fa;
        }
        .order-book-item:last-child {
            border-bottom: none;
        }
        .order-book-info {
            flex: 1;
        }
        .order-book-title {
            font-weight: 600;
            margin-bottom: 5px;
            color: #2c3e50;
        }
        .order-book-price {
            color: #e74c3c;
            margin-right: 30px;
            font-weight: 500;
        }
        .order-book-quantity {
            margin-right: 30px;
            color: #666;
        }
        .order-book-total {
            font-weight: 600;
            color: #e74c3c;
        }
        .order-summary {
            text-align: right;
            margin: 30px 10px;
            font-size: 20px;
            font-weight: 600;
            padding: 15px 0;
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
        }
        .order-summary span {
            color: #e74c3c;
        }
        .address-form {
            margin-top: 40px;
            padding: 0 10px;
        }
        .address-form h3 {
            color: #2c3e50;
            margin-bottom: 25px;
            font-size: 18px;
            font-weight: 600;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .form-group input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        .btn-group {
            margin-top: 30px;
            display: flex;
            gap: 15px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-default {
            background-color: #95a5a6;
            color: white;
        }
        .btn-default:hover {
            background-color: #7f8c8d;
            transform: translateY(-1px);
        }
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        .btn-primary:hover {
            background-color: #2980b9;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
<!-- 引入导航栏 -->
<%@ include file="../common/header.jsp" %>

<div class="container">
    <div class="order-container">
        <div class="order-header">
            <h2>填写订单信息</h2>
        </div>
        
        <!-- 图书信息列表 -->
        <div class="order-book-list">
            <h3>购买图书</h3>
            <% 
                List<Map<String, Object>> bookList = (List<Map<String, Object>>) request.getAttribute("bookList");
                if (bookList != null && !bookList.isEmpty()) {
                    for (Map<String, Object> book : bookList) {
            %>
            <div class="order-book-item">
                <div class="order-book-info">
                    <div class="order-book-title"><%= book.get("bookName") %></div>
                </div>
                <div class="order-book-price">¥<%= book.get("price") %></div>
                <div class="order-book-quantity">×<%= book.get("quantity") %></div>
                <div class="order-book-total">¥<%= book.get("total") %></div>
            </div>
            <% 
                    }
                }
            %>
        </div>
        
        <!-- 订单总价 -->
        <div class="order-summary">
            总计：<span>¥<%= request.getAttribute("totalAmount") %></span>
        </div>
        
        <!-- 收货人信息填写栏 -->
        <div class="address-form">
            <h3>收货人信息</h3>
            <form action="${pageContext.request.contextPath}/user/order?action=directBuy" method="post">
                <input type="hidden" name="bookId" value="${requestScope.bookId}">
                <input type="hidden" name="quantity" value="${requestScope.quantity}">
                <input type="hidden" name="fromCart" value="${requestScope.fromCart}">
                
                <div class="form-group">
                    <label for="recipientName">收件人姓名：</label>
                    <input type="text" id="recipientName" name="recipientName" required>
                </div>
                
                <div class="form-group">
                    <label for="phoneNumber">手机号：</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" required>
                </div>
                
                <div class="form-group">
                    <label for="deliveryAddress">收货地址：</label>
                    <input type="text" id="deliveryAddress" name="deliveryAddress" required>
                </div>
                
                <div class="btn-group">
                    <button type="button" class="btn btn-default" onclick="useDefaultAddress()">使用默认信息</button>
                    <button type="submit" class="btn btn-primary">购买</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
// 使用默认地址
function useDefaultAddress() {
    // 获取默认地址信息
    <% 
        user = (com.bookstore.entity.User) session.getAttribute("user");
        if (user != null) {
    %>
    document.getElementById("deliveryAddress").value = "<%= user.getAddress() %>";
    <% 
        }
    %>
}
</script>

<!-- 引入页脚 -->
<%@ include file="../common/footer.jsp" %>
</body>
</html>