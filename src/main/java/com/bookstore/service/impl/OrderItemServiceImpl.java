package com.bookstore.service.impl;

import com.bookstore.entity.OrderItem;
import com.bookstore.mapper.OrderItemMapper;
import com.bookstore.service.OrderItemService;
import com.bookstore.tool.MyBatisUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class OrderItemServiceImpl implements OrderItemService {
    
    @Override
    public boolean addOrderItem(OrderItem orderItem) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderItemMapper orderItemMapper = sqlSession.getMapper(OrderItemMapper.class);
            orderItemMapper.insert(orderItem);
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
    public List<OrderItem> getOrderItemsByOrderId(String orderId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderItemMapper orderItemMapper = sqlSession.getMapper(OrderItemMapper.class);
            return orderItemMapper.selectByOrderId(orderId);
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public OrderItem getOrderItemById(Integer itemId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderItemMapper orderItemMapper = sqlSession.getMapper(OrderItemMapper.class);
            return orderItemMapper.selectById(itemId);
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public boolean deleteOrderItem(Integer itemId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderItemMapper orderItemMapper = sqlSession.getMapper(OrderItemMapper.class);
            orderItemMapper.delete(itemId);
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
}