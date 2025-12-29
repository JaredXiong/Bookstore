package com.bookstore.service;

import com.bookstore.entity.User;
import java.util.List;

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
    
    /**
     * 根据用户ID查找用户
     * @param userId 用户ID
     * @return 用户信息，不存在返回null
     */
    User findById(Integer userId);
    
    /**
     * 更新用户信息
     * @param user 用户信息
     * @return 是否更新成功
     */
    boolean updateUser(User user);
    
    /**
     * 删除用户
     * @param userId 用户ID
     * @return 是否删除成功
     */
    boolean deleteUser(Integer userId);
    
    /**
     * 检查是否是最后一个管理员
     * @return 是否是最后一个管理员
     */
    boolean isLastAdmin();
    
    /**
     * 获取所有用户
     * @return 用户列表
     */
    List<User> getAllUsers();
    
    /**
     * 获取所有管理员
     * @return 管理员列表
     */
    List<User> getAllAdmins();
    
    /**
     * 添加管理员
     * @param user 管理员信息
     * @return 是否添加成功
     */
    boolean addAdmin(User user);
}