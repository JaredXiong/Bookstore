<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.bookstore.entity.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员个人中心 - 求知书店</title>
    <link rel="icon" type="image/x-icon" href="../images/icons/管理员.svg">
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <style>
        /* 管理后台专属样式 */
        .admin-container {
            display: flex;
            min-height: calc(100vh - 60px);
        }
        
        /* 右侧主内容 */
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
        
        /* 个人中心样式 */
        .profile-tabs {
            display: flex;
            margin-bottom: 20px;
            border-bottom: 1px solid #ddd;
        }
        
        .profile-tab {
            padding: 12px 20px;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: all 0.3s;
        }
        
        .profile-tab:hover {
            background-color: #f5f5f5;
        }
        
        .profile-tab.active {
            border-bottom-color: #3498db;
            color: #3498db;
            font-weight: bold;
        }
        
        .profile-content {
            display: none;
        }
        
        .profile-content.active {
            display: block;
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
            border-color: #3498db;
        }
        
        /* 按钮样式 */
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
            margin-right: 10px;
        }
        
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #2980b9;
        }
        
        .btn-danger {
            background-color: #e74c3c;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #c0392b;
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
    <div class="admin-container">
        <!-- 引入统一的左侧菜单栏 -->
        <%@ include file="/common/leftbar.jsp" %>
        
        <!-- 右侧主内容 -->
        <main class="admin-main">
            <div class="admin-content">
                <div class="admin-header">
                    <h1>管理员个人中心</h1>
                </div>
                
                <!-- 标签页 -->
                <div class="profile-tabs">
                    <div class="profile-tab active" data-tab="profile">个人信息</div>
                    <div class="profile-tab" data-tab="edit">编辑信息</div>
                    <div class="profile-tab" data-tab="delete">注销账号</div>
                </div>
                
                <!-- 个人信息内容 -->
                <div id="profile" class="profile-content active">
                    <h2>个人信息</h2>
                    <% User admin = (User) session.getAttribute("admin");
                       if (admin == null) {
                           admin = (User) session.getAttribute("user");
                       }
                       if (admin != null) { %>
                        <div class="profile-info">
                            <div class="info-item">
                                <label>用户ID</label>
                                <span><%= admin.getUserId() %></span>
                            </div>
                            <div class="info-item">
                                <label>用户名</label>
                                <span><%= admin.getUsername() %></span>
                            </div>
                            <div class="info-item">
                                <label>邮箱</label>
                                <span><%= admin.getEmail() != null ? admin.getEmail() : "未设置" %></span>
                            </div>
                            <div class="info-item">
                                <label>地址</label>
                                <span><%= admin.getAddress() != null ? admin.getAddress() : "未设置" %></span>
                            </div>
                            <div class="info-item">
                                <label>邮编</label>
                                <span><%= admin.getPostalCode() != null ? admin.getPostalCode() : "未设置" %></span>
                            </div>
                            <div class="info-item">
                                <label>用户类型</label>
                                <span>管理员</span>
                            </div>
                            <div class="info-item">
                                <label>注册时间</label>
                                <span><%= admin.getRegisterTime() %></span>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="message error">
                            请先登录管理员账号
                        </div>
                    <% } %>
                </div>
                
                <!-- 编辑信息内容 -->
                <div id="edit" class="profile-content">
                    <h2>编辑个人信息</h2>
                    <% if (request.getAttribute("message") != null) { %>
                        <div class="message success">
                            <%= request.getAttribute("message") %>
                        </div>
                    <% } %>
                    <% if (admin != null) { %>
                        <form action="${pageContext.request.contextPath}/admin/profile?action=updateProfile" method="post">
                            <div class="form-group">
                                <label for="username">用户名</label>
                                <input type="text" id="username" name="username" value="<%= admin.getUsername() %>" readonly>
                            </div>
                            <div class="form-group">
                                <label for="email">邮箱</label>
                                <input type="email" id="email" name="email" value="<%= admin.getEmail() != null ? admin.getEmail() : "" %>">
                            </div>
                            <div class="form-group">
                                <label for="address">地址</label>
                                <input type="text" id="address" name="address" value="<%= admin.getAddress() != null ? admin.getAddress() : "" %>">
                            </div>
                            <div class="form-group">
                                <label for="postalCode">邮编</label>
                                <input type="text" id="postalCode" name="postalCode" value="<%= admin.getPostalCode() != null ? admin.getPostalCode() : "" %>">
                            </div>
                            <button type="submit" class="btn btn-primary">保存修改</button>
                        </form>
                    <% } else { %>
                        <div class="message error">
                            请先登录管理员账号
                        </div>
                    <% } %>
                </div>
                
                <!-- 注销账号内容 -->
                <div id="delete" class="profile-content">
                    <h2>注销账号</h2>
                    <div class="warning-box">
                        <h4>⚠️ 警告</h4>
                        <p>注销账户将永久删除您的所有信息，此操作不可撤销，请谨慎考虑！</p>
                    </div>
                    
                    <% Boolean isLastAdmin = (Boolean) request.getAttribute("isLastAdmin");
                       if (isLastAdmin == null) {
                           isLastAdmin = false;
                       }
                    %>
                    
                    <% if (isLastAdmin) { %>
                        <div class="message error">
                            <p>您是系统中的最后一名管理员，不能注销账号！</p>
                            <p>请先创建其他管理员账号后再执行此操作。</p>
                        </div>
                        <button class="btn btn-danger" disabled>确认注销</button>
                        <button class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/admin/index.jsp'">返回</button>
                    <% } else if (admin != null) { %>
                        <p>您确定要注销管理员账号吗？</p>
                        <form action="${pageContext.request.contextPath}/admin/profile?action=deleteAccount" method="post">
                            <button type="submit" class="btn btn-danger">确认注销</button>
                            <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/admin/index.jsp'">取消</button>
                        </form>
                    <% } else { %>
                        <div class="message error">
                            请先登录管理员账号
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    
    <!-- 引入页脚 -->
    <%@ include file="/common/footer.jsp" %>
    
    <script>
        // 标签页切换功能
        document.addEventListener('DOMContentLoaded', function() {
            const tabs = document.querySelectorAll('.profile-tab');
            const contents = document.querySelectorAll('.profile-content');
            
            tabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    const tabId = this.getAttribute('data-tab');
                    
                    // 移除所有活动状态
                    tabs.forEach(t => t.classList.remove('active'));
                    contents.forEach(c => c.classList.remove('active'));
                    
                    // 添加当前活动状态
                    this.classList.add('active');
                    document.getElementById(tabId).classList.add('active');
                });
            });
            
            // 根据URL参数设置默认标签页
            const urlParams = new URLSearchParams(window.location.search);
            const tabParam = urlParams.get('tab');
            if (tabParam) {
                const targetTab = document.querySelector(`.profile-tab[data-tab="${tabParam}"]`);
                if (targetTab) {
                    targetTab.click();
                }
            }
        });
    </script>
</body>
</html>