package com.bookstore.service.impl;

import com.bookstore.entity.Order;
import com.bookstore.mapper.OrderMapper;
import com.bookstore.service.OrderService;
import com.bookstore.tool.MyBatisUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public class OrderServiceImpl implements OrderService {
    
    @Override
    public String createOrder(Order order) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession(true); // 开启自动提交
            OrderMapper orderMapper = sqlSession.getMapper(OrderMapper.class);
            
            // 生成订单编号
            String orderId = "ORD" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            order.setOrderId(orderId);
            order.setCreateTime(new Date());
            order.setOrderStatus("待支付");
            
            // 插入订单
            orderMapper.insert(order);
            
            return orderId;
        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback();
            return null;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
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
        return updateOrderStatus(orderId, "已取消");
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
}