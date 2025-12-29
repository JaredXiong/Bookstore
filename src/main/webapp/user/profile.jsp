<%@ page import="com.bookstore.entity.User" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>用户个人中心 - 求知书店</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <style>
        /* 个人中心样式 */
        .profile-container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }

        .profile-sidebar {
            width: 250px;
            background-color: #f5f5f5;
            padding: 20px;
            border-radius: 8px;
            margin-right: 30px;
        }

        .profile-sidebar h3 {
            margin-bottom: 20px;
            color: #333;
        }

        .profile-menu {
            list-style: none;
            padding: 0;
        }

        .profile-menu li {
            margin-bottom: 10px;
        }

        .profile-menu a {
            display: block;
            padding: 10px 15px;
            color: #333;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .profile-menu a:hover {
            background-color: #e9e9e9;
        }

        .profile-menu a.active {
            background-color: #4CAF50;
            color: white;
        }

        .profile-content {
            flex: 1;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .profile-content h2 {
            margin-bottom: 20px;
            color: #333;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }

        /* 个人信息样式 */
        .profile-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-item label {
            font-weight: bold;
            margin-bottom: 5px;
            color: #666;
        }

        .info-item span {
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 4px;
        }

        /* 表单样式 */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #666;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        .form-group input:focus {
            outline: none;
            border-color: #4CAF50;
        }

        /* 按钮样式 */
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background-color: #45a049;
        }

        .btn-danger {
            background-color: #f44336;
            color: white;
        }

        .btn-danger:hover {
            background-color: #da190b;
        }

        .btn-secondary {
            background-color: #e7e7e7;
            color: black;
        }

        .btn-secondary:hover {
            background-color: #ddd;
        }

        .btn:disabled {
            background-color: #cccccc;
            color: #666666;
            cursor: not-allowed;
        }

        /* 消息提示样式 */
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }

        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* 警告样式 */
        .warning-box {
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<!-- 引入导航栏 -->
<%@ include file="../common/header.jsp" %>

<div class="profile-container">
    <!-- 左侧菜单 -->
    <div class="profile-sidebar">
        <h3>个人中心</h3>
        <ul class="profile-menu">
            <li><a href="${pageContext.request.contextPath}/user/profile?action=viewProfile" class="${param.menu == 'profile' ? 'active' : ''}">个人信息</a></li>
            <li><a href="${pageContext.request.contextPath}/user/profile.jsp?menu=editProfile" class="${param.menu == 'editProfile' ? 'active' : ''}">修改信息</a></li>
            <li><a href="${pageContext.request.contextPath}/user/profile?action=cancelUser" class="${param.menu == 'cancelUser' ? 'active' : ''}">注销用户</a></li>
        </ul>
    </div>

    <!-- 右侧内容 -->
    <div class="profile-content">
        <% String menu = request.getParameter("menu");
           if (menu == null) {
               menu = "profile";
           }
           // 检查request中是否有更新后的user信息，如果有则使用它
           if (request.getAttribute("user") != null) {
               user = (User) request.getAttribute("user");
           }
        %>

        <!-- 个人信息 -->
        <% if ("profile".equals(menu)) { %>
            <h2>个人信息</h2>
            <% if (user != null) { %>
                <div class="profile-info">
                    <div class="info-item">
                        <label>用户名</label>
                        <span><%= user.getUsername() %></span>
                    </div>
                    <div class="info-item">
                        <label>邮箱</label>
                        <span><%= user.getEmail() %></span>
                    </div>
                    <div class="info-item">
                        <label>地址</label>
                        <span><%= user.getAddress() %></span>
                    </div>
                    <div class="info-item">
                        <label>邮编</label>
                        <span><%= user.getPostalCode() %></span>
                    </div>
                    <div class="info-item">
                        <label>用户类型</label>
                        <span><%= "user".equals(user.getUserType()) ? "普通用户" : "管理员" %></span>
                    </div>
                    <div class="info-item">
                        <label>注册时间</label>
                        <span><%= user.getRegisterTime() %></span>
                    </div>
                </div>
            <% } %>

        <!-- 修改信息 -->
        <% } else if ("editProfile".equals(menu)) { %>
            <h2>修改个人信息</h2>
            <% if (request.getAttribute("message") != null) { %>
                <div class="message success">
                    <%= request.getAttribute("message") %>
                </div>
            <% } %>
            <% if (user != null) { %>
                <form action="${pageContext.request.contextPath}/user/profile?action=updateProfile" method="post">
                    <div class="form-group">
                        <label for="username">用户名</label>
                        <input type="text" id="username" name="username" value="<%= user.getUsername() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="email">邮箱</label>
                        <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="address">地址</label>
                        <input type="text" id="address" name="address" value="<%= user.getAddress() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="postalCode">邮编</label>
                        <input type="text" id="postalCode" name="postalCode" value="<%= user.getPostalCode() %>" required>
                    </div>
                    <button type="submit" class="btn btn-primary">保存修改</button>
                </form>
            <% } %>

        <!-- 注销用户 -->
        <% } else if ("cancelUser".equals(menu)) { %>
            <h2>注销用户</h2>
            <div class="warning-box">
                <h4>⚠️ 警告</h4>
                <p>注销账户将永久删除您的所有信息，包括订单历史、购物车内容等。此操作不可撤销，请谨慎考虑！</p>
            </div>

            <% Boolean hasUncompletedOrders = (Boolean) request.getAttribute("hasUncompletedOrders");
               if (hasUncompletedOrders == null) {
                   hasUncompletedOrders = false;
               }
            %>

            <% if (hasUncompletedOrders) { %>
                <div class="message error">
                    <p>您还有未完成的订单，请先完成或取消相关订单后再注销账户！</p>
                    <p><a href="${pageContext.request.contextPath}/user/order?action=list">查看订单</a></p>
                </div>
                <button class="btn btn-danger" disabled>确认注销</button>
                <a href="${pageContext.request.contextPath}/user/profile?action=viewProfile" class="btn btn-secondary">返回</a>
            <% } else { %>
                <p>您确定要注销账户吗？</p>
                <form action="${pageContext.request.contextPath}/user/profile?action=cancelUser" method="post">
                    <button type="submit" class="btn btn-danger">确认注销</button>
                    <a href="${pageContext.request.contextPath}/user/profile?action=viewProfile" class="btn btn-secondary">取消</a>
                </form>
            <% } %>
        <% } %>
    </div>
</div>

<!-- 引入页脚 -->
<%@ include file="../common/footer.jsp" %>
</body>
</html>