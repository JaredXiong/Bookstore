package com.bookstore.mapper;

import com.bookstore.entity.ShoppingCart;
import java.util.List;

public interface ShoppingCartMapper {
    void insert(ShoppingCart shoppingCart);
    ShoppingCart selectById(Integer cartId);
    ShoppingCart selectByUserAndBook(Integer userId, Integer bookId);
    List<ShoppingCart> selectByUserId(Integer userId);
    void updateQuantity(Integer cartId, Integer quantity);
    void delete(Integer cartId);
    void deleteByUserAndBook(Integer userId, Integer bookId);
    void deleteByUserId(Integer userId);
}
