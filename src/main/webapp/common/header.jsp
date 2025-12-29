<%@ page import="com.bookstore.entity.User" %>
<%@ page import="com.bookstore.entity.ShoppingCart" %>
<%@ page import="com.bookstore.service.CartService" %>
<%@ page import="com.bookstore.service.impl.CartServiceImpl" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- 导航栏 -->
<nav class="navbar">
    <div class="container navbar-container">
        <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-logo">📚 求知书店</a>
        <ul class="navbar-menu">
            <li><a href="${pageContext.request.contextPath}/index.jsp">首页</a></li>
            <li><a href="${pageContext.request.contextPath}/user/book?action=list">图书分类</a></li>
            <li><a href="#">公告栏</a></li>
            <% 
            // 获取购物车数量
            User user = (User) session.getAttribute("user");
            int cartCount = 0;
            if (user != null) {
                CartService cartService = new CartServiceImpl();
                List<ShoppingCart> cartItems = cartService.getCartItemsByUserId(user.getUserId());
                cartCount = cartItems.size();
            }
            %>
            <li><a href="${pageContext.request.contextPath}/user/cart?action=viewCart" class="cart-link">
                购物车 <span class="cart-count"><%= cartCount %></span>
            </a></li>
        </ul>

        <!-- 搜索栏 -->
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/user/book" method="get" class="search-form">
                <!-- 添加隐藏字段来传递 action参数 -->
                <input type="hidden" name="action" value="search">
                <div class="search-box">
                    <label for="search-input"></label><input type="text" name="keyword" id="search-input" class="search-input" placeholder="搜索图书...">
                    <div id="search-results" class="search-results"></div>
                </div>
                <button type="submit" class="search-btn">搜索</button>
            </form>
        </div>

        <!-- 在用户已登录的情况下显示"我的"下拉菜单 -->
        <div class="navbar-right">
            <% if (session.getAttribute("user") == null) { %>
                <a href="${pageContext.request.contextPath}/user/login.jsp" class="btn btn-primary">登录</a>
                <a href="${pageContext.request.contextPath}/user/register.jsp" class="btn btn-secondary">注册</a>
            <% } else { %>
                <span class="welcome-text">欢迎您, <%= session.getAttribute("username") %></span>
                <div class="dropdown">
                    <a href="#" class="dropdown-toggle">我的 ▼</a>
                    <div class="dropdown-menu">
                        <a href="${pageContext.request.contextPath}/user/profile?action=viewProfile" class="dropdown-item">个人中心</a>
                        <a href="${pageContext.request.contextPath}/user/order?action=list" class="dropdown-item">订单信息</a>
                        <div class="dropdown-divider"></div>
                        <a href="${pageContext.request.contextPath}/user/logout" class="dropdown-item logout-item">退出</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</nav>

<script>
// 实时搜索功能
let searchTimer;
const searchInput = document.getElementById('search-input');
const searchResults = document.getElementById('search-results');
const searchForm = document.querySelector('.search-form');

// 输入事件监听
searchInput.addEventListener('input', function() {
    const keyword = this.value.trim();
    
    // 清除之前的定时器
    clearTimeout(searchTimer);
    
    if (keyword.length < 1) {
        searchResults.innerHTML = '';
        searchResults.style.display = 'none';
        return;
    }
    
    // 设置新的定时器
    searchTimer = setTimeout(function() {
        fetchSearchResults(keyword);
    }, 300);
});

// 点击搜索结果跳转
searchResults.addEventListener('click', function(e) {
    const bookItem = e.target.closest('.search-result-item');
    if (bookItem) {
        const bookId = bookItem.dataset.bookid;
        window.location.href = '${pageContext.request.contextPath}/user/book?action=detail&id=' + bookId;
    }
});

// 点击页面其他地方隐藏搜索结果
document.addEventListener('click', function(e) {
    if (!e.target.closest('.search-container')) {
        searchResults.innerHTML = '';
        searchResults.style.display = 'none';
    }
});

// 防止表单提交时刷新页面
searchForm.addEventListener('submit', function(e) {
    if (searchInput.value.trim() === '') {
        e.preventDefault();
    }
});

// 获取搜索结果
function fetchSearchResults(keyword) {
    fetch('${pageContext.request.contextPath}/user/book?action=searchAuto&keyword=' + encodeURIComponent(keyword))
        .then(response => response.json())
        .then(data => {
            displaySearchResults(data);
        })
        .catch(error => {
            console.error('搜索失败:', error);
        });
}

// 显示搜索结果
function displaySearchResults(books) {
    if (books.length === 0) {
        searchResults.innerHTML = '<div class="search-result-item no-results">没有找到匹配的图书</div>';
        searchResults.style.display = 'block';
        return;
    }
    
    let html = '';
    books.forEach(book => {
        html += '<div class="search-result-item" data-bookid="' + book.bookId + '">';
        html += '<div class="book-info">';
        html += '<div class="book-title">' + book.bookName + '</div>';
        html += '<div class="book-meta">作者: ' + book.author + ' | 价格: ¥' + book.price + '</div>';
        html += '<div class="match-info">匹配: ' + book.matchFields.join(', ') + '</div>';
        html += '</div>';
        html += '</div>';
    });
    
    searchResults.innerHTML = html;
    searchResults.style.display = 'block';
}
</script>

<style>
/* 搜索框样式 */
.search-container {
    position: relative;
    display: flex;
    align-items: center;
}

.search-form {
    display: flex;
    align-items: center;
    gap: 8px;
    position: relative;
}

.search-box {
    position: relative;
}

.search-results {
    position: absolute;
    top: 100%;
    left: 0;
    width: 350px;
    max-height: 300px;
    overflow-y: auto;
    background: white;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    box-shadow: 0 6px 16px rgba(0,0,0,0.12);
    z-index: 1000;
    display: none;
    margin-top: 8px;
}

.search-result-item {
    padding: 12px 16px;
    cursor: pointer;
    border-bottom: 1px solid #f0f0f0;
    transition: background-color 0.2s ease;
}

.search-result-item:last-child {
    border-bottom: none;
}

.search-result-item:hover {
    background-color: #f8f9fa;
}

.search-result-item.no-results {
    cursor: default;
    color: #666;
    text-align: center;
    background-color: #fafafa;
}

.book-info {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.book-title {
    font-weight: 600;
    color: #333;
    font-size: 14px;
}

.book-meta {
    font-size: 12px;
    color: #666;
}

.match-info {
    font-size: 11px;
    color: #e74c3c;
    font-style: italic;
}
</style>