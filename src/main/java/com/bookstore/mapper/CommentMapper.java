package com.bookstore.mapper;

import com.bookstore.entity.Comment;
import java.util.List;

/**
 * 评论数据访问层，提供评论相关的数据库操作
 */
public interface CommentMapper {
    /**
     * 插入评论信息
     * @param comment 评论实体对象
     */
    void insert(Comment comment);
    /**
     * 根据评论ID查询评论
     * @param commentId 评论ID
     * @return 评论实体对象
     */
    Comment selectById(Integer commentId);
    /**
     * 根据图书ID查询评论列表
     * @param bookId 图书ID
     * @return 评论列表
     */
    List<Comment> selectByBookId(Integer bookId);
    /**
     * 根据用户ID查询评论列表
     * @param userId 用户ID
     * @return 评论列表
     */
    List<Comment> selectByUserId(Integer userId);
    /**
     * 更新评论信息
     * @param comment 评论实体对象
     */
    void update(Comment comment);
    /**
     * 根据评论ID删除评论
     * @param commentId 评论ID
     */
    void delete(Integer commentId);
    /**
     *根据订单ID和图书ID查询评论
     * @return 评论列表
     */
    Comment selectByOrderIdAndBookId(String orderId, Integer bookId);
}