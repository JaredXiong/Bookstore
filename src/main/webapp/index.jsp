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
            距离下一场秒杀开始还有：
            <span class="countdown-item" id="hours">00</span>:
            <span class="countdown-item" id="minutes">00</span>:
            <span class="countdown-item" id="seconds">00</span>
        </div>
        <div class="row" id="seckill-books-container">
            <!-- 秒杀图书卡片将通过JavaScript动态生成 -->
        </div>
    </div>

    <!-- 精选图书 -->
    <div class="container">
        <h2 class="section-title">⭐ 精选图书</h2>
        <div class="row" id="top-rated-books-container">
            <!-- 精选图书卡片将通过JavaScript动态生成 -->
        </div>
    </div>

    <!-- 新书推荐 -->
    <div class="container">
        <h2 class="section-title">📖 新书推荐</h2>
        <div class="row" id="newest-books-container">
            <!-- 新书推荐卡片将通过JavaScript动态生成 -->
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

        // 获取当前时间
        function getCurrentTime() {
            return new Date();
        }

        // 计算距离下一场秒杀活动的时间
        function calculateTimeToNextSeckill() {
            const currentTime = getCurrentTime();
            const currentHour = currentTime.getHours();
            const currentMinute = currentTime.getMinutes();
            const currentSecond = currentTime.getSeconds();

            // 秒杀时间点：8:00, 12:00, 16:00, 20:00
            const seckillHours = [8, 12, 16, 20];
            
            // 找到下一个秒杀时间点
            let nextSeckillHour = null;
            for (let hour of seckillHours) {
                if (hour > currentHour) {
                    nextSeckillHour = hour;
                    break;
                }
            }
            
            // 如果今天的秒杀活动已经结束，使用明天的第一场
            if (nextSeckillHour === null) {
                nextSeckillHour = seckillHours[0];
                // 创建明天的日期对象
                const nextDay = new Date();
                nextDay.setDate(nextDay.getDate() + 1);
                nextDay.setHours(nextSeckillHour, 0, 0, 0);
                return nextDay - currentTime;
            } else {
                // 创建今天下一场秒杀的日期对象
                const nextSeckill = new Date();
                nextSeckill.setHours(nextSeckillHour, 0, 0, 0);
                return nextSeckill - currentTime;
            }
        }

        // 秒杀倒计时
        function updateSeckillCountdown() {
            const timeRemaining = calculateTimeToNextSeckill();
            
            if (timeRemaining <= 0) {
                // 秒杀开始，更新秒杀图书
                loadSeckillBooks();
                // 重新计算下一场秒杀时间
                updateSeckillCountdown();
                return;
            }

            const hours = Math.floor(timeRemaining / (1000 * 60 * 60));
            const minutes = Math.floor((timeRemaining % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((timeRemaining % (1000 * 60)) / 1000);

            document.getElementById('hours').textContent = String(hours).padStart(2, '0');
            document.getElementById('minutes').textContent = String(minutes).padStart(2, '0');
            document.getElementById('seconds').textContent = String(seconds).padStart(2, '0');
        }

        // 存储应用上下文路径
        const contextPath = '<%= request.getContextPath() %>';
        
        // 加载秒杀图书
        function loadSeckillBooks() {
            fetch(contextPath + '/user/book?action=random&limit=5')
                .then(response => response.json())
                .then(books => {
                    const container = document.getElementById('seckill-books-container');
                    container.innerHTML = '';
                    
                    books.forEach(book => {
                        // 计算秒杀价格（原价的7折）
                        const seckillPrice = (book.price * 0.7).toFixed(2);
                        const bookItem = document.createElement('div');
                        bookItem.className = 'book-item';

                        bookItem.innerHTML = 
                            '<img src="' + contextPath + book.coverImage + '" alt="' + book.bookName + '" class="book-cover">' +
                            '<a href="' + contextPath + '/user/book?action=detail&id=' + book.bookId + '">' + book.bookName + '</a>' +
                            '<p class="book-author">作者：' + book.author + '</p>' +
                            '<p class="book-publisher">出版社：' + book.publisher + '</p>' +
                            '<p class="book-price">价格：¥' + seckillPrice + ' <span class="original-price">¥' + book.price + '</span></p>';

                        container.appendChild(bookItem);
                    });
                })
                .catch(error => {
                    console.error('加载秒杀图书失败:', error);
                });
        }

        // 加载精选图书
        function loadTopRatedBooks() {
            fetch(contextPath + '/user/book?action=topRated&limit=5')
                .then(response => response.json())
                .then(books => {
                    const container = document.getElementById('top-rated-books-container');
                    container.innerHTML = '';
                    
                    books.forEach(book => {
                        const bookItem = document.createElement('div');
                        bookItem.className = 'book-item';

                        bookItem.innerHTML = 
                            '<img src="' + contextPath + book.coverImage + '" alt="' + book.bookName + '" class="book-cover">' +
                            '<a href="' + contextPath + '/user/book?action=detail&id=' + book.bookId + '">' + book.bookName + '</a>' +
                            '<p class="book-author">作者：' + book.author + '</p>' +
                            '<p class="book-publisher">出版社：' + book.publisher + '</p>' +
                            '<p class="book-price">价格：¥' + book.price + '</p>';
                        
                        container.appendChild(bookItem);
                    });
                })
                .catch(error => {
                    console.error('加载精选图书失败:', error);
                });
        }

        // 加载新书推荐
        function loadNewestBooks() {
            fetch(contextPath + '/user/book?action=newest&limit=5')
                .then(response => response.json())
                .then(books => {
                    const container = document.getElementById('newest-books-container');
                    container.innerHTML = '';
                    
                    books.forEach(book => {
                        const bookItem = document.createElement('div');
                        bookItem.className = 'book-item';

                        bookItem.innerHTML = 
                            '<img src="' + contextPath + book.coverImage + '" alt="' + book.bookName + '" class="book-cover">' +
                            '<a href="' + contextPath + '/user/book?action=detail&id=' + book.bookId + '">' + book.bookName + '</a>' +
                            '<p class="book-author">作者：' + book.author + '</p>' +
                            '<p class="book-publisher">出版社：' + book.publisher + '</p>' +
                            '<p class="book-price">价格：¥' + book.price + '</p>';
                        
                        container.appendChild(bookItem);
                    });
                })
                .catch(error => {
                    console.error('加载新书推荐失败:', error);
                });
        }

        // 页面加载完成后初始化
        document.addEventListener('DOMContentLoaded', () => {
            // 初始化秒杀倒计时
            updateSeckillCountdown();
            // 每秒更新一次倒计时
            setInterval(updateSeckillCountdown, 1000);
            
            // 加载秒杀图书
            loadSeckillBooks();
            
            // 加载精选图书
            loadTopRatedBooks();
            
            // 加载新书推荐
            loadNewestBooks();
        });
    </script>
</body>
</html>