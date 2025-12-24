package com.bookstore.mapper;

import com.bookstore.entity.Comment;
import java.util.List;

public interface CommentMapper {
    void insert(Comment comment);
    Comment selectById(Integer commentId);
    List<Comment> selectByBookId(Integer bookId);
    List<Comment> selectByUserId(Integer userId);
    void update(Comment comment);
    void delete(Integer commentId);
}
