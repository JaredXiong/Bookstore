package com.bookstore.mapper;

import com.bookstore.entity.Book;
import java.util.List;

/**
 * 图书数据访问层，提供图书相关的数据库操作
 */
public interface BookMapper {
    /**
     * 插入图书信息
     * @param book 图书实体对象
     */
    void insert(Book book);
    /**
     * 根据图书ID查询图书
     * @param bookId 图书ID
     * @return 图书实体对象
     */
    Book selectById(Integer bookId);
    /**
     * 查询所有图书
     * @return 图书列表
     */
    List<Book> selectAll();
    /**
     * 搜索图书
     * @param keyword 搜索关键词
     * @return 图书列表
     */
    List<Book> searchBooks(String keyword);
    /**
     * 根据图书类型查询图书
     * @param type 图书类型
     * @return 图书列表
     */
    List<Book> selectByType(Integer type);
    /**
     * 更新图书信息
     * @param book 图书实体对象
     */
    void update(Book book);
    /**
     * 根据图书ID删除图书
     * @param bookId 图书ID
     */
    void delete(Integer bookId);
    /**
     * 获取总图书数量
     * @return 图书总数
     */
    Integer getTotalBookCount();
    /**
     * 随机获取指定数量的图书
     * @param limit 图书数量限制
     * @return 随机图书列表
     */
    List<Book> selectRandomBooks(Integer limit);
    /**
     * 获取评分最高的图书
     * @param limit 图书数量限制
     * @return 评分最高的图书列表
     */
    List<Book> selectTopRatedBooks(Integer limit);
    /**
     * 获取最新添加的图书
     * @param limit 图书数量限制
     * @return 最新图书列表
     */
    List<Book> selectNewestBooks(Integer limit);
}