package com.niit.servlet;

import com.niit.mapper.ScenicSpotMapper;
import com.niit.pojo.ScenicSpot;
import com.niit.utils.DBUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/map")
public class MapServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String action = request.getParameter("action");

        if ("scenicData".equals(action)) {
            handleScenicData(request, response);
        } else if ("listOpen".equals(action)) {
            handleListOpen(response);
        } else {
            response.getWriter().write("{\"ok\":false,\"msg\":\"未知操作\"}");
        }
    }

    private void handleScenicData(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Long scenicId = Long.parseLong(request.getParameter("id"));
            try (SqlSession s = DBUtil.getSession()) {
                ScenicSpot scenic = s.getMapper(ScenicSpotMapper.class).findById(scenicId);
                if (scenic != null) {
                    response.getWriter().write(String.format(
                        "{\"ok\":true,\"id\":%d,\"name\":\"%s\",\"address\":\"%s\",\"city\":\"%s\",\"lat\":%s,\"lng\":%s}",
                        scenic.getId(),
                        escapeJson(scenic.getName()),
                        escapeJson(scenic.getAddress()),
                        escapeJson(scenic.getCity()),
                        scenic.getLatitude() != null ? scenic.getLatitude().toString() : "null",
                        scenic.getLongitude() != null ? scenic.getLongitude().toString() : "null"
                    ));
                } else {
                    response.getWriter().write("{\"ok\":false,\"msg\":\"景区不存在\"}");
                }
            }
        } catch (Exception e) {
            response.getWriter().write("{\"ok\":false,\"msg\":\"查询失败\"}");
        }
    }

    private void handleListOpen(HttpServletResponse response) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            List<ScenicSpot> list = s.getMapper(ScenicSpotMapper.class).findOpen();
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                if (i > 0) sb.append(",");
                ScenicSpot scenic = list.get(i);
                sb.append(String.format(
                    "{\"id\":%d,\"name\":\"%s\",\"city\":\"%s\"}",
                    scenic.getId(),
                    escapeJson(scenic.getName()),
                    escapeJson(scenic.getCity())
                ));
            }
            sb.append("]");
            response.getWriter().write(sb.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
