<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单管理 - 求知书店</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* 订单列表样式 */
        .admin-order-list {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            max-width: 100%;
            table-layout: auto;
        }
        
        .admin-order-list th, .admin-order-list td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .admin-order-list th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        
        .admin-order-list tr:hover {
            background-color: #f5f5f5;
        }
        
        /* 操作按钮样式 */
        .btn {
            padding: 4px 8px;
            margin-right: 4px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 12px;
        }
        
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #2980b9;
        }
        
        .btn-warning {
            background-color: #f39c12;
            color: white;
        }
        
        .btn-warning:hover {
            background-color: #e67e22;
        }
        
        .btn-danger {
            background-color: #e74c3c;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #c0392b;
        }
        
        /* 搜索和筛选区域 */
        .action-bar {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .search-form {
            display: flex;
            gap: 10px;
        }
        
        .search-form input[type="text"], .search-form select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        /* 分页样式 */
        .pagination-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
        
        .pagination-info {
            font-size: 14px;
            color: #6c757d;
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
        
        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .admin-header h1 {
            margin: 0;
            color: #2c3e50;
            font-size: 24px;
        }
        
        /* 表格滚动容器 */
        .table-scroll-container {
            overflow-x: auto;
            margin-bottom: 20px;
        }
        
        /* 标签页样式 */
        .tabs {
            display: flex;
            margin-bottom: 20px;
            border-bottom: 1px solid #ddd;
        }
        
        .tab {
            padding: 10px 20px;
            cursor: pointer;
            border: none;
            background: none;
            font-size: 14px;
            font-weight: bold;
            color: #666;
            border-bottom: 3px solid transparent;
        }
        
        .tab.active {
            color: #3498db;
            border-bottom-color: #3498db;
        }
        
        .tab:hover {
            color: #3498db;
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
                <div class="admin-header">
                    <h1>订单管理</h1>
                    <!-- 操作栏 -->
                    <div class="action-bar">
                        <form class="search-form" action="${pageContext.request.contextPath}/admin/order" method="get">
                            <input type="hidden" name="action" value="search">
                            <label>
                                <input type="text" name="keyword" placeholder="搜索订单号或用户..." value="${keyword}">
                            </label>
                            <label>
                                <select name="status">
                                    <option value="" ${empty status ? 'selected' : ''}>所有状态</option>
                                    <option value="待支付" ${status == '待支付' ? 'selected' : ''}>待支付</option>
                                    <option value="待发货" ${status == '待发货' ? 'selected' : ''}>待发货</option>
                                    <option value="待收货" ${status == '待收货' ? 'selected' : ''}>待收货</option>
                                    <option value="待评价" ${status == '待评价' ? 'selected' : ''}>待评价</option>
                                    <option value="已完成" ${status == '已完成' ? 'selected' : ''}>已完成</option>
                                    <option value="待退款" ${status == '待退款' ? 'selected' : ''}>待退款</option>
                                    <option value="已取消" ${status == '已取消' ? 'selected' : ''}>已取消</option>
                                </select>
                            </label>
                            <button type="submit" class="btn btn-primary">搜索</button>
                        </form>
                    </div>
                </div>
                
                <!-- 标签页 -->
                <div class="tabs">
                    <a href="${pageContext.request.contextPath}/admin/order?action=list" class="tab ${not empty requestScope.orders && empty requestScope.isPending ? 'active' : ''}">所有订单</a>
                    <a href="${pageContext.request.contextPath}/admin/order?action=pending" class="tab ${not empty requestScope.isPending ? 'active' : ''}">待处理订单</a>
                </div>
                
                <!-- 订单列表 -->
                <div class="table-scroll-container">
                    <table class="admin-order-list">
                        <thead>
                            <tr>
                                <th>订单ID</th>
                                <th>用户信息</th>
                                <th>订单金额</th>
                                <th>订单状态</th>
                                <th>下单时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${orders}" var="order">
                                <tr>
                                    <td>${order.orderId}</td>
                                    <!-- 在订单列表中显示用户信息的位置 -->
                                    <c:set var="userAttrName" value="user_${order.orderId}" />
                                    <td>${requestScope[userAttrName].username}</td>
                                    <td>¥${order.totalAmount}</td>
                                    <td>
                                        <span class="status-tag ${order.orderStatus == '待支付' ? 'status-pending-payment' : 
                                                                 order.orderStatus == '待发货' ? 'status-pending-shipping' : 
                                                                 order.orderStatus == '待收货' ? 'status-pending-receipt' : 
                                                                 order.orderStatus == '待评价' ? 'status-pending-review' : 
                                                                 order.orderStatus == '已完成' ? 'status-completed' : 
                                                                 order.orderStatus == '待退款' ? 'status-pending-refund' : 'status-canceled'}">
                                            ${order.orderStatus}
                                        </span>
                                    </td>
                                    <td>${order.createTime}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/order?action=detail&id=${order.orderId}" class="btn btn-primary">查看详情</a>
                                        
                                        <!-- 根据订单状态显示不同操作按钮 -->
                                        <c:if test="${order.orderStatus == '待发货'}">
                                            <a href="${pageContext.request.contextPath}/admin/order?action=ship&id=${order.orderId}" class="btn btn-warning">发货</a>
                                        </c:if>
                                        
                                        <c:if test="${order.orderStatus == '待退款'}">
                                            <a href="${pageContext.request.contextPath}/admin/order?action=refund&id=${order.orderId}" class="btn btn-danger">退款</a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <!-- 无订单时显示提示 -->
                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="6" style="text-align: center; color: #999; padding: 30px;">
                                        暂无订单
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- 引入页脚 -->
    <%@ include file="../../common/footer.jsp" %>
</body>
</html>