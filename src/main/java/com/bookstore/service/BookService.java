package com.bookstore.service;

import com.bookstore.entity.Book;
import java.util.List;

public interface BookService {
    List<Book> searchBooks(String keyword);
    List<Book> getAllActiveBooks();
    List<Book> getBooksByType(Integer bookType); // 按类别获取图书
    Book getBookById(Integer bookId);
    void clearBookCache();
}