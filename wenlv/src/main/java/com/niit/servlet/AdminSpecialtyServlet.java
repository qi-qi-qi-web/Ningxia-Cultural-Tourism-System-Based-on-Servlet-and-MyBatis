package com.niit.servlet;

import com.niit.mapper.SpecialtyMapper;
import com.niit.pojo.Specialty;
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
import java.util.List;

@WebServlet("/admin/specialty")
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
            sp.setCategoryId(Long.parseLong(request.getParameter("categoryId")));
            sp.setName(request.getParameter("name"));
            sp.setDescription(request.getParameter("description"));
            sp.setPrice(new BigDecimal(request.getParameter("price")));
            sp.setStock(Integer.parseInt(request.getParameter("stock")));
            sp.setMainImage(request.getParameter("mainImage"));
            sp.setImages(request.getParameter("images"));
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

    private String truncate(String s) {
        if (s == null) return "";
        return s.length() > 15 ? s.substring(0, 15) + "..." : s;
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r","");
    }
}
