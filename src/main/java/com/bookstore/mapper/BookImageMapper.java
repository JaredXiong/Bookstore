package com.bookstore.mapper;

import com.bookstore.entity.BookImage;
import java.util.List;

public interface BookImageMapper {
    void insert(BookImage bookImage);
    BookImage selectById(Integer imageId);
    List<BookImage> selectByBookId(Integer bookId);
    void update(BookImage bookImage);
    void delete(Integer imageId);
    void deleteByBookId(Integer bookId);
}
