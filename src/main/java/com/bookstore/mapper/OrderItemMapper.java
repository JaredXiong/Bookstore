package com.bookstore.mapper;

import com.bookstore.entity.OrderItem;
import java.util.List;

/**
 * 订单项数据访问层，提供订单项相关的数据库操作
 */
public interface OrderItemMapper {
    /**
     * 插入订单项信息
     * @param orderItem 订单项实体对象
     */
    void insert(OrderItem orderItem);
    /**
     * 根据订单项ID查询订单项
     * @param itemId 订单项ID
     * @return 订单项实体对象
     */
    OrderItem selectById(Integer itemId);
    /**
     * 根据订单ID查询订单项列表
     * @param orderId 订单ID
     * @return 订单项列表
     */
    List<OrderItem> selectByOrderId(String orderId);
    /**
     * 根据订单ID删除订单项
     * @param orderId 订单ID
     */
    void deleteByOrderId(String orderId);
    /**
     * 根据订单项ID删除订单项
     * @param itemId 订单项ID
     */
    void delete(Integer itemId);
}