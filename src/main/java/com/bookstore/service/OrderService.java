package com.bookstore.service;

import com.bookstore.entity.Order;
import java.util.List;

public interface OrderService {
    /**
     * 创建订单
     * @param order 订单信息
     * @return 订单编号，失败返回null
     */
    String createOrder(Order order);
    
    /**
     * 根据订单编号获取订单
     * @param orderId 订单编号
     * @return 订单信息
     */
    Order getOrderById(String orderId);
    
    /**
     * 根据用户ID获取订单列表
     * @param userId 用户ID
     * @return 订单列表
     */
    List<Order> getOrdersByUserId(Integer userId);
    
    /**
     * 根据订单状态获取订单列表
     * @param status 订单状态
     * @return 订单列表
     */
    List<Order> getOrdersByStatus(String status);
    
    /**
     * 更新订单状态
     * @param orderId 订单编号
     * @param status 新状态
     * @return 是否更新成功
     */
    boolean updateOrderStatus(String orderId, String status);
    
    /**
     * 取消订单
     * @param orderId 订单编号
     * @return 是否取消成功
     */
    boolean cancelOrder(String orderId);
    
    /**
     * 获取所有订单（供管理员使用）
     * @return 订单列表
     */
    List<Order> getAllOrders();
}