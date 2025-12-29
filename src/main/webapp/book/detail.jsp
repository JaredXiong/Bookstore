<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.bookstore.entity.Book" %>
<%@ page import="com.bookstore.entity.BookImage" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
    <title>图书详情</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
<!-- 引入导航栏 -->
<%@ include file="../common/header.jsp" %>

<div class="book-detail-container">
    <!-- 左侧轮播图 -->
    <div class="book-images">
        <% 
            Book book = (Book) request.getAttribute("book");
            List<BookImage> bookImages = (List<BookImage>) request.getAttribute("bookImages");
            
            // 创建一个包含所有图片的列表
            List<String> allImages = new ArrayList<>();
            // 先添加封面图片
            allImages.add(book.getCoverImage());
            // 再添加扩展图片
            if (bookImages != null && !bookImages.isEmpty()) {
                for (BookImage image : bookImages) {
                    allImages.add(image.getImageUrl());
                }
            }
        %>
        
        <div class="main-image">
            <% for (int i = 0; i < allImages.size(); i++) { %>
                <% String displayStyle = i == 0 ? "block" : "none"; %>
                <img id="carousel-img-<%= i %>" src="${pageContext.request.contextPath}<%= allImages.get(i) %>" alt="<%= book.getBookName() %>" 
                     style="display: <%= displayStyle %>;">
            <% } %>
            
            <!-- 轮播控制按钮 -->
            <button class="carousel-control prev" onclick="changeImage(-1)">&lt;</button>
            <button class="carousel-control next" onclick="changeImage(1)">&gt;</button>
        </div>
        
        <!-- 缩略图 -->
        <div class="thumbnails">
            <% for (int i = 0; i < allImages.size(); i++) {
                String thumbnailClass = i == 0 ? "active" : "";
            %>
                <div class="thumbnail <%= thumbnailClass %>" onclick="showImage(<%= i %>)">
                    <img src="${pageContext.request.contextPath}<%= allImages.get(i) %>" alt="<%= book.getBookName() %> 图片<%= i + 1 %>">
                </div>
            <% } %>
        </div>
    </div>
    
    <!-- 右侧图书信息 -->
    <div class="book-info">
        <h1><%= book.getBookName() %></h1>
        
        <div class="info-item">
            <span class="info-label">作者：</span>
            <span><%= book.getAuthor() %></span>
        </div>
        
        <div class="info-item">
            <span class="info-label">出版社：</span>
            <span><%= book.getPublisher() %></span>
        </div>
        
        <div class="info-item">
            <span class="info-label">ISBN：</span>
            <span><%= book.getISBN() %></span>
        </div>
        
        <div class="info-item">
            <span class="info-label">类别：</span>
            <span>
                <% 
                    String bookType = "未知";
                    switch (book.getBookType()) {
                        case 1: bookType = "文学"; break;
                        case 2: bookType = "社科"; break;
                        case 3: bookType = "少儿"; break;
                        case 4: bookType = "技术"; break;
                        case 5: bookType = "其他"; break;
                    }
                    <%= bookType %>
                %>
            </span>
        </div>
        
        <div class="info-item">
            <span class="info-label">已售：</span>
            <span><%= book.getSoldNum() %> 本</span>
        </div>
        
        <div class="info-item">
            <span class="info-label">库存：</span>
            <span><%= book.getStockNum() %> 本</span>
        </div>
        
        <div class="book-price">¥<%= book.getPrice() %></div>
        
        <div class="book-intro">
            <h4>图书简介</h4>
            <p><%= book.getIntroduction() %></p>
        </div>
        
        <!-- 购买按钮 -->
        <div class="buy-buttons">
            <div class="quantity-selector">
                <span>数量：</span>
                <label for="quantity"></label><input type="number" id="quantity" name="quantity" value="1" min="1" max="<%= book.getStockNum() %>" style="width: 60px; margin: 0 10px; text-align: center;">
                <span>库存：<%= book.getStockNum() %>本</span>
            </div>
            <a href="#" onclick="addToCart(<%= book.getBookId() %>)" class="btn btn-success">
                加入购物车
            </a>
            <a href="#" onclick="directBuy(<%= book.getBookId() %>)" class="btn btn-primary">
                立即购买
            </a>
        </div>
        
        <script>
        function addToCart(bookId) {
            const quantity = document.getElementById('quantity').value;
            window.location.href = '${pageContext.request.contextPath}/user/cart?action=addToCart&bookId=' + bookId + '&quantity=' + quantity;
        }
        
        function directBuy(bookId) {
            const quantity = document.getElementById('quantity').value;
            window.location.href = '${pageContext.request.contextPath}/user/order?action=fillAddress&bookId=' + bookId + '&quantity=' + quantity;
        }
        </script>
    </div>
</div>

<!-- 引入页脚 -->
<%@ include file="../common/footer.jsp" %>

<script>
    // 当前显示的图片索引
    let currentImageIndex = 0;
    // 获取所有图片元素
    const images = document.querySelectorAll('.main-image img');
    // 获取所有缩略图元素
    const thumbnails = document.querySelectorAll('.thumbnail');
    
    // 切换图片
    function showImage(index) {
        // 隐藏所有图片
        images.forEach(img => img.style.display = 'none');
        // 移除所有缩略图的active类
        thumbnails.forEach(thumb => thumb.classList.remove('active'));
        
        // 显示当前图片
        images[index].style.display = 'block';
        // 给当前缩略图添加active类
        thumbnails[index].classList.add('active');
        // 更新当前索引
        currentImageIndex = index;
    }
    
    // 切换到上一张或下一张图片
    function changeImage(direction) {
        let newIndex = currentImageIndex + direction;
        // 边界检查
        if (newIndex < 0) {
            newIndex = images.length - 1;
        } else if (newIndex >= images.length) {
            newIndex = 0;
        }
        // 显示新图片
        showImage(newIndex);
    }
</script>
</body>
</html>