package com.bookstore.service;

import com.bookstore.entity.User;

public interface UserService {
    /**
     * 用户注册
     * @param user 用户信息
     * @return 是否注册成功
     */
    boolean register(User user);
    
    /**
     * 用户登录
     * @param username 用户名
     * @param password 密码
     * @return 登录成功的用户信息，失败返回null
     */
    User login(String username, String password);
    
    /**
     * 根据用户名查找用户
     * @param username 用户名
     * @return 用户信息，不存在返回null
     */
    User findByUsername(String username);
}