package com.niit.servlet;

import com.niit.mapper.CommentMapper;
import com.niit.mapper.TravelGuideMapper;
import com.niit.pojo.Comment;
import com.niit.pojo.TravelGuide;
import com.niit.pojo.User;
import com.niit.service.UserService;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/personalCenter")
public class PersonalCenterServlet extends HttpServlet {

    private UserService userService = new UserService();


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

        if ("myGuides".equals(action)) {
            handleMyGuides(request, response);
            return;
        }

        if ("myComments".equals(action)) {
            handleMyComments(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        User latestUser = userService.findById(sessionUser.getId());
        if (latestUser == null) {
            session.invalidate();
            response.sendRedirect("login.jsp");
            return;
        }

        request.setAttribute("user", latestUser);
        request.getRequestDispatcher("PersonalCenter.jsp").forward(request, response);
    }

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

        String avatar = latestUser.getAvatar() != null ? latestUser.getAvatar() : "";
        String nickname = latestUser.getNickname() != null ? latestUser.getNickname() : "";
        String username = latestUser.getUsername() != null ? latestUser.getUsername() : "";
        String phone = latestUser.getPhone() != null ? latestUser.getPhone() : "";
        String email = latestUser.getEmail() != null ? latestUser.getEmail() : "";
        String role = latestUser.getRole() != null ? latestUser.getRole() : "";

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
        } else if ("deleteComment".equals(action)) {
            handleDeleteComment(request, response, sessionUser);
        } else if ("editComment".equals(action)) {
            handleEditComment(request, response, sessionUser);
        } else {
            sendJson(response, false, "未知操作");
        }
    }

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

    private void handleEditComment(HttpServletRequest request, HttpServletResponse response, User sessionUser) throws IOException {
        String idStr = request.getParameter("id");
        String content = request.getParameter("content");
        if (idStr == null || idStr.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            sendJson(response, false, "参数错误");
            return;
        }
        long commentId = Long.parseLong(idStr);
        try (SqlSession s = DBUtil.getSession(false)) {
            int rows = s.getMapper(CommentMapper.class).updateContent(commentId, sessionUser.getId(), content.trim());
            if (rows > 0) {
                s.commit();
                sendJson(response, true, "评论已修改");
            } else {
                sendJson(response, false, "修改失败（评论不存在或无权操作）");
            }
        } catch (Exception e) {
            sendJson(response, false, "修改失败：" + e.getMessage());
        }
    }

    private void handleDeleteComment(HttpServletRequest request, HttpServletResponse response, User sessionUser) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            sendJson(response, false, "参数错误");
            return;
        }
        long commentId = Long.parseLong(idStr);
        try (SqlSession s = DBUtil.getSession(false)) {
            int rows = s.getMapper(CommentMapper.class).deleteByUser(commentId, sessionUser.getId());
            if (rows > 0) {
                s.commit();
                sendJson(response, true, "评论已删除");
            } else {
                sendJson(response, false, "删除失败（评论不存在或无权操作）");
            }
        } catch (Exception e) {
            sendJson(response, false, "删除失败：" + e.getMessage());
        }
    }

    private void sendJson(HttpServletResponse response, boolean success, String message) throws IOException {
        // 转义 message 中的特殊字符，防止 JSON 注入
        String escaped = message.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
        String json = "{\"success\":" + success + ",\"message\":\"" + escaped + "\"}";
        response.getWriter().write(json);
    }

    private void handleMyGuides(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.getWriter().write("{\"error\":\"not_logged_in\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        try (SqlSession s = DBUtil.getSession()) {
            List<TravelGuide> list = s.getMapper(TravelGuideMapper.class).findByUserId(user.getId());
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                if (i > 0) sb.append(",");
                TravelGuide g = list.get(i);
                sb.append(String.format(
                    "{\"id\":%d,\"title\":\"%s\",\"content\":\"%s\",\"coverImage\":\"%s\",\"tags\":\"%s\",\"likeCount\":%d,\"viewCount\":%d,\"commentCount\":%d,\"status\":\"%s\",\"createdAt\":\"%s\"}",
                    g.getId(),
                    esc(g.getTitle()),
                    esc(g.getContent()),
                    esc(g.getCoverImage()),
                    esc(g.getTags()),
                    g.getLikeCount() != null ? g.getLikeCount() : 0,
                    g.getViewCount() != null ? g.getViewCount() : 0,
                    g.getCommentCount() != null ? g.getCommentCount() : 0,
                    esc(g.getStatus()),
                    g.getCreatedAt() != null ? g.getCreatedAt().toString() : ""
                ));
            }
            sb.append("]");
            response.getWriter().write(sb.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r","");
    }

    private void handleMyComments(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.getWriter().write("[]");
            return;
        }
        User user = (User) session.getAttribute("user");
        try (SqlSession s = DBUtil.getSession()) {
            List<Comment> list = s.getMapper(CommentMapper.class).findByUserId(user.getId());
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                if (i > 0) sb.append(",");
                Comment c = list.get(i);
                String typeName = "";
                switch (c.getTargetType()) {
                    case "SCENIC": typeName = "景区"; break;
                    case "HOTEL": typeName = "酒店"; break;
                    case "GUIDE": typeName = "攻略"; break;
                    case "SPECIALTY": typeName = "特产"; break;
                }
                sb.append(String.format(
                    "{\"id\":%d,\"content\":\"%s\",\"targetType\":\"%s\",\"targetTypeName\":\"%s\",\"targetId\":%d,\"targetName\":\"%s\",\"createdAt\":\"%s\"}",
                    c.getId(), esc(c.getContent()), esc(c.getTargetType()),
                    typeName, c.getTargetId(), esc(c.getTargetName()),
                    c.getCreatedAt() != null ? c.getCreatedAt().toString() : ""
                ));
            }
            sb.append("]");
            response.getWriter().write(sb.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }
}
