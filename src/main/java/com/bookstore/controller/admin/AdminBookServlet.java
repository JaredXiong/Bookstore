package com.bookstore.controller.admin;

import com.bookstore.entity.Book;
import com.bookstore.service.BookService;
import com.bookstore.service.impl.BookServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminBookServlet", urlPatterns = "/admin/book")
public class AdminBookServlet extends HttpServlet {
    private final BookService bookService = new BookServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listBooks(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBook(request, response);
                break;
            case "search":
                searchBooks(request, response);
                break;
            default:
                listBooks(request, response);
                break;
        }
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取当前页码，默认为第1页
        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // 每页显示的图书数量
        int pageSize = 10;

        // 获取所有图书总数（包括下架的）
        int totalBooks = bookService.getAllBooksCount();

        // 计算总页数
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        // 获取当前页的图书列表
        List<Book> books = bookService.getAllBooksByPage(page, pageSize);

        // 设置请求属性
        request.setAttribute("books", books);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalPages", totalPages);

        // 转发到图书列表页面
        request.getRequestDispatcher("/admin/book/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/admin/book/add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
            return;
        }

        try {
            Integer bookId = Integer.parseInt(idParam);
            Book book = bookService.getBookById(bookId);
            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
                return;
            }
            request.setAttribute("book", book);
            request.getRequestDispatcher("/admin/book/edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
        }
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
            return;
        }
    
        try {
            Integer bookId = Integer.parseInt(idParam);
            bookService.deleteBook(bookId);
            bookService.clearBookCache();
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
        }
    }

    private void searchBooks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Book> books = bookService.searchBooks(keyword);
        request.setAttribute("books", books);
        request.setAttribute("keyword", keyword);
        // 搜索结果暂时不支持分页
        request.getRequestDispatcher("/admin/book/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
    
        switch (action) {
            case "add":
                addBook(request, response);
                break;
            case "update":
                updateBook(request, response);
                break;
            default:
                doGet(request, response);
                break;
        }
    }
    
    private void addBook(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        
        // 创建Book对象并设置属性
        Book book = new Book();
        book.setISBN(request.getParameter("ISBN"));
        book.setBookName(request.getParameter("bookName"));
        book.setAuthor(request.getParameter("author"));
        book.setPublisher(request.getParameter("publisher"));
        book.setPrice(Double.parseDouble(request.getParameter("price")));
        book.setStockNum(Integer.parseInt(request.getParameter("stockNum")));
        book.setSoldNum(0); // 新添加的图书销量为0
        book.setIntroduction(request.getParameter("introduction"));
        book.setCoverImage(request.getParameter("coverImage"));
        book.setBookType(Integer.parseInt(request.getParameter("bookType")));
        book.setIsActive(request.getParameter("isActive") != null); // 检查是否勾选了上架
        
        try {
            bookService.addBook(book);
            // 添加成功后重定向到图书列表
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            // 添加失败后重定向到添加页面
            response.sendRedirect(request.getContextPath() + "/admin/book?action=add");
        }
    }
    
    private void updateBook(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        
        // 创建Book对象并设置属性
        Book book = new Book();
        book.setBookId(Integer.parseInt(request.getParameter("bookId")));
        book.setISBN(request.getParameter("ISBN"));
        book.setBookName(request.getParameter("bookName"));
        book.setAuthor(request.getParameter("author"));
        book.setPublisher(request.getParameter("publisher"));
        book.setPrice(Double.parseDouble(request.getParameter("price")));
        book.setStockNum(Integer.parseInt(request.getParameter("stockNum")));
        book.setSoldNum(Integer.parseInt(request.getParameter("soldNum")));
        book.setIntroduction(request.getParameter("introduction"));
        book.setCoverImage(request.getParameter("coverImage"));
        book.setBookType(Integer.parseInt(request.getParameter("bookType")));
        book.setIsActive(request.getParameter("isActive") != null); // 检查是否勾选了上架
        
        try {
            bookService.updateBook(book);
            // 更新成功后重定向到图书列表
            response.sendRedirect(request.getContextPath() + "/admin/book?action=list");
        } catch (Exception e) {
            e.printStackTrace();
            // 更新失败后重定向到编辑页面
            response.sendRedirect(request.getContextPath() + "/admin/book?action=edit&id=" + book.getBookId());
        }
    }
}