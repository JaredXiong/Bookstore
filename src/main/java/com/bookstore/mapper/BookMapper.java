package com.bookstore.mapper;

import com.bookstore.entity.Book;
import java.util.List;

public interface BookMapper {
    void insert(Book book);
    Book selectById(Integer bookId);
    List<Book> selectAll();
    List<Book> selectActive();
    List<Book> selectByType(Integer bookType); // 按类别获取图书
    void update(Book book);
    void updateStock(Integer bookId, Integer quantity);
    void delete(Integer bookId);
    List<Book> searchBooks(String keyword);
    Integer getTotalBookCount();
}