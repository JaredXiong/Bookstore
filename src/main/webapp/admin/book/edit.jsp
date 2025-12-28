<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑图书 - 求知书店</title>
    <link rel="stylesheet" type="text/css" href="../../css/style.css">
    <style>
        /* 管理后台布局样式 */
        .admin-container {
            display: flex;
            min-height: 100vh;
        }
        
        .admin-main {
            flex: 1;
            background-color: #f5f7fa;
            padding: 20px;
        }
        
        .admin-content {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .admin-header h1 {
            margin: 0;
            color: #333;
            font-size: 24px;
        }
        
        /* 表单样式 */
        .book-form {
            max-width: 600px;
            margin: 0 auto;
        }
        
        .book-form .form-group {
            margin-bottom: 20px;
        }
        
        .book-form .form-group > label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .book-form .form-group input[type="text"],
        .book-form .form-group input[type="number"],
        .book-form .form-group input[type="file"],
        .book-form .form-group select,
        .book-form .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        
        .book-form .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        
        /* 复选框组样式 - 确保不受全局CSS影响 */
        .book-form .form-group .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 5px;
        }
        
        .book-form .form-group .checkbox-group input[type="checkbox"] {
            width: auto;
            margin: 0;
        }
        
        .book-form .form-group .checkbox-group label {
            display: inline-block !important;
            margin-bottom: 0 !important;
            font-weight: normal !important;
            cursor: pointer;
        }
        
        /* 按钮样式 */
        .btn {
            padding: 10px 20px;
            margin-right: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }
        
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #2980b9;
        }
        
        .btn-secondary {
            background-color: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        
        /* 图书封面预览 */
        .cover-preview {
            margin-top: 10px;
            max-width: 200px;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- 引入统一的左侧菜单栏 -->
        <%@ include file="../../common/leftbar.jsp" %>
        
        <!-- 右侧主内容 -->
        <main class="admin-main">
            <div class="admin-content">
                <div class="admin-header">
                    <h1>编辑图书信息</h1>
                    <!-- 返回图书列表按钮 -->
                    <a href="${pageContext.request.contextPath}/admin/book?action=list" class="btn btn-secondary">&laquo; 返回图书列表</a>
                </div>
                    <!-- 表单提交 action -->
                <form action="${pageContext.request.contextPath}/admin/book?action=update" method="post" class="book-form">

                    <!-- 隐藏字段：图书ID -->
                    <input type="hidden" name="bookId" value="${book.bookId}">
                    
                    <div class="form-group">
                        <label for="ISBN">ISBN</label>
                        <input type="text" id="ISBN" name="ISBN" value="${book.ISBN}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="bookName">图书名称</label>
                        <input type="text" id="bookName" name="bookName" value="${book.bookName}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="author">作者</label>
                        <input type="text" id="author" name="author" value="${book.author}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="publisher">出版社</label>
                        <input type="text" id="publisher" name="publisher" value="${book.publisher}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="price">价格</label>
                        <input type="number" id="price" name="price" step="0.01" min="0" value="${book.price}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="stockNum">库存数量</label>
                        <input type="number" id="stockNum" name="stockNum" min="0" value="${book.stockNum}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="soldNum">已售数量</label>
                        <input type="number" id="soldNum" name="soldNum" min="0" value="${book.soldNum}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="introduction">图书简介</label>
                        <textarea id="introduction" name="introduction" required>${book.introduction}</textarea>
                    </div>
                    
                    <div class="form-group">
                        <label for="coverImage">封面图片路径</label>
                        <input type="text" id="coverImage" name="coverImage" value="${book.coverImage}" required>
                        <small>提示：请输入图片在服务器上的相对路径，如 /images/book/cover.jpg</small>
                        <img src="${book.coverImage}" alt="${book.bookName}" class="cover-preview">
                    </div>
                    
                    <div class="form-group">
                        <label for="bookType">图书类型</label>
                        <select id="bookType" name="bookType" required>
                            <option value="1" ${book.bookType == 1 ? 'selected' : ''}>文学</option>
                            <option value="2" ${book.bookType == 2 ? 'selected' : ''}>社科</option>
                            <option value="3" ${book.bookType == 3 ? 'selected' : ''}>少儿</option>
                            <option value="4" ${book.bookType == 4 ? 'selected' : ''}>技术</option>
                            <option value="5" ${book.bookType == 5 ? 'selected' : ''}>其他</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="isActive">上架销售</label>
                        <div class="checkbox-group">
                            <input type="checkbox" id="isActive" name="isActive" ${book.isActive ? 'checked' : ''}>
                            <label for="isActive">是</label>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">保存修改</button>
                        <a href="?action=list" class="btn btn-secondary">取消</a>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <!-- 引入页脚 -->
    <%@ include file="../../common/footer.jsp" %>
</body>
</html>