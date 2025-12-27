package com.bookstore.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

// 评论实体类，存储用户对已购图书的评价与反馈
@Data
@NoArgsConstructor//无参构造
@AllArgsConstructor//有参构造
public class Comment {
    private Integer commentId; // 评论ID
    private Integer userId;    // 评论者用户ID
    private Integer bookId;    // 被评论图书ID
    private String orderId;   // 关联的订单ID
    private String content;    // 评论正文
    private Date createTime;   // 评论时间
    private Integer rating;    // 用户评分（1~5分制）
}