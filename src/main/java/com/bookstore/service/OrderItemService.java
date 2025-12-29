package com.bookstore.service;

import com.bookstore.entity.OrderItem;
import java.util.List;

public interface OrderItemService {
    /**
     * 根据订单编号获取订单项列表
     * @param orderId 订单编号
     * @return 订单项列表
     */
    List<OrderItem> getOrderItemsByOrderId(String orderId);

}