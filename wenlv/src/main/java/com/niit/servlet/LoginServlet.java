package com.niit.servlet;

import com.niit.mapper.UserMapper;
import com.niit.pojo.User;
import com.niit.utils.DBUtil;
import com.niit.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/login")
@MultipartConfig
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("register".equals(action)) {
            handleRegister(request, response);
            return;
        }
        if ("adminLogin".equals(action)) {
            handleAdminLogin(request, response);
            return;
        }

        handleLogin(request, response);
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String phoneOrEmail = request.getParameter("phoneOrEmail");
        String password = request.getParameter("password");

        boolean isAjax = "1".equals(request.getParameter("_ajax"));

        if (phoneOrEmail == null || phoneOrEmail.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            if (isAjax) {
                sendJson(response, false, "请填写完整的登录信息");
            } else {
                response.sendRedirect("index.jsp?error=" + URLEncoder.encode("请填写完整的登录信息", "UTF-8"));
            }
            return;
        }

        try (SqlSession session = DBUtil.getSession()) {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            User user = userMapper.findByPhoneOrEmail(phoneOrEmail);

            if (user == null || !PasswordUtil.verify(password, user.getPasswordHash())) {
                if (isAjax) {
                    sendJson(response, false, "账号或密码错误");
                } else {
                    response.sendRedirect("index.jsp?error=" + URLEncoder.encode("账号或密码错误", "UTF-8"));
                }
                return;
            }

            // 登录成功
            HttpSession httpSession = request.getSession();
            httpSession.setAttribute("user", user);
            httpSession.setAttribute("isLoggedIn", true);

            if (isAjax) {
                sendLoginSuccessJson(response, user);
            } else {
                response.sendRedirect("index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                sendJson(response, false, "服务器错误，请稍后重试");
            } else {
                response.sendRedirect("index.jsp?error=" + URLEncoder.encode("服务器错误，请稍后重试", "UTF-8"));
            }
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            sendJson(response, false, "请填写所有必填字段");
            return;
        }

        try (SqlSession session = DBUtil.getSession(false)) {
            UserMapper userMapper = session.getMapper(UserMapper.class);

            if (userMapper.findByUsername(username) != null) {
                sendJson(response, false, "用户名已被注册");
                return;
            }
            if (userMapper.findByPhone(phone) != null) {
                sendJson(response, false, "手机号已被注册");
                return;
            }

            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPhone(phone);
            newUser.setPasswordHash(PasswordUtil.hash(password));
            newUser.setRole("USER");
            // ID = 当前最大ID + 1（不依赖 AUTO_INCREMENT）
            newUser.setId(userMapper.findMaxId() + 1);

            int rows = userMapper.insertUser(newUser);
            session.commit();

            if (rows > 0) {
                HttpSession httpSession = request.getSession();
                httpSession.setAttribute("user", newUser);
                httpSession.setAttribute("isLoggedIn", true);
                sendRegisterSuccessJson(response, newUser);
            } else {
                sendJson(response, false, "注册失败，请重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJson(response, false, "服务器错误，请稍后重试");
        }
    }

    private void handleAdminLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            sendJson(response, false, "请填写管理员账号和密码");
            return;
        }

        try (SqlSession session = DBUtil.getSession()) {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            User user = userMapper.findByUsername(username.trim());

            if (user == null) {
                sendJson(response, false, "管理员账号不存在");
                return;
            }

            if (!"ADMIN".equals(user.getRole())) {
                sendJson(response, false, "该账号不是管理员");
                return;
            }

            if (!PasswordUtil.verify(password, user.getPasswordHash())) {
                sendJson(response, false, "密码错误");
                return;
            }

            HttpSession httpSession = request.getSession();
            httpSession.setAttribute("user", user);
            httpSession.setAttribute("isLoggedIn", true);
            httpSession.setAttribute("isAdmin", true);

            sendJson(response, true, "管理员登录成功");

        } catch (Exception e) {
            e.printStackTrace();
            sendJson(response, false, "服务器错误，请稍后重试");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    private void sendLoginSuccessJson(HttpServletResponse response, User user) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String json = "{" +
            "\"success\":true," +
            "\"message\":\"登录成功\"," +
            "\"username\":\"" + escapeJson(user.getUsername()) + "\"," +
            "\"nickname\":\"" + (user.getNickname() != null ? escapeJson(user.getNickname()) : "") + "\"," +
            "\"phone\":\"" + (user.getPhone() != null ? escapeJson(user.getPhone()) : "") + "\"," +
            "\"email\":\"" + (user.getEmail() != null ? escapeJson(user.getEmail()) : "") + "\"," +
            "\"avatar\":\"" + (user.getAvatar() != null ? escapeJson(user.getAvatar()) : "") + "\"" +
            "}";
        response.getWriter().write(json);
    }

    private void sendRegisterSuccessJson(HttpServletResponse response, User user) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String json = "{" +
            "\"success\":true," +
            "\"message\":\"注册成功\"," +
            "\"username\":\"" + escapeJson(user.getUsername()) + "\"," +
            "\"phone\":\"" + (user.getPhone() != null ? escapeJson(user.getPhone()) : "") + "\"" +
            "}";
        response.getWriter().write(json);
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    private void sendJson(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String escaped = message.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
        response.getWriter().write("{\"success\":" + success + ",\"message\":\"" + escaped + "\"}");
    }
}
