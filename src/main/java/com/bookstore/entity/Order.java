package com.bookstore.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

// 订单实体类，记录用户购买商品后产生的订单信息
@Data
@NoArgsConstructor//无参构造
@AllArgsConstructor//有参构造
public class Order {
    private String orderId;        // 订单编号
    private Integer userId;        // 下单用户ID
    private Double totalAmount;    // 订单总金额
    private String deliveryAddress;// 送货地址
    private String orderStatus;    // 订单状态：待支付、已支付、已发货、已完成、已取消
    private Date createTime;       // 订单创建时间
}