package com.bookstore.mapper;

import com.bookstore.entity.User;
import java.util.List;

public interface UserMapper {
    void insert(User user);
    User selectById(Integer userId);
    User selectByUsername(String username);
    List<User> selectAll();
    void update(User user);
    void delete(Integer userId);
    Integer getTotalUserCount();
}