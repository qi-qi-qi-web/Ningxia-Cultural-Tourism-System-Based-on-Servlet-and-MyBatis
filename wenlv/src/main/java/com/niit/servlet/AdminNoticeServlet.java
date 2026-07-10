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
import java.util.List;

@WebServlet("/admin/notice")
public class AdminNoticeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr  = request.getParameter("id");

        if (action != null && idStr != null) {
            String msg = executeAction(action, idStr);
            request.getSession().setAttribute("msg", msg);
            response.sendRedirect(request.getContextPath() + "/admin/notice");
            return;
        }

        try (SqlSession session = DBUtil.getSession()) {
            List<OfficialNotice> list = session.getMapper(OfficialNoticeMapper.class).findAll();
            request.setAttribute("noticeList", list);
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

    private void saveNotice(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        try (SqlSession session = DBUtil.getSession(false)) {
            OfficialNoticeMapper mapper = session.getMapper(OfficialNoticeMapper.class);
            OfficialNotice n = new OfficialNotice();
            n.setTitle(request.getParameter("title"));
            n.setContent(request.getParameter("content"));
            n.setCoverImage(request.getParameter("coverImage"));
            n.setIsTop(request.getParameter("isTop") != null ? Integer.parseInt(request.getParameter("isTop")) : 0);
            n.setIsPublished(request.getParameter("isPublished") != null ? Integer.parseInt(request.getParameter("isPublished")) : 0);
            String spotId = request.getParameter("scenicSpotId");
            if (spotId != null && !spotId.isEmpty()) n.setScenicSpotId(Long.parseLong(spotId));

            if (idStr != null && !idStr.isEmpty()) {
                n.setId(Long.parseLong(idStr));
                mapper.update(n);
            } else {
                n.setCreatedBy(1L);
                mapper.insert(n);
            }
            session.commit();
            request.getSession().setAttribute("msg", "公告保存成功");
        } catch (Exception e) {
            request.getSession().setAttribute("msg", "保存失败：" + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/notice");
    }

    private String executeAction(String action, String idStr) {
        Long id = Long.parseLong(idStr);
        try (SqlSession session = DBUtil.getSession()) {
            OfficialNoticeMapper mapper = session.getMapper(OfficialNoticeMapper.class);
            switch (action) {
                case "delete": mapper.deleteById(id); session.commit(); return "公告已删除";
                case "publish": mapper.togglePublish(id, 1); session.commit(); return "公告已发布";
                case "unpublish": mapper.togglePublish(id, 0); session.commit(); return "公告已下架";
                case "top": mapper.toggleTop(id, 1); session.commit(); return "已置顶";
                case "untop": mapper.toggleTop(id, 0); session.commit(); return "已取消置顶";
                default: return "未知操作";
            }
        }
    }
}
