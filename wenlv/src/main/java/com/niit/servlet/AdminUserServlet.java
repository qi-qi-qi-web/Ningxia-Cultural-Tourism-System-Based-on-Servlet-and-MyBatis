package com.niit.servlet;

import com.niit.mapper.UserMapper;
import com.niit.pojo.User;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.sql.Statement;
import java.util.List;

/**
 * 管理员用户管理控制器
 * GET  /admin/user               → 列出所有用户，转发到 Admin-user.jsp
 * GET  /admin/user?action=delete&id=1  → 删除用户
 * GET  /admin/user?action=toggle&id=1  → 切换用户禁用/启用状态
 */
@WebServlet("/admin/user")
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        String idStr  = request.getParameter("id");

        // ---- 如果有操作指令，先执行 ----
        if (action != null && idStr != null && !idStr.isEmpty()) {
            String msg = executeAction(action, idStr);
            request.getSession().setAttribute("msg", msg);
            response.sendRedirect(request.getContextPath() + "/admin/user");
            return;
        }

        // ---- 默认：查询全部用户并转发到 JSP ----
        try (SqlSession session = DBUtil.getSession()) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            List<User> users = mapper.findAll();
            request.setAttribute("users", users);
        } catch (Exception e) {
            request.setAttribute("error", "用户数据加载失败：" + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/Admin-user.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // ==================== 私有方法 ====================

    /**
     * 执行删除 / 状态切换，返回提示消息
     */
    private String executeAction(String action, String idStr) {
        Long id;
        try {
            id = Long.parseLong(idStr);
        } catch (NumberFormatException e) {
            return "无效的用户 ID";
        }

        try (SqlSession session = DBUtil.getSession()) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            User user = mapper.findById(id);

            if (user == null) {
                return "用户不存在";
            }

            switch (action) {
                case "delete":
                    if ("ADMIN".equals(user.getRole())) {
                        return "不允许删除管理员账号";
                    }
                    Statement stmt = null;
                    try {
                        stmt = session.getConnection().createStatement();
                        stmt.execute("SET FOREIGN_KEY_CHECKS = 0");
                        mapper.deleteById(id);
                        mapper.shiftIdsDown(id);
                        Long maxId = mapper.findMaxId();
                        stmt.execute("ALTER TABLE sys_user AUTO_INCREMENT = " + (maxId + 1));
                        stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
                    } finally { if (stmt != null) try { stmt.close(); } catch (Exception ignored) {} }
                    session.commit();
                    return "用户「" + user.getUsername() + "」已删除.";

                case "toggle":
                    if ("ADMIN".equals(user.getRole())) {
                        return "不允许限制管理员账号";
                    }
                    int newStatus = (user.getStatus() != null && user.getStatus() == 0) ? 1 : 0;
                    mapper.updateStatus(id, newStatus);
                    session.commit();
                    return newStatus == 0
                            ? "用户「" + user.getUsername() + "」已被禁用（无法发布攻略和评论）"
                            : "用户「" + user.getUsername() + "」已解除限制";

                default:
                    return "未知操作: " + action;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "操作失败：" + e.getMessage();
        }
    }
}
