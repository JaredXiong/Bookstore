package com.bookstore.mapper;

import com.bookstore.entity.Order;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * 订单数据访问层，提供订单相关的数据库操作
 */
public interface OrderMapper {
    /**
     * 插入订单信息
     * @param order 订单实体对象
     */
    void insert(Order order);
    /**
     * 根据订单ID查询订单
     * @param orderId 订单ID
     * @return 订单实体对象
     */
    Order selectById(String orderId);
    /**
     * 根据用户ID查询订单列表
     * @param userId 用户ID
     * @return 订单列表
     */
    List<Order> selectByUserId(Integer userId);
    /**
     * 根据订单状态查询订单列表
     * @param status 订单状态
     * @return 订单列表
     */
    List<Order> selectByStatus(String status);
    /**
     * 查询所有订单
     * @return 订单列表
     */
    List<Order> selectAll();
    /**
     * 更新订单信息
     * @param order 订单实体对象
     */
    void update(Order order);
    /**
     * 更新订单状态
     * @param orderId 订单ID
     * @param status 订单状态
     */
    void updateStatus(@Param("orderId") String orderId, @Param("status") String status);
    /**
     * 根据订单 ID删除订单
     * @param orderId 订单 ID
     */
    void delete(String orderId);
    /**
     * 查询过期未支付的订单
     * @return 订单列表
     */
    List<Order> selectExpiredUnpaid();
    /**
     * 获取待处理订单数量
     * @return 待处理订单数量
     */
    Integer getPendingOrderCount();
    /**
     * 查询待处理订单（待支付、待发货、待退款）
     * @return 订单列表
     */
    List<Order> selectPendingOrders();
    /**
     * 搜索订单
     * @param keyword 搜索关键词（订单号或用户名）
     * @param status 订单状态
     * @return 订单列表
     */
    List<Order> searchOrders(@Param("keyword") String keyword, @Param("status") String status);
}