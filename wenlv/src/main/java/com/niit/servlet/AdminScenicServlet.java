package com.niit.servlet;

import com.niit.mapper.ScenicSpotMapper;
import com.niit.pojo.ScenicSpot;
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

@WebServlet("/admin/scenic")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)  // 10MB
public class AdminScenicServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if ("edit".equals(action) && idStr != null) { returnJson(response, Long.parseLong(idStr)); return; }

        if (action != null && idStr != null && !"edit".equals(action)) {
            request.getSession().setAttribute("msg", executeAction(action, idStr));
            response.sendRedirect(request.getContextPath() + "/admin/scenic");
            return;
        }

        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("scenicList", s.getMapper(ScenicSpotMapper.class).findAll());
        } catch (Exception e) { request.setAttribute("error", "加载失败：" + e.getMessage()); }
        request.getRequestDispatcher("/Admin-scenic.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if ("save".equals(request.getParameter("action"))) save(request, response);
        else doGet(request, response);
    }

    private void returnJson(HttpServletResponse response, Long id) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            ScenicSpot sc = s.getMapper(ScenicSpotMapper.class).findById(id);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(String.format(
                "{\"id\":%d,\"name\":\"%s\",\"description\":\"%s\",\"address\":\"%s\",\"city\":\"%s\",\"openingHours\":\"%s\",\"contactPhone\":\"%s\",\"coverImage\":\"%s\",\"images\":\"%s\",\"longitude\":%s,\"latitude\":%s,\"minPrice\":%s,\"status\":\"%s\"}",
                sc.getId(), esc(sc.getName()), esc(sc.getDescription()), esc(sc.getAddress()),
                esc(sc.getCity()), esc(sc.getOpeningHours()), esc(sc.getContactPhone()),
                esc(sc.getCoverImage()), esc(sc.getImages()),
                sc.getLongitude()==null?"null":sc.getLongitude().toPlainString(),
                sc.getLatitude()==null?"null":sc.getLatitude().toPlainString(),
                sc.getMinPrice()==null?"null":sc.getMinPrice().toPlainString(), esc(sc.getStatus())
            ));
        }
    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        try (SqlSession s = DBUtil.getSession(false)) {
            ScenicSpotMapper m = s.getMapper(ScenicSpotMapper.class);
            ScenicSpot sc = new ScenicSpot();
            sc.setName(request.getParameter("name"));
            sc.setDescription(request.getParameter("description"));
            sc.setAddress(request.getParameter("address"));
            sc.setCity(request.getParameter("city"));
            sc.setOpeningHours(request.getParameter("openingHours"));
            sc.setContactPhone(request.getParameter("contactPhone"));

            // 处理封面图上传（单文件）
            String coverImage = request.getParameter("coverImage");
            try {
                Part filePart = request.getPart("coverImageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    coverImage = saveUploadedFile(filePart, request, "images/scenic/");
                }
            } catch (Exception e) {}
            if ((coverImage == null || coverImage.isEmpty()) && idStr != null && !idStr.isEmpty()) {
                ScenicSpot old = m.findById(Long.parseLong(idStr));
                if (old != null) coverImage = old.getCoverImage();
            }
            sc.setCoverImage(nvl(coverImage));

            // 处理图片列表上传（多文件）
            String images = processMultiFileUpload(request, "imagesFiles", "images/scenic/",
                                                    request.getParameter("images"));
            sc.setImages(images);

            try { sc.setMinPrice(new BigDecimal(request.getParameter("minPrice"))); } catch(Exception e){}
            try { sc.setLongitude(new BigDecimal(request.getParameter("longitude"))); } catch(Exception e){}
            try { sc.setLatitude(new BigDecimal(request.getParameter("latitude"))); } catch(Exception e){}
            sc.setStatus(request.getParameter("status")!=null?request.getParameter("status"):"OPEN");

            if (idStr != null && !idStr.isEmpty()) {
                sc.setId(Long.parseLong(idStr)); m.update(sc);
            } else { sc.setId(m.findMaxId() + 1); m.insert(sc); }
            s.commit();
            request.getSession().setAttribute("msg", "景区「"+truncate(sc.getName())+"」保存成功");
        } catch (Exception e) { request.getSession().setAttribute("msg", "保存失败："+e.getMessage()); }
        response.sendRedirect(request.getContextPath()+"/admin/scenic");
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
            ScenicSpotMapper m = s.getMapper(ScenicSpotMapper.class);
            ScenicSpot sc = m.findById(id);
            String name = sc!=null ? truncate(sc.getName()) : String.valueOf(id);
            switch (action) {
                case "delete":
                    Statement st = s.getConnection().createStatement();
                    try { st.execute("SET FOREIGN_KEY_CHECKS = 0"); m.deleteById(id); m.shiftIdsDown(id);
                          st.execute("SET FOREIGN_KEY_CHECKS = 1"); } finally { try {st.close();}catch(Exception e){} }
                    s.commit(); return "景区「"+name+"」已删除";
                case "open": m.updateStatus(id,"OPEN"); s.commit(); return "景区「"+name+"」已开放";
                case "close": m.updateStatus(id,"CLOSED"); s.commit(); return "景区「"+name+"」已关闭";
                default: return "未知操作";
            }
        } catch (Exception e) { return "操作失败："+e.getMessage(); }
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

    private String esc(String s){ if(s==null)return""; return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r",""); }
    private String nvl(String s){ return (s==null||s.isEmpty())?null:s; }
    private String truncate(String s){ if(s==null)return""; return s.length()>15?s.substring(0,15)+"...":s; }
}
