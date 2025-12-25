<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>求知书店 - 首页</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <!-- 引入导航栏 -->
    <%@ include file="common/header.jsp" %>

    <!-- 轮播图和用户信息 -->
    <div class="container carousel-container">
        <!-- 轮播图 -->
        <div class="carousel">
            <div class="carousel-slide active">
                <img src="https://via.placeholder.com/800x350/3498db/ffffff?text=图书促销活动" alt="图书促销">
            </div>
            <div class="carousel-slide">
                <img src="https://via.placeholder.com/800x350/e74c3c/ffffff?text=新书推荐" alt="新书推荐">
            </div>
            <div class="carousel-slide">
                <img src="https://via.placeholder.com/800x350/2ecc71/ffffff?text=阅读节活动" alt="阅读节活动">
            </div>

            <!-- 轮播指示器 -->
            <div class="carousel-indicators">
                <button class="carousel-indicator active" data-slide="0"></button>
                <button class="carousel-indicator" data-slide="1"></button>
                <button class="carousel-indicator" data-slide="2"></button>
            </div>

            <!-- 轮播控制按钮 -->
            <div class="carousel-controls">
                <button class="carousel-control" id="prevSlide">&lt;</button>
                <button class="carousel-control" id="nextSlide">&gt;</button>
            </div>
        </div>

        <!-- 用户信息卡片 -->
        <div class="user-info-card">
            <h4>欢迎光临求知书店</h4>
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

    <!-- 公告栏 -->
    <div class="container">
        <div class="notice-board">
            <h3>📢 最新公告</h3>
            <div class="notice-item">
                <a href="#">
                    <span>双十二大促活动开始啦！全场图书8折起</span>
                    <span class="notice-date">2025-12-01</span>
                </a>
            </div>
            <div class="notice-item">
                <a href="#">
                    <span>新书上架：《人工智能时代》现已开售</span>
                    <span class="notice-date">2025-11-28</span>
                </a>
            </div>
            <div class="notice-item">
                <a href="#">
                    <span>会员积分兑换活动即将结束，快来兑换吧</span>
                    <span class="notice-date">2025-11-25</span>
                </a>
            </div>
            <div class="notice-item">
                <a href="#">
                    <span>网站系统升级维护通知（12月5日凌晨2-4点）</span>
                    <span class="notice-date">2025-11-20</span>
                </a>
            </div>
        </div>
    </div>

    <!-- 图书秒杀 -->
    <div class="container">
        <h2 class="section-title">📢 限时秒杀</h2>
        <div class="countdown">
            距离结束还有：
            <span class="countdown-item" id="hours">02</span>:
            <span class="countdown-item" id="minutes">30</span>:
            <span class="countdown-item" id="seconds">45</span>
        </div>
        <div class="row">
            <!-- 秒杀图书卡片 -->
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/3498db/ffffff?text=Java编程思想" alt="Java编程思想">
                <div class="book-card-body">
                    <div class="book-title">Java编程思想</div>
                    <div class="book-author">Bruce Eckel</div>
                    <div class="book-price">¥59.90 <span class="original-price">¥129.00</span></div>
                    <a href="book/detail.jsp?id=1" class="btn btn-danger w-100 mt-2">立即抢购</a>
                </div>
            </div>
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/e74c3c/ffffff?text=深入理解计算机系统" alt="深入理解计算机系统">
                <div class="book-card-body">
                    <div class="book-title">深入理解计算机系统</div>
                    <div class="book-author">Randal E. Bryant</div>
                    <div class="book-price">¥69.90 <span class="original-price">¥139.00</span></div>
                    <a href="book/detail.jsp?id=2" class="btn btn-danger w-100 mt-2">立即抢购</a>
                </div>
            </div>
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/2ecc71/ffffff?text=Python编程" alt="Python编程：从入门到实践">
                <div class="book-card-body">
                    <div class="book-title">Python编程：从入门到实践</div>
                    <div class="book-author">Eric Matthes</div>
                    <div class="book-price">¥49.90 <span class="original-price">¥99.00</span></div>
                    <a href="book/detail.jsp?id=3" class="btn btn-danger w-100 mt-2">立即抢购</a>
                </div>
            </div>
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/f39c12/ffffff?text=算法导论" alt="算法导论">
                <div class="book-card-body">
                    <div class="book-title">算法导论</div>
                    <div class="book-author">Thomas H. Cormen</div>
                    <div class="book-price">¥79.90 <span class="original-price">¥159.00</span></div>
                    <a href="book/detail.jsp?id=4" class="btn btn-danger w-100 mt-2">立即抢购</a>
                </div>
            </div>
        </div>
    </div>

    <!-- 精选图书 -->
    <div class="container">
        <h2 class="section-title">⭐ 精选图书</h2>
        <div class="row">
            <!-- 精选图书卡片 -->
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/9b59b6/ffffff?text=设计模式" alt="设计模式">
                <div class="book-card-body">
                    <div class="book-title">设计模式：可复用面向对象软件的基础</div>
                    <div class="book-author">Erich Gamma</div>
                    <div class="book-price">¥89.00</div>
                    <a href="book/detail.jsp?id=5" class="btn btn-primary w-100 mt-2">查看详情</a>
                </div>
            </div>
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/1abc9c/ffffff?text=重构" alt="重构：改善既有代码的设计">
                <div class="book-card-body">
                    <div class="book-title">重构：改善既有代码的设计</div>
                    <div class="book-author">Martin Fowler</div>
                    <div class="book-price">¥79.00</div>
                    <a href="book/detail.jsp?id=6" class="btn btn-primary w-100 mt-2">查看详情</a>
                </div>
            </div>
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/e67e22/ffffff?text=代码整洁之道" alt="代码整洁之道">
                <div class="book-card-body">
                    <div class="book-title">代码整洁之道</div>
                    <div class="book-author">Robert C. Martin</div>
                    <div class="book-price">¥69.00</div>
                    <a href="book/detail.jsp?id=7" class="btn btn-primary w-100 mt-2">查看详情</a>
                </div>
            </div>
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/34495e/ffffff?text=人月神话" alt="人月神话">
                <div class="book-card-body">
                    <div class="book-title">人月神话</div>
                    <div class="book-author">Frederick P. Brooks Jr.</div>
                    <div class="book-price">¥59.00</div>
                    <a href="book/detail.jsp?id=8" class="btn btn-primary w-100 mt-2">查看详情</a>
                </div>
            </div>
        </div>
    </div>

    <!-- 新书推荐 -->
    <div class="container">
        <h2 class="section-title">📖 新书推荐</h2>
        <div class="row">
            <!-- 新书推荐卡片 -->
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/e74c3c/ffffff?text=AI新时代" alt="AI新时代">
                <div class="book-card-body">
                    <div class="book-title">AI新时代：人工智能的商业应用</div>
                    <div class="book-author">吴军</div>
                    <div class="book-price">¥99.00</div>
                    <a href="book/detail.jsp?id=9" class="btn btn-primary w-100 mt-2">查看详情</a>
                </div>
            </div>
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/3498db/ffffff?text=数据分析实战" alt="数据分析实战">
                <div class="book-card-body">
                    <div class="book-title">数据分析实战：使用Python进行数据挖掘</div>
                    <div class="book-author">李航</div>
                    <div class="book-price">¥89.00</div>
                    <a href="book/detail.jsp?id=10" class="btn btn-primary w-100 mt-2">查看详情</a>
                </div>
            </div>
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/2ecc71/ffffff?text=云计算架构" alt="云计算架构">
                <div class="book-card-body">
                    <div class="book-title">云计算架构设计：原理与实践</div>
                    <div class="book-author">王珊</div>
                    <div class="book-price">¥109.00</div>
                    <a href="book/detail.jsp?id=11" class="btn btn-primary w-100 mt-2">查看详情</a>
                </div>
            </div>
            <div class="book-card">
                <img src="https://via.placeholder.com/300x400/9b59b6/ffffff?text=网络安全技术" alt="网络安全技术">
                <div class="book-card-body">
                    <div class="book-title">网络安全技术与实践</div>
                    <div class="book-author">张焕国</div>
                    <div class="book-price">¥99.00</div>
                    <a href="book/detail.jsp?id=12" class="btn btn-primary w-100 mt-2">查看详情</a>
                </div>
            </div>
        </div>
    </div>

    <!-- 引入页脚 -->
    <%@ include file="common/footer.jsp" %>

    <!-- 轮播图脚本 -->
    <script>
        // 轮播图功能
        let currentSlide = 0;
        const slides = document.querySelectorAll('.carousel-slide');
        const indicators = document.querySelectorAll('.carousel-indicator');

        function showSlide(index) {
            // 隐藏所有幻灯片
            slides.forEach(slide => slide.classList.remove('active'));
            indicators.forEach(indicator => indicator.classList.remove('active'));

            // 显示当前幻灯片
            slides[index].classList.add('active');
            indicators[index].classList.add('active');

            currentSlide = index;
        }

        // 自动轮播
        setInterval(() => {
            const nextSlide = (currentSlide + 1) % slides.length;
            showSlide(nextSlide);
        }, 3000);

        // 点击指示器切换幻灯片
        indicators.forEach((indicator, index) => {
            indicator.addEventListener('click', () => showSlide(index));
        });

        // 点击左右箭头切换幻灯片
        document.getElementById('prevSlide').addEventListener('click', () => {
            const prevSlide = (currentSlide - 1 + slides.length) % slides.length;
            showSlide(prevSlide);
        });

        document.getElementById('nextSlide').addEventListener('click', () => {
            const nextSlide = (currentSlide + 1) % slides.length;
            showSlide(nextSlide);
        });

        // 秒杀倒计时
        function updateCountdown() {
            const hours = document.getElementById('hours');
            const minutes = document.getElementById('minutes');
            const seconds = document.getElementById('seconds');

            let h = parseInt(hours.textContent);
            let m = parseInt(minutes.textContent);
            let s = parseInt(seconds.textContent);

            s--;
            if (s < 0) {
                s = 59;
                m--;
                if (m < 0) {
                    m = 59;
                    h--;
                    if (h < 0) {
                        h = 0;
                        m = 0;
                        s = 0;
                    }
                }
            }

            hours.textContent = String(h).padStart(2, '0');
            minutes.textContent = String(m).padStart(2, '0');
            seconds.textContent = String(s).padStart(2, '0');
        }

        setInterval(updateCountdown, 1000);
    </script>
</body>
</html>