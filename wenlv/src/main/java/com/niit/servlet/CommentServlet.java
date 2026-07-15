package com.niit.servlet;

import com.niit.mapper.CommentMapper;
import com.niit.mapper.OrderMapper;
import com.niit.pojo.Comment;
import com.niit.pojo.User;
import com.niit.utils.DBUtil;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/comment")
@MultipartConfig
public class CommentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String action = request.getParameter("action");

        if ("list".equals(action)) {
            listComments(request, response);
        } else {
            response.getWriter().write("[]");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.getWriter().write("{\"ok\":false,\"msg\":\"请先登录\"}");
            return;
        }
        User user = (User) session.getAttribute("user");

        String content = request.getParameter("content");
        String targetType = request.getParameter("targetType");
        String targetId = request.getParameter("targetId");

        if (content == null || content.trim().isEmpty()) {
            response.getWriter().write("{\"ok\":false,\"msg\":\"请输入评论内容\"}");
            return;
        }

        // 特产评论需校验用户是否已购买并支付
        if ("SPECIALTY".equals(targetType)) {
            try (SqlSession s = DBUtil.getSession()) {
                int count = s.getMapper(OrderMapper.class).hasPaidSpecialtyOrder(user.getId(), Long.parseLong(targetId));
                if (count == 0) {
                    response.getWriter().write("{\"ok\":false,\"msg\":\"请先购买并完成支付后再评论\"}");
                    return;
                }
            }
        }

        try (SqlSession s = DBUtil.getSession(false)) {
            CommentMapper m = s.getMapper(CommentMapper.class);
            Comment c = new Comment();
            c.setUserId(user.getId());
            c.setTargetType(targetType);
            c.setTargetId(Long.parseLong(targetId));
            c.setContent(content.trim());
            m.insert(c);
            s.commit();
            response.getWriter().write("{\"ok\":true}");
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg == null) msg = "服务器内部错误";
            response.getWriter().write("{\"ok\":false,\"msg\":\"" + esc(msg) + "\"}");
        }
    }

    private void listComments(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String targetType = request.getParameter("targetType");
        String targetId = request.getParameter("targetId");
        try (SqlSession s = DBUtil.getSession()) {
            List<Comment> list = s.getMapper(CommentMapper.class).findByTarget(targetType, Long.parseLong(targetId));
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                if (i > 0) sb.append(",");
                Comment c = list.get(i);
                sb.append(String.format(
                    "{\"id\":%d,\"userName\":\"%s\",\"nickname\":\"%s\",\"avatar\":\"%s\",\"content\":\"%s\",\"createdAt\":\"%s\"}",
                    c.getId(), esc(c.getUserName()), esc(c.getNickname()), esc(c.getAvatar()), esc(c.getContent()),
                    c.getCreatedAt() != null ? c.getCreatedAt().toString() : ""
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
}
