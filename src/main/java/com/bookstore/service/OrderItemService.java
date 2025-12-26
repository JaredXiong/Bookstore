package com.bookstore.service;

import com.bookstore.entity.OrderItem;
import java.util.List;

public interface OrderItemService {
    /**
     * 添加订单项
     * @param orderItem 订单项
     * @return 是否添加成功
     */
    boolean addOrderItem(OrderItem orderItem);
    
    /**
     * 根据订单编号获取订单项列表
     * @param orderId 订单编号
     * @return 订单项列表
     */
    List<OrderItem> getOrderItemsByOrderId(String orderId);
    
    /**
     * 根据订单项ID获取订单项
     * @param itemId 订单项ID
     * @return 订单项
     */
    OrderItem getOrderItemById(Integer itemId);
    
    /**
     * 删除订单项
     * @param itemId 订单项ID
     * @return 是否删除成功
     */
    boolean deleteOrderItem(Integer itemId);
}