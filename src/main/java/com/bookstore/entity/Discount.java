package com.bookstore.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

// 折扣实体类，用于设置图书销售时的优惠折扣信息
@Data
@NoArgsConstructor//无参构造
@AllArgsConstructor//有参构造
public class Discount {
    private Integer discountId;      // 折扣ID
    private String discountType;     // 折扣类型
    private Double discountRate;     // 折扣比例（如0.95表示九五折）
    private String applicableBooks;  // 适用图书ID列表（用英文逗号分隔）
    private Date startTime;          // 折扣开始时间
    private Date endTime;            // 折扣结束时间
}