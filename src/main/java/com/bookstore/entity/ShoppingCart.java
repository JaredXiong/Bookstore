package com.bookstore.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

// 购物车实体类，记录用户购物车信息
@Data
@NoArgsConstructor//无参构造
@AllArgsConstructor//有参构造
public class ShoppingCart {
    private Integer cartId;    // 购物车ID
    private Integer userId;    // 用户ID
    private Integer bookId;    // 图书ID
    private Integer quantity;  // 选购数量
    private Date addedTime;    // 加入购物车时间
}