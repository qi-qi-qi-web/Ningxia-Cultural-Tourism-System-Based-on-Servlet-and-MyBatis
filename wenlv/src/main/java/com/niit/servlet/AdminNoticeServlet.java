package com.niit.servlet;

import com.niit.mapper.OfficialNoticeMapper;
import com.niit.pojo.OfficialNotice;
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

@WebServlet("/admin/notice")
public class AdminNoticeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr  = request.getParameter("id");

        if ("edit".equals(action) && idStr != null) {
            returnJson(response, Long.parseLong(idStr));
            return;
        }

        if (action != null && idStr != null && !"edit".equals(action)) {
            String msg = executeAction(action, idStr);
            request.getSession().setAttribute("msg", msg);
            response.sendRedirect(request.getContextPath() + "/admin/notice");
            return;
        }

        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("noticeList", s.getMapper(OfficialNoticeMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.getRequestDispatcher("/Admin-notice.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if ("save".equals(request.getParameter("action"))) {
            saveNotice(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void returnJson(HttpServletResponse response, Long id) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            OfficialNotice n = s.getMapper(OfficialNoticeMapper.class).findById(id);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(String.format(
                "{\"id\":%d,\"title\":\"%s\",\"content\":\"%s\",\"coverImage\":\"%s\",\"scenicSpotId\":\"%s\",\"isTop\":%d,\"isPublished\":%d}",
                n.getId(), esc(n.getTitle()), esc(n.getContent()),
                esc(n.getCoverImage()), n.getScenicSpotId() == null ? "" : n.getScenicSpotId().toString(),
                n.getIsTop(), n.getIsPublished()
            ));
        }
    }

    private void saveNotice(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        try (SqlSession s = DBUtil.getSession(false)) {
            OfficialNoticeMapper m = s.getMapper(OfficialNoticeMapper.class);
            OfficialNotice n = new OfficialNotice();
            n.setTitle(request.getParameter("title"));
            n.setContent(request.getParameter("content"));
            n.setCoverImage(request.getParameter("coverImage"));
            n.setIsTop(Integer.parseInt(request.getParameter("isTop") != null ? request.getParameter("isTop") : "0"));
            n.setIsPublished(Integer.parseInt(request.getParameter("isPublished") != null ? request.getParameter("isPublished") : "0"));
            String spotId = request.getParameter("scenicSpotId");
            if (spotId != null && !spotId.isEmpty()) n.setScenicSpotId(Long.parseLong(spotId));

            if (idStr != null && !idStr.isEmpty()) {
                n.setId(Long.parseLong(idStr));
                m.update(n);
            } else {
                n.setCreatedBy(1L);
                n.setId(m.findMaxId() + 1);
                m.insert(n);
            }
            s.commit();
            request.getSession().setAttribute("msg", "公告「" + truncate(n.getTitle()) + "」保存成功");
        } catch (Exception e) {
            request.getSession().setAttribute("msg", "保存失败：" + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/notice");
    }

    private String executeAction(String action, String idStr) {
        Long id = Long.parseLong(idStr);
        try (SqlSession s = DBUtil.getSession()) {
            OfficialNoticeMapper m = s.getMapper(OfficialNoticeMapper.class);
            OfficialNotice item = m.findById(id);
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
                    return "公告「" + title + "」已删除";
                case "publish":  m.togglePublish(id, 1); s.commit(); return "公告「" + title + "」已发布";
                case "unpublish": m.togglePublish(id, 0); s.commit(); return "公告「" + title + "」已下架";
                case "top":    m.toggleTop(id, 1); s.commit(); return "公告「" + title + "」已置顶";
                case "untop":  m.toggleTop(id, 0); s.commit(); return "公告「" + title + "」已取消置顶";
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
