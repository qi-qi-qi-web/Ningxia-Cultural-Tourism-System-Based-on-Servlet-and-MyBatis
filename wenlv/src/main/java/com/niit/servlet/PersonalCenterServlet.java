package com.niit.servlet;

import com.niit.pojo.User;
import com.niit.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/personalCenter")
public class PersonalCenterServlet extends HttpServlet {

    private UserService userService = new UserService();

    /**
     * GET 请求：进入个人中心页面 / 处理退出登录 / 获取用户JSON数据
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            // 退出登录：销毁 session，跳转首页
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("index.jsp");
            return;
        }

        if ("me".equals(action)) {
            handleGetMe(request, response);
            return;
        }

        // 默认行为：进入个人中心
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        // 从数据库查询最新用户信息
        User latestUser = userService.findById(sessionUser.getId());
        if (latestUser == null) {
            session.invalidate();
            response.sendRedirect("login.jsp");
            return;
        }

        // 将最新用户信息放入 request，供 JSP 渲染
        request.setAttribute("user", latestUser);
        request.getRequestDispatcher("PersonalCenter.jsp").forward(request, response);
    }

    /**
     * 返回当前登录用户的 JSON 数据（前端 AJAX 拉取用）
     */
    private void handleGetMe(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.getWriter().write("{\"error\":\"not_logged_in\"}");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        User latestUser = userService.findById(sessionUser.getId());

        if (latestUser == null) {
            response.getWriter().write("{\"error\":\"user_not_found\"}");
            return;
        }

        // 手动拼接 JSON
        String avatar = latestUser.getAvatar() != null ? latestUser.getAvatar() : "";
        String nickname = latestUser.getNickname() != null ? latestUser.getNickname() : "";
        String username = latestUser.getUsername() != null ? latestUser.getUsername() : "";
        String phone = latestUser.getPhone() != null ? latestUser.getPhone() : "";
        String email = latestUser.getEmail() != null ? latestUser.getEmail() : "";
        String role = latestUser.getRole() != null ? latestUser.getRole() : "";

        // 转义特殊字符
        String json = "{" +
            "\"avatar\":\"" + escapeJson(avatar) + "\"," +
            "\"username\":\"" + escapeJson(username) + "\"," +
            "\"nickname\":\"" + escapeJson(nickname) + "\"," +
            "\"phone\":\"" + escapeJson(phone) + "\"," +
            "\"email\":\"" + escapeJson(email) + "\"," +
            "\"role\":\"" + escapeJson(role) + "\"" +
            "}";
        response.getWriter().write(json);
    }

    private String escapeJson(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    /**
     * POST 请求：修改个人资料 / 修改密码
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendJson(response, false, "请先登录");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            handleUpdateProfile(request, response, sessionUser);
        } else if ("changePassword".equals(action)) {
            handleChangePassword(request, response, sessionUser);
        } else if ("changeAvatar".equals(action)) {
            handleChangeAvatar(request, response, sessionUser);
        } else {
            sendJson(response, false, "未知操作");
        }
    }

    /**
     * 处理修改个人资料
     */
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, User sessionUser) throws IOException {
        String nickname = request.getParameter("nickname");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        if (nickname == null || nickname.trim().isEmpty()) {
            sendJson(response, false, "昵称不能为空");
            return;
        }

        boolean success = userService.updateProfile(sessionUser.getId(), nickname.trim(), phone != null ? phone.trim() : null, email != null ? email.trim() : null);

        if (success) {
            // 更新 session 中的用户信息
            User updatedUser = userService.findById(sessionUser.getId());
            HttpSession session = request.getSession(false);
            if (session != null && updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }
            sendJson(response, true, "资料修改成功");
        } else {
            sendJson(response, false, "资料修改失败");
        }
    }

    /**
     * 处理修改密码
     */
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User sessionUser) throws IOException {
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        if (oldPassword == null || oldPassword.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
            sendJson(response, false, "请填写所有字段");
            return;
        }

        if (newPassword.length() < 6) {
            sendJson(response, false, "密码长度至少6位");
            return;
        }

        boolean success = userService.changePassword(sessionUser.getId(), oldPassword, newPassword);

        if (success) {
            sendJson(response, true, "密码修改成功");
        } else {
            sendJson(response, false, "旧密码错误");
        }
    }

    /**
     * 处理更换头像
     */
    private void handleChangeAvatar(HttpServletRequest request, HttpServletResponse response, User sessionUser) throws IOException {
        String avatar = request.getParameter("avatar");

        if (avatar == null || avatar.trim().isEmpty()) {
            sendJson(response, false, "请选择头像");
            return;
        }

        boolean success = userService.updateAvatar(sessionUser.getId(), avatar.trim());

        if (success) {
            // 更新 session 中的 avatar
            User updatedUser = userService.findById(sessionUser.getId());
            HttpSession session = request.getSession(false);
            if (session != null && updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }
            sendJson(response, true, "头像更换成功");
        } else {
            sendJson(response, false, "头像更换失败");
        }
    }

    /**
     * 手动拼接 JSON 返回（不引入 Jackson 依赖）
     */
    private void sendJson(HttpServletResponse response, boolean success, String message) throws IOException {
        // 转义 message 中的特殊字符，防止 JSON 注入
        String escaped = message.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
        String json = "{\"success\":" + success + ",\"message\":\"" + escaped + "\"}";
        response.getWriter().write(json);
    }
}
