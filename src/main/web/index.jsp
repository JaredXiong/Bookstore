<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>网上书店 - 首页</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">

</head>
<body>hello</body>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">📚 网上书店</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="index.jsp">首页</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="book/list.jsp">图书分类</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="cart/cart.jsp">购物车</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="order/orders.jsp">我的订单</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="user/login.jsp">登录</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="user/register.jsp">注册</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 轮播图和用户登录信息 -->
    <div class="container carousel-container">
        <div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
                <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>
                <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>
            </div>
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="images/banner1.jpg" class="d-block w-100" alt="图书促销">
                </div>
                <div class="carousel-item">
                    <img src="images/banner2.jpg" class="d-block w-100" alt="新书推荐">
                </div>
                <div class="carousel-item">
                    <img src="images/banner3.jpg" class="d-block w-100" alt="阅读节活动">
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>

        <!-- 用户登录信息 -->
        <div class="user-info">
            <h4 class="mb-3">欢迎光临</h4>
            <%-- 判断用户是否登录，这里使用session示例 --%>
            <% if (session.getAttribute("user") == null) { %>
                <p>请登录后享受更多服务</p>
                <a href="user/login.jsp" class="btn btn-primary w-100 mb-2">登录</a>
                <a href="user/register.jsp" class="btn btn-secondary w-100">注册</a>
            <% } else { %>
                <p>欢迎回来，<%= session.getAttribute("username") %></p>
                <a href="user/profile.jsp" class="btn btn-primary w-100 mb-2">个人中心</a>
                <a href="user/logout.jsp" class="btn btn-secondary w-100">退出登录</a>
            <% } %>
        </div>
    </div>

    <!-- 图书秒杀 -->
    <div class="container mt-5">
        <h2 class="section-title">📢 限时秒杀</h2>
        <div class="countdown text-center">
            距离结束还有：
            <span class="countdown-item" id="hours">00</span>:
            <span class="countdown-item" id="minutes">00</span>:
            <span class="countdown-item" id="seconds">00</span>
        </div>
        <div class="row">
            <!-- 秒杀图书卡片 -->
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book1.jpg" alt="Java编程思想">
                    <div class="book-card-body">
                        <div class="book-title">Java编程思想</div>
                        <div class="book-author">Bruce Eckel</div>
                        <div class="book-price">¥59.90 <span class="original-price">¥129.00</span></div>
                        <a href="book/detail.jsp?id=1" class="btn btn-danger btn-sm w-100 mt-2">立即抢购</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book2.jpg" alt="深入理解计算机系统">
                    <div class="book-card-body">
                        <div class="book-title">深入理解计算机系统</div>
                        <div class="book-author">Randal E. Bryant</div>
                        <div class="book-price">¥69.90 <span class="original-price">¥139.00</span></div>
                        <a href="book/detail.jsp?id=2" class="btn btn-danger btn-sm w-100 mt-2">立即抢购</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book3.jpg" alt="Python编程：从入门到实践">
                    <div class="book-card-body">
                        <div class="book-title">Python编程：从入门到实践</div>
                        <div class="book-author">Eric Matthes</div>
                        <div class="book-price">¥49.90 <span class="original-price">¥99.00</span></div>
                        <a href="book/detail.jsp?id=3" class="btn btn-danger btn-sm w-100 mt-2">立即抢购</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book4.jpg" alt="算法导论">
                    <div class="book-card-body">
                        <div class="book-title">算法导论</div>
                        <div class="book-author">Thomas H. Cormen</div>
                        <div class="book-price">¥79.90 <span class="original-price">¥159.00</span></div>
                        <a href="book/detail.jsp?id=4" class="btn btn-danger btn-sm w-100 mt-2">立即抢购</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 精选图书 -->
    <div class="container mt-5">
        <h2 class="section-title">⭐ 精选图书</h2>
        <div class="row">
            <!-- 精选图书卡片 -->
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book5.jpg" alt="设计模式">
                    <div class="book-card-body">
                        <div class="book-title">设计模式：可复用面向对象软件的基础</div>
                        <div class="book-author">Erich Gamma</div>
                        <div class="book-price">¥89.00</div>
                        <a href="book/detail.jsp?id=5" class="btn btn-primary btn-sm w-100 mt-2">查看详情</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book6.jpg" alt="重构：改善既有代码的设计">
                    <div class="book-card-body">
                        <div class="book-title">重构：改善既有代码的设计</div>
                        <div class="book-author">Martin Fowler</div>
                        <div class="book-price">¥79.00</div>
                        <a href="book/detail.jsp?id=6" class="btn btn-primary btn-sm w-100 mt-2">查看详情</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book7.jpg" alt="代码整洁之道">
                    <div class="book-card-body">
                        <div class="book-title">代码整洁之道</div>
                        <div class="book-author">Robert C. Martin</div>
                        <div class="book-price">¥69.00</div>
                        <a href="book/detail.jsp?id=7" class="btn btn-primary btn-sm w-100 mt-2">查看详情</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book8.jpg" alt="人月神话">
                    <div class="book-card-body">
                        <div class="book-title">人月神话</div>
                        <div class="book-author">Frederick P. Brooks Jr.</div>
                        <div class="book-price">¥59.00</div>
                        <a href="book/detail.jsp?id=8" class="btn btn-primary btn-sm w-100 mt-2">查看详情</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 新书推荐 -->
    <div class="container mt-5">
        <h2 class="section-title">📖 新书推荐</h2>
        <div class="row">
            <!-- 新书推荐卡片 -->
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book9.jpg" alt="AI新时代">
                    <div class="book-card-body">
                        <div class="book-title">AI新时代：人工智能的商业应用</div>
                        <div class="book-author">吴军</div>
                        <div class="book-price">¥99.00</div>
                        <a href="book/detail.jsp?id=9" class="btn btn-primary btn-sm w-100 mt-2">查看详情</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book10.jpg" alt="数据分析实战">
                    <div class="book-card-body">
                        <div class="book-title">数据分析实战：使用Python进行数据挖掘</div>
                        <div class="book-author">李航</div>
                        <div class="book-price">¥89.00</div>
                        <a href="book/detail.jsp?id=10" class="btn btn-primary btn-sm w-100 mt-2">查看详情</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book11.jpg" alt="云计算架构">
                    <div class="book-card-body">
                        <div class="book-title">云计算架构设计：原理与实践</div>
                        <div class="book-author">王珊</div>
                        <div class="book-price">¥109.00</div>
                        <a href="book/detail.jsp?id=11" class="btn btn-primary btn-sm w-100 mt-2">查看详情</a>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="book-card">
                    <img src="images/book12.jpg" alt="网络安全技术">
                    <div class="book-card-body">
                        <div class="book-title">网络安全技术与实践</div>
                        <div class="book-author">张焕国</div>
                        <div class="book-price">¥99.00</div>
                        <a href="book/detail.jsp?id=12" class="btn btn-primary btn-sm w-100 mt-2">查看详情</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 页脚 -->
    <footer>
        <div class="container text-center">
            <p>&copy; 2025 网上书店. All rights reserved.</p>
            <p>联系我们 | 关于我们 | 隐私政策 | 服务条款</p>
        </div>
    </footer>

    <!-- 引入Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- 秒杀倒计时脚本 -->
    <script>
        // 设置秒杀结束时间（示例：当前时间+2小时）
        const endTime = new Date();
        endTime.setHours(endTime.getHours() + 2);

        function updateCountdown() {
            const now = new Date();
            const difference = endTime - now;

            if (difference > 0) {
                const hours = Math.floor(difference / (1000 * 60 * 60));
                const minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((difference % (1000 * 60)) / 1000);

                document.getElementById('hours').textContent = String(hours).padStart(2, '0');
                document.getElementById('minutes').textContent = String(minutes).padStart(2, '0');
                document.getElementById('seconds').textContent = String(seconds).padStart(2, '0');
            } else {
                // 秒杀结束，刷新页面或更新状态
                clearInterval(countdownInterval);
                document.querySelector('.countdown').innerHTML = '<span style="color: yellow;">秒杀已结束！</span>';
            }
        }

        // 初始化倒计时
        updateCountdown();
        const countdownInterval = setInterval(updateCountdown, 1000);
    </script>
</body>
</html>