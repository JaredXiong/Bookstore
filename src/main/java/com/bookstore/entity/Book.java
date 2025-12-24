package com.bookstore.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// 图书实体类，书店出售的所有图书的基本信息
@Data
@NoArgsConstructor//无参构造
@AllArgsConstructor//有参构造
public class Book {
    private Integer bookId;       // 图书ID
    private String ISBN;          // 国际标准书号（ISBN）
    private String bookName;      // 图书名称
    private String author;        // 作者
    private String publisher;     // 出版社
    private Double price;         // 单价（元）
    private Integer stockNum;     // 库存数量
    private Integer soldNum;      // 已售数量
    private String introduction;  // 图书简介
    private String coverImage;    // 图书封面图片路径
    private Integer bookType;     // 图书类别：1：文学；2：社科；3：少儿；4：技术；5：其他
    private Boolean isActive;     // 是否上架
}