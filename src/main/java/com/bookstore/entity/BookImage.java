package com.bookstore.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// 图书图片实体类，存储图书的详细展示图片
@Data
@NoArgsConstructor//无参构造
@AllArgsConstructor//有参构造
public class BookImage {
    private Integer imageId;    // 图片ID
    private Integer bookId;     // 关联图书ID
    private String imageUrl;    // 图片的具体URL
    private Integer sortOrder;  // 排序
    private String description; // 图片说明
}