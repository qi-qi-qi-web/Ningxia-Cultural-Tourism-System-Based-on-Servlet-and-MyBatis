package com.niit.servlet;

import com.niit.mapper.GuideTagMapper;
import com.niit.mapper.TravelGuideMapper;
import com.niit.pojo.GuideTag;
import com.niit.pojo.TravelGuide;
import com.niit.pojo.User;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import org.apache.ibatis.session.SqlSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;

@WebServlet("/guide")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)  // 10MB
public class GuideServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // 返回已发布攻略 JSON 列表
        if ("list".equals(action)) {
            returnGuideListJson(response);
            return;
        }

        // 返回单篇攻略详情（JSON）
        if ("detail".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                returnGuideJson(response, Long.parseLong(idStr));
            }
            return;
        }

        // 收藏/取消收藏
        if ("fav".equals(action)) {
            handleFavorite(request, response);
            return;
        }

        // 浏览数自动+1（AJAX）
        if ("view".equals(action)) {
            handleView(request, response);
            return;
        }

        // 返回某用户的攻略 JSON 列表
        if ("my".equals(action)) {
            String userIdStr = request.getParameter("userId");
            if (userIdStr != null) {
                returnUserGuidesJson(response, Long.parseLong(userIdStr));
            }
            return;
        }

        // 默认：加载已发布攻略列表，转发到 TravelGuide.jsp
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("guideList", s.getMapper(TravelGuideMapper.class).findPublished());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.getRequestDispatcher("/TravelGuide.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");

        if ("publish".equals(action)) {
            handlePublish(request, response);
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"未知操作\"}");
        }
    }

    /**
     * 发布攻略：需要登录态
     */
    private void handlePublish(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"请先登录\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String tags = request.getParameter("tags");

        if (title == null || title.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"请输入攻略标题\"}");
            return;
        }
        if (content == null || content.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"请输入攻略内容\"}");
            return;
        }

        // 处理封面图上传
        String coverImage = "";
        try {
            Part filePart = request.getPart("coverImage");
            if (filePart != null && filePart.getSize() > 0) {
                coverImage = saveUploadedFile(filePart, request);
            }
        } catch (Exception e) {
            // 无文件上传，忽略
        }

        try (SqlSession s = DBUtil.getSession(false)) {
            TravelGuideMapper m = s.getMapper(TravelGuideMapper.class);
            GuideTagMapper tm = s.getMapper(GuideTagMapper.class);
            TravelGuide g = new TravelGuide();
            long newId = m.findMaxId() + 1;
            g.setId(newId);
            g.setUserId(user.getId());
            g.setTitle(title.trim());
            g.setContent(content.trim());
            g.setTags(tags != null ? tags.trim() : "");
            g.setCoverImage(coverImage);
            g.setStatus("PUBLISHED");
            m.insert(g);

            // 写入 guide_tag 关联
            if (tags != null && !tags.trim().isEmpty()) {
                saveGuideTags(tm, newId, tags.trim());
            }

            s.commit();
            response.getWriter().write("{\"success\":true,\"message\":\"攻略发布成功！\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"message\":\"发布失败：" + esc(e.getMessage()) + "\"}");
        }
    }

    /**
     * 保存攻略标签关联：先删后插
     */
    private void saveGuideTags(GuideTagMapper tm, Long guideId, String tagsStr) {
        tm.deleteByGuideId(guideId);
        String[] names = tagsStr.split(",");
        for (String name : names) {
            name = name.trim();
            if (!name.isEmpty()) {
                GuideTag t = new GuideTag();
                t.setId(tm.findMaxId() + 1);
                t.setGuideId(guideId);
                t.setName(name);
                t.setCategory("FEATURE");  // 默认分类
                t.setSortOrder(0);
                tm.insert(t);
            }
        }
    }

    /**
     * 保存上传的文件到 images/guides/ 目录，返回相对路径
     */
    private String saveUploadedFile(Part filePart, HttpServletRequest request) throws IOException {
        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) return "";

        // 生成唯一文件名：时间戳_原文件名
        String uniqueName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9._\\-]", "_");
        String relativePath = "images/guides/" + uniqueName;

        // 获取绝对路径
        String realPath = request.getServletContext().getRealPath("/images/guides/");
        File uploadDir = new File(realPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        File targetFile = new File(uploadDir, uniqueName);
        Files.copy(filePart.getInputStream(), targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

        return relativePath;
    }

    /**
     * 返回已发布攻略 JSON 数组
     */
    private void returnGuideListJson(HttpServletResponse response) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            List<TravelGuide> list = s.getMapper(TravelGuideMapper.class).findPublished();
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                if (i > 0) sb.append(",");
                sb.append(guideToJson(list.get(i)));
            }
            sb.append("]");
            response.getWriter().write(sb.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    /**
     * 返回单篇攻略 JSON
     */
    private void returnGuideJson(HttpServletResponse response, Long id) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            TravelGuide g = s.getMapper(TravelGuideMapper.class).findById(id);
            if (g == null) {
                response.getWriter().write("{}");
                return;
            }
            response.getWriter().write(guideToJson(g));
        } catch (Exception e) {
            response.getWriter().write("{}");
        }
    }

    /**
     * 返回某用户的攻略 JSON 数组
     */
    private void returnUserGuidesJson(HttpServletResponse response, Long userId) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            List<TravelGuide> list = s.getMapper(TravelGuideMapper.class).findByUserId(userId);
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                if (i > 0) sb.append(",");
                sb.append(guideToJson(list.get(i)));
            }
            sb.append("]");
            response.getWriter().write(sb.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    /**
     * 将 TravelGuide 对象转为 JSON 字符串
     */
    private String guideToJson(TravelGuide g) {
        return String.format(
            "{\"id\":%d,\"userId\":%d,\"title\":\"%s\",\"content\":\"%s\",\"coverImage\":\"%s\",\"tags\":\"%s\",\"likeCount\":%d,\"viewCount\":%d,\"commentCount\":%d,\"favoriteCount\":%d,\"status\":\"%s\",\"createdAt\":\"%s\",\"userName\":\"%s\"}",
            g.getId(),
            g.getUserId() != null ? g.getUserId() : 0,
            esc(g.getTitle()),
            esc(g.getContent()),
            esc(g.getCoverImage()),
            esc(g.getTags()),
            g.getLikeCount() != null ? g.getLikeCount() : 0,
            g.getViewCount() != null ? g.getViewCount() : 0,
            g.getCommentCount() != null ? g.getCommentCount() : 0,
            g.getFavoriteCount() != null ? g.getFavoriteCount() : 0,
            esc(g.getStatus()),
            g.getCreatedAt() != null ? g.getCreatedAt().toString() : "",
            esc(g.getUserName())
        );
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r","");
    }

    private void handleFavorite(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        Long guideId = Long.parseLong(request.getParameter("id"));
        boolean checkOnly = "1".equals(request.getParameter("check"));
        if (session == null || session.getAttribute("user") == null) {
            if (checkOnly) { response.getWriter().write("{\"faved\":false}"); return; }
            response.getWriter().write("{\"ok\":false,\"msg\":\"请先登录\"}");
            return;
        }
        Long userId = ((User) session.getAttribute("user")).getId();
        try (SqlSession s = DBUtil.getSession(checkOnly)) {
            TravelGuideMapper m = s.getMapper(TravelGuideMapper.class);
            java.sql.Statement st = s.getConnection().createStatement();
            java.sql.ResultSet rs = st.executeQuery(
                "SELECT COUNT(*) FROM favorite WHERE user_id=" + userId + " AND target_type='GUIDE' AND target_id=" + guideId);
            rs.next();
            boolean faved = rs.getInt(1) > 0;
            rs.close(); st.close();
            if (checkOnly) {
                response.getWriter().write("{\"faved\":" + faved + "}");
                return;
            }
            if (faved) {
                s.getConnection().createStatement().execute(
                    "DELETE FROM favorite WHERE user_id=" + userId + " AND target_type='GUIDE' AND target_id=" + guideId);
                m.decrementFavoriteCount(guideId);
            } else {
                s.getConnection().createStatement().execute(
                    "INSERT INTO favorite (user_id, target_type, target_id) VALUES (" + userId + ",'GUIDE'," + guideId + ")");
                m.incrementFavoriteCount(guideId);
            }
            s.commit();
            TravelGuide g = m.findById(guideId);
            response.getWriter().write("{\"ok\":true,\"faved\":" + !faved + ",\"count\":" + (g != null ? g.getFavoriteCount() : 0) + "}");
        } catch (Exception e) {
            response.getWriter().write("{\"ok\":false,\"msg\":\"" + esc(e.getMessage()) + "\"}");
        }
    }

    private void handleView(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Long guideId = Long.parseLong(request.getParameter("id"));
        try (SqlSession s = DBUtil.getSession(false)) {
            s.getMapper(TravelGuideMapper.class).incrementViewCount(guideId);
            s.commit();
            response.getWriter().write("{\"ok\":true}");
        } catch (Exception e) {
            response.getWriter().write("{\"ok\":false}");
        }
    }
}
