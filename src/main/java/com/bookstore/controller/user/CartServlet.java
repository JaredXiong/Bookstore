package com.bookstore.controller.user;

import com.bookstore.common.BaseServlet;
import com.bookstore.entity.Book;
import com.bookstore.entity.ShoppingCart;
import com.bookstore.entity.User;
import com.bookstore.service.BookService;
import com.bookstore.service.CartService;
import com.bookstore.service.impl.BookServiceImpl;
import com.bookstore.service.impl.CartServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = "/user/cart")
public class CartServlet extends BaseServlet {
    private final CartService cartService = new CartServiceImpl();
    private final BookService bookService = new BookServiceImpl();
    
    // 添加商品到购物车
    public void addToCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        try {
            Integer bookId = Integer.parseInt(request.getParameter("bookId"));
            Integer quantity = Integer.parseInt(request.getParameter("quantity"));
            
            // 获取图书信息
            Book book = bookService.getBookById(bookId);
            if (book == null) {
                request.setAttribute("errorMsg", "图书不存在");
                response.sendRedirect(request.getContextPath() + "/user/cart?action=viewCart");
                return;
            }
            
            // 创建购物车项
            ShoppingCart cart = new ShoppingCart();
            cart.setUserId(user.getUserId());
            cart.setBookId(bookId);
            cart.setQuantity(quantity);
            cart.setAddedTime(new Date());
            
            // 添加到购物车
            boolean success = cartService.addToCart(cart);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/user/cart?action=viewCart");
            } else {
                request.setAttribute("errorMsg", "添加购物车失败，库存不足");
                response.sendRedirect(request.getContextPath() + "/user/cart?action=viewCart");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "参数错误");
            response.sendRedirect(request.getContextPath() + "/user/cart?action=viewCart");
        }
    }
    
    // 更新购物车中商品数量
    public void updateCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        try {
            Integer cartId = Integer.parseInt(request.getParameter("cartId"));
            Integer quantity = Integer.parseInt(request.getParameter("quantity"));
            
            boolean success = cartService.updateQuantity(cartId, quantity);
            // 重定向到viewCart方法而不是直接到JSP
            response.sendRedirect(request.getContextPath() + "/user/cart?action=viewCart");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "参数错误");
            response.sendRedirect(request.getContextPath() + "/user/cart?action=viewCart");
        }
    }
    
    // 从购物车删除商品
    public void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        try {
            Integer cartId = Integer.parseInt(request.getParameter("cartId"));
            
            boolean success = cartService.removeFromCart(cartId);
            response.sendRedirect(request.getContextPath() + "/user/cart?action=viewCart");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "参数错误");
            response.sendRedirect(request.getContextPath() + "/user/cart?action=viewCart");
        }
    }
    
    // 查看购物车
    public void viewCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        // 获取购物车项列表
        List<ShoppingCart> cartItems = cartService.getCartItemsByUserId(user.getUserId());
        
        // 获取图书详细信息并计算总金额
        double totalAmount = 0;
        for (ShoppingCart cartItem : cartItems) {
            Book book = bookService.getBookById(cartItem.getBookId());
            cartItem.setBook(book);
            totalAmount += book.getPrice() * cartItem.getQuantity();
        }
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("/cart/index.jsp").forward(request, response);
    }
    
    // 清空购物车
    public void clearCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否登录
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        
        boolean success = cartService.clearCart(user.getUserId());
        response.sendRedirect(request.getContextPath() + "/user/cart?action=viewCart");
    }
}