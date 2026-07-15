package com.niit.servlet;

import com.niit.mapper.FavoriteMapper;
import com.niit.mapper.HotelMapper;
import com.niit.mapper.ScenicSpotMapper;
import com.niit.mapper.SpecialtyMapper;
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
        String type = request.getParameter("type");

        // 批量查询：返回该类型所有已收藏的 target_id 列表
        if ("1".equals(request.getParameter("list"))) {
            if (session == null || session.getAttribute("user") == null) {
                response.getWriter().write("[]");
                return;
            }
            Long userId = ((User) session.getAttribute("user")).getId();
            try (SqlSession s = DBUtil.getSession()) {
                java.util.List<Long> ids = s.getMapper(FavoriteMapper.class).findIdsByUserAndType(userId, type);
                StringBuilder sb = new StringBuilder("[");
                for (int i = 0; i < ids.size(); i++) {
                    if (i > 0) sb.append(",");
                    sb.append(ids.get(i));
                }
                sb.append("]");
                response.getWriter().write(sb.toString());
            }
            return;
        }

        Long targetId = Long.parseLong(request.getParameter("id"));
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
        else if ("SCENIC".equals(type)) s.getMapper(ScenicSpotMapper.class).incrementFavoriteCount(id);
        else if ("SPECIALTY".equals(type)) s.getMapper(SpecialtyMapper.class).incrementFavoriteCount(id);
        else s.getMapper(TravelGuideMapper.class).incrementFavoriteCount(id);
    }

    private void decrementCount(SqlSession s, String type, Long id) {
        if ("HOTEL".equals(type)) s.getMapper(HotelMapper.class).decrementFavoriteCount(id);
        else if ("SCENIC".equals(type)) s.getMapper(ScenicSpotMapper.class).decrementFavoriteCount(id);
        else if ("SPECIALTY".equals(type)) s.getMapper(SpecialtyMapper.class).decrementFavoriteCount(id);
        else s.getMapper(TravelGuideMapper.class).decrementFavoriteCount(id);
    }

    private long getCount(SqlSession s, String type, Long id) {
        try {
            if ("HOTEL".equals(type)) {
                return s.getMapper(HotelMapper.class).findById(id).getFavoriteCount();
            } else if ("SCENIC".equals(type)) {
                return s.getMapper(ScenicSpotMapper.class).findById(id).getFavoriteCount();
            } else if ("SPECIALTY".equals(type)) {
                return s.getMapper(SpecialtyMapper.class).findById(id).getFavoriteCount();
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
