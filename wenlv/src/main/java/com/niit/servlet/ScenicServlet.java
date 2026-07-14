package com.niit.servlet;

import com.niit.mapper.ScenicSpotMapper;
import com.niit.utils.DBUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;

@WebServlet("/scenic")
public class ScenicServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String action = request.getParameter("action");

        // 浏览数自动+1（AJAX）
        if ("view".equals(action)) {
            handleView(request, response);
            return;
        }

        response.getWriter().write("{\"ok\":false,\"msg\":\"未知操作\"}");
    }

    private void handleView(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Long scenicId = Long.parseLong(request.getParameter("id"));
            try (SqlSession s = DBUtil.getSession(false)) {
                s.getMapper(ScenicSpotMapper.class).incrementViewCount(scenicId);
                s.commit();
                response.getWriter().write("{\"ok\":true}");
            }
        } catch (Exception e) {
            response.getWriter().write("{\"ok\":false}");
        }
    }
}
