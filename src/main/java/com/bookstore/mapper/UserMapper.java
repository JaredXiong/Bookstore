package com.bookstore.mapper;

import com.bookstore.entity.User;
import java.util.List;

/**
 * 用户数据访问层，提供用户相关的数据库操作
 */
public interface UserMapper {
    /**
     * 插入用户信息
     * @param user 用户实体对象
     */
    void insert(User user);
    /**
     * 根据用户ID查询用户
     * @param userId 用户ID
     * @return 用户实体对象
     */
    User selectById(Integer userId);
    /**
     * 根据用户名查询用户
     * @param username 用户名
     * @return 用户实体对象
     */
    User selectByUsername(String username);
    /**
     * 根据用户类型查询用户列表
     * @param userType 用户类型
     * @return 用户列表
     */
    List<User> selectByUserType(String userType);
    /**
     * 查询所有用户
     * @return 用户列表
     */
    List<User> selectAll();
    /**
     * 更新用户信息
     * @param user 用户实体对象
     */
    void update(User user);
    /**
     * 根据用户 ID删除用户
     * @param userId 用户 ID
     */
    void delete(Integer userId);
    /**
     * 获取总用户数量
     * @return 用户总数
     */
    Integer getTotalUserCount();
}