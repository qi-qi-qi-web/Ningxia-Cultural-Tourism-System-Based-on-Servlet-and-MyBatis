package com.niit.servlet;

import com.niit.mapper.PlatformLogMapper;
import com.niit.pojo.PlatformLog;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/log")
public class AdminLogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");

        // 查看单条日志详情（返回 JSON）
        if (idStr != null) {
            try (SqlSession session = DBUtil.getSession()) {
                PlatformLog log = session.getMapper(PlatformLogMapper.class).findById(Long.parseLong(idStr));
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(
                    "{\"id\":" + log.getId() +
                    ",\"userName\":\"" + escape(log.getUserName()) + "\"" +
                    ",\"logType\":\"" + escape(log.getLogType()) + "\"" +
                    ",\"targetType\":\"" + escape(log.getTargetType()) + "\"" +
                    ",\"targetName\":\"" + escape(log.getTargetName()) + "\"" +
                    ",\"detail\":\"" + escape(log.getDetail()) + "\"" +
                    ",\"ipAddress\":\"" + escape(log.getIpAddress()) + "\"" +
                    ",\"userAgent\":\"" + escape(log.getUserAgent()) + "\"" +
                    ",\"createdAt\":\"" + (log.getCreatedAt() != null ? log.getCreatedAt().toString() : "") + "\"" +
                    "}"
                );
            } catch (Exception e) {
                response.getWriter().write("{\"error\":\"" + escape(e.getMessage()) + "\"}");
            }
            return;
        }

        // 默认：列表
        try (SqlSession session = DBUtil.getSession()) {
            List<PlatformLog> list = session.getMapper(PlatformLogMapper.class).findAll();
            request.setAttribute("logList", list);
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.getRequestDispatcher("/Admin-log.jsp").forward(request, response);
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
