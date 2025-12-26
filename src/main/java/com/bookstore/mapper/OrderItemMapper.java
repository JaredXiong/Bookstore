package com.bookstore.mapper;

import com.bookstore.entity.OrderItem;
import java.util.List;

public interface OrderItemMapper {
    void insert(OrderItem orderItem);
    OrderItem selectById(Integer itemId);
    List<OrderItem> selectByOrderId(String orderId);
    void deleteByOrderId(String orderId);
    void delete(Integer itemId);
}