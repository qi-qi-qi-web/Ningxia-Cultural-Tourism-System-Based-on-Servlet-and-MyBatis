package com.niit.servlet;

import com.niit.mapper.GuideTagMapper;
import com.niit.pojo.GuideTag;
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

@WebServlet("/admin/guideTag")
public class AdminGuideTagServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String cat = request.getParameter("cat");
        if (cat == null || cat.isEmpty()) cat = "FEATURE";

        // 返回 JSON 标签列表（供前端 AJAX）
        if ("list".equals(action)) {
            returnTagListJson(response);
            return;
        }

        if (action != null && idStr != null && !"list".equals(action)) {
            String msg = executeAction(action, idStr);
            request.getSession().setAttribute("msg", msg);
            response.sendRedirect(request.getContextPath() + "/admin/guideTag?cat=" + cat);
            return;
        }

        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("tagList", s.getMapper(GuideTagMapper.class).findByCategory(cat));
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.setAttribute("cat", cat);
        request.getRequestDispatcher("/Admin-guideTag.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if ("save".equals(request.getParameter("action"))) {
            saveTag(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void saveTag(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        try (SqlSession s = DBUtil.getSession(false)) {
            GuideTagMapper m = s.getMapper(GuideTagMapper.class);
            GuideTag t = new GuideTag();
            t.setName(request.getParameter("name"));
            t.setCategory(request.getParameter("category"));
            t.setSortOrder(Integer.parseInt(request.getParameter("sortOrder") != null ? request.getParameter("sortOrder") : "0"));

            if (idStr != null && !idStr.isEmpty()) {
                t.setId(Long.parseLong(idStr));
                m.update(t);
            } else {
                t.setId(m.findMaxId() + 1);
                m.insert(t);
            }
            s.commit();
            request.getSession().setAttribute("msg", "标签「" + t.getName() + "」保存成功");
        } catch (Exception e) {
            request.getSession().setAttribute("msg", "保存失败：" + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/guideTag?cat=" + java.net.URLEncoder.encode(request.getParameter("cat") != null ? request.getParameter("cat") : "FEATURE", "UTF-8"));
    }

    private void returnTagListJson(HttpServletResponse response) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            List<GuideTag> list = s.getMapper(GuideTagMapper.class).findAll();
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                if (i > 0) sb.append(",");
                GuideTag t = list.get(i);
                sb.append(String.format(
                    "{\"id\":%d,\"name\":\"%s\",\"category\":\"%s\",\"sortOrder\":%d}",
                    t.getId(), esc(t.getName()), esc(t.getCategory()), t.getSortOrder()
                ));
            }
            sb.append("]");
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(sb.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    private String executeAction(String action, String idStr) {
        Long id = Long.parseLong(idStr);
        try (SqlSession s = DBUtil.getSession()) {
            GuideTagMapper m = s.getMapper(GuideTagMapper.class);
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
                    return "标签已删除";
                default: return "未知操作";
            }
        } catch (Exception e) {
            return "操作失败：" + e.getMessage();
        }
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r","");
    }
}
