package com.bookstore.mapper;

import com.bookstore.entity.BookImage;
import java.util.List;

/**
 * 图书图片数据访问层，提供图书图片相关的数据库操作
 */
public interface BookImageMapper {
    /**
     * 插入图书图片信息
     * @param bookImage 图书图片实体对象
     */
    void insert(BookImage bookImage);
    /**
     * 根据图片ID查询图书图片
     * @param imageId 图片ID
     * @return 图书图片实体对象
     */
    BookImage selectById(Integer imageId);
    /**
     * 根据图书ID查询图书图片列表
     * @param bookId 图书ID
     * @return 图书图片列表
     */
    List<BookImage> selectByBookId(Integer bookId);
    /**
     * 更新图书图片信息
     * @param bookImage 图书图片实体对象
     */
    void update(BookImage bookImage);
    /**
     * 根据图片ID删除图书图片
     * @param imageId 图片ID
     */
    void delete(Integer imageId);
    /**
     * 根据图书ID删除图书图片
     * @param bookId 图书ID
     */
    void deleteByBookId(Integer bookId);
}