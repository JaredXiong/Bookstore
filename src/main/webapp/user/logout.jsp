<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>退出登录 - 求知书店</title>
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

    <div class="container">
        <div class="form-container">
            <h2>退出登录</h2>
            <p>您已成功退出登录！</p>
            <a href="../index.jsp" class="btn btn-primary">返回首页</a>
            <a href="login.jsp" class="btn btn-secondary">重新登录</a>
        </div>
    </div>

    <!-- 引入页脚 -->
    <%@ include file="../common/footer.jsp" %>
</body>
</html>