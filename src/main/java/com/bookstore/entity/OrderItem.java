package com.bookstore.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// 订单详情实体类，记录订单中的具体书籍购买信息
@Data
@NoArgsConstructor//无参构造
@AllArgsConstructor//有参构造
public class OrderItem {
    private Integer itemId;   // 详情项 ID
    private String orderId;   // 所属订单编号
    private Integer bookId;   // 购买图书 ID
    private Integer quantity; // 购买数量
    private Double price;     // 该订单项的实际单价
    private Book book;        // 关联的图书信息
}