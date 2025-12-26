package com.bookstore.service;

import com.bookstore.entity.ShoppingCart;
import java.util.List;

public interface CartService {
    /**
     * 添加商品到购物车
     * @param cart 购物车项
     * @return 是否添加成功
     */
    boolean addToCart(ShoppingCart cart);
    
    /**
     * 更新购物车中商品数量
     * @param cartId 购物车项ID
     * @param quantity 新数量
     * @return 是否更新成功
     */
    boolean updateQuantity(Integer cartId, Integer quantity);
    
    /**
     * 从购物车删除商品
     * @param cartId 购物车项ID
     * @return 是否删除成功
     */
    boolean removeFromCart(Integer cartId);
    
    /**
     * 根据用户ID获取购物车列表
     * @param userId 用户ID
     * @return 购物车列表
     */
    List<ShoppingCart> getCartItemsByUserId(Integer userId);
    
    /**
     * 清空用户购物车
     * @param userId 用户ID
     * @return 是否清空成功
     */
    boolean clearCart(Integer userId);
    
    /**
     * 根据用户ID和图书ID获取购物车项
     * @param userId 用户ID
     * @param bookId 图书ID
     * @return 购物车项
     */
    ShoppingCart getCartItemByUserAndBook(Integer userId, Integer bookId);
}