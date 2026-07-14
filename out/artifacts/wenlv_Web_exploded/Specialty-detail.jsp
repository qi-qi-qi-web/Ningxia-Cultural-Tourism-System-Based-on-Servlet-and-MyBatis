<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.SpecialtyMapper" %>
<%@ page import="com.niit.pojo.Specialty" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>

<%
    String idStr = request.getParameter("id");
    Specialty food = null;
    if (idStr != null && !idStr.isEmpty()) {
        try (SqlSession s = DBUtil.getSession()) {
            food = s.getMapper(SpecialtyMapper.class).findById(Long.parseLong(idStr));
        } catch (Exception e) { food = null; }
    }
    request.setAttribute("food", food);
%>

<%@include file="Head.jsp"%>

<c:if test="${empty food}">
    <section class="section section-lg bg-default">
        <div class="container text-center" style="padding:80px 0;">
            <h3>特产不存在或已下架</h3>
            <a href="Specialty.jsp" class="button button-primary">返回特产列表</a>
        </div>
    </section>
</c:if>

<c:if test="${not empty food}">

<!-- Breadcrumbs-->
<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);">
    <div class="container">
        <h4 class="breadcrumbs-custom-title">${food.name}</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="Specialty.jsp">宁夏特产</a></li>
            <li class="active">${food.name}</li>
        </ul>
    </div>
</section>

<!-- 详情主体 -->
<section class="section section-lg bg-default">
    <div class="container">
        <div class="row">
            <!-- 左侧图片 -->
            <div class="col-lg-6 wow fadeInLeft">
                <div style="border-radius:10px;overflow:hidden;margin-bottom:20px;">
                    <c:choose>
                        <c:when test="${not empty food.mainImage}">
                            <img src="${food.mainImage}" alt="${food.name}" style="width:100%;max-height:450px;object-fit:cover;"/>
                        </c:when>
                        <c:otherwise>
                            <img src="images/food-detail-1-1170x544.jpg" alt="${food.name}" style="width:100%;max-height:450px;object-fit:cover;"/>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 右侧信息 -->
            <div class="col-lg-6 wow fadeInRight">
                <h2>${food.name}</h2>
                <p style="color:#00a8a8;font-size:14px;">
                    <c:if test="${not empty food.categoryName}">
                        分类：${food.categoryName} &nbsp;|&nbsp;
                    </c:if>
                    已售 <strong>${food.salesCount}</strong> 件 &nbsp;|&nbsp;
                    库存 <strong>${food.stock}</strong> 件
                </p>

                <!-- 价格区 -->
                <div style="background:#f9fafb;border-radius:8px;padding:20px;margin:20px 0;">
                    <span style="font-size:32px;color:#e74c3c;font-weight:bold;">¥${food.price}</span>
                    <c:if test="${food.favoriteCount > 0}">
                        <span style="color:#999;font-size:13px;margin-left:10px;">${food.favoriteCount} 人收藏</span>
                    </c:if>
                </div>

                <!-- 描述 -->
                <div style="border-left:3px solid #00a8a8;padding-left:15px;margin:20px 0;color:#666;line-height:1.8;">
                    ${food.description}
                </div>

                <!-- 下单区域 -->
                <div style="background:#fff;border:1px solid #e0e0e0;border-radius:10px;padding:25px;margin-top:25px;">
                    <h5 style="margin-bottom:18px;">立即下单</h5>
                    <form id="order-form" onsubmit="return submitOrder(event, ${food.id}, '${food.name}', ${food.price})">
                        <div class="row mb-3">
                            <div class="col-6">
                                <label style="font-weight:500;font-size:14px;">购买数量</label>
                                <div style="display:flex;align-items:center;gap:8px;margin-top:5px;">
                                    <button type="button" onclick="changeQty(-1)" style="width:36px;height:36px;border:1px solid #ddd;background:#f5f5f5;border-radius:6px;font-size:18px;cursor:pointer;">-</button>
                                    <input type="number" id="order-qty" value="1" min="1" max="${food.stock}" style="width:60px;text-align:center;border:1px solid #ddd;border-radius:6px;padding:6px;font-size:16px;" onchange="updateTotal()">
                                    <button type="button" onclick="changeQty(1)" style="width:36px;height:36px;border:1px solid #ddd;background:#f5f5f5;border-radius:6px;font-size:18px;cursor:pointer;">+</button>
                                </div>
                            </div>
                            <div class="col-6">
                                <label style="font-weight:500;font-size:14px;">小计</label>
                                <div id="order-subtotal" style="font-size:22px;color:#e74c3c;font-weight:bold;margin-top:5px;">¥${food.price}</div>
                            </div>
                        </div>

                        <!-- 取货方式 -->
                        <div class="mb-3">
                            <label style="font-weight:500;font-size:14px;">取货方式</label>
                            <div style="display:flex;gap:15px;margin-top:8px;">
                                <label style="cursor:pointer;padding:10px 20px;border:2px solid #00a8a8;border-radius:8px;background:#e8f8f8;color:#00a8a8;font-weight:500;">
                                    <input type="radio" name="pickup" value="PICKUP" checked onchange="toggleDelivery()" style="margin-right:6px;"> 自取
                                </label>
                                <label style="cursor:pointer;padding:10px 20px;border:2px solid #e0e0e0;border-radius:8px;color:#666;" id="delivery-label">
                                    <input type="radio" name="pickup" value="DELIVERY" onchange="toggleDelivery()" style="margin-right:6px;"> 快递
                                </label>
                            </div>
                        </div>

                        <!-- 快递信息 -->
                        <div id="delivery-info" style="display:none;">
                            <div class="row mb-2">
                                <div class="col-6"><input class="form-control" id="del-name" placeholder="收件人姓名"></div>
                                <div class="col-6"><input class="form-control" id="del-phone" placeholder="收件人电话"></div>
                            </div>
                            <div class="mb-3"><input class="form-control" id="del-addr" placeholder="收件地址"></div>
                        </div>

                        <button type="submit" style="width:100%;padding:14px;background:linear-gradient(135deg,#00a8a8,#00d4aa);border:none;border-radius:8px;color:#fff;font-size:16px;font-weight:600;cursor:pointer;">
                            确认下单
                        </button>
                    </form>
                </div>

                <!-- 收藏按钮 -->
                <div style="margin-top:15px;text-align:right;">
                    <button onclick="toggleFavorite(${food.id})" style="background:none;border:1px solid #e0e0e0;border-radius:20px;padding:8px 20px;cursor:pointer;color:#666;font-size:14px;" id="fav-btn">
                        <span id="fav-icon">&#9825;</span> <span id="fav-text">收藏</span>
                    </button>
                </div>
            </div>
        </div>

        <!-- 实景展示 - 图片画廊 -->
        <c:if test="${not empty food.images}">
        <div style="padding-top:15px;padding-bottom:15px;">
            <h4 style="border-left:4px solid #00a8a8;padding-left:12px;margin-bottom:15px;">图片展示</h4>
            <div class="row row-30 justify-content-center">
                <c:forTokens items="${food.images}" delims='["],[]{} ' var="img">
                    <c:if test="${not empty img && img.length() > 5}">
                        <div class="col-lg-3 col-md-4 col-sm-6" style="margin-bottom:20px;">
                            <img src="${img}" alt="${food.name}" onclick="openLightbox('${img}')" style="width:100%;height:220px;object-fit:cover;border-radius:8px;cursor:pointer;transition:transform 0.2s;" onmouseover="this.style.transform='scale(1.03)'" onmouseout="this.style.transform='scale(1)'"/>
                        </div>
                    </c:if>
                </c:forTokens>
            </div>
        </div>
        </c:if>

    </div>
</section>
</c:if>

<!-- Image lightbox overlay -->
<div class="lightbox-overlay" id="lightboxOverlay" onclick="closeLightbox()">
    <span class="lightbox-close" onclick="closeLightbox()">&times;</span>
    <img class="lightbox-image" id="lightboxImage" src="" alt="">
</div>

<%@include file="Footer.jsp"%>
</div>

<script>
var unitPrice = ${food.price};

function changeQty(delta) {
    var qty = document.getElementById('order-qty');
    var v = parseInt(qty.value) + delta;
    if (v >= 1 && v <= ${food.stock}) { qty.value = v; updateTotal(); }
}

function updateTotal() {
    var qty = parseInt(document.getElementById('order-qty').value) || 1;
    document.getElementById('order-subtotal').textContent = '¥' + (qty * unitPrice).toFixed(2);
}

function toggleDelivery() {
    var isDelivery = document.querySelector('input[name="pickup"]:checked').value === 'DELIVERY';
    document.getElementById('delivery-info').style.display = isDelivery ? 'block' : 'none';
    var labels = document.querySelectorAll('input[name="pickup"] + span') ;
    document.querySelectorAll('input[name="pickup"]').forEach(function(r){
        var label = r.parentElement;
        if (r.checked) {
            label.style.borderColor = '#00a8a8'; label.style.background = '#e8f8f8'; label.style.color = '#00a8a8';
        } else {
            label.style.borderColor = '#e0e0e0'; label.style.background = '#fff'; label.style.color = '#666';
        }
    });
}

function submitOrder(e, id, name, price) {
    e.preventDefault();
    var qty = parseInt(document.getElementById('order-qty').value) || 1;
    var pickup = document.querySelector('input[name="pickup"]:checked').value;
    var total = (qty * price).toFixed(2);

    if (pickup === 'DELIVERY') {
        var dn = document.getElementById('del-name').value.trim();
        var dp = document.getElementById('del-phone').value.trim();
        var da = document.getElementById('del-addr').value.trim();
        if (!dn || !dp || !da) { alert('请填写完整的收件信息'); return false; }
    }

    alert('下单成功！\n商品：' + name + '\n数量：' + qty + '\n取货：' + (pickup === 'PICKUP' ? '自取' : '快递') + '\n金额：¥' + total + '\n\n（订单功能后续完善）');
    return false;
}

function toggleFavorite(id) {
    var btn = document.getElementById('fav-btn');
    var icon = document.getElementById('fav-icon');
    var text = document.getElementById('fav-text');
    if (text.textContent === '收藏') {
        icon.innerHTML = '&#9829;'; text.textContent = '已收藏';
        btn.style.color = '#e74c3c'; btn.style.borderColor = '#e74c3c';
    } else {
        icon.innerHTML = '&#9825;'; text.textContent = '收藏';
        btn.style.color = '#666'; btn.style.borderColor = '#e0e0e0';
	}
}

// Image lightbox
function openLightbox(src) {
    document.getElementById('lightboxImage').src = src;
    document.getElementById('lightboxOverlay').style.display = 'flex';
}
function closeLightbox() {
    document.getElementById('lightboxOverlay').style.display = 'none';
}
</script>
<script src="js/core.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>
