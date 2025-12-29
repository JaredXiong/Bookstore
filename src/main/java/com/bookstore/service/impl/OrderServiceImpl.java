package com.bookstore.service.impl;

import com.bookstore.entity.Book;
import com.bookstore.entity.Order;
import com.bookstore.entity.OrderItem;
import com.bookstore.mapper.BookMapper;
import com.bookstore.mapper.OrderItemMapper;
import com.bookstore.mapper.OrderMapper;
import com.bookstore.service.OrderService;
import com.bookstore.tool.MyBatisUtil;
import org.apache.ibatis.session.SqlSession;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

public class OrderServiceImpl implements OrderService {
    
    // 用于生成同一时刻的订单序号，每日重置
    private static final AtomicInteger ORDER_SEQUENCE = new AtomicInteger(0);
    private static String LAST_DATE = "";
    
    @Override
    public String createOrderWithStockCheck(Order order, List<OrderItem> orderItems) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            OrderItemMapper orderItemMapper = sqlSession.getMapper(OrderItemMapper.class);
            
            // 生成订单编号
            String orderId = generateOrderId();
            order.setOrderId(orderId);
            order.setCreateTime(new Date());
            // 设置订单状态为"待支付"
            order.setOrderStatus("待支付");
            
            // 1. 检查所有商品库存是否充足
            for (OrderItem item : orderItems) {
                Book book = bookMapper.selectById(item.getBookId());
                if (book == null) {
                    throw new RuntimeException("图书不存在: " + item.getBookId());
                }
                if (book.getStockNum() < item.getQuantity()) {
                    throw new RuntimeException("图书库存不足: " + book.getBookName());
                }
            }
            
            // 2. 插入订单
            orderMapper.insert(order);
            
            // 3. 插入订单项
            for (OrderItem item : orderItems) {
                item.setOrderId(orderId);
                orderItemMapper.insert(item);
            }
            
            // 4. 更新库存和销量
            for (OrderItem item : orderItems) {
                bookMapper.updateStock(item.getBookId(), item.getQuantity());
            }
            
            sqlSession.commit();
            return orderId;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            return null;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    /**
     * 生成16位订单编号
     */
    private String generateOrderId() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        Date now = new Date();
        String dateStr = sdf.format(now);
        
        // 检查日期是否变化，如果是新的一天则重置序列号
        synchronized (this) {
            if (!dateStr.equals(LAST_DATE)) {
                ORDER_SEQUENCE.set(0);
                LAST_DATE = dateStr;
            }
            
            // 生成2位序列号，不足2位补0
            int sequence = ORDER_SEQUENCE.incrementAndGet() % 100;
            String sequenceStr = String.format("%02d", sequence);
            
            return dateStr + sequenceStr;
        }
    }
    
    @Override
    public Order getOrderById(String orderId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            return orderMapper.selectById(orderId);
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public List<Order> getOrdersByUserId(Integer userId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            return orderMapper.selectByUserId(userId);
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public List<Order> getOrdersByStatus(String status) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            return orderMapper.selectByStatus(status);
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public boolean updateOrderStatus(String orderId, String status) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            orderMapper.updateStatus(orderId, status);
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback();
            return false;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }

    @Override
    public boolean cancelOrder(String orderId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            OrderItemMapper orderItemMapper = sqlSession.getMapper(OrderItemMapper.class);
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
    
            // 获取订单
            Order order = orderMapper.selectById(orderId);
            if (order == null || !"待支付".equals(order.getOrderStatus())) {
                return false;
            }
    
            // 获取订单项
            List<OrderItem> orderItems = orderItemMapper.selectByOrderId(orderId);
    
            // 恢复库存
            for (OrderItem item : orderItems) {
                bookMapper.updateStockForCancel(item.getBookId(), item.getQuantity());
            }
    
            // 更新订单状态为已取消
            orderMapper.updateStatus(orderId, "已取消");
    
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback();
            return false;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public List<Order> getAllOrders() {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            return orderMapper.selectAll();
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public List<Order> getPendingOrders() {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            return orderMapper.selectPendingOrders();
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public boolean hasUncompletedOrders(Integer userId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            List<Order> orders = orderMapper.selectByUserId(userId);
            
            // 检查是否有未完成订单（待支付、待发货、待收货、待评价、待退款）
            for (Order order : orders) {
                String status = order.getOrderStatus();
                if (!"已完成".equals(status) && !"已取消".equals(status)) {
                    return true;
                }
            }
            return false;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public List<Order> searchOrders(String keyword, String status) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            return orderMapper.searchOrders(keyword, status);
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
}