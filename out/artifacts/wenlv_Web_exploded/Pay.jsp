<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.OrderMapper" %>
<%@ page import="com.niit.mapper.OrderItemMapper" %>
<%@ page import="com.niit.pojo.OrderMain" %>
<%@ page import="com.niit.pojo.OrderItem" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    String orderIdStr = request.getParameter("orderId");
    OrderMain order = null;
    List<OrderItem> items = null;
    String error = null;

    if (orderIdStr != null) {
        try {
            Long orderId = Long.parseLong(orderIdStr);
            SqlSession s = DBUtil.getSession();
            order = s.getMapper(OrderMapper.class).findById(orderId);
            if (order != null) {
                items = s.getMapper(OrderItemMapper.class).findByOrderId(orderId);
            } else {
                error = "订单不存在";
            }
            s.close();
        } catch (Exception e) {
            error = "加载订单失败：" + e.getMessage();
        }
    } else {
        error = "缺少订单ID";
    }
%>

<style>
    .pay-container {
        max-width: 650px;
        margin: 40px auto;
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        overflow: hidden;
    }
    .pay-header {
        background: linear-gradient(135deg, #00a8a8, #00d4aa);
        color: #fff;
        padding: 25px 30px;
        text-align: center;
    }
    .pay-header h3 { margin: 0; font-size: 20px; }
    .pay-timer {
        margin-top: 12px;
        font-size: 14px;
        opacity: 0.95;
    }
    .countdown {
        display: inline-block;
        background: rgba(255,255,255,0.2);
        padding: 4px 10px;
        border-radius: 4px;
        font-weight: bold;
        font-size: 18px;
        min-width: 70px;
        letter-spacing: 1px;
    }
    .countdown.expired {
        background: rgba(231,76,60,0.3);
        animation: pulse 1s infinite;
    }
    @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.5} }
    .pay-body { padding: 25px 30px; }
    .pay-section {
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px solid #f0f0f0;
    }
    .pay-section:last-child { border-bottom: none; margin-bottom: 0; }
    .pay-section h5 { font-size: 14px; color: #999; margin-bottom: 10px; font-weight: 500; }
    .pay-item {
        display: flex; align-items: center; gap: 12px;
        padding: 10px; background: #fafafa; border-radius: 8px; margin-bottom: 8px;
    }
    .pay-item img { width: 60px; height: 60px; border-radius: 6px; object-fit: cover; }
    .pay-item-info { flex: 1; }
    .pay-item-name { font-size: 15px; font-weight: 500; color: #333; }
    .pay-item-detail { font-size: 13px; color: #999; margin-top: 3px; }
    .pay-item-price { font-size: 15px; font-weight: 600; color: #e74c3c; text-align: right; }
    .pay-row { display: flex; justify-content: space-between; padding: 6px 0; font-size: 14px; color: #666; }
    .pay-total {
        display: flex; justify-content: space-between; padding: 15px 0;
        font-size: 18px; font-weight: 600; color: #e74c3c;
        border-top: 1px dashed #eee; margin-top: 10px;
    }
    .pay-btn {
        display: block; width: 100%; padding: 15px;
        background: linear-gradient(135deg, #00a8a8, #00d4aa);
        border: none; border-radius: 8px; color: #fff;
        font-size: 17px; font-weight: 600; cursor: pointer; transition: all 0.3s; margin-top: 20px;
    }
    .pay-btn:hover { opacity: 0.9; transform: translateY(-1px); }
    .pay-btn:disabled { background: #ccc; cursor: not-allowed; transform: none; }
    .pay-methods { display: flex; gap: 10px; margin-top: 8px; }
    .pay-method {
        flex: 1; padding: 12px; border: 2px solid #e0e0e0;
        border-radius: 8px; text-align: center; cursor: pointer;
        transition: all 0.2s; font-size: 14px;
    }
    .pay-method:hover { border-color: #00a8a8; }
    .pay-method.selected { border-color: #00a8a8; background: #e8f8f8; color: #00a8a8; font-weight: 500; }
</style>

<div class="page-title" style="background:url('images/page-title-bg.jpg') center/cover no-repeat;padding:60px 0 50px;text-align:center;position:relative;">
    <div style="position:absolute;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.45);"></div>
    <div style="position:relative;z-index:1;">
        <h1 style="color:#fff;font-size:32px;font-weight:700;margin:0;">确认付款</h1>
        <p style="color:rgba(255,255,255,0.8);margin-top:10px;">请尽快完成支付，超时订单将自动取消</p>
    </div>
</div>

<div class="pay-container">
    <% if (error != null) { %>
    <div class="pay-body" style="text-align:center;padding:60px 30px;">
        <p style="color:#e74c3c;font-size:16px;"><%= error %></p>
        <a href="index.jsp" class="btn-secondary-custom" style="display:inline-block;margin-top:20px;">返回首页</a>
    </div>
    <% } else if (order != null && !"PLACED".equals(order.getStatus())) { %>
    <div class="pay-body" style="text-align:center;padding:60px 30px;">
        <p style="color:#999;font-size:16px;">该订单状态为「<%= order.getStatus() %>」，无需付款</p>
        <a href="personalCenter#orders" class="btn-secondary-custom" style="display:inline-block;margin-top:20px;">查看订单</a>
    </div>
    <% } else if (order != null) { %>
    <div class="pay-header">
        <h3>订单支付</h3>
        <div class="pay-timer">
            剩余支付时间：<span class="countdown" id="countdown">05:00</span>
        </div>
    </div>
    <div class="pay-body">
        <div class="pay-section">
            <h5>订单信息</h5>
            <div class="pay-row"><span>订单编号</span><span><%= order.getOrderNo() %></span></div>
            <div class="pay-row"><span>下单时间</span><span><%= order.getCreatedAt() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(order.getCreatedAt()) : "" %></span></div>
            <div class="pay-row"><span>取货方式</span><span><%= "DELIVERY".equals(order.getPickupMethod()) ? "快递配送" : "到店自取" %></span></div>
            <% if ("DELIVERY".equals(order.getPickupMethod())) { %>
            <div class="pay-row"><span>收件人</span><span><%= order.getDeliveryName() != null ? order.getDeliveryName() : "" %></span></div>
            <div class="pay-row"><span>联系电话</span><span><%= order.getDeliveryPhone() != null ? order.getDeliveryPhone() : "" %></span></div>
            <div class="pay-row"><span>收货地址</span><span><%= order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "" %></span></div>
            <% } %>
        </div>
        <div class="pay-section">
            <h5>商品明细</h5>
            <% if (items != null) for (OrderItem it : items) { %>
            <div class="pay-item">
                <img src="<%= it.getItemImage() != null ? it.getItemImage() : "images/img-1-720x400.jpg" %>" alt="<%= it.getItemName() %>" onerror="this.src='images/img-1-720x400.jpg'">
                <div class="pay-item-info">
                    <div class="pay-item-name"><%= it.getItemName() %></div>
                    <div class="pay-item-detail">数量: <%= it.getQuantity() %></div>
                </div>
                <div class="pay-item-price">¥<%= String.format("%.2f", it.getSubtotal()) %></div>
            </div>
            <% } %>
        </div>
        <div class="pay-section">
            <h5>支付方式</h5>
            <div class="pay-methods">
                <div class="pay-method selected" onclick="selectPayMethod(this)">微信支付</div>
                <div class="pay-method" onclick="selectPayMethod(this)">支付宝</div>
            </div>
        </div>
        <div class="pay-total">
            <span>应付金额</span>
            <span>¥<%= String.format("%.2f", order.getPayAmount()) %></span>
        </div>
        <button class="pay-btn" id="pay-btn" onclick="confirmPay()">确认付款</button>
        <button class="cancel-btn" id="cancel-btn" onclick="manualCancel()" style="display:block;width:100%;padding:12px;background:#fff;border:1px solid #e0e0e0;border-radius:8px;color:#999;font-size:14px;cursor:pointer;margin-top:10px;transition:all 0.2s;" onmouseover="this.style.borderColor='#e74c3c';this.style.color='#e74c3c'" onmouseout="this.style.borderColor='#e0e0e0';this.style.color='#999'">取消订单</button>
    </div>
    <% } %>
</div>

<script>
    // 基于订单创建时间计算剩余付款时间（5分钟=300秒）
    <%
        long remainingSec = 0;
        if (order != null && order.getCreatedAt() != null) {
            long createdMs = order.getCreatedAt().getTime();
            long deadlineMs = createdMs + 300_000; // 5分钟
            long nowMs = System.currentTimeMillis();
            remainingSec = Math.max(0, (deadlineMs - nowMs) / 1000);
        }
    %>
    var totalSeconds = <%= remainingSec %>;
    var timerInterval = null;
    var orderId = '<%= order != null ? order.getId() : "" %>';
    var expired = totalSeconds <= 0;

    // 如果进入页面时已超时，直接取消
    if (expired && orderId) {
        (function(){
            var btn = document.getElementById('pay-btn');
            if (btn) { btn.disabled = true; btn.textContent = '订单已超时取消'; }
            var cancelBtn = document.getElementById('cancel-btn');
            if (cancelBtn) cancelBtn.style.display = 'none';
            // 延迟执行取消，确保页面渲染完毕
            setTimeout(function(){ cancelOrder(false); }, 1000);
        })();
    }

    function updateCountdown() {
        if (expired && totalSeconds <= 0) { clearInterval(timerInterval); return; }
        var m = Math.floor(totalSeconds / 60);
        var s = totalSeconds % 60;
        var display = (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s);
        var el = document.getElementById('countdown');
        if (el) el.textContent = display;
        if (totalSeconds <= 60 && el) el.classList.add('expired');
        if (totalSeconds <= 0) {
            clearInterval(timerInterval);
            expired = true;
            var btn = document.getElementById('pay-btn');
            if (btn) { btn.disabled = true; btn.textContent = '订单已超时取消'; }
            cancelOrder(false);
        }
        totalSeconds--;
    }

    function cancelOrder(isManual) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '/order?action=cancelByUser&id=' + orderId, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp.success) {
                        setTimeout(function() {
                            alert(isManual ? '订单已取消' : '支付超时，订单已自动取消');
                            window.location.href = 'personalCenter#orders';
                        }, 500);
                    }
                } catch(e) {}
            }
        };
        xhr.send();
    }

    function manualCancel() {
        if (!confirm('确认取消订单？')) return;
        clearInterval(timerInterval);
        expired = true;
        var btn = document.getElementById('pay-btn');
        var cancelBtn = document.getElementById('cancel-btn');
        if (btn) { btn.disabled = true; btn.textContent = '订单已取消'; }
        if (cancelBtn) { cancelBtn.disabled = true; cancelBtn.style.color = '#ccc'; }
        cancelOrder(true);
    }

    function confirmPay() {
        if (expired) { alert('支付时间已过，订单已取消'); return; }
        var btn = document.getElementById('pay-btn');
        btn.disabled = true; btn.textContent = '处理中...';
        clearInterval(timerInterval);

        var xhr = new XMLHttpRequest();
        xhr.open('GET', '/order?action=pay&id=' + orderId, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var resp = JSON.parse(xhr.responseText);
                        if (resp.success) {
                            alert('支付成功！');
                            window.location.href = 'personalCenter#orders';
                        } else {
                            btn.disabled = false; btn.textContent = '确认付款';
                            timerInterval = setInterval(updateCountdown, 1000);
                            alert(resp.message || '支付失败');
                        }
                    } catch(e) {
                        btn.disabled = false; btn.textContent = '确认付款';
                        timerInterval = setInterval(updateCountdown, 1000);
                    }
                } else {
                    btn.disabled = false; btn.textContent = '确认付款';
                    timerInterval = setInterval(updateCountdown, 1000);
                }
            }
        };
        xhr.send();
    }

    function selectPayMethod(el) {
        document.querySelectorAll('.pay-method').forEach(function(m) { m.classList.remove('selected'); });
        el.classList.add('selected');
    }

    timerInterval = setInterval(updateCountdown, 1000);
    updateCountdown();

    window.addEventListener('beforeunload', function(e) {
        if (!expired && totalSeconds > 0) return '订单尚未支付，离开后需重新下单';
    });
</script>
<%@include file="Footer.jsp"%>
