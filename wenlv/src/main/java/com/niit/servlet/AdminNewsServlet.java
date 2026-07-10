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
import java.sql.Statement;
import java.util.List;

@WebServlet("/admin/news")
public class AdminNewsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr  = request.getParameter("id");

        // 编辑回填：返回 JSON
        if ("edit".equals(action) && idStr != null) {
            returnJson(request, response, Long.parseLong(idStr));
            return;
        }

        if (action != null && idStr != null && !"edit".equals(action)) {
            String msg = executeAction(action, idStr);
            request.getSession().setAttribute("msg", msg);
            response.sendRedirect(request.getContextPath() + "/admin/news");
            return;
        }

        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("newsList", s.getMapper(NewsDynamicMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.getRequestDispatcher("/Admin-news.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if ("save".equals(request.getParameter("action"))) {
            saveNews(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void returnJson(HttpServletRequest request, HttpServletResponse response, Long id) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            NewsDynamic n = s.getMapper(NewsDynamicMapper.class).findById(id);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(String.format(
                "{\"id\":%d,\"title\":\"%s\",\"content\":\"%s\",\"coverImage\":\"%s\",\"source\":\"%s\",\"authorName\":\"%s\",\"isPublished\":%d}",
                n.getId(), esc(n.getTitle()), esc(n.getContent()),
                esc(n.getCoverImage()), esc(n.getSource()), esc(n.getAuthorName()), n.getIsPublished()
            ));
        }
    }

    private void saveNews(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        try (SqlSession s = DBUtil.getSession(false)) {
            NewsDynamicMapper m = s.getMapper(NewsDynamicMapper.class);
            NewsDynamic n = new NewsDynamic();
            n.setTitle(request.getParameter("title"));
            n.setContent(request.getParameter("content"));
            n.setCoverImage(request.getParameter("coverImage"));
            n.setSource(request.getParameter("source"));
            n.setAuthorName(request.getParameter("authorName"));
            n.setIsPublished(Integer.parseInt(request.getParameter("isPublished") != null ? request.getParameter("isPublished") : "0"));

            if (idStr != null && !idStr.isEmpty()) {
                n.setId(Long.parseLong(idStr));
                m.update(n);
            } else {
                n.setCreatedBy(1L);
                n.setId(m.findMaxId() + 1);
                m.insert(n);
            }
            s.commit();
            request.getSession().setAttribute("msg", "新闻「" + truncate(n.getTitle()) + "」保存成功");
        } catch (Exception e) {
            request.getSession().setAttribute("msg", "保存失败：" + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/news");
    }

    private String executeAction(String action, String idStr) {
        Long id = Long.parseLong(idStr);
        try (SqlSession s = DBUtil.getSession()) {
            NewsDynamicMapper m = s.getMapper(NewsDynamicMapper.class);
            NewsDynamic item = m.findById(id);
            String title = truncate(item != null ? item.getTitle() : String.valueOf(id));

            switch (action) {
                case "delete":
                    Statement st = s.getConnection().createStatement();
                    try {
                        st.execute("SET FOREIGN_KEY_CHECKS = 0");
                        m.deleteById(id);
                        m.shiftIdsDown(id);
                        st.execute("SET FOREIGN_KEY_CHECKS = 1");
                    } finally { try { st.close(); } catch (Exception ignored) {} }
                    s.commit();
                    return "新闻「" + title + "」已删除";
                case "publish":  m.togglePublish(id, 1); s.commit(); return "新闻「" + title + "」已发布";
                case "unpublish": m.togglePublish(id, 0); s.commit(); return "新闻「" + title + "」已下架";
                default: return "未知操作";
            }
        } catch (Exception e) {
            return "操作失败：" + e.getMessage();
        }
    }

    private String truncate(String s) {
        if (s == null) return "";
        return s.length() > 15 ? s.substring(0, 15) + "..." : s;
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r","");
    }
}
