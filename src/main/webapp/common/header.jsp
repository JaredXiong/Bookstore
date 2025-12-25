<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- 导航栏 -->
<nav class="navbar">
    <div class="container navbar-container">
        <a href="index.jsp" class="navbar-logo">📚 求知书店</a>
        <ul class="navbar-menu">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="book/list.jsp">图书分类</a></li>
            <li><a href="#">公告栏</a></li>
            <li><a href="user/profile.jsp">个人中心</a></li>
        </ul>

        <!-- 添加搜索栏 -->
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/user/book?action=search" method="get">
                <label>
                    <input type="text" name="keyword" class="search-input" placeholder="搜索图书...">
                    <button type="submit" class="search-btn">搜索</button>
                </label>
            </form>
        </div>

        <div class="navbar-right">
            <%-- 判断用户是否登录 --%>
            <% if (session.getAttribute("user") == null) { %>
            <a href="user/login.jsp" class="btn btn-primary">登录</a>
            <a href="user/register.jsp" class="btn btn-secondary">注册</a>
            <% } else { %>
            <div class="user-info">
                <span>欢迎, <%= session.getAttribute("username") %></span>
                <a href="user/profile.jsp" class="btn btn-primary">个人中心</a>
                <a href="${pageContext.request.contextPath}/user/logout" class="btn btn-secondary">退出</a>
            </div>
            <% } %>
        </div>
    </div>
</nav>