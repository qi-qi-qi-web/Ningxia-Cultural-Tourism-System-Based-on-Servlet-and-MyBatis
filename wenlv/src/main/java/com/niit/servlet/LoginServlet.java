package com.niit.servlet;

import com.niit.mapper.UserMapper;
import com.niit.pojo.User;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String phoneOrEmail = request.getParameter("phoneOrEmail");
        String password = request.getParameter("password");

        if (phoneOrEmail == null || phoneOrEmail.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "请填写完整的登录信息");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try (SqlSession session = DBUtil.getSession()) {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            User user = userMapper.findByPhoneOrEmail(phoneOrEmail);

            if (user != null && user.getPassword().equals(password)) {
                HttpSession httpSession = request.getSession();
                httpSession.setAttribute("user", user);
                response.sendRedirect("index.html");
            } else {
                request.setAttribute("error", "账号或密码错误");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
