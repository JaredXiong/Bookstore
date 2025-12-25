package com.bookstore.service.impl;

import com.bookstore.entity.User;
import com.bookstore.mapper.UserMapper;
import com.bookstore.service.AdminService;
import com.bookstore.tool.MyBatisUtil;
import org.apache.ibatis.session.SqlSession;

public class AdminServiceImpl implements AdminService {
    @Override
    public User login(String username, String password) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSession()) {
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            
            // 根据用户名查找用户
            User user = userMapper.selectByUsername(username);
            
            // 检查用户是否存在、密码是否正确、是否为管理员
            if (user != null && user.getPassword().equals(password) && "admin".equals(user.getUserType())) {
                return user;
            }
            return null;
        }
    }
}