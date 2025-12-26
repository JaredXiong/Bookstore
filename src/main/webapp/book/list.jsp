<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.bookstore.entity.Book" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>图书列表</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
<!-- 引入导航栏 -->
<%@ include file="../common/header.jsp" %>

<div class="container">
    <h2>图书分类</h2>

    <!-- 类别筛选 -->
    <div class="category-filter">
        <h3>图书分类</h3>
        <ul>
            <li><a href="${pageContext.request.contextPath}/user/book?action=list" ${requestScope.selectedType == null ? 'class="active"' : ''}>全部</a></li>
            <li><a href="${pageContext.request.contextPath}/user/book?action=byType&type=1" ${requestScope.selectedType == 1 ? 'class="active"' : ''}>文学</a></li>
            <li><a href="${pageContext.request.contextPath}/user/book?action=byType&type=2" ${requestScope.selectedType == 2 ? 'class="active"' : ''}>社科</a></li>
            <li><a href="${pageContext.request.contextPath}/user/book?action=byType&type=3" ${requestScope.selectedType == 3 ? 'class="active"' : ''}>少儿</a></li>
            <li><a href="${pageContext.request.contextPath}/user/book?action=byType&type=4" ${requestScope.selectedType == 4 ? 'class="active"' : ''}>技术</a></li>
            <li><a href="${pageContext.request.contextPath}/user/book?action=byType&type=5" ${requestScope.selectedType == 5 ? 'class="active"' : ''}>其他</a></li>
        </ul>
    </div>

    <!-- 图书列表 -->
    <div class="book-list">
        <%
            List<Book> books = (List<Book>) request.getAttribute("books");
            if (books != null && !books.isEmpty()) {
                for (Book book : books) {
        %>
        <div class="book-item">
            <img src="${pageContext.request.contextPath}<%= book.getCoverImage() %>" alt="<%= book.getBookName() %>" class="book-cover">
            <a href="${pageContext.request.contextPath}/user/book?action=detail&id=<%= book.getBookId() %>"><%= book.getBookName() %></a>
            <p class="book-author">作者：<%= book.getAuthor() %></p>
            <p class="book-publisher">出版社：<%= book.getPublisher() %></p>
            <p class="book-price">价格：¥<%= book.getPrice() %></p>
            <p class="book-stock">库存：<%= book.getStockNum() %></p>
        </div>
        <%
                }
            } else {
        %>
        <p class="no-books">暂无图书</p>
        <%
            }
        %>
    </div>
</div>

<!-- 引入页脚 -->
<%@ include file="../common/footer.jsp" %>
</body>
</html>