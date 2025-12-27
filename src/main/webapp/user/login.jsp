<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 求知书店</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <script>
        // 页面加载时自动填充表单
        window.onload = function() {
            // 获取Cookie
            function getCookie(name) {
                let nameEQ = name + "=";
                let ca = document.cookie.split(';');
                for(let i=0; i < ca.length; i++) {
                    let c = ca[i];
                    while (c.charAt(0)===' ') c = c.substring(1,c.length);
                    if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length,c.length);
                }
                return null;
            }
            
            // 自动填充用户名和密码
            let username = getCookie('remember_username');
            let password = getCookie('remember_password');
            if (username) {
                document.getElementById('username').value = username;
                if (password) {
                    document.getElementById('password').value = password;
                    document.getElementById('remember').checked = true;
                }
            }
        };
    </script>
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

    <!-- 登录表单 -->
    <div class="container">
        <div class="form-container">
            <a href="../admin/login.jsp" class="page-switch-btn">管理员端-></a>
            <h2>用户登录</h2>
            
            <!-- 显示错误信息 -->
            <% if (request.getAttribute("errorMsg") != null) {
                out.println("<div style='color: red; margin-bottom: 15px;'>" + request.getAttribute("errorMsg") + "</div>");
            } %>
            
            <!-- 显示成功消息 -->
            <% 
                String message = request.getParameter("message");
                if (message != null && !message.isEmpty()) {
                    out.println("<div style='color: green; margin-bottom: 15px;'>" + message + "</div>");
                }
            %>
            
            <form action="${pageContext.request.contextPath}/user/login" method="post">
                <div class="form-group">
                    <label for="username">用户名</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="password">密码</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-row">
                    <div class="checkbox-group">
                        <input type="checkbox" id="remember" name="remember" value="true">
                        <label for="remember">自动登录</label>
                    </div>
                    <div class="forgot-password">
                        <a href="#">忘记密码？</a>
                    </div>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary full-width-btn">登录</button>
                </div>
                <div class="form-actions">
                    <a href="register.jsp" class="form-link">还没有账号？立即注册</a>
                </div>
            </form>
        </div>
    </div>

    <!-- 引入页脚 -->
    <%@ include file="../common/footer.jsp" %>
</body>
</html>