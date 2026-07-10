package com.niit.servlet;

import com.niit.mapper.OrderMapper;
import com.niit.pojo.OrderMain;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/order")
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action != null && idStr != null) {
            String msg = executeAction(action, idStr);
            request.getSession().setAttribute("msg", msg);
            response.sendRedirect(request.getContextPath() + "/admin/order");
            return;
        }

        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("orderList", s.getMapper(OrderMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
        request.getRequestDispatcher("/Admin-order.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { doGet(request, response); }

    private String executeAction(String action, String idStr) {
        Long id = Long.parseLong(idStr);
        try (SqlSession s = DBUtil.getSession()) {
            OrderMapper m = s.getMapper(OrderMapper.class);
            switch (action) {
                case "ship": m.shipOrder(id); s.commit(); return "已标记发货";
                case "complete": m.completeOrder(id); s.commit(); return "已确认收货";
                case "cancel": m.updateStatus(id, "CANCELLED"); s.commit(); return "订单已取消";
                default: return "未知操作";
            }
        }
    }
}
