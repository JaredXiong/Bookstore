<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
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

    <!-- 轮播图和时间日期组件 -->
    <div class="container carousel-container">
        <!-- 轮播图 -->
        <div class="carousel">
            <% 
                // 动态读取banner图片
                String bannerPath = application.getRealPath("/images/banner");
                File bannerDir = new File(bannerPath);
                ArrayList<String> bannerImages = new ArrayList<>();
                
                if (bannerDir.exists() && bannerDir.isDirectory()) {
                    File[] files = bannerDir.listFiles();
                    if (files != null) {
                        for (File file : files) {
                            if (file.isFile() && (file.getName().endsWith(".jpg") || file.getName().endsWith(".jpeg") || file.getName().endsWith(".png") || file.getName().endsWith(".gif") || file.getName().endsWith(".webp"))) {
                                bannerImages.add("images/banner/" + file.getName());
                            }
                        }
                    }
                }
                
                // 如果没有图片，使用默认图片
                if (bannerImages.isEmpty()) {
                    bannerImages.add("images/banner/banner_1.webp");
                }
                
                // 生成轮播图幻灯片
                for (int i = 0; i < bannerImages.size(); i++) {
                    String imagePath = bannerImages.get(i);
                    String activeClass = (i == 0) ? "active" : "";
            %>
                <div class="carousel-slide <%= activeClass %>">
                    <img src="<%= imagePath %>" alt="Banner <%= i + 1 %>">
                </div>
            <% } %>

            <!-- 轮播指示器 -->
            <div class="carousel-indicators">
                <% for (int i = 0; i < bannerImages.size(); i++) {
                    String activeClass = (i == 0) ? "active" : "";
                %>
                    <button class="carousel-indicator <%= activeClass %>" data-slide="<%= i %>"></button>
                <% } %>
            </div>

            <!-- 轮播控制按钮 -->
            <div class="carousel-controls">
                <button class="carousel-control" id="prevSlide">&lt;</button>
                <button class="carousel-control" id="nextSlide">&gt;</button>
            </div>
        </div>

        <!-- 时间日期组件 -->
        <div class="date-time-card">
            <% 
                // 获取当前日期时间
                Calendar calendar = Calendar.getInstance();
                SimpleDateFormat monthFormat = new SimpleDateFormat("MM");
                SimpleDateFormat dayFormat = new SimpleDateFormat("dd");
                SimpleDateFormat weekFormat = new SimpleDateFormat("EEEE");
                
                int monthNum = calendar.get(Calendar.MONTH) + 1;
                String day = dayFormat.format(calendar.getTime());
                String week = weekFormat.format(calendar.getTime());
                
                // 月份数组
                String[] chineseMonths = {"", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"};
                String month = chineseMonths[monthNum] + "月";
                
                // 判断月份大小
                int[] bigMonths = {1, 3, 5, 7, 8, 10, 12};
                boolean isBigMonth = false;
                for (int bigMonth : bigMonths) {
                    if (bigMonth == monthNum) {
                        isBigMonth = true;
                        break;
                    }
                }
                String monthSize = isBigMonth ? "大" : "小";
            %>
            <div class="date-info">
                <div class="month">
                    <span><%= month %></span>
                    <span class="month-size"><%= monthSize %></span>
                </div>
                <div class="day"><%= day %></div>
                <div class="week"><%= week %></div>
            </div>
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
                    <span>网站系统升级维护通知（12月5凌晨2-4点）</span>
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
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/3498db/ffffff?text=Java编程思想" alt="Java编程思想" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=1">Java编程思想</a>
                    <p class="book-author">作者：Bruce Eckel</p>
                    <p class="book-publisher">出版社：机械工业出版社</p>
                    <p class="book-price">价格：¥59.90 <span class="original-price">¥129.00</span></p>
            </div>
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/e74c3c/ffffff?text=深入理解计算机系统" alt="深入理解计算机系统" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=2">深入理解计算机系统</a>
                    <p class="book-author">作者：Randal E. Bryant</p>
                    <p class="book-publisher">出版社：机械工业出版社</p>
                    <p class="book-price">价格：¥69.90 <span class="original-price">¥139.00</span></p>
            </div>
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/2ecc71/ffffff?text=Python编程" alt="Python编程：从入门到实践" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=3">Python编程：从入门到实践</a>
                    <p class="book-author">作者：Eric Matthes</p>
                    <p class="book-publisher">出版社：人民邮电出版社</p>
                    <p class="book-price">价格：¥49.90 <span class="original-price">¥99.00</span></p>
            </div>
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/f39c12/ffffff?text=算法导论" alt="算法导论" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=4">算法导论</a>
                    <p class="book-author">作者：Thomas H. Cormen</p>
                    <p class="book-publisher">出版社：机械工业出版社</p>
                    <p class="book-price">价格：¥79.90 <span class="original-price">¥159.00</span></p>
            </div>
        </div>
    </div>

    <!-- 精选图书 -->
    <div class="container">
        <h2 class="section-title">⭐ 精选图书</h2>
        <div class="row">
            <!-- 精选图书卡片 -->
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/9b59b6/ffffff?text=设计模式" alt="设计模式" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=5">设计模式：可复用面向对象软件的基础</a>
                    <p class="book-author">作者：Erich Gamma</p>
                    <p class="book-publisher">出版社：机械工业出版社</p>
                    <p class="book-price">价格：¥89.00</p>
            </div>
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/1abc9c/ffffff?text=重构" alt="重构：改善既有代码的设计" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=6">重构：改善既有代码的设计</a>
                    <p class="book-author">作者：Martin Fowler</p>
                    <p class="book-publisher">出版社：人民邮电出版社</p>
                    <p class="book-price">价格：¥79.00</p>
            </div>
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/e67e22/ffffff?text=代码整洁之道" alt="代码整洁之道" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=7">代码整洁之道</a>
                    <p class="book-publisher">出版社：人民邮电出版社</p>
                    <p class="book-price">价格：¥69.00</p>
            </div>
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/34495e/ffffff?text=人月神话" alt="人月神话" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=8">人月神话</a>
                    <p class="book-author">作者：Frederick P. Brooks Jr.</p>
                    <p class="book-publisher">出版社：清华大学出版社</p>
                    <p class="book-price">价格：¥59.00</p>
            </div>
        </div>
    </div>

    <!-- 新书推荐 -->
    <div class="container">
        <h2 class="section-title">📖 新书推荐</h2>
        <div class="row">
            <!-- 新书推荐卡片 -->
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/e74c3c/ffffff?text=AI新时代" alt="AI新时代" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=9">AI新时代：人工智能的商业应用</a>
                    <p class="book-author">作者：吴军</p>
                    <p class="book-publisher">出版社：中信出版社</p>
                    <p class="book-price">价格：¥99.00</p>
            </div>
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/3498db/ffffff?text=数据分析实战" alt="数据分析实战" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=10">数据分析实战：使用Python进行数据挖掘</a>
                    <p class="book-author">作者：李航</p>
                    <p class="book-publisher">出版社：机械工业出版社</p>
                    <p class="book-price">价格：¥89.00</p>
            </div>
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/2ecc71/ffffff?text=云计算架构" alt="云计算架构" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=11">云计算架构设计：原理与实践</a>
                    <p class="book-author">作者：王珊</p>
                    <p class="book-publisher">出版社：清华大学出版社</p>
                    <p class="book-price">价格：¥109.00</p>
            </div>
            <div class="book-item">
                <img src="https://via.placeholder.com/300x400/9b59b6/ffffff?text=网络安全技术" alt="网络安全技术" class="book-cover">
                    <a href="${pageContext.request.contextPath}/user/book?action=detail&id=12">网络安全技术与实践</a>
                    <p class="book-author">作者：张焕国</p>
                    <p class="book-publisher">出版社：武汉大学出版社</p>
                    <p class="book-price">价格：¥99.00</p>
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