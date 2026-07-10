package com.niit.servlet;

import com.niit.mapper.NewsDynamicMapper;
import com.niit.pojo.NewsDynamic;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/news")
public class AdminNewsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr  = request.getParameter("id");

        if (action != null && idStr != null) {
            String msg = executeAction(action, idStr);
            request.getSession().setAttribute("msg", msg);
            response.sendRedirect(request.getContextPath() + "/admin/news");
            return;
        }

        try (SqlSession session = DBUtil.getSession()) {
            List<NewsDynamic> list = session.getMapper(NewsDynamicMapper.class).findAll();
            request.setAttribute("newsList", list);
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.getRequestDispatcher("/Admin-news.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("save".equals(action)) {
            saveNews(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void saveNews(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        try (SqlSession session = DBUtil.getSession(false)) {
            NewsDynamicMapper mapper = session.getMapper(NewsDynamicMapper.class);
            NewsDynamic n = new NewsDynamic();
            n.setTitle(request.getParameter("title"));
            n.setContent(request.getParameter("content"));
            n.setCoverImage(request.getParameter("coverImage"));
            n.setSource(request.getParameter("source"));
            n.setAuthorName(request.getParameter("authorName"));
            n.setIsPublished(Integer.parseInt(request.getParameter("isPublished") != null ? request.getParameter("isPublished") : "0"));

            if (idStr != null && !idStr.isEmpty()) {
                n.setId(Long.parseLong(idStr));
                mapper.update(n);
            } else {
                n.setCreatedBy(1L); // admin ID
                mapper.insert(n);
            }
            session.commit();
            request.getSession().setAttribute("msg", "新闻保存成功");
        } catch (Exception e) {
            request.getSession().setAttribute("msg", "保存失败：" + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/news");
    }

    private String executeAction(String action, String idStr) {
        Long id = Long.parseLong(idStr);
        try (SqlSession session = DBUtil.getSession()) {
            NewsDynamicMapper mapper = session.getMapper(NewsDynamicMapper.class);
            switch (action) {
                case "delete": mapper.deleteById(id); session.commit(); return "新闻已删除";
                case "publish": mapper.togglePublish(id, 1); session.commit(); return "新闻已发布";
                case "unpublish": mapper.togglePublish(id, 0); session.commit(); return "新闻已下架";
                default: return "未知操作";
            }
        }
    }
}
