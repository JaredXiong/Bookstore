<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>折扣管理 - 求知书店</title>
    <link rel="icon" type="image/x-icon" href="../../images/icons/管理员.svg">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* 折扣列表样式 */
        .admin-discount-list {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            max-width: 100%;
            table-layout: auto;
        }
        
        .admin-discount-list th, .admin-discount-list td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .admin-discount-list th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        
        .admin-discount-list tr:hover {
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
        
        /* 搜索和添加按钮区域 */
        .action-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .search-form {
            display: flex;
            gap: 10px;
        }
        
        .search-form input[type="text"] {
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
                    <h1>折扣管理</h1>
                    <!-- 操作栏 -->
                    <div class="action-bar">
                        <form class="search-form" action="${pageContext.request.contextPath}/admin/discount?action=search" method="get">
                            <label>
                                <input type="text" name="keyword" placeholder="搜索折扣..." value="${keyword}">
                            </label>
                            <button type="submit" class="btn btn-primary">搜索</button>
                        </form>
                        <a href="${pageContext.request.contextPath}/admin/discount/add.jsp" class="btn btn-primary">添加折扣</a>
                    </div>
                </div>
                
                <!-- 折扣列表 -->
                <div class="table-scroll-container">
                    <table class="admin-discount-list">
                        <thead>
                            <tr>
                                <th>折扣ID</th>
                                <th>折扣类型</th>
                                <th>折扣比例</th>
                                <th>适用图书范围</th>
                                <th>开始时间</th>
                                <th>结束时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${discounts}" var="discount">
                                <tr>
                                    <td>${discount.discountId}</td>
                                    <td>${discount.discountType}</td>
                                    <td>${discount.discountRate}%</td>
                                    <td>${discount.applicableBooks}</td>
                                    <td>${discount.startTime}</td>
                                    <td>${discount.endTime}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/discount?action=edit&id=${discount.discountId}" class="btn btn-warning">编辑</a>
                                        <a href="${pageContext.request.contextPath}/admin/discount?action=delete&id=${discount.discountId}" class="btn btn-danger">删除</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <!-- 分页控件 -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        显示第 <%= ((Integer) request.getAttribute("page") - 1) * (Integer) request.getAttribute("pageSize") + 1 %> 到 
                        <%= Math.min((Integer) request.getAttribute("page") * (Integer) request.getAttribute("pageSize"), (Integer) request.getAttribute("totalDiscounts")) %> 条，
                        共 <%= request.getAttribute("totalDiscounts") %> 条记录
                    </div>
                    <nav>
                        <ul class="pagination">
                            <!-- 分页逻辑 -->
                        </ul>
                    </nav>
                </div>
            </div>
        </main>
    </div>

    <!-- 引入页脚 -->
    <%@ include file="../../common/footer.jsp" %>
</body>
</html>