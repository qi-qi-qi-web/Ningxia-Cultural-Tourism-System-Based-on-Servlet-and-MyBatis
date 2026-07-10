package com.niit.servlet;

import com.niit.mapper.TravelGuideMapper;
import com.niit.pojo.TravelGuide;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.sql.Statement;

@WebServlet("/admin/strategy")
public class AdminStrategyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if ("edit".equals(action) && idStr != null) {
            returnJson(response, Long.parseLong(idStr));
            return;
        }

        if (action != null && idStr != null && !"edit".equals(action)) {
            String msg = executeAction(action, idStr);
            request.getSession().setAttribute("msg", msg);
            response.sendRedirect(request.getContextPath() + "/admin/strategy");
            return;
        }

        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("guideList", s.getMapper(TravelGuideMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.getRequestDispatcher("/Admin-strategy.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { doGet(request, response); }

    private void returnJson(HttpServletResponse response, Long id) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            TravelGuide g = s.getMapper(TravelGuideMapper.class).findById(id);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(String.format(
                "{\"id\":%d,\"title\":\"%s\",\"content\":\"%s\",\"coverImage\":\"%s\",\"tags\":\"%s\",\"status\":\"%s\"}",
                g.getId(), esc(g.getTitle()), esc(g.getContent()),
                esc(g.getCoverImage()), esc(g.getTags()), esc(g.getStatus())
            ));
        }
    }

    private String executeAction(String action, String idStr) {
        Long id = Long.parseLong(idStr);
        try (SqlSession s = DBUtil.getSession()) {
            TravelGuideMapper m = s.getMapper(TravelGuideMapper.class);
            TravelGuide item = m.findById(id);
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
                    return "攻略「" + title + "」已删除";
                case "publish": m.updateStatus(id, "PUBLISHED"); s.commit(); return "攻略「" + title + "」已发布";
                case "hide":    m.updateStatus(id, "HIDDEN"); s.commit(); return "攻略「" + title + "」已隐藏";
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
