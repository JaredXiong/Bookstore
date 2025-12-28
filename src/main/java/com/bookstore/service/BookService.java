package com.bookstore.service;

import com.bookstore.entity.Book;
import java.util.List;

public interface BookService {
    List<Book> searchBooks(String keyword);
    List<Book> getAllActiveBooks();
    List<Book> getBooksByType(Integer bookType); // 按类别获取图书
    Book getBookById(Integer bookId);
    void clearBookCache();
    List<Book> getRandomBooks(Integer limit); // 获取随机图书（用于图书秒杀）
    List<Book> getTopRatedBooks(Integer limit); // 获取评分最高的图书（用于精选图书）
    List<Book> getNewestBooks(Integer limit); // 获取最新图书（用于新书推荐）
    List<Book> getAllBooksByPage(Integer page, Integer pageSize); // 分页获取所有图书（包括下架的）
    Integer getAllBooksCount(); // 获取所有图书数量（包括下架的）
    
    void addBook(Book book); // 添加图书
    void updateBook(Book book); // 修改图书
    void deleteBook(Integer bookId); // 删除图书
}