<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>订单详情</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <style>
        /* 订单详情页面样式 */
        .order-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .order-info {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .order-header {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #eee;
        }
        
        .order-header h2 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 24px;
        }
        
        .order-header p {
            margin-bottom: 8px;
            font-size: 16px;
            color: #666;
        }
        
        .order-items {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }
        
        .order-items th, .order-items td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .order-items th {
            background-color: #f8f9fa;
            color: #2c3e50;
            font-weight: 600;
        }
        
        .order-items tr:hover {
            background-color: #f8f9fa;
        }
        
        .order-actions {
            display: flex;
            gap: 15px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        /* 订单状态样式 */
        .status-pending {
            color: #f39c12;
            font-weight: bold;
        }
        
        .status-shipped {
            color: #3498db;
            font-weight: bold;
        }
        
        .status-completed {
            color: #2ecc71;
            font-weight: bold;
        }
        
        .status-cancelled {
            color: #e74c3c;
            font-weight: bold;
        }
        
        .status-refunded {
            color: #9b59b6;
            font-weight: bold;
        }
        
        /* 按钮样式增强 */
        .btn-pay {
            background-color: #2ecc71;
            color: white;
        }
        
        .btn-pay:hover {
            background-color: #4CAF50;
            transform: translateY(-1px);
        }
        
        .btn-cancel {
            background-color: #da190b;
            color: white;
        }
        
        .btn-cancel:hover {
            background-color: #c0392b;
            transform: translateY(-1px);
        }
        
        .btn-receipt {
            background-color: #2ecc71;
            color: white;
        }
        
        .btn-receipt:hover {
            background-color: #27ae60;
            transform: translateY(-1px);
        }
        
        .btn-refund {
            background-color: #9b59b6;
            color: white;
        }
        
        .btn-refund:hover {
            background-color: #8e44ad;
            transform: translateY(-1px);
        }
        
        .btn-comment {
            background-color: #3498db;
            color: white;
        }
        
        .btn-comment:hover {
            background-color: #2980b9;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
<!-- 引入导航栏 -->
<%@ include file="../common/header.jsp" %>

<div class="order-container">
    <div class="order-info">
        <div class="order-header">
            <h2>订单详情</h2>
            <p>订单编号: ${order.orderId}</p>
            <p>订单状态:
                <span class="
                    <c:if test="${order.orderStatus == '待支付'}">status-pending</c:if>
                    <c:if test="${order.orderStatus == '待发货'}">status-shipped</c:if>
                    <c:if test="${order.orderStatus == '待收货'}">status-shipped</c:if>
                    <c:if test="${order.orderStatus == '待评价'}">status-completed</c:if>
                    <c:if test="${order.orderStatus == '已取消'}">status-cancelled</c:if>
                    <c:if test="${order.orderStatus == '待退款'}">status-refunded</c:if>
                    <c:if test="${order.orderStatus == '已完成'}">status-completed</c:if>
                ">${order.orderStatus}</span>
            </p>
            <p>创建时间: ${order.createTime}</p>
            <p>配送地址: ${order.deliveryAddress}</p>
            <p>订单金额: <span style="color: #e74c3c; font-weight: bold;">${order.totalAmount}元</span></p>
        </div>
        
        <h3 style="color: #2c3e50; margin-bottom: 15px; font-size: 18px;">订单商品</h3>
        <table class="order-items">
            <tr>
                <th>商品名称</th>
                <th>作者</th>
                <th>单价</th>
                <th>数量</th>
                <th>小计</th>
            </tr>
            <c:forEach items="${orderItems}" var="item">
                <tr>
                    <td>${item.book.bookName}</td>
                    <td>${item.book.author}</td>
                    <td>${item.price}元</td>
                    <td>${item.quantity}</td>
                    <td>${item.price * item.quantity}元</td>
                </tr>
            </c:forEach>
        </table>
        
        <div class="order-actions">
            <!-- 根据订单状态显示不同的操作按钮 -->
            <c:if test="${order.orderStatus == '待支付'}">
                <a href="${pageContext.request.contextPath}/user/order?action=payOrder&orderId=${order.orderId}" class="btn btn-pay">支付</a>
                <a href="${pageContext.request.contextPath}/user/order?action=cancelOrder&orderId=${order.orderId}" class="btn btn-cancel">取消</a>
            </c:if>
            <c:if test="${order.orderStatus == '待收货'}">
                <a href="${pageContext.request.contextPath}/user/order?action=confirmReceipt&orderId=${order.orderId}" class="btn btn-receipt">收货</a>
                <a href="${pageContext.request.contextPath}/user/order?action=applyRefund&orderId=${order.orderId}" class="btn btn-refund">退款</a>
            </c:if>
            <c:if test="${order.orderStatus == '待评价'}">
                <a href="#" class="btn btn-comment">评价</a> <!-- 评价功能暂未实现 -->
            </c:if>
        </div>
    </div>
</div>

<!-- 引入页脚 -->
<%@ include file="../common/footer.jsp" %>
</body>
</html>