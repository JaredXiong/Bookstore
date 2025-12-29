package com.bookstore.service.impl;

import com.bookstore.entity.User;
import com.bookstore.mapper.UserMapper;
import com.bookstore.service.UserService;
import com.bookstore.tool.MyBatisUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.Date;
import java.util.List;

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

    @Override
    public User findById(Integer userId) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            return userMapper.selectById(userId);
        }
    }

    @Override
    public boolean updateUser(User user) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            userMapper.update(user);
            sqlSession.commit();
            return true;
        }
    }

    @Override
    public boolean deleteUser(Integer userId) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            userMapper.delete(userId);
            sqlSession.commit();
            return true;
        }
    }
    
    @Override
    public boolean isLastAdmin() {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            List<User> adminUsers = userMapper.selectByUserType("admin");
            return adminUsers.size() <= 1;
        }
    }
    
    @Override
    public List<User> getAllUsers() {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            return userMapper.selectByUserType("user");
        }
    }
    
    @Override
    public List<User> getAllAdmins() {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            return userMapper.selectByUserType("admin");
        }
    }
    
    @Override
    public boolean addAdmin(User user) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            
            // 检查用户名是否已存在
            User existingUser = userMapper.selectByUsername(user.getUsername());
            if (existingUser != null) {
                return false;
            }
            
            // 设置管理员类型
            user.setUserType("admin");
            user.setRegisterTime(new Date());
            
            // 插入管理员
            userMapper.insert(user);
            sqlSession.commit();
            return true;
        }
    }
}