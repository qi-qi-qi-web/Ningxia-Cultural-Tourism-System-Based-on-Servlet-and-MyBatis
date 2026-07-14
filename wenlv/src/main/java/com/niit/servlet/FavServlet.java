package com.niit.servlet;

import com.niit.mapper.HotelMapper;
import com.niit.mapper.TravelGuideMapper;
import com.niit.pojo.User;
import com.niit.utils.DBUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;

@WebServlet("/fav")
public class FavServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);
        Long targetId = Long.parseLong(request.getParameter("id"));
        String type = request.getParameter("type"); // GUIDE / HOTEL
        boolean checkOnly = "1".equals(request.getParameter("check"));

        if (session == null || session.getAttribute("user") == null) {
            if (checkOnly) { response.getWriter().write("{\"faved\":false}"); return; }
            response.getWriter().write("{\"ok\":false,\"msg\":\"请先登录\"}");
            return;
        }
        Long userId = ((User) session.getAttribute("user")).getId();

        try (SqlSession s = DBUtil.getSession(checkOnly)) {
            java.sql.Statement st = s.getConnection().createStatement();
            java.sql.ResultSet rs = st.executeQuery(
                "SELECT COUNT(*) FROM favorite WHERE user_id=" + userId + " AND target_type='" + type + "' AND target_id=" + targetId);
            rs.next();
            boolean faved = rs.getInt(1) > 0;
            rs.close(); st.close();

            if (checkOnly) {
                response.getWriter().write("{\"faved\":" + faved + "}");
                return;
            }

            if (faved) {
                s.getConnection().createStatement().execute(
                    "DELETE FROM favorite WHERE user_id=" + userId + " AND target_type='" + type + "' AND target_id=" + targetId);
                decrementCount(s, type, targetId);
            } else {
                s.getConnection().createStatement().execute(
                    "INSERT INTO favorite (user_id, target_type, target_id) VALUES (" + userId + ",'" + type + "'," + targetId + ")");
                incrementCount(s, type, targetId);
            }
            s.commit();

            long count = getCount(s, type, targetId);
            response.getWriter().write("{\"ok\":true,\"faved\":" + !faved + ",\"count\":" + count + "}");
        } catch (Exception e) {
            response.getWriter().write("{\"ok\":false,\"msg\":\"" + esc(e.getMessage()) + "\"}");
        }
    }

    private void incrementCount(SqlSession s, String type, Long id) {
        if ("HOTEL".equals(type)) s.getMapper(HotelMapper.class).incrementFavoriteCount(id);
        else s.getMapper(TravelGuideMapper.class).incrementFavoriteCount(id);
    }

    private void decrementCount(SqlSession s, String type, Long id) {
        if ("HOTEL".equals(type)) s.getMapper(HotelMapper.class).decrementFavoriteCount(id);
        else s.getMapper(TravelGuideMapper.class).decrementFavoriteCount(id);
    }

    private long getCount(SqlSession s, String type, Long id) {
        try {
            if ("HOTEL".equals(type)) {
                return s.getMapper(HotelMapper.class).findById(id).getFavoriteCount();
            } else {
                return s.getMapper(TravelGuideMapper.class).findById(id).getFavoriteCount();
            }
        } catch (Exception e) { return 0; }
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r","");
    }
}
