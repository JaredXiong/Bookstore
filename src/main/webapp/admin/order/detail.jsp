<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单详情 - 求知书店</title>
    <link rel="icon" type="image/x-icon" href="../../images/icons/管理员.svg">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* 订单详情样式 */
        .order-detail-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .detail-section {
            background-color: white;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .detail-header {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 10px;
        }
        
        .detail-label {
            width: 120px;
            font-weight: bold;
            color: #666;
        }
        
        .detail-value {
            flex: 1;
        }
        
        /* 订单项列表 */
        .order-items {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .order-items th, .order-items td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        
        .order-items th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        
        .order-items tr:hover {
            background-color: #f5f5f5;
        }
        
        /* 返回按钮 */
        .back-button {
            display: inline-block;
            padding: 8px 15px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        
        .back-button:hover {
            background-color: #2980b9;
        }
        
        /* 订单状态标签 */
        .status-tag {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
        }
        
        .status-pending-payment { background-color: #ffc107; color: #fff; }
        .status-pending-shipping { background-color: #17a2b8; color: #fff; }
        .status-pending-receipt { background-color: #6f42c1; color: #fff; }
        .status-pending-review { background-color: #28a745; color: #fff; }
        .status-completed { background-color: #20c997; color: #fff; }
        .status-pending-refund { background-color: #dc3545; color: #fff; }
        .status-canceled { background-color: #6c757d; color: #fff; }
        
        /* 管理后台布局 */
        .admin-container {
            display: flex;
            min-height: calc(100vh - 60px);
        }
        
        .admin-main {
            flex: 1;
            padding: 20px;
            background-color: #f5f5f5;
            overflow-y: auto;
        }
        
        .admin-content {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- 引入统一的左侧菜单栏 -->
        <%@ include file="/common/leftbar.jsp" %>
        
        <!-- 右侧主内容 -->
        <main class="admin-main">
            <div class="admin-content">
                <div class="order-detail-container">
                    <!-- 返回按钮 -->
                    <a href="${pageContext.request.contextPath}/admin/order?action=list" class="back-button">← 返回订单列表</a>
                    
                    <h1>订单详情</h1>
                    
                    <!-- 订单基本信息 -->
                    <div class="detail-section">
                        <div class="detail-header">订单基本信息</div>
                        <div class="detail-row">
                            <div class="detail-label">订单ID:</div>
                            <div class="detail-value">${order.orderId}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">订单状态:</div>
                            <div class="detail-value">
                                <span class="status-tag ${order.orderStatus == '待支付' ? 'status-pending-payment' : 
                                                             order.orderStatus == '待发货' ? 'status-pending-shipping' : 
                                                             order.orderStatus == '待收货' ? 'status-pending-receipt' : 
                                                             order.orderStatus == '待评价' ? 'status-pending-review' : 
                                                             order.orderStatus == '已完成' ? 'status-completed' : 
                                                             order.orderStatus == '待退款' ? 'status-pending-refund' : 'status-canceled'}">
                                    ${order.orderStatus}
                                </span>
                            </div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">下单时间:</div>
                            <div class="detail-value">${order.createTime}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">订单金额:</div>
                            <div class="detail-value">¥${order.totalAmount}</div>
                        </div>
                    </div>
                    
                    <!-- 用户信息 -->
                    <div class="detail-section">
                        <div class="detail-header">用户信息</div>
                        <div class="detail-row">
                            <div class="detail-label">用户名:</div>
                            <div class="detail-value">${user.username}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">用户ID:</div>
                            <div class="detail-value">${user.userId}</div>
                        </div>
                    </div>
                    
                    <!-- 配送信息 -->
                    <div class="detail-section">
                        <div class="detail-header">配送信息</div>
                        <div class="detail-row">
                            <div class="detail-label">收货地址:</div>
                            <div class="detail-value">${order.deliveryAddress}</div>
                        </div>
                    </div>
                    
                    <!-- 订单项列表 -->
                    <div class="detail-section">
                        <div class="detail-header">订单项</div>
                        <table class="order-items">
                            <thead>
                                <tr>
                                    <th>书籍信息</th>
                                    <th>单价</th>
                                    <th>数量</th>
                                    <th>小计</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orderItems}" var="item">
                                    <tr>
                                        <td>
                                            <div>${item.book.bookName}</div>
                                            <div style="font-size: 12px; color: #666;">${item.book.author} - ${item.book.publisher}</div>
                                        </td>
                                        <td>¥${item.price}</td>
                                        <td>${item.quantity}</td>
                                        <td>¥${item.price * item.quantity}</td>
                                    </tr>
                                </c:forEach>
                                
                                <tr>
                                    <td colspan="3" style="text-align: right; font-weight: bold;">总计:</td>
                                    <td style="font-weight: bold;">¥${order.totalAmount}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- 操作按钮 -->
                    <div style="margin-top: 20px; text-align: right;">
                        <!-- 根据订单状态显示不同操作按钮 -->
                        <c:if test="${order.orderStatus == '待发货'}">
                            <a href="${pageContext.request.contextPath}/admin/order?action=ship&id=${order.orderId}" class="btn btn-warning">发货</a>
                        </c:if>
                        
                        <c:if test="${order.orderStatus == '待退款'}">
                            <a href="${pageContext.request.contextPath}/admin/order?action=refund&id=${order.orderId}" class="btn btn-danger">退款</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- 引入页脚 -->
    <%@ include file="../../common/footer.jsp" %>
</body>
</html>