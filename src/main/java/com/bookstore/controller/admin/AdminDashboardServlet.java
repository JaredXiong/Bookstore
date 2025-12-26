package com.bookstore.controller.admin;

import com.bookstore.mapper.*;
import com.bookstore.tool.MyBatisUtil;
import com.bookstore.tool.RedisUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.ibatis.session.SqlSession;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import redis.clients.jedis.Jedis;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard", "/admin/getStatistics"})
public class AdminDashboardServlet extends HttpServlet {
    private static final String CACHE_KEY_STATISTICS = "admin:statistics";
    private static final int CACHE_EXPIRE_TIME = 300; // 5分钟

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取统计数据
        Map<String, Object> statistics = getStatistics();

        // 检查是否需要返回 JSON 格式
        String format = request.getParameter("format");
        if ("json".equals(format)) {
            response.setContentType("application/json;charset=UTF-8");
            ObjectMapper mapper = new ObjectMapper();
            mapper.writeValue(response.getWriter(), statistics);
        } else {
            // 将统计数据存入 request
            request.setAttribute("statistics", statistics);
            // 转发到管理员首页
            request.getRequestDispatcher("/admin/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private Map getStatistics() {
        // 尝试从 Redis 获取缓存数据
        Jedis jedis = null;
        try {
            jedis = RedisUtil.getJedis();
            String cachedData = jedis.get(CACHE_KEY_STATISTICS);
            if (cachedData != null) {
                ObjectMapper mapper = new ObjectMapper();
                return mapper.readValue(cachedData, Map.class);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (jedis != null) {
                RedisUtil.closeJedis(jedis);
            }
        }

        // 从数据库获取统计数据
        Map<String, Object> statistics = new HashMap<>();
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {

            // 获取总图书数量
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            Integer totalBooks = bookMapper.getTotalBookCount();
            statistics.put("totalBooks", totalBooks != null ? totalBooks : 0);

            // 获取待处理订单数量
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            Integer pendingOrders = orderMapper.getPendingOrderCount();
            statistics.put("pendingOrders", pendingOrders != null ? pendingOrders : 0);

            // 获取总用户数量
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            Integer totalUsers = userMapper.getTotalUserCount();
            statistics.put("totalUsers", totalUsers != null ? totalUsers : 0);

            // 获取活跃折扣数量
            DiscountMapper discountMapper = sqlSession.getMapper(DiscountMapper.class);
            Integer activeDiscounts = discountMapper.getActiveDiscountCount();
            statistics.put("activeDiscounts", activeDiscounts != null ? activeDiscounts : 0);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 将数据存入 Redis 缓存
        try {
            jedis = RedisUtil.getJedis();
            ObjectMapper mapper = new ObjectMapper();
            String jsonData = mapper.writeValueAsString(statistics);
            jedis.setex(CACHE_KEY_STATISTICS, CACHE_EXPIRE_TIME, jsonData);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (jedis != null) {
                RedisUtil.closeJedis(jedis);
            }
        }

        return statistics;
    }
}
