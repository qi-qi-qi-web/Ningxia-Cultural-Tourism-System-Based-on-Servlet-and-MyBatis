package com.niit.servlet;

import com.niit.mapper.ScenicSpotMapper;
import com.niit.pojo.ScenicSpot;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Statement;

@WebServlet("/admin/scenic")
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
                "{\"id\":%d,\"name\":\"%s\",\"description\":\"%s\",\"address\":\"%s\",\"city\":\"%s\",\"openingHours\":\"%s\",\"contactPhone\":\"%s\",\"coverImage\":\"%s\",\"images\":\"%s\",\"minPrice\":%s,\"status\":\"%s\"}",
                sc.getId(), esc(sc.getName()), esc(sc.getDescription()), esc(sc.getAddress()),
                esc(sc.getCity()), esc(sc.getOpeningHours()), esc(sc.getContactPhone()),
                esc(sc.getCoverImage()), esc(sc.getImages()),
                sc.getMinPrice()==null?"null":sc.getMinPrice().toString(), esc(sc.getStatus())
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
            sc.setCoverImage(nvl(request.getParameter("coverImage")));
            sc.setImages(nvl(request.getParameter("images")));
            try { sc.setMinPrice(new BigDecimal(request.getParameter("minPrice"))); } catch(Exception e){}
            sc.setStatus(request.getParameter("status")!=null?request.getParameter("status"):"OPEN");

            if (idStr != null && !idStr.isEmpty()) {
                sc.setId(Long.parseLong(idStr)); m.update(sc);
            } else { sc.setId(m.findMaxId() + 1); m.insert(sc); }
            s.commit();
            request.getSession().setAttribute("msg", "景区「"+truncate(sc.getName())+"」保存成功");
        } catch (Exception e) { request.getSession().setAttribute("msg", "保存失败："+e.getMessage()); }
        response.sendRedirect(request.getContextPath()+"/admin/scenic");
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

    private String esc(String s){ if(s==null)return""; return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r",""); }
    private String nvl(String s){ return (s==null||s.isEmpty())?null:s; }
    private String truncate(String s){ if(s==null)return""; return s.length()>15?s.substring(0,15)+"...":s; }
}
