package com.bookstore.service;

import com.bookstore.entity.Order;
import com.bookstore.entity.OrderItem;
import java.util.List;

public interface OrderService {
    /**
     * 创建订单
     * @param order 订单信息
     * @param orderItems 订单项列表
     * @return 订单编号，失败返回null
     */
    String createOrderWithStockCheck(Order order, List<OrderItem> orderItems);
    
    /**
     * 根据订单编号获取订单
     * @param orderId 订单编号
     * @return 订单信息
     */
    Order getOrderById(String orderId);
    
    /**
     * 根据用户 ID获取订单列表
     * @param userId 用户 ID
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
     * 取消订单（恢复库存）
     * @param orderId 订单编号
     * @return 是否取消成功
     */
    boolean cancelOrder(String orderId);
    
    /**
     * 获取所有订单
     * @return 订单列表
     */
    List<Order> getAllOrders();
    
    /**
     * 获取待处理订单（待支付、待发货、待退款）
     * @return 订单列表
     */
    List<Order> getPendingOrders();
    
    /**
     * 检查用户是否有未完成订单
     * @param userId 用户 ID
     * @return true表示有未完成订单，false表示没有
     */
    boolean hasUncompletedOrders(Integer userId);
    
    /**
     * 搜索订单
     * @param keyword 搜索关键词（订单号或用户名）
     * @param status 订单状态
     * @return 订单列表
     */
    List<Order> searchOrders(String keyword, String status);
}