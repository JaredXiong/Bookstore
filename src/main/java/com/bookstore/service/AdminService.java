package com.bookstore.service;

import com.bookstore.entity.User;

public interface AdminService {
    /**
     * 管理员登录
     * @param username 用户名
     * @param password 密码
     * @return 登录成功的管理员信息，失败返回null
     */
    User login(String username, String password);
}