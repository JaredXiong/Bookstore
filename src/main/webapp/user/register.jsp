<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 求知书店</title>
    <link rel="icon" type="image/x-icon" href="../images/icons/书城.svg">
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar">
        <div class="container navbar-container">
            <a href="../index.jsp" class="navbar-logo">📚 求知书店</a>
            <ul class="navbar-menu">
                <li><a href="../index.jsp">首页</a></li>
                <li><a href="../book/list.jsp">图书分类</a></li>
                <li><a href="#">公告栏</a></li>
            </ul>
        </div>
    </nav>

    <!-- 注册表单 -->
    <div class="container">
        <div class="form-container">
            <h2>用户注册</h2>
            
            <!-- 显示错误信息 -->
            <c:if test="${not empty errorMsg}">
                <div style='color: red; margin-bottom: 15px;'>${errorMsg}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/user/register" method="post">
                <div class="form-group">
                    <label for="username">用户名</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password">密码</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="email">邮箱</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="address">地址</label>
                    <input type="text" id="address" name="address" required>
                </div>
                <div class="form-group">
                    <label for="postalCode">邮政编码</label>
                    <input type="text" id="postalCode" name="postalCode" required>
                </div>
                <div class="form-actions">
                    <a href="login.jsp" class="form-link">已有账号？立即登录</a>
                    <button type="submit" class="btn btn-primary">注册</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 引入页脚 -->
    <%@ include file="../common/footer.jsp" %>
</body>
</html>