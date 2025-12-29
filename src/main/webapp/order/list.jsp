<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>订单列表</title>
    <style>
        .order-list {
            width: 80%;
            margin: 0 auto;
            border-collapse: collapse;
        }
        .order-list th, .order-list td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .order-list th {
            background-color: #f2f2f2;
        }

        .btn {
            padding: 5px 10px;
            margin: 0 5px;
            text-decoration: none;
            color: white;
            border-radius: 3px;
        }
        .btn-pay { background-color: #4CAF50; }
        .btn-cancel { background-color: #f44336; }
        .btn-receipt { background-color: #2196F3; }
        .btn-refund { background-color: #ff9800; }
    </style>
</head>
<body>
<!-- 引入导航栏 -->
<%@ include file="../common/header.jsp" %>

    <h1>我的订单</h1>
    
    <table class="order-list">
        <tr>
            <th>订单编号</th>
            <th>订单金额</th>
            <th>订单状态</th>
            <th>创建时间</th>
            <th>配送地址</th>
            <th>操作</th>
        </tr>
        <c:forEach items="${orders}" var="order">
            <tr>
                <td><a href="${pageContext.request.contextPath}/user/order?action=detail&orderId=${order.orderId}">${order.orderId}</a></td>
                <td>${order.totalAmount}元</td>
                <td>${order.orderStatus}</td>
                <td>${order.createTime}</td>
                <td>${order.deliveryAddress}</td>
                <td>
                    <!-- 根据订单状态显示不同的操作按钮 -->
                    <c:if test="${order.orderStatus == '待支付'}">
                        <a href="${pageContext.request.contextPath}/user/order?action=payOrder&orderId=${order.orderId}" class="btn btn-pay">支付</a>
                        <a href="${pageContext.request.contextPath}/user/order?action=cancelOrder&orderId=${order.orderId}" class="btn btn-cancel">取消</a>
                    </c:if>
                    <c:if test="${order.orderStatus == '待收货'}">
                        <a href="${pageContext.request.contextPath}/user/order?action=confirmReceipt&orderId=${order.orderId}" class="btn btn-receipt">收货</a>
                        <a href="${pageContext.request.contextPath}/user/order?action=applyRefund&orderId=${order.orderId}" class="btn btn-refund">退款</a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
<!-- 引入页脚 -->
<%@ include file="../common/footer.jsp" %>
</html>