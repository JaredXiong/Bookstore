<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- 管理员左侧导航栏 -->
<aside class="admin-sidebar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-logo">📚 求知书店</a>
    <ul class="admin-nav">
        <li class="admin-nav-item">
            <a href="${pageContext.request.contextPath}/admin/index.jsp" class="admin-nav-link">首页</a>
        </li>
        
        <!-- 图书管理二级菜单 -->
        <li class="admin-nav-item has-submenu">
            <a href="#" class="admin-nav-link submenu-toggle">图书管理 ▼</a>
            <ul class="admin-submenu">
                <li><a href="${pageContext.request.contextPath}/admin/book?action=list" class="admin-submenu-link">图书列表</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/book/add.jsp" class="admin-submenu-link">添加图书</a></li>
            </ul>
        </li>
        
        <li class="admin-nav-item">
            <a href="${pageContext.request.contextPath}/admin/order/list.jsp" class="admin-nav-link">订单管理</a>
        </li>
        <li class="admin-nav-item">
            <a href="${pageContext.request.contextPath}/admin/discount/list.jsp" class="admin-nav-link">折扣管理</a>
        </li>
        <li class="admin-nav-item">
            <a href="${pageContext.request.contextPath}/admin/comment/list.jsp" class="admin-nav-link">评论管理</a>
        </li>
        <li class="admin-nav-item">
            <a href="${pageContext.request.contextPath}/admin/user/list.jsp" class="admin-nav-link">用户管理</a>
        </li>
        <li class="admin-nav-item">
            <a href="${pageContext.request.contextPath}/admin/list.jsp" class="admin-nav-link">管理员管理</a>
        </li>
        <li class="admin-nav-item">
            <a href="${pageContext.request.contextPath}/admin/profile.jsp" class="admin-nav-link">管理员个人中心</a>
        </li>
    </ul>
</aside>

<style>

    /* 左侧导航栏 */
    .admin-sidebar {
        width: 250px;
        background-color: #2c3e50;
        color: white;
        padding: 20px 0;
        box-shadow: 2px 0 5px rgba(0,0,0,0.1);
    }

    .admin-sidebar .navbar-logo {
        display: block;
        text-align: center;
        margin-bottom: 30px;
        font-size: 20px;
        background-color: transparent;
    }

    .admin-sidebar .navbar-logo:hover {
        background-color: rgba(255,255,255,0.1);
    }

    .admin-nav {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .admin-nav-item {
        margin-bottom: 5px;
    }

    .admin-nav-link {
        display: block;
        padding: 15px 20px;
        color: white;
        text-decoration: none;
        transition: all 0.3s ease;
        border-left: 3px solid transparent;
    }

    .admin-nav-link:hover {
        background-color: rgba(255,255,255,0.1);
        border-left-color: #3498db;
        padding-left: 25px;
    }

    .admin-nav-link.active {
        background-color: rgba(52, 152, 219, 0.3);
        border-left-color: #3498db;
    }
    /* 二级菜单样式 */
    .has-submenu .submenu-toggle {
        position: relative;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .admin-submenu {
        list-style: none;
        padding: 0;
        margin: 0;
        display: none;
        background-color: rgba(0, 0, 0, 0.2);
    }
    
    .admin-submenu-link {
        display: block;
        padding: 10px 40px;
        color: white;
        text-decoration: none;
        transition: all 0.3s ease;
        font-size: 14px;
    }
    
    .admin-submenu-link:hover {
        background-color: rgba(255, 255, 255, 0.1);
        padding-left: 45px;
    }
    
    /* 显示二级菜单 */
    .has-submenu.active .admin-submenu {
        display: block;
    }
    
    /* 点击事件处理 */
    .submenu-toggle {
        cursor: pointer;
    }
</style>

<script>
    // 二级菜单展开/折叠功能
    document.addEventListener('DOMContentLoaded', function() {
        const submenuToggles = document.querySelectorAll('.submenu-toggle');
        
        submenuToggles.forEach(toggle => {
            toggle.addEventListener('click', function(e) {
                e.preventDefault();
                const parentItem = this.parentElement;
                parentItem.classList.toggle('active');
            });
        });
        
        // 自动激活当前页面的导航项
        const currentUrl = window.location.href;
        const navLinks = document.querySelectorAll('.admin-nav-link, .admin-submenu-link');
        
        navLinks.forEach(link => {
            // 处理相对路径和绝对路径
            const linkUrl = link.href;
            if (currentUrl.includes(linkUrl)) {
                link.classList.add('active');
                
                // 如果是子菜单链接，同时激活父菜单
                if (link.classList.contains('admin-submenu-link')) {
                    const parentItem = link.closest('.has-submenu');
                    if (parentItem) {
                        parentItem.classList.add('active');
                    }
                }
            }
        });
    });
</script>