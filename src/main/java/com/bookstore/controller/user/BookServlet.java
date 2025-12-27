package com.bookstore.controller.user;

import com.bookstore.entity.Book;
import com.bookstore.entity.BookImage;
import com.bookstore.mapper.BookImageMapper;
import com.bookstore.service.BookService;
import com.bookstore.service.impl.BookServiceImpl;
import com.bookstore.tool.MyBatisUtil;
import org.apache.ibatis.session.SqlSession;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookServlet", urlPatterns = "/user/book")
public class BookServlet extends HttpServlet {
    private final BookService bookService = new BookServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "search":
                searchBooks(request, response);
                break;
            case "byType":
                getBooksByType(request, response); // 添加按类别筛选的处理
                break;
            case "detail":
                showBookDetail(request, response);
                break;
            case "random":
                getRandomBooks(request, response); // 处理随机图书请求（用于图书秒杀）
                break;
            case "topRated":
                getTopRatedBooks(request, response); // 处理评分最高图书请求（用于精选图书）
                break;
            case "newest":
                getNewestBooks(request, response); // 处理最新图书请求（用于新书推荐）
                break;
            case "list":
            default:
                listBooks(request, response);
                break;
        }
    }

    private void searchBooks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Book> books = bookService.searchBooks(keyword);
        request.setAttribute("books", books);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/book/list.jsp").forward(request, response);
    }

    // 添加按类别筛选的方法
    private void getBooksByType(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String typeParam = request.getParameter("type");
        if (typeParam != null && !typeParam.isEmpty()) {
            Integer bookType = Integer.parseInt(typeParam);
            List<Book> books = bookService.getBooksByType(bookType);
            request.setAttribute("books", books);
            request.setAttribute("selectedType", bookType); // 设置选中的类别，用于页面显示
        } else {
            // 如果没有提供类别参数，默认显示所有活跃图书
            listBooks(request, response);
            return;
        }
        request.getRequestDispatcher("/book/list.jsp").forward(request, response);
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Book> books = bookService.getAllActiveBooks();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/book/list.jsp").forward(request, response);
    }

    private void showBookDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            // 如果没有提供图书ID，重定向到图书列表页
            response.sendRedirect(request.getContextPath() + "/user/book?action=list");
            return;
        }

        try {
            Integer bookId = Integer.parseInt(idParam);
            // 获取图书信息
            Book book = bookService.getBookById(bookId);
            if (book == null) {
                // 如果图书不存在，重定向到图书列表页
                response.sendRedirect(request.getContextPath() + "/user/book?action=list");
                return;
            }

            // 获取图书扩展图片
            SqlSession sqlSession = MyBatisUtil.getSqlSession();
            BookImageMapper bookImageMapper = sqlSession.getMapper(BookImageMapper.class);
            List<BookImage> bookImages = bookImageMapper.selectByBookId(bookId);
            MyBatisUtil.closeSqlSession(sqlSession);
            // 设置request属性
            request.setAttribute("book", book);
            request.setAttribute("bookImages", bookImages);
            System.out.println("bookImages: " + bookImages);
            // 转发到图书详情页
            request.getRequestDispatcher("/book/detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            // 如果ID格式不正确，重定向到图书列表页
            response.sendRedirect(request.getContextPath() + "/user/book?action=list");
        }
    }

    // 处理随机图书请求（用于图书秒杀）
    private void getRandomBooks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String limitParam = request.getParameter("limit");
        Integer limit = (limitParam != null && !limitParam.isEmpty()) ? Integer.parseInt(limitParam) : 5;
        List<Book> randomBooks = bookService.getRandomBooks(limit);
        System.out.println("randomBooks: " + randomBooks);
        request.setAttribute("randomBooks", randomBooks);
        // 直接返回JSON数据，用于AJAX请求
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(randomBooks));
    }

    // 处理评分最高图书请求（用于精选图书）
    private void getTopRatedBooks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String limitParam = request.getParameter("limit");
        Integer limit = (limitParam != null && !limitParam.isEmpty()) ? Integer.parseInt(limitParam) : 5;
        List<Book> topRatedBooks = bookService.getTopRatedBooks(limit);
        System.out.println("topRatedBooks: " + topRatedBooks);
        request.setAttribute("topRatedBooks", topRatedBooks);
        // 直接返回JSON数据，用于AJAX请求
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(topRatedBooks));
    }

    // 处理最新图书请求（用于新书推荐）
    private void getNewestBooks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String limitParam = request.getParameter("limit");
        Integer limit = (limitParam != null && !limitParam.isEmpty()) ? Integer.parseInt(limitParam) : 5;
        List<Book> newestBooks = bookService.getNewestBooks(limit);
        System.out.println("newestBooks: " + newestBooks);
        request.setAttribute("newestBooks", newestBooks);
        // 直接返回JSON数据，用于AJAX请求
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(newestBooks));
    }
}