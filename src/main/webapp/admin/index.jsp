<%--
  Created by IntelliJ IDEA.
  User: xijta
  Date: 2025/12/25
  Time: 09:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员后台 - 求知书店</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <style>
        /* 管理后台专属样式 */
        .admin-container {
            display: flex;
            min-height: calc(100vh - 60px); /* 减去导航栏高度 */
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
        
        .welcome-message {
            font-size: 16px;
            color: #7f8c8d;
        }
        
        .admin-stats {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        
        .stat-card {
            flex: 1;
            min-width: 200px;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        /* 快捷操作按钮 */
        .quick-actions {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        
        .quick-action-btn {
            flex: 1;
            min-width: 150px;
            padding: 15px;
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }
        
        .quick-action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        
        .quick-action-btn.primary {
            background-color: #3498db;
        }
        
        .quick-action-btn.success {
            background-color: #2ecc71;
        }
        
        .quick-action-btn.warning {
            background-color: #f39c12;
        }
        
        .quick-action-btn.danger {
            background-color: #e74c3c;
        }
        
        /* 响应式设计 */
        @media (max-width: 768px) {
            .admin-container {
                flex-direction: column;
            }

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
                    <h1>欢迎使用求知书店管理后台</h1>
                    <div class="welcome-message">
                        <% if (session.getAttribute("admin") != null) { %>
                            管理员: <%= session.getAttribute("username") %>
                        <% } %>
                    </div>
                </div>
                
                <!-- 快捷操作按钮 -->
                <div class="quick-actions">
                    <a href="book/add.jsp" class="quick-action-btn primary">添加新图书</a>
                    <a href="order/list.jsp?status=待处理" class="quick-action-btn warning">处理订单</a>
                    <a href="user/list.jsp" class="quick-action-btn danger">管理用户</a>
                    <a href="discount/add.jsp" class="quick-action-btn success">创建折扣</a>

                </div>
                
                <!-- 统计信息 -->
                <div class="admin-stats">
                    <div class="stat-card">
                        <div class="stat-icon book-icon">📚</div>
                        <div class="stat-content">
                            <h3>总图书数量</h3>
                            <p class="stat-number" id="totalBooks">0</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon order-icon">📦</div>
                        <div class="stat-content">
                            <h3>待处理订单</h3>
                            <p class="stat-number" id="pendingOrders">0</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon user-icon">👥</div>
                        <div class="stat-content">
                            <h3>注册用户</h3>
                            <p class="stat-number" id="totalUsers">0</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon discount-icon">🎟️</div>
                        <div class="stat-content">
                            <h3>活跃折扣</h3>
                            <p class="stat-number" id="activeDiscounts">0</p>
                        </div>
                    </div>
                </div>
                
                <!-- 系统公告 -->
                <div class="notice-board">
                    <h3>📢 系统公告</h3>
                    <div class="notice-item">
                        <a href="#">
                            <span>系统将于今晚23:00-次日凌晨2:00进行维护，请提前做好准备</span>
                            <span class="notice-date">2025-12-25</span>
                        </a>
                    </div>
                    <div class="notice-item">
                        <a href="#">
                            <span>双十二活动已结束，感谢您的参与</span>
                            <span class="notice-date">2025-12-13</span>
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- 引入页脚 -->
    <%@ include file="../common/footer.jsp" %>
</body>
</html>

<script>
    // 页面加载完成后获取统计数据
    document.addEventListener('DOMContentLoaded', function() {
        fetchStatistics();
    });

    function fetchStatistics() {
        // 发送AJAX请求获取统计数据
        const xhr = new XMLHttpRequest();
        xhr.open('GET', '/admin/getStatistics?format=json', true);
        xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    let statistics = JSON.parse(xhr.responseText);
                    updateStatistics(statistics);
                } catch (e) {
                    console.error('解析统计数据失败:', e);
                }
            }
        };
        xhr.send();
    }

    function updateStatistics(statistics) {
        // 更新统计数字
        document.getElementById('totalBooks').textContent = statistics.totalBooks;
        document.getElementById('pendingOrders').textContent = statistics.pendingOrders;
        document.getElementById('totalUsers').textContent = statistics.totalUsers;
        document.getElementById('activeDiscounts').textContent = statistics.activeDiscounts;
    }
</script>