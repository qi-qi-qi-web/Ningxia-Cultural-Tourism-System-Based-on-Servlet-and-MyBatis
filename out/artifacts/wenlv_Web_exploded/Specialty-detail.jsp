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

                <!-- 价格区 + 收藏 -->
                <div style="background:#f9fafb;border-radius:8px;padding:20px;margin:20px 0;display:flex;justify-content:space-between;align-items:center;">
                    <span style="font-size:32px;color:#e74c3c;font-weight:bold;">¥${food.price}</span>
                    <span onclick="toggleFavDetail()" style="cursor:pointer;font-size:15px;color:#999;" id="fav-area"><span class="icon fa fa-heart" id="fav-icon-detail" style="color:#ccc;"></span> <span id="fav-count-detail">${food.favoriteCount}</span> 收藏</span>
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

                        <!-- 收件信息 -->
                        <div class="mb-3">
                            <label style="font-weight:500;font-size:14px;">收件信息</label>
                            <div class="row mb-2" style="margin-top:8px;">
                                <div class="col-6"><input class="form-control" id="del-name" placeholder="收件人姓名"></div>
                                <div class="col-6"><input class="form-control" id="del-phone" placeholder="收件人电话"></div>
                            </div>
                            <div class="mb-2"><input class="form-control" id="del-addr" placeholder="收件地址"></div>
                        </div>

                        <button type="submit" style="width:100%;padding:14px;background:linear-gradient(135deg,#00a8a8,#00d4aa);border:none;border-radius:8px;color:#fff;font-size:16px;font-weight:600;cursor:pointer;">
                            确认下单
                        </button>
                    </form>
                </div>
                </div>
            </div>

            <!-- 评论区（全宽，左边对齐图片） -->
            <div id="comment-section" style="margin-top:30px;border-top:1px solid #eee;padding-top:20px;">
                <h5 style="margin-bottom:12px;font-size:15px;color:#333;">用户评论</h5>
                <div id="comment-list" style="margin-bottom:15px;"></div>
                <p style="font-size:12px;color:#999;">购买后可前往<a href="personalCenter" style="color:#00a8a8;">个人中心</a>发表评论</p>
            </div>
        </div>

        <!-- 实景展示 - 图片画廊 -->
        <c:if test="${not empty food.images}">
        <div style="padding-top:15px;padding-bottom:15px;">
            <h4 style="border-left:4px solid #00a8a8;padding-left:12px;margin-bottom:15px;">图片展示</h4>
            <div class="row row-30 justify-content-center">
                <c:forTokens items="${food.images}" delims='["],[]{} ' var="img" varStatus="status">
                    <c:if test="${not empty img && img.length() > 5}">
                        <div class="col-lg-3 col-md-4 col-sm-6" style="margin-bottom:20px;">
                            <img src="${img}" alt="${food.name}" onclick="openGalleryLightbox(${status.index})" style="width:100%;height:220px;object-fit:cover;border-radius:8px;cursor:pointer;transition:transform 0.2s;" onmouseover="this.style.transform='scale(1.03)'" onmouseout="this.style.transform='scale(1)'"/>
                        </div>
                    </c:if>
                </c:forTokens>
            </div>
        </div>
        </c:if>

    </div>
</section>
</c:if>

<!-- 图片灯箱（含上一张/下一张导航） -->
<div class="lightbox-overlay" id="lightboxOverlay" onclick="closeLightbox()" style="display:none;position:fixed;z-index:9999;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,0.9);justify-content:center;align-items:center;">
    <span onclick="closeLightbox()" style="position:absolute;top:20px;right:30px;color:#fff;font-size:40px;cursor:pointer;z-index:10000;line-height:1;">&times;</span>
    <span id="lightboxPrev" onclick="event.stopPropagation();prevGalleryImage()" style="display:none;position:absolute;left:20px;top:50%;transform:translateY(-50%);color:#fff;font-size:48px;cursor:pointer;z-index:10001;padding:10px;user-select:none;line-height:1;">&#8249;</span>
    <span id="lightboxNext" onclick="event.stopPropagation();nextGalleryImage()" style="display:none;position:absolute;right:20px;top:50%;transform:translateY(-50%);color:#fff;font-size:48px;cursor:pointer;z-index:10001;padding:10px;user-select:none;line-height:1;">&#8250;</span>
    <span id="lightboxCounter" style="display:none;position:absolute;bottom:30px;left:50%;transform:translateX(-50%);color:#fff;font-size:16px;z-index:10001;background:rgba(0,0,0,0.5);padding:6px 16px;border-radius:20px;"></span>
    <img id="lightboxImage" src="" style="max-width:90%;max-height:90%;object-fit:contain;"/>
</div>

<%@include file="Footer.jsp"%>
</div>

<style>
.comment-item {
    padding: 15px;
    background: #f8f9fa;
    border-radius: 8px;
    margin-bottom: 12px;
    display: flex;
}
.comment-avatar {
    width: 40px;
    height: 40px;
    background: #00a8a8;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 16px;
    font-weight: bold;
    margin-right: 12px;
    flex-shrink: 0;
}
.comment-body { flex-grow: 1; }
.comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 6px;
}
.comment-author { font-weight: bold; color: #333; font-size: 14px; }
.comment-time { font-size: 11px; color: #999; }
.comment-text { color: #666; font-size: 14px; line-height: 1.6; }
</style>

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

function submitOrder(e, id, name, price) {
    e.preventDefault();

    // 检查登录状态
    if (sessionStorage.getItem('isLoggedIn') !== 'true') {
        alert('请先登录后再下单！');
        return false;
    }

    var qty = parseInt(document.getElementById('order-qty').value) || 1;

    // 校验收件信息
    var dn = document.getElementById('del-name').value.trim();
    var dp = document.getElementById('del-phone').value.trim();
    var da = document.getElementById('del-addr').value.trim();
    if (!dn || !dp || !da) { alert('请填写完整的收件信息'); return false; }

    // 组装参数（全部快递配送）
    var params = 'specialtyId=' + encodeURIComponent(id)
        + '&quantity=' + encodeURIComponent(qty)
        + '&pickupMethod=DELIVERY'
        + '&deliveryName=' + encodeURIComponent(dn)
        + '&deliveryPhone=' + encodeURIComponent(dp)
        + '&deliveryAddress=' + encodeURIComponent(da);

    // 禁用按钮防止重复提交
    var btn = document.querySelector('#order-form button[type="submit"]');
    btn.disabled = true;
    btn.textContent = '提交中...';

    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/order', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            btn.disabled = false;
            btn.textContent = '确认下单';
            if (xhr.status === 200) {
                try {
                    var resp = JSON.parse(xhr.responseText);
                    if (resp.success) {
                        alert(resp.message);
                        // 跳转到付款页面
                        if (resp.orderId) {
                            window.location.href = 'Pay.jsp?orderId=' + resp.orderId;
                        } else if (confirm('下单成功！是否前往个人中心查看订单？')) {
                            window.location.href = 'personalCenter#orders';
                        }
                    } else {
                        alert(resp.message || '下单失败');
                    }
                } catch (e) {
                    alert('服务器返回异常，请稍后重试');
                }
            } else {
                alert('网络错误（' + xhr.status + '），请重试');
            }
        }
    };
    xhr.send(params);

    return false;
}

function toggleFavDetail() {
    var sid = '${food.id}';
    fetch('/fav?type=SPECIALTY&id=' + sid)
    .then(function(r){ return r.json(); })
    .then(function(d){
        if (d.ok) {
            document.getElementById('fav-icon-detail').style.color = d.faved ? '#e74c3c' : '#ccc';
            document.getElementById('fav-count-detail').textContent = d.count;
        } else if (d.msg) { alert(d.msg); }
    });
}
(function(){
    var sid = '${food.id}';
    if (sid) fetch('/fav?type=SPECIALTY&id=' + sid + '&check=1')
    .then(function(r){ return r.json(); })
    .then(function(d){
        if (d.faved) document.getElementById('fav-icon-detail').style.color = '#e74c3c';
    });
})();

    // 评论功能 - 后端联动
    function loadComments() {
        var sid = '${food.id}';
        fetch('/comment?action=list&targetType=SPECIALTY&targetId=' + sid)
        .then(function(r){ return r.json(); })
        .then(function(list){
            var html = '';
            if (list.length === 0) html = '<div style="color:#999;text-align:center;padding:20px;">暂无评论，购买后即可评论</div>';
            else list.forEach(function(c){
                var displayName = c.nickname || c.userName || '匿名';
                var avatarSrc = c.avatar || 'images/avatar-1.png';
                html += '<div style="display:flex;padding:14px 0;border-bottom:1px solid #f0f0f0;">' +
                    '<img src="' + avatarSrc + '" style="width:36px;height:36px;border-radius:50%;object-fit:cover;flex-shrink:0;" onerror="this.src=\'images/avatar-1.png\'"/>' +
                    '<div style="margin-left:12px;flex:1;"><div style="font-weight:bold;color:#333;font-size:14px;">'+displayName+'</div>' +
                    '<div style="color:#666;margin-top:4px;line-height:1.6;">'+escHtml(c.content)+'</div>' +
                    '<div style="color:#bbb;font-size:12px;margin-top:4px;">'+(c.createdAt||'').substring(0,16)+'</div></div></div>';
            });
            document.getElementById('comment-list').innerHTML = html;
        });
    }
    function escHtml(s){if(!s)return'';return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
    loadComments();

    // ========== 图片画廊灯箱（含上一张/下一张/键盘导航） ==========
    var galleryImages = [];
    <c:if test="${not empty food.images}">
        <c:forTokens items="${food.images}" delims='["],[]{} ' var="img" varStatus="sta">
            <c:if test="${not empty img && img.length() > 5}">
                galleryImages.push('${img}');
            </c:if>
        </c:forTokens>
    </c:if>
    var currentGalleryIndex = -1;

    function openGalleryLightbox(index) {
        currentGalleryIndex = index;
        updateGalleryImage();
        document.getElementById('lightboxPrev').style.display = '';
        document.getElementById('lightboxNext').style.display = '';
        document.getElementById('lightboxCounter').style.display = '';
        document.getElementById('lightboxOverlay').style.display = 'flex';
    }

    function updateGalleryImage() {
        if (currentGalleryIndex < 0 || currentGalleryIndex >= galleryImages.length) return;
        document.getElementById('lightboxImage').src = galleryImages[currentGalleryIndex];
        document.getElementById('lightboxCounter').textContent = (currentGalleryIndex + 1) + ' / ' + galleryImages.length;
        document.getElementById('lightboxPrev').style.opacity = currentGalleryIndex > 0 ? '1' : '0.3';
        document.getElementById('lightboxNext').style.opacity = currentGalleryIndex < galleryImages.length - 1 ? '1' : '0.3';
    }

    function prevGalleryImage() {
        if (currentGalleryIndex > 0) {
            currentGalleryIndex--;
            updateGalleryImage();
        }
    }

    function nextGalleryImage() {
        if (currentGalleryIndex < galleryImages.length - 1) {
            currentGalleryIndex++;
            updateGalleryImage();
        }
    }

    function closeLightbox() {
        document.getElementById('lightboxOverlay').style.display = 'none';
        currentGalleryIndex = -1;
    }

    // 键盘左右键切换
    document.addEventListener('keydown', function(e) {
        var overlay = document.getElementById('lightboxOverlay');
        if (overlay.style.display !== 'flex') return;
        if (currentGalleryIndex < 0) return;
        if (e.key === 'ArrowLeft') { prevGalleryImage(); e.preventDefault(); }
        else if (e.key === 'ArrowRight') { nextGalleryImage(); e.preventDefault(); }
        else if (e.key === 'Escape') { closeLightbox(); e.preventDefault(); }
    });
</script>
<script src="js/core.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>
