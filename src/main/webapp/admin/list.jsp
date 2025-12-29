<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员管理 - 求知书店</title>
    <style>
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
        
        /* 原有样式保持不变 */
        .tab-container {
            margin-bottom: 20px;
        }
        
        .tab {
            display: inline-block;
            padding: 10px 20px;
            background-color: #f2f2f2;
            border: 1px solid #ddd;
            border-bottom: none;
            cursor: pointer;
            text-decoration: none;
            color: #333;
            border-radius: 5px 5px 0 0;
            margin-right: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        table, th, td {
            border: 1px solid #ddd;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
        }
        
        th {
            background-color: #f2f2f2;
        }
        
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        .btn {
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-right: 5px;
        }
        
        .btn:hover {
            background-color: #45a049;
        }
        
        .btn-danger {
            background-color: #f44336;
        }
        
        .btn-danger:hover {
            background-color: #da190b;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: inline-block;
            width: 100px;
            text-align: right;
            margin-right: 10px;
        }
        
        .form-group input {
            padding: 8px;
            width: 300px;
        }
        
        .message {
            color: red;
            text-align: center;
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
                    <h1>管理员管理</h1>
                </div>
                
                <!-- 原有内容保持不变 -->
                <c:if test="${not empty message}">
                    <div class="message">${message}</div>
                </c:if>
                
                <div class="tab-container">
                    <a href="${pageContext.request.contextPath}/admin/admins?tab=list" class="tab ${currentTab eq 'list' ? 'active' : ''}">管理员列表</a>
                    <a href="${pageContext.request.contextPath}/admin/admins?tab=add" class="tab ${currentTab eq 'add' ? 'active' : ''}">添加管理员</a>
                </div>
                
                <c:if test="${currentTab eq 'list'}">
                    <table>
                        <tr>
                            <th>管理员ID</th>
                            <th>用户名</th>
                            <th>邮箱</th>
                            <th>地址</th>
                            <th>邮编</th>
                            <th>注册时间</th>
                            <th>操作</th>
                        </tr>
                        <c:forEach var="admin" items="${admins}">
                            <tr>
                                <td>${admin.userId}</td>
                                <td>${admin.username}</td>
                                <td>${admin.email}</td>
                                <td>${admin.address}</td>
                                <td>${admin.postalCode}</td>
                                <td>${admin.registerTime}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/admins" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="deleteAdmin">
                                        <input type="hidden" name="userId" value="${admin.userId}">
                                        <button type="submit" class="btn btn-danger" onclick="return confirm('确定要删除这个管理员吗？');">删除</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:if>
                
                <c:if test="${currentTab eq 'add'}">
                    <form action="${pageContext.request.contextPath}/admin/admins" method="post">
                        <input type="hidden" name="action" value="addAdmin">
                        
                        <div class="form-group">
                            <label for="username">用户名：</label>
                            <input type="text" id="username" name="username" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="password">密码：</label>
                            <input type="password" id="password" name="password" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">邮箱：</label>
                            <input type="email" id="email" name="email" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="address">地址：</label>
                            <input type="text" id="address" name="address">
                        </div>
                        
                        <div class="form-group">
                            <label for="postalCode">邮编：</label>
                            <input type="text" id="postalCode" name="postalCode">
                        </div>
                        
                        <div style="text-align: center;">
                            <button type="submit" class="btn">添加管理员</button>
                        </div>
                    </form>
                </c:if>
            </div>
        </main>
    </div>
    
    <!-- 引入统一的页脚 -->
    <%@ include file="../common/footer.jsp" %>
</body>
</html>