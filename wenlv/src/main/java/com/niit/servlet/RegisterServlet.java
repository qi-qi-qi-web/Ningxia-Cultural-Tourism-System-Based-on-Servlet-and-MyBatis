package com.niit.servlet;

import com.niit.mapper.UserMapper;
import com.niit.pojo.User;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (phone == null || phone.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "请填写完整的注册信息");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的密码不一致");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try (SqlSession session = DBUtil.getSession()) {
            UserMapper userMapper = session.getMapper(UserMapper.class);

            User existingByPhone = userMapper.findByPhone(phone);
            if (existingByPhone != null) {
                request.setAttribute("error", "该手机号已被注册");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            User existingByEmail = userMapper.findByEmail(email);
            if (existingByEmail != null) {
                request.setAttribute("error", "该邮箱已被注册");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            User user = new User(phone, email, password);
            userMapper.insertUser(user);

            response.sendRedirect("login.html");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
