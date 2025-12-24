package com.bookstore.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

// 用户实体类，存储系统所有注册用户的基本信息
@Data
@NoArgsConstructor//无参构造
@AllArgsConstructor//有参构造
public class User {
    private Integer userId;       // 用户ID
    private String username;      // 用户名
    private String password;      // 密码
    private String email;         // 电子邮件
    private String address;       // 居住地址（默认收货地址）
    private String postalCode;    // 邮政编码
    private String userType;      // 用户类型：customer-普通用户，admin-管理员用户
    private Date registerTime;    // 用户注册时间
}