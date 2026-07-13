package com.niit.servlet;

import com.niit.mapper.HotelMapper;
import com.niit.pojo.Hotel;
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

@WebServlet("/admin/hotel")
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
            h.setFacilities(nvl(request.getParameter("facilities")));
            h.setCoverImage(nvl(request.getParameter("coverImage")));
            h.setImages(nvl(request.getParameter("images")));
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

    private String esc(String s){ if(s==null)return ""; return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r",""); }
    private String nvl(String s){ return (s==null||s.isEmpty())?null:s; }
    private String truncate(String s){ if(s==null)return""; return s.length()>15?s.substring(0,15)+"...":s; }
}
