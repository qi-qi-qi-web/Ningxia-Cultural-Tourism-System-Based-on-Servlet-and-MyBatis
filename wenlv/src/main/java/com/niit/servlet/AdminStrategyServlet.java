package com.niit.servlet;

import com.niit.mapper.GuideTagMapper;
import com.niit.mapper.TravelGuideMapper;
import com.niit.pojo.GuideTag;
import com.niit.pojo.TravelGuide;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.apache.ibatis.session.SqlSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Statement;
import java.util.List;

@WebServlet("/admin/strategy")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)  // 10MB
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
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if ("save".equals(request.getParameter("action"))) {
            saveStrategy(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void saveStrategy(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        try (SqlSession s = DBUtil.getSession(false)) {
            TravelGuideMapper m = s.getMapper(TravelGuideMapper.class);
            GuideTagMapper tm = s.getMapper(GuideTagMapper.class);
            TravelGuide g = new TravelGuide();
            g.setTitle(request.getParameter("title"));
            g.setContent(request.getParameter("content"));
            g.setTags(request.getParameter("tags"));
            g.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "PUBLISHED");

            // 处理封面图上传
            String coverImage = request.getParameter("coverImage");
            try {
                Part filePart = request.getPart("coverImageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    coverImage = saveUploadedFile(filePart, request);
                }
            } catch (Exception e) {}
            g.setCoverImage(coverImage != null ? coverImage : "");

            Long guideId;
            if (idStr != null && !idStr.isEmpty()) {
                guideId = Long.parseLong(idStr);
                if (coverImage == null || coverImage.isEmpty()) {
                    TravelGuide old = m.findById(guideId);
                    if (old != null && old.getCoverImage() != null) {
                        g.setCoverImage(old.getCoverImage());
                    }
                }
                g.setId(guideId);
                m.update(g);
            } else {
                Object userObj = request.getSession().getAttribute("user");
                g.setUserId(userObj != null ? ((com.niit.pojo.User)userObj).getId() : 1L);
                guideId = m.findMaxId() + 1;
                g.setId(guideId);
                m.insert(g);
            }

            // 同步 guide_tag 关联
            String tags = g.getTags();
            tm.deleteByGuideId(guideId);
            if (tags != null && !tags.trim().isEmpty()) {
                String[] names = tags.split(",");
                for (String name : names) {
                    name = name.trim();
                    if (!name.isEmpty()) {
                        GuideTag t = new GuideTag();
                        t.setId(tm.findMaxId() + 1);
                        t.setGuideId(guideId);
                        t.setName(name);
                        t.setCategory("FEATURE");
                        t.setSortOrder(0);
                        tm.insert(t);
                    }
                }
            }

            s.commit();
            request.getSession().setAttribute("msg", "攻略「" + truncate(g.getTitle()) + "」保存成功");
        } catch (Exception e) {
            request.getSession().setAttribute("msg", "保存失败：" + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/strategy");
    }

    /**
     * 保存上传的文件到 images/guides/ 目录，返回相对路径
     */
    private String saveUploadedFile(Part filePart, HttpServletRequest request) throws IOException {
        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) return "";

        String uniqueName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9._\\-]", "_");
        String realPath = request.getServletContext().getRealPath("/images/guides/");
        File uploadDir = new File(realPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        File targetFile = new File(uploadDir, uniqueName);
        Files.copy(filePart.getInputStream(), targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

        return "images/guides/" + uniqueName;
    }

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
                        // guide_tag 的 guide_id 也跟着减1
                        st.execute("UPDATE guide_tag SET guide_id = guide_id - 1 WHERE guide_id > " + id);
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
