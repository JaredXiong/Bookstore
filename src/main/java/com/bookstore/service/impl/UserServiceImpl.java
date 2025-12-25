package com.bookstore.service.impl;

import com.bookstore.entity.User;
import com.bookstore.mapper.UserMapper;
import com.bookstore.service.UserService;
import com.bookstore.tool.MyBatisUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.Date;

public class UserServiceImpl implements UserService {
    @Override
    public boolean register(User user) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

            // 检查用户名是否已存在
            User existingUser = userMapper.selectByUsername(user.getUsername());
            if (existingUser != null) {
                return false;
            }

            // 设置默认值
            user.setUserType("user"); // 默认普通用户
            user.setRegisterTime(new Date());

            // 插入用户
            userMapper.insert(user);
            sqlSession.commit();
            return true;
        }
    }

    @Override
    public User login(String username, String password) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

            // 根据用户名查找用户
            User user = userMapper.selectByUsername(username);
            if (user != null && user.getPassword().equals(password)) {
                return user;
            }
            return null;
        }
    }

    @Override
    public User findByUsername(String username) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            return userMapper.selectByUsername(username);
        }
    }
}