package com.bookstore.mapper;

import com.bookstore.entity.Order;
import java.util.List;

public interface OrderMapper {
    void insert(Order order);
    Order selectById(String orderId);
    List<Order> selectByUserId(Integer userId);
    List<Order> selectByStatus(String status);
    List<Order> selectAll();
    void update(Order order);
    void updateStatus(String orderId, String status);
    void delete(String orderId);
    List<Order> selectExpiredUnpaid();
    Integer getPendingOrderCount();
}