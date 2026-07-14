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

                <!-- 评论 & 收藏按钮 -->
                <div style="margin-top:15px;display:flex;justify-content:space-between;align-items:center;">
                    <button onclick="toggleCommentForm()" style="background:none;border:1px solid #e0e0e0;border-radius:20px;padding:8px 20px;cursor:pointer;color:#666;font-size:14px;" id="comment-btn">
                        评论
                    </button>
                    <button onclick="toggleFavorite(${food.id})" style="background:none;border:1px solid #e0e0e0;border-radius:20px;padding:8px 20px;cursor:pointer;color:#666;font-size:14px;" id="fav-btn">
                        <span id="fav-icon">&#9825;</span> <span id="fav-text">收藏</span>
                    </button>
                </div>

                <!-- 评论区域 -->
                <div id="comment-section" style="display:none;margin-top:15px;border-top:1px solid #eee;padding-top:15px;">
                    <div class="comment-form">
                        <h5 style="margin-bottom:12px;font-size:15px;color:#333;">发表评论</h5>
                        <textarea id="comment-content" class="form-control" rows="3" placeholder="分享您的购买体验..." style="width:100%;padding:10px;border:1px solid #ddd;border-radius:8px;resize:vertical;font-size:14px;"></textarea>
                        <div style="margin-top:10px;text-align:right;">
                            <button onclick="submitComment()" style="background:#00a8a8;border:none;border-radius:6px;padding:8px 24px;color:#fff;font-size:14px;cursor:pointer;">提交评论</button>
                        </div>
                    </div>
                    <div class="comment-list" style="margin-top:15px;">
                        <h5 style="margin-bottom:12px;font-size:15px;color:#333;">全部评论 <span style="font-size:12px;color:#999;" id="comment-count">(0)</span></h5>
                        <div id="comments-container"></div>
                    </div>
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
    if (localStorage.getItem('isLoggedIn') !== 'true') {
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

// 评论功能
function escHtml(s) {
    if (!s) return '';
    return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
var comments = [
    { author: '王小明', avatar: '王', content: '味道非常好，家人特别喜欢！发货也很快，包装很用心。', time: '2026-06-20 14:30' },
    { author: '李芳', avatar: '李', content: '第一次买宁夏特产，品质超出预期。枸杞颗粒饱满，真空包装很新鲜。', time: '2026-06-18 09:15' },
    { author: '张大叔', avatar: '张', content: '八宝茶味道正宗，跟去宁夏旅游时喝到的一样。已经回购好几次了。', time: '2026-06-15 20:45' }
];

function toggleCommentForm() {
    var section = document.getElementById('comment-section');
    var btn = document.getElementById('comment-btn');
    if (section.style.display === 'none' || section.style.display === '') {
        section.style.display = 'block';
        btn.style.color = '#00a8a8';
        btn.style.borderColor = '#00a8a8';
        renderComments();
    } else {
        section.style.display = 'none';
        btn.style.color = '#666';
        btn.style.borderColor = '#e0e0e0';
    }
}

function renderComments() {
    var container = document.getElementById('comments-container');
    if (!container) return;
    var html = '';
    if (comments.length === 0) {
        html = '<div style="text-align:center;color:#999;padding:20px;">暂无评论，快来发表第一条评论吧！</div>';
    } else {
        for (var i = 0; i < comments.length; i++) {
            var c = comments[i];
            html += '<div class="comment-item">' +
                '<div class="comment-avatar">' + c.avatar + '</div>' +
                '<div class="comment-body">' +
                '<div class="comment-header">' +
                '<span class="comment-author">' + escHtml(c.author) + '</span>' +
                '<span class="comment-time">' + c.time + '</span>' +
                '</div>' +
                '<div class="comment-text">' + escHtml(c.content) + '</div>' +
                '</div></div>';
        }
    }
    container.innerHTML = html;
    document.getElementById('comment-count').textContent = '(' + comments.length + ')';
}

function submitComment() {
    var content = document.getElementById('comment-content').value.trim();
    if (!content) {
        alert('请输入评论内容！');
        return;
    }
    if (content.length < 5) {
        alert('评论内容至少5个字');
        return;
    }
    var username = localStorage.getItem('username') || localStorage.getItem('adminUsername') || '匿名用户';
    var avatar = username.charAt(0);
    var now = new Date();
    var timeStr = now.getFullYear() + '-' +
        String(now.getMonth() + 1).padStart(2, '0') + '-' +
        String(now.getDate()).padStart(2, '0') + ' ' +
        String(now.getHours()).padStart(2, '0') + ':' +
        String(now.getMinutes()).padStart(2, '0');

    comments.unshift({
        author: username,
        avatar: avatar,
        content: content,
        time: timeStr
    });

    document.getElementById('comment-content').value = '';
    renderComments();
    alert('评论发表成功！');
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
