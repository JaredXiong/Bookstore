<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图书管理 - 求知书店</title>
    <style>
        /* 图书列表样式 */
        .admin-book-list {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            max-width: 100%;
            table-layout: auto; /* 改为自适应布局 */
        }

        .admin-book-list th, .admin-book-list td {
            border: 1px solid #ddd;
            padding: 8px; /* 缩小行高 */
            text-align: left;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .admin-book-list th {
            background-color: #f2f2f2;
            font-weight: bold;
        }

        .admin-book-list tr:hover {
            background-color: #f5f5f5;
        }

        .admin-book-cover {
            width: 60px; /* 缩小封面图片 */
            height: 80px; /* 缩小封面图片 */
            object-fit: cover;
        }

        /* 操作按钮样式 */
        .btn {
            padding: 4px 8px; /* 缩小按钮 */
            margin-right: 4px; /* 减小按钮间距 */
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 12px; /* 缩小按钮文字 */
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
            justify-content: flex-end;
            align-items: center;
            gap: 10px;
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
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination a {
            color: #3498db;
            padding: 8px 16px;
            text-decoration: none;
            border: 1px solid #ddd;
            margin: 0 4px;
            border-radius: 4px;
        }

        .pagination a.active {
            background-color: #3498db;
            color: white;
            border: 1px solid #3498db;
        }

        .pagination a:hover:not(.active) {
            background-color: #ddd;
        }

        /* 分页控件样式 */
        .pagination-container {
            margin-top: 20px;
            text-align: center;
        }

        .pagination {
            display: inline-flex;
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .pagination .page-item {
            margin: 0 2px;
            list-style: none;
        }

        .pagination .page-link {
            display: block;
            padding: 8px 12px;
            background-color: #fff;
            border: 1px solid #ddd;
            color: #333;
            text-decoration: none;
            border-radius: 4px;
        }

        .pagination .page-item.active .page-link {
            background-color: #007bff;
            border-color: #007bff;
            color: #fff;
        }

        .pagination .page-item.disabled .page-link {
            background-color: #eee;
            border-color: #ddd;
            color: #999;
            cursor: not-allowed;
        }

        .pagination-info {
            margin-top: 10px;
            font-size: 14px;
            color: #666;
        }


        /* 图书状态标签 */
        .status-tag {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
        }
        /* 图书类型标签 */
        .type-tag {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            background-color: #f0f0f0;
            white-space: nowrap;
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
            overflow-x: auto; /* 添加左右滑动功能 */
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
                    <h1>图书管理</h1>
                    <!-- 操作栏 -->
                    <div class="action-bar">
                        <form class="search-form" action="${pageContext.request.contextPath}/admin/book?action=search" method="get">
                            <label>
                                <input type="text" name="keyword" placeholder="搜索图书名称或作者..." value="${keyword}">
                            </label>
                            <button type="submit" class="btn btn-primary">搜索</button>
                        </form>
                        <a href="${pageContext.request.contextPath}/admin/book/add.jsp" class="btn btn-primary">添加新图书</a>
                    </div>
                </div>

                <!-- 图书列表 - 添加滚动容器 -->
                <div class="table-scroll-container">
                    <table class="admin-book-list">
                        <thead>
                            <tr>
                                <th style="min-width: 80px;">图书封面</th>
                                <th style="min-width: 50px;">图书ID</th>
                                <th style="min-width: 80px;">ISBN</th>
                                <th style="min-width: 100px; width: 10%;">图书名称</th>
                                <th style="min-width: 50px;">作者</th>
                                <th style="min-width: 100px;">出版社</th>
                                <th style="min-width: 70px;">价格</th>
                                <th style="min-width: 50px;">库存</th>
                                <th style="min-width: 50px;">已售</th>
                                <th style="min-width: 70px;">类型</th>
                                <th style="min-width: 70px;">状态</th>
                                <th style="min-width: 100px;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="book" items="${books}">
                                <tr>
                                    <td><img src="${book.coverImage}" alt="${book.bookName}" class="admin-book-cover"></td>
                                    <td>${book.bookId}</td>
                                    <td>${book.ISBN}</td>
                                    <td>${book.bookName}</td>
                                    <td>${book.author}</td>
                                    <td>${book.publisher}</td>
                                    <td>¥${book.price}</td>
                                    <td>${book.stockNum}</td>
                                    <td>${book.soldNum}</td>
                                    <td>
                                        <span class="type-tag">
                                            <c:choose>
                                                <c:when test="${book.bookType == 1}">文学</c:when>
                                                <c:when test="${book.bookType == 2}">社科</c:when>
                                                <c:when test="${book.bookType == 3}">少儿</c:when>
                                                <c:when test="${book.bookType == 4}">技术</c:when>
                                                <c:otherwise>其他</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-tag ${book.isActive ? 'status-active' : 'status-inactive'}">
                                            ${book.isActive ? '上架' : '下架'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/book?action=edit&id=${book.bookId}" class="btn btn-warning">编辑</a>
                                        <a href="${pageContext.request.contextPath}/admin/book?action=delete&id=${book.bookId}" class="btn btn-danger" onclick="return confirm('确定要删除这本书吗？')">删除</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <%-- 在图书列表表格下方添加分页控件 --%>
                <div class="pagination-container">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <%-- 上一页按钮 --%>
                            <li class="page-item <%= (Integer) request.getAttribute("page") == 1 ? "disabled" : "" %>">
                                <a class="page-link" href="<%= request.getContextPath() %>/admin/book?action=list&page=<%= (Integer) request.getAttribute("page") - 1 %>" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                    <span class="sr-only">上一页</span>
                                </a>
                            </li>

                            <%-- 页码按钮 --%>
                            <%
                               int currentPage = (Integer) request.getAttribute("page");
                               int totalPages = (Integer) request.getAttribute("totalPages");
                               int startPage = Math.max(1, currentPage - 2);
                               int endPage = Math.min(totalPages, currentPage + 2);

                               // 显示第一页
                               if (startPage > 1) {
                            %>
                            <li class="page-item"><a class="page-link" href="<%= request.getContextPath() %>/admin/book?action=list&page=1">1</a></li>
                            <% if (startPage > 2) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            <% } %>
                            <% } %>

                            <%-- 显示中间页码 --%>
                            <% for (int i = startPage; i <= endPage; i++) { %>
                            <li class="page-item <%= i == currentPage ? "active" : "" %>">
                                <a class="page-link" href="<%= request.getContextPath() %>/admin/book?action=list&page=<%= i %>"><%= i %></a>
                            </li>
                            <% } %>

                            <%-- 显示最后一页 --%>
                            <% if (endPage < totalPages) { %>
                            <% if (endPage < totalPages - 1) { %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            <% } %>
                            <li class="page-item"><a class="page-link" href="<%= request.getContextPath() %>/admin/book?action=list&page=<%= totalPages %>"><%= totalPages %></a></li>
                            <% } %>

                            <%-- 下一页按钮 --%>
                            <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                                <a class="page-link" href="<%= request.getContextPath() %>/admin/book?action=list&page=<%= currentPage + 1 %>" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                    <span class="sr-only">下一页</span>
                                </a>
                            </li>
                        </ul>
                    </nav>

                    <div class="pagination-info">
                        显示第 <%= ((Integer) request.getAttribute("page") - 1) * (Integer) request.getAttribute("pageSize") + 1 %> 到
                        <%= Math.min((Integer) request.getAttribute("page") * (Integer) request.getAttribute("pageSize"), (Integer) request.getAttribute("totalBooks")) %> 条，
                        共 <%= request.getAttribute("totalBooks") %> 条记录
                    </div>
                </div>

                <%-- 添加一些CSS样式使分页更美观 --%>
                <style>
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
                </style>
            </div>
        </main>
    </div>

    <!-- 引入页脚 -->
    <%@ include file="../../common/footer.jsp" %>
</body>
</html>