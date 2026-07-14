package com.niit.servlet;

import com.niit.mapper.OrderItemMapper;
import com.niit.mapper.OrderMapper;
import com.niit.mapper.SpecialtyMapper;
import com.niit.pojo.OrderItem;
import com.niit.pojo.OrderMain;
import com.niit.pojo.Specialty;
import com.niit.pojo.User;
import com.niit.utils.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendJson(response, false, "请先登录", null);
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (idStr == null) {
            sendJson(response, false, "缺少订单ID", null);
            return;
        }

        Long orderId;
        try {
            orderId = Long.parseLong(idStr);
        } catch (NumberFormatException e) {
            sendJson(response, false, "无效的订单ID", null);
            return;
        }

        switch (action != null ? action : "") {
            case "pay":
                handlePay(response, orderId);
                break;
            case "cancelByUser":
                handleCancelByUser(response, orderId);
                break;
            case "confirmReceipt":
                handleConfirmReceipt(response, user, orderId);
                break;
            case "complete":
                handleComplete(response, user, orderId);
                break;
            case "requestReturn":
                handleRequestReturn(response, user, orderId, request.getParameter("reason"));
                break;
            case "completeWithComment":
                handleCompleteWithComment(response, user, orderId,
                        request.getParameter("rating"), request.getParameter("content"));
                break;
            default:
                sendJson(response, false, "未知操作", null);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");

        // POST 处理 completeWithComment（有评论内容时走POST）
        if ("completeWithComment".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                sendJson(response, false, "请先登录", null);
                return;
            }
            User user = (User) session.getAttribute("user");
            String idStr = request.getParameter("id");
            if (idStr == null) { sendJson(response, false, "缺少订单ID", null); return; }
            Long orderId;
            try { orderId = Long.parseLong(idStr); } catch (NumberFormatException e) {
                sendJson(response, false, "无效的订单ID", null); return;
            }
            handleCompleteWithComment(response, user, orderId,
                    request.getParameter("rating"), request.getParameter("content"));
            return;
        }

        // 创建订单
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendJson(response, false, "请先登录", null);
            return;
        }

        User user = (User) session.getAttribute("user");

        // 检查是否有未付款订单
        try (SqlSession checkSession = DBUtil.getSession()) {
            int unpaid = checkSession.getMapper(OrderMapper.class).hasUnpaidOrder(user.getId());
            if (unpaid > 0) {
                sendJson(response, false, "您有一笔待付款订单，请先完成或取消后再下单", null);
                return;
            }
        }

        String specialtyIdStr = request.getParameter("specialtyId");
        String quantityStr = request.getParameter("quantity");
        String pickupMethod = request.getParameter("pickupMethod");
        String deliveryName = request.getParameter("deliveryName");
        String deliveryPhone = request.getParameter("deliveryPhone");
        String deliveryAddress = request.getParameter("deliveryAddress");

        if (specialtyIdStr == null || quantityStr == null || pickupMethod == null) {
            sendJson(response, false, "缺少必填参数", null);
            return;
        }

        Long specialtyId;
        int quantity;
        try {
            specialtyId = Long.parseLong(specialtyIdStr);
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            sendJson(response, false, "参数格式错误", null);
            return;
        }

        if (quantity < 1) {
            sendJson(response, false, "购买数量至少为1", null);
            return;
        }

        if ("DELIVERY".equals(pickupMethod)) {
            if (deliveryName == null || deliveryName.trim().isEmpty() ||
                deliveryPhone == null || deliveryPhone.trim().isEmpty() ||
                deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
                sendJson(response, false, "请填写完整的收件信息", null);
                return;
            }
        }

        SqlSession s = null;
        try {
            s = DBUtil.getSession(false);

            Specialty specialty = s.getMapper(SpecialtyMapper.class).findById(specialtyId);
            if (specialty == null || specialty.getStatus() == 0) {
                sendJson(response, false, "商品不存在或已下架", null);
                s.rollback();
                return;
            }
            if (specialty.getStock() < quantity) {
                sendJson(response, false, "库存不足，当前库存：" + specialty.getStock(), null);
                s.rollback();
                return;
            }

            String orderNo = "SP" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
                    + String.format("%03d", (int) (Math.random() * 1000));

            OrderMain order = new OrderMain();
            order.setOrderNo(orderNo);
            order.setUserId(user.getId());
            BigDecimal unitPrice = specialty.getPrice();
            BigDecimal totalAmount = unitPrice.multiply(new BigDecimal(quantity));
            order.setTotalAmount(totalAmount);
            order.setDiscountAmount(BigDecimal.ZERO);
            order.setPayAmount(totalAmount);
            order.setPickupMethod(pickupMethod);
            order.setDeliveryName(deliveryName);
            order.setDeliveryPhone(deliveryPhone);
            order.setDeliveryAddress(deliveryAddress);
            order.setStatus("PLACED");

            OrderMapper orderMapper = s.getMapper(OrderMapper.class);
            int rows = orderMapper.insert(order);
            if (rows <= 0) {
                sendJson(response, false, "创建订单失败", null);
                s.rollback();
                return;
            }

            OrderItem item = new OrderItem();
            item.setOrderId(order.getId());
            item.setSpecialtyId(specialtyId);
            item.setItemName(specialty.getName());
            item.setItemImage(specialty.getMainImage());
            item.setQuantity(quantity);
            item.setUnitPrice(unitPrice);
            item.setSubtotal(totalAmount);

            s.getMapper(OrderItemMapper.class).insert(item);

            int stockRows = s.getMapper(SpecialtyMapper.class).decrementStock(specialtyId, quantity);
            if (stockRows <= 0) {
                sendJson(response, false, "库存不足", null);
                s.rollback();
                return;
            }

            s.commit();
            sendJson(response, true, "下单成功", order.getId());

        } catch (Exception e) {
            if (s != null) { try { s.rollback(); } catch (Exception ignored) {} }
            sendJson(response, false, "系统错误：" + e.getMessage(), null);
        } finally {
            if (s != null) { try { s.close(); } catch (Exception ignored) {} }
        }
    }

    // ==================== Action Handlers ====================

    private void handlePay(HttpServletResponse response, Long orderId) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            int rows = s.getMapper(OrderMapper.class).payOrder(orderId);
            if (rows > 0) {
                s.commit();
                sendJson(response, true, "支付成功", orderId);
            } else {
                sendJson(response, false, "支付失败，订单状态异常", null);
            }
        }
    }

    private void handleCancelByUser(HttpServletResponse response, Long orderId) throws IOException {
        SqlSession s = null;
        try {
            s = DBUtil.getSession(false); // 手动事务
            OrderMapper m = s.getMapper(OrderMapper.class);

            // 先查询订单项用于回滚库存
            List<OrderItem> items = s.getMapper(OrderItemMapper.class).findByOrderId(orderId);

            int rows = m.cancelByUser(orderId);
            if (rows > 0) {
                // 回滚库存
                SpecialtyMapper sm = s.getMapper(SpecialtyMapper.class);
                if (items != null) {
                    for (OrderItem it : items) {
                        sm.restoreStock(it.getSpecialtyId(), it.getQuantity());
                    }
                }
                s.commit();
                sendJson(response, true, "订单已取消", orderId);
            } else {
                sendJson(response, false, "取消失败", null);
                s.rollback();
            }
        } catch (Exception e) {
            if (s != null) { try { s.rollback(); } catch (Exception ignored) {} }
            sendJson(response, false, "系统错误：" + e.getMessage(), null);
        } finally {
            if (s != null) { try { s.close(); } catch (Exception ignored) {} }
        }
    }

    private void handleConfirmReceipt(HttpServletResponse response, User user, Long orderId) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            OrderMapper m = s.getMapper(OrderMapper.class);
            OrderMain order = m.findById(orderId);

            if (order == null) { sendJson(response, false, "订单不存在", null); return; }
            if (!order.getUserId().equals(user.getId())) {
                sendJson(response, false, "无权操作此订单", null); return;
            }
            if (!"SHIPPED".equals(order.getStatus())) {
                sendJson(response, false, "当前订单状态不允许确认收货", null); return;
            }

            int rows = m.confirmReceipt(orderId);
            if (rows > 0) {
                s.commit();
                sendJson(response, true, "已确认收货", orderId);
            } else {
                sendJson(response, false, "操作失败，请刷新后重试", null);
            }
        }
    }

    private void handleComplete(HttpServletResponse response, User user, Long orderId) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            OrderMapper m = s.getMapper(OrderMapper.class);
            OrderMain order = m.findById(orderId);
            if (order == null) { sendJson(response, false, "订单不存在", null); return; }
            if (!order.getUserId().equals(user.getId())) {
                sendJson(response, false, "无权操作此订单", null); return;
            }
            if (!"RECEIVED".equals(order.getStatus())) {
                sendJson(response, false, "当前订单状态不允许完成", null); return;
            }
            int rows = m.completeOrder(orderId);
            if (rows > 0) {
                s.commit();
                sendJson(response, true, "订单已完成", orderId);
            } else {
                sendJson(response, false, "操作失败", null);
            }
        }
    }

    private void handleRequestReturn(HttpServletResponse response, User user, Long orderId, String reason) throws IOException {
        if (reason == null || reason.trim().isEmpty()) {
            sendJson(response, false, "请选择退货原因", null);
            return;
        }
        try (SqlSession s = DBUtil.getSession()) {
            OrderMapper m = s.getMapper(OrderMapper.class);
            OrderMain order = m.findById(orderId);
            if (order == null) { sendJson(response, false, "订单不存在", null); return; }
            if (!order.getUserId().equals(user.getId())) {
                sendJson(response, false, "无权操作此订单", null); return;
            }
            if (!"RECEIVED".equals(order.getStatus())) {
                sendJson(response, false, "当前订单状态不允许申请退货", null); return;
            }
            int rows = m.requestReturn(orderId, reason.trim());
            if (rows > 0) {
                s.commit();
                sendJson(response, true, "退货申请已提交，等待管理员处理", orderId);
            } else {
                sendJson(response, false, "操作失败，请刷新后重试", null);
            }
        }
    }

    private void handleCompleteWithComment(HttpServletResponse response, User user,
                                           Long orderId, String rating, String content) throws IOException {
        try (SqlSession s = DBUtil.getSession()) {
            OrderMapper m = s.getMapper(OrderMapper.class);
            OrderMain order = m.findById(orderId);
            if (order == null) { sendJson(response, false, "订单不存在", null); return; }
            if (!order.getUserId().equals(user.getId())) {
                sendJson(response, false, "无权操作此订单", null); return;
            }
            String status = order.getStatus();
            if (!"RECEIVED".equals(status) && !"COMPLETED".equals(status) && !"REFUNDED".equals(status)) {
                sendJson(response, false, "当前订单状态不允许评论", null); return;
            }

            // 插入评论（仅评论，不改变订单状态）
            if (content != null && !content.trim().isEmpty()) {
                List<OrderItem> items = s.getMapper(OrderItemMapper.class).findByOrderId(orderId);
                Long specialtyId = (items != null && !items.isEmpty()) ? items.get(0).getSpecialtyId() : null;
                int ratingVal = 5;
                if (rating != null && !rating.isEmpty()) {
                    try { ratingVal = Integer.parseInt(rating); } catch (NumberFormatException ignored) {}
                    if (ratingVal < 1) ratingVal = 1;
                    if (ratingVal > 5) ratingVal = 5;
                }
                java.sql.Connection conn = s.getConnection();
                String sql = "INSERT INTO comment (user_id, target_type, target_id, content, rating, status, created_at, updated_at) VALUES (?, 'SPECIALTY', ?, ?, ?, 1, NOW(), NOW())";
                try (java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setLong(1, user.getId());
                    ps.setLong(2, specialtyId != null ? specialtyId : 0L);
                    ps.setString(3, content.trim());
                    ps.setInt(4, ratingVal);
                    ps.executeUpdate();
                }
                s.commit();
                sendJson(response, true, "评价成功", orderId);
            } else {
                sendJson(response, false, "请输入评价内容", null);
            }
        } catch (Exception e) {
            sendJson(response, false, "系统错误：" + e.getMessage(), null);
        }
    }

    // ==================== JSON Helpers ====================

    private void sendJson(HttpServletResponse response, boolean success, String message, Long orderId) throws IOException {
        String escaped = message != null ? message.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r") : "";
        StringBuilder sb = new StringBuilder("{\"success\":").append(success)
                .append(",\"message\":\"").append(escaped).append("\"");
        if (orderId != null) {
            sb.append(",\"orderId\":").append(orderId);
        }
        sb.append("}");
        response.getWriter().write(sb.toString());
    }
}
