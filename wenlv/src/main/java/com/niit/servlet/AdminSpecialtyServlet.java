package com.niit.servlet;

import com.niit.mapper.SpecialtyMapper;
import com.niit.pojo.Specialty;
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
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@WebServlet("/admin/specialty")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)  // 10MB
public class AdminSpecialtyServlet extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/admin/specialty");
            return;
        }

        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("specialtyList", s.getMapper(SpecialtyMapper.class).findAllWithCategory());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.getRequestDispatcher("/Admin-speciality.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if ("save".equals(request.getParameter("action"))) {
            saveSpecialty(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void returnJson(HttpServletResponse response, Long id) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            Specialty sp = s.getMapper(SpecialtyMapper.class).findById(id);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(String.format(
                "{\"id\":%d,\"name\":\"%s\",\"description\":\"%s\",\"categoryId\":%d,\"price\":%s,\"stock\":%d,\"mainImage\":\"%s\",\"images\":\"%s\",\"status\":%d}",
                sp.getId(), esc(sp.getName()), esc(sp.getDescription()),
                sp.getCategoryId(), sp.getPrice().toString(), sp.getStock(),
                esc(sp.getMainImage()), esc(sp.getImages()), sp.getStatus()
            ));
        }
    }

    private void saveSpecialty(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        try (SqlSession s = DBUtil.getSession(false)) {
            SpecialtyMapper m = s.getMapper(SpecialtyMapper.class);
            Specialty sp = new Specialty();

            String catId = request.getParameter("categoryId");
            if (catId == null || catId.isEmpty()) {
                request.getSession().setAttribute("msg", "请选择分类");
                response.sendRedirect(request.getContextPath() + "/admin/specialty");
                return;
            }
            sp.setCategoryId(Long.parseLong(catId));
            sp.setName(request.getParameter("name"));
            sp.setDescription(request.getParameter("description"));
            sp.setPrice(new BigDecimal(request.getParameter("price")));
            sp.setStock(Integer.parseInt(request.getParameter("stock")));

            // 处理主图上传（单文件）
            String mainImage = request.getParameter("mainImage");
            try {
                Part filePart = request.getPart("mainImageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    mainImage = saveUploadedFile(filePart, request, "images/specialties/");
                }
            } catch (Exception e) {}
            if ((mainImage == null || mainImage.isEmpty()) && idStr != null && !idStr.isEmpty()) {
                Specialty old = m.findById(Long.parseLong(idStr));
                if (old != null) mainImage = old.getMainImage();
            }
            sp.setMainImage(emptyToNull(mainImage));

            // 处理图片列表上传（多文件）
            String images = processMultiFileUpload(request, "imagesFiles", "images/specialties/",
                                                    request.getParameter("images"));
            sp.setImages(images);

            sp.setStatus(Integer.parseInt(request.getParameter("status") != null ? request.getParameter("status") : "1"));

            if (idStr != null && !idStr.isEmpty()) {
                sp.setId(Long.parseLong(idStr));
                m.update(sp);
            } else {
                sp.setId(m.findMaxId() + 1);
                m.insert(sp);
            }
            s.commit();
            request.getSession().setAttribute("msg", "特产「" + truncate(sp.getName()) + "」保存成功");
        } catch (Exception e) {
            request.getSession().setAttribute("msg", "保存失败：" + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/specialty");
    }

    /**
     * 处理多文件上传，与手动输入的JSON数组合并
     */
    private String processMultiFileUpload(HttpServletRequest request, String fileFieldName,
                                           String uploadDir, String manualJson) throws IOException {
        List<String> allUrls = new ArrayList<>();

        // 解析手动输入的JSON数组
        if (manualJson != null && !manualJson.trim().isEmpty()) {
            String trimmed = manualJson.trim();
            if (trimmed.startsWith("[") && trimmed.endsWith("]")) {
                String content = trimmed.substring(1, trimmed.length() - 1).trim();
                if (!content.isEmpty()) {
                    StringBuilder item = new StringBuilder();
                    boolean inQuote = false;
                    for (int i = 0; i < content.length(); i++) {
                        char c = content.charAt(i);
                        if (c == '"') {
                            inQuote = !inQuote;
                        } else if (c == ',' && !inQuote) {
                            String s = item.toString().trim();
                            if (s.startsWith("\"") && s.endsWith("\"")) {
                                s = s.substring(1, s.length() - 1);
                            }
                            if (!s.isEmpty()) allUrls.add(s);
                            item = new StringBuilder();
                        } else {
                            item.append(c);
                        }
                    }
                    String s = item.toString().trim();
                    if (s.startsWith("\"") && s.endsWith("\"")) {
                        s = s.substring(1, s.length() - 1);
                    }
                    if (!s.isEmpty()) allUrls.add(s);
                }
            } else {
                allUrls.add(trimmed);
            }
        }

        // 添加上传的文件
        try {
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if (fileFieldName.equals(part.getName()) && part.getSize() > 0) {
                    String url = saveUploadedFile(part, request, uploadDir);
                    if (!url.isEmpty()) allUrls.add(url);
                }
            }
        } catch (Exception e) {
            // ignore
        }

        if (allUrls.isEmpty()) return null;

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < allUrls.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(escJson(allUrls.get(i))).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    private String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"");
    }

    private String executeAction(String action, String idStr) {
        Long id = Long.parseLong(idStr);
        try (SqlSession s = DBUtil.getSession()) {
            SpecialtyMapper m = s.getMapper(SpecialtyMapper.class);
            Specialty item = m.findById(id);
            String name = truncate(item != null ? item.getName() : String.valueOf(id));

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
                    return "特产「" + name + "」已删除";
                case "up":   m.toggleStatus(id, 1); s.commit(); return "特产「" + name + "」已上架";
                case "down": m.toggleStatus(id, 0); s.commit(); return "特产「" + name + "」已下架";
                default: return "未知操作";
            }
        } catch (Exception e) {
            return "操作失败：" + e.getMessage();
        }
    }

    /**
     * 保存上传的文件到指定目录，返回相对路径
     */
    private String saveUploadedFile(Part filePart, HttpServletRequest request, String uploadDir) throws IOException {
        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) return "";

        String uniqueName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9._\\-]", "_");
        String realPath = request.getServletContext().getRealPath("/" + uploadDir);
        File dir = new File(realPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        File targetFile = new File(dir, uniqueName);
        Files.copy(filePart.getInputStream(), targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

        return uploadDir + uniqueName;
    }

    private String truncate(String s) {
        if (s == null) return "";
        return s.length() > 15 ? s.substring(0, 15) + "..." : s;
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r","");
    }

    private String emptyToNull(String s) {
        return (s == null || s.isEmpty()) ? null : s;
    }
}
