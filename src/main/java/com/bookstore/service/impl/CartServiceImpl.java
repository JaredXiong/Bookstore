package com.bookstore.service.impl;

import com.bookstore.entity.Book;
import com.bookstore.entity.ShoppingCart;
import com.bookstore.mapper.BookMapper;
import com.bookstore.mapper.ShoppingCartMapper;
import com.bookstore.service.CartService;
import com.bookstore.tool.MyBatisUtil;
import org.apache.ibatis.session.SqlSession;

public class CartServiceImpl implements CartService {
    
    @Override
    public boolean addToCart(ShoppingCart cart) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            ShoppingCartMapper cartMapper = sqlSession.getMapper(ShoppingCartMapper.class);
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            
            // 检查图书是否存在且库存充足
            Book book = bookMapper.selectById(cart.getBookId());
            if (book == null || book.getStockNum() < cart.getQuantity()) {
                return false;
            }
            
            // 检查购物车中是否已存在该商品
            ShoppingCart existingCart = cartMapper.selectByUserAndBook(cart.getUserId(), cart.getBookId());
            if (existingCart != null) {
                // 如果已存在，更新数量
                int newQuantity = existingCart.getQuantity() + cart.getQuantity();
                if (book.getStockNum() < newQuantity) {
                    return false; // 库存不足
                }
                cartMapper.updateQuantity(existingCart.getCartId(), newQuantity);
            } else {
                // 如果不存在，新增购物车项
                cartMapper.insert(cart);
            }
            
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback();
            return false;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public boolean updateQuantity(Integer cartId, Integer quantity) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            ShoppingCartMapper cartMapper = sqlSession.getMapper(ShoppingCartMapper.class);
            ShoppingCart cart = cartMapper.selectById(cartId);
            
            if (cart == null || quantity <= 0) {
                return false;
            }
            
            // 检查库存是否充足
            BookMapper bookMapper = sqlSession.getMapper(BookMapper.class);
            Book book = bookMapper.selectById(cart.getBookId());
            if (book == null || book.getStockNum() < quantity) {
                return false;
            }
            
            cartMapper.updateQuantity(cartId, quantity);
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback();
            return false;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public boolean removeFromCart(Integer cartId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            ShoppingCartMapper cartMapper = sqlSession.getMapper(ShoppingCartMapper.class);
            cartMapper.delete(cartId);
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback();
            return false;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public java.util.List<ShoppingCart> getCartItemsByUserId(Integer userId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            ShoppingCartMapper cartMapper = sqlSession.getMapper(ShoppingCartMapper.class);
            return cartMapper.selectByUserId(userId);
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public boolean clearCart(Integer userId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            ShoppingCartMapper cartMapper = sqlSession.getMapper(ShoppingCartMapper.class);
            cartMapper.deleteByUserId(userId);
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            sqlSession.rollback();
            return false;
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
    
    @Override
    public ShoppingCart getCartItemByUserAndBook(Integer userId, Integer bookId) {
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            ShoppingCartMapper cartMapper = sqlSession.getMapper(ShoppingCartMapper.class);
            return cartMapper.selectByUserAndBook(userId, bookId);
        } finally {
            MyBatisUtil.closeSqlSession(sqlSession);
        }
    }
}