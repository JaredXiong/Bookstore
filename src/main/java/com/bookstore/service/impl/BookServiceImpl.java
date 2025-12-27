package com.bookstore.service.impl;

import com.bookstore.entity.Book;
import com.bookstore.mapper.BookMapper;
import com.bookstore.service.BookService;
import com.bookstore.tool.MyBatisUtil;
import com.bookstore.tool.RedisUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.ibatis.session.SqlSession;
import redis.clients.jedis.Jedis;

import java.util.List;

public class BookServiceImpl implements BookService {
    // JSON序列化工具
    private static final ObjectMapper objectMapper = new ObjectMapper();
    // 缓存过期时间（秒）
    private static final int CACHE_EXPIRE_TIME = 3600;
    // 缓存键前缀
    private static final String BOOK_CACHE_PREFIX = "book:";
    private static final String ALL_BOOKS_CACHE_KEY = "book:all:active";
    private static final String BOOKS_BY_TYPE_CACHE_PREFIX = "book:type:"; // 按类别缓存的前缀
    private static final String RANDOM_BOOKS_CACHE_KEY_PREFIX = "book:random:"; // 随机图书缓存前缀
    private static final String TOP_RATED_BOOKS_CACHE_KEY_PREFIX = "book:top_rated:"; // 评分最高图书缓存前缀
    private static final String NEWEST_BOOKS_CACHE_KEY_PREFIX = "book:newest:"; // 最新图书缓存前缀

    @Override
    public List<Book> searchBooks(String keyword) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            return bookMapper.searchBooks(keyword);
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }

    @Override
    public List<Book> getAllActiveBooks() {
        // 先从缓存获取
        String cacheKey = ALL_BOOKS_CACHE_KEY;
        String cachedBooks = RedisUtil.get(cacheKey);
        if (cachedBooks != null) {
            try {
                return objectMapper.readValue(cachedBooks, objectMapper.getTypeFactory().constructCollectionType(List.class, Book.class));
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }
        }

        // 缓存未命中，从数据库获取
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            List<Book> books = bookMapper.selectAll();

            // 将结果存入缓存
            try {
                RedisUtil.setex(cacheKey, objectMapper.writeValueAsString(books), CACHE_EXPIRE_TIME);
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }

            return books;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    // 添加按类别获取图书的方法
    @Override
    public List<Book> getBooksByType(Integer bookType) {
        // 先从缓存获取
        String cacheKey = BOOKS_BY_TYPE_CACHE_PREFIX + bookType;
        String cachedBooks = RedisUtil.get(cacheKey);
        if (cachedBooks != null) {
            try {
                return objectMapper.readValue(cachedBooks, objectMapper.getTypeFactory().constructCollectionType(List.class, Book.class));
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }
        }

        // 缓存未命中，从数据库获取
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            List<Book> books = bookMapper.selectByType(bookType);

            // 将结果存入缓存
            try {
                RedisUtil.setex(cacheKey, objectMapper.writeValueAsString(books), CACHE_EXPIRE_TIME);
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }

            return books;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }

    @Override
    public Book getBookById(Integer bookId) {
        // 先从缓存获取
        String cacheKey = BOOK_CACHE_PREFIX + bookId;
        String cachedBook = RedisUtil.get(cacheKey);
        if (cachedBook != null) {
            try {
                return objectMapper.readValue(cachedBook, Book.class);
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }
        }

        // 缓存未命中，从数据库获取
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            Book book = bookMapper.selectById(bookId);

            // 将结果存入缓存
            if (book != null) {
                try {
                    RedisUtil.setex(cacheKey, objectMapper.writeValueAsString(book), CACHE_EXPIRE_TIME);
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }
            }

            return book;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }

    @Override
    public void clearBookCache() {
        // 清除所有图书相关缓存
        Jedis jedis = null;
        try {
            jedis = RedisUtil.getJedis();
            // 清除所有图书缓存
            jedis.keys(BOOK_CACHE_PREFIX + "*")
                    .forEach(jedis::del);
            // 清除所有活跃图书缓存
            jedis.del(ALL_BOOKS_CACHE_KEY);
            // 清除所有按类别缓存的图书
            jedis.keys(BOOKS_BY_TYPE_CACHE_PREFIX + "*")
                    .forEach(jedis::del);
            // 清除所有随机图书缓存
            jedis.keys(RANDOM_BOOKS_CACHE_KEY_PREFIX + "*")
                    .forEach(jedis::del);
            // 清除所有评分最高图书缓存
            jedis.keys(TOP_RATED_BOOKS_CACHE_KEY_PREFIX + "*")
                    .forEach(jedis::del);
            // 清除所有最新图书缓存
            jedis.keys(NEWEST_BOOKS_CACHE_KEY_PREFIX + "*")
                    .forEach(jedis::del);
        } finally {
            RedisUtil.closeJedis(jedis);
        }
    }

    @Override
    public List<Book> getRandomBooks(Integer limit) {
        // 先从缓存获取
        String cacheKey = RANDOM_BOOKS_CACHE_KEY_PREFIX + limit;
        String cachedBooks = RedisUtil.get(cacheKey);
        if (cachedBooks != null) {
            try {
                return objectMapper.readValue(cachedBooks, objectMapper.getTypeFactory().constructCollectionType(List.class, Book.class));
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }
        }

        // 缓存未命中，从数据库获取
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            List<Book> books = bookMapper.selectRandomBooks(limit);

            // 将结果存入缓存
            try {
                RedisUtil.setex(cacheKey, objectMapper.writeValueAsString(books), CACHE_EXPIRE_TIME);
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }

            return books;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }

    @Override
    public List<Book> getTopRatedBooks(Integer limit) {
        // 先从缓存获取
        String cacheKey = TOP_RATED_BOOKS_CACHE_KEY_PREFIX + limit;
        String cachedBooks = RedisUtil.get(cacheKey);
        if (cachedBooks != null) {
            try {
                return objectMapper.readValue(cachedBooks, objectMapper.getTypeFactory().constructCollectionType(List.class, Book.class));
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }
        }

        // 缓存未命中，从数据库获取
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            List<Book> books = bookMapper.selectTopRatedBooks(limit);

            // 将结果存入缓存
            try {
                RedisUtil.setex(cacheKey, objectMapper.writeValueAsString(books), CACHE_EXPIRE_TIME);
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }

            return books;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }

    @Override
    public List<Book> getNewestBooks(Integer limit) {
        // 先从缓存获取
        String cacheKey = NEWEST_BOOKS_CACHE_KEY_PREFIX + limit;
        String cachedBooks = RedisUtil.get(cacheKey);
        if (cachedBooks != null) {
            try {
                return objectMapper.readValue(cachedBooks, objectMapper.getTypeFactory().constructCollectionType(List.class, Book.class));
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }
        }

        // 缓存未命中，从数据库获取
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            List<Book> books = bookMapper.selectNewestBooks(limit);

            // 将结果存入缓存
            try {
                RedisUtil.setex(cacheKey, objectMapper.writeValueAsString(books), CACHE_EXPIRE_TIME);
            } catch (JsonProcessingException e) {
                e.printStackTrace();
            }

            return books;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
}