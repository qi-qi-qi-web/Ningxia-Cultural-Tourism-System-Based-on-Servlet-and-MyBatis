package com.niit.servlet;

import com.niit.mapper.HotelMapper;
import com.niit.pojo.Hotel;
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

@WebServlet("/admin/hotel")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)  // 10MB
public class AdminHotelServlet extends HttpServlet {

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
            request.getSession().setAttribute("msg", executeAction(action, idStr));
            response.sendRedirect(request.getContextPath() + "/admin/hotel");
            return;
        }

        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("hotelList", s.getMapper(HotelMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.getRequestDispatcher("/Admin-Hotel.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if ("save".equals(request.getParameter("action"))) saveHotel(request, response);
        else doGet(request, response);
    }

    private void returnJson(HttpServletResponse response, Long id) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            Hotel h = s.getMapper(HotelMapper.class).findById(id);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(String.format(
                "{\"id\":%d,\"name\":\"%s\",\"description\":\"%s\",\"address\":\"%s\",\"city\":\"%s\",\"starRating\":%s,\"contactPhone\":\"%s\",\"facilities\":\"%s\",\"coverImage\":\"%s\",\"images\":\"%s\",\"minPrice\":%s,\"status\":%d}",
                h.getId(), esc(h.getName()), esc(h.getDescription()), esc(h.getAddress()),
                esc(h.getCity()), h.getStarRating()==null?"null":h.getStarRating().toString(),
                esc(h.getContactPhone()), esc(h.getFacilities()), esc(h.getCoverImage()),
                esc(h.getImages()), h.getMinPrice()==null?"null":h.getMinPrice().toString(), h.getStatus()
            ));
        }
    }

    private void saveHotel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        try (SqlSession s = DBUtil.getSession(false)) {
            HotelMapper m = s.getMapper(HotelMapper.class);
            Hotel h = new Hotel();
            h.setName(request.getParameter("name"));
            h.setDescription(request.getParameter("description"));
            h.setAddress(request.getParameter("address"));
            h.setCity(request.getParameter("city"));
            try { h.setStarRating(Integer.parseInt(request.getParameter("starRating"))); } catch(Exception e){}
            h.setContactPhone(request.getParameter("contactPhone"));

            // 处理封面图上传（单文件）
            String coverImage = request.getParameter("coverImage");
            try {
                Part filePart = request.getPart("coverImageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    coverImage = saveUploadedFile(filePart, request, "images/hotels/");
                }
            } catch (Exception e) {}
            if ((coverImage == null || coverImage.isEmpty()) && idStr != null && !idStr.isEmpty()) {
                Hotel old = m.findById(Long.parseLong(idStr));
                if (old != null) coverImage = old.getCoverImage();
            }
            h.setCoverImage(nvl(coverImage));

            h.setFacilities(nvl(request.getParameter("facilities")));

            // 处理图片列表上传（多文件）
            String images = processMultiFileUpload(request, "imagesFiles", "images/hotels/",
                                                    request.getParameter("images"));
            h.setImages(images);

            try { h.setMinPrice(new BigDecimal(request.getParameter("minPrice"))); } catch(Exception e){}
            h.setStatus(Integer.parseInt(request.getParameter("status")!=null?request.getParameter("status"):"1"));

            if (idStr != null && !idStr.isEmpty()) {
                h.setId(Long.parseLong(idStr));
                m.update(h);
            } else {
                h.setId(m.findMaxId() + 1);
                m.insert(h);
            }
            s.commit();
            request.getSession().setAttribute("msg", "酒店「"+truncate(h.getName())+"」保存成功");
        } catch (Exception e) {
            request.getSession().setAttribute("msg", "保存失败："+e.getMessage());
        }
        response.sendRedirect(request.getContextPath()+"/admin/hotel");
    }

    /**
     * 处理多文件上传，与手动输入的JSON数组合并
     * @param request HttpServletRequest
     * @param fileFieldName 文件上传字段名
     * @param uploadDir 上传目录
     * @param manualJson 手动输入的JSON数组字符串
     * @return 合并后的JSON数组字符串，若无内容返回null
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
                    // 简单分割：按逗号分割，去除引号
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
                    // 最后一项
                    String s = item.toString().trim();
                    if (s.startsWith("\"") && s.endsWith("\"")) {
                        s = s.substring(1, s.length() - 1);
                    }
                    if (!s.isEmpty()) allUrls.add(s);
                }
            } else {
                // 非JSON格式，作为单个URL处理
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

        // 构建JSON数组字符串
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
            HotelMapper m = s.getMapper(HotelMapper.class);
            Hotel h = m.findById(id);
            String name = h!=null ? truncate(h.getName()) : String.valueOf(id);
            switch (action) {
                case "delete":
                    Statement st = s.getConnection().createStatement();
                    try { st.execute("SET FOREIGN_KEY_CHECKS = 0"); m.deleteById(id); m.shiftIdsDown(id);
                          st.execute("SET FOREIGN_KEY_CHECKS = 1"); } finally { try {st.close();}catch(Exception e){} }
                    s.commit(); return "酒店「"+name+"」已删除";
                case "up":   m.toggleStatus(id,1); s.commit(); return "酒店「"+name+"」已上架";
                case "down": m.toggleStatus(id,0); s.commit(); return "酒店「"+name+"」已下架";
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

    private String esc(String s){ if(s==null)return ""; return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r",""); }
    private String nvl(String s){ return (s==null||s.isEmpty())?null:s; }
    private String truncate(String s){ if(s==null)return""; return s.length()>15?s.substring(0,15)+"...":s; }
}
