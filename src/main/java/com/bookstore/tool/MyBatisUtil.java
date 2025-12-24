package com.bookstore.tool;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;

public class MyBatisUtil {
    private static SqlSessionFactory sqlSessionFactory;

    static {
        try {
            // 读取配置文件
            InputStream inputStream = Resources.getResourceAsStream("mybatis-config.xml");
            // 创建SqlSessionFactory
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("初始化MyBatis失败");
        }
    }

    /**
     * 获取SqlSession实例
     * @return SqlSession
     */
    public static SqlSession getSqlSession() {
        return sqlSessionFactory.openSession();
    }

    /**
     * 获取SqlSession实例，可以指定是否自动提交
     * @param autoCommit 是否自动提交事务
     * @return SqlSession
     */
    public static SqlSession getSqlSession(boolean autoCommit) {
        return sqlSessionFactory.openSession(autoCommit);
    }

    /**
     * 关闭SqlSession
     * @param sqlSession SqlSession实例
     */
    public static void closeSqlSession(SqlSession sqlSession) {
        if (sqlSession != null) {
            sqlSession.close();
        }
    }
}