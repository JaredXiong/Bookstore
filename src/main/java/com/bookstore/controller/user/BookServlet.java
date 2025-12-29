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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
            case "searchAuto": // 添加实时搜索处理
                searchAuto(request, response);
                break;
            case "byType":
                getBooksByType(request, response);
                break;
            case "detail":
                showBookDetail(request, response);
                break;
            case "random":
                getRandomBooks(request, response);
                break;
            case "topRated":
                getTopRatedBooks(request, response);
                break;
            case "newest":
                getNewestBooks(request, response);
                break;
            case "list":
            default:
                listBooks(request, response);
                break;
        }
    }

    // 实时搜索方法
    private void searchAuto(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("[]");
            return;
        }

        List<Book> books = bookService.searchBooks(keyword);
        List<Map<String, Object>> result = new ArrayList<>();

        for (Book book : books) {
            Map<String, Object> bookMap = new HashMap<>();
            bookMap.put("bookId", book.getBookId());
            bookMap.put("bookName", book.getBookName());
            bookMap.put("author", book.getAuthor());
            bookMap.put("price", book.getPrice());
            
            // 确定匹配的字段类型
            List<String> matchFields = new ArrayList<>();
            keyword = keyword.toLowerCase();
            
            if (book.getBookName() != null && book.getBookName().toLowerCase().contains(keyword)) {
                matchFields.add("书名");
            }
            if (book.getAuthor() != null && book.getAuthor().toLowerCase().contains(keyword)) {
                matchFields.add("作者");
            }
            if (book.getISBN() != null && book.getISBN().toLowerCase().contains(keyword)) {
                matchFields.add("ISBN");
            }
            if (book.getPublisher() != null && book.getPublisher().toLowerCase().contains(keyword)) {
                matchFields.add("出版社");
            }
            if (book.getIntroduction() != null && book.getIntroduction().toLowerCase().contains(keyword)) {
                matchFields.add("简介");
            }
            
            bookMap.put("matchFields", matchFields);
            result.add(bookMap);
        }

        // 返回JSON数据
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(result));
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
            // 转发到图书详情页
            request.getRequestDispatcher("/book/detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            // 如果ID格式不正确，重定向到图书列表页
            response.sendRedirect(request.getContextPath() + "/user/book?action=list");
        }
    }

    // 处理随机图书请求（用于图书秒杀）
    private void getRandomBooks(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String limitParam = request.getParameter("limit");
        Integer limit = (limitParam != null && !limitParam.isEmpty()) ? Integer.parseInt(limitParam) : 5;
        List<Book> randomBooks = bookService.getRandomBooks(limit);
        request.setAttribute("randomBooks", randomBooks);
        // 直接返回JSON数据，用于AJAX请求
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(randomBooks));
    }

    // 处理评分最高图书请求（用于精选图书）
    private void getTopRatedBooks(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String limitParam = request.getParameter("limit");
        Integer limit = (limitParam != null && !limitParam.isEmpty()) ? Integer.parseInt(limitParam) : 5;
        List<Book> topRatedBooks = bookService.getTopRatedBooks(limit);
        request.setAttribute("topRatedBooks", topRatedBooks);
        // 直接返回JSON数据，用于AJAX请求
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(topRatedBooks));
    }

    // 处理最新图书请求（用于新书推荐）
    private void getNewestBooks(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String limitParam = request.getParameter("limit");
        Integer limit = (limitParam != null && !limitParam.isEmpty()) ? Integer.parseInt(limitParam) : 5;
        List<Book> newestBooks = bookService.getNewestBooks(limit);
        request.setAttribute("newestBooks", newestBooks);
        // 直接返回JSON数据，用于AJAX请求
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(newestBooks));
    }
}