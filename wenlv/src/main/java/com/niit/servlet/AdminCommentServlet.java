package com.niit.servlet;

import com.niit.mapper.CommentMapper;
import com.niit.pojo.Comment;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;

@WebServlet("/admin/comment")
public class AdminCommentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action != null && idStr != null) {
            String msg = executeAction(action, idStr);
            request.getSession().setAttribute("msg", msg);
            response.sendRedirect(request.getContextPath() + "/admin/comment");
            return;
        }

        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("commentList", s.getMapper(CommentMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.getRequestDispatcher("/Admin-comment.jsp").forward(request, response);
    }

    private String executeAction(String action, String idStr) {
        Long id = Long.parseLong(idStr);
        try (SqlSession s = DBUtil.getSession()) {
            CommentMapper m = s.getMapper(CommentMapper.class);
            switch (action) {
                case "hide":
                    m.updateStatus(id, 0);
                    s.commit();
                    return "评论已屏蔽";
                case "show":
                    m.updateStatus(id, 1);
                    s.commit();
                    return "评论已显示";
                case "delete":
                    m.deleteById(id);
                    s.commit();
                    return "评论已删除";
                default: return "未知操作";
            }
        } catch (Exception e) {
            return "操作失败：" + e.getMessage();
        }
    }
}
