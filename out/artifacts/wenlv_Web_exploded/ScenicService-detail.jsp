<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.niit.utils.DBUtil,com.niit.mapper.ScenicSpotMapper,com.niit.pojo.ScenicSpot,org.apache.ibatis.session.SqlSession,jakarta.servlet.http.HttpSession" %>

<%
    ScenicSpot scenic = null;
    String idStr = request.getParameter("id");
    if (idStr != null) {
        try (SqlSession s = DBUtil.getSession()) {
            scenic = s.getMapper(ScenicSpotMapper.class).findById(Long.parseLong(idStr));
        } catch (Exception e) {}
    }
    request.setAttribute("scenic", scenic);
    if (scenic != null && scenic.getDescription() != null) {
        if (scenic.getDescription().trim().startsWith("<")) {
            request.setAttribute("formattedDesc", scenic.getDescription());
        } else {
            String[] paras = scenic.getDescription().split("\n\n");
            StringBuilder sb = new StringBuilder();
            for (String p : paras) { p = p.trim(); if (!p.isEmpty()) sb.append("<p style=\"text-indent:2em;margin-bottom:0.8em;line-height:2;\">").append(p.replace("\n","<br/>")).append("</p>"); }
            request.setAttribute("formattedDesc", sb.toString());
        }
    }
%>

<%@include file="Head.jsp"%>

<c:if test="${empty scenic}">
    <section class="section section-lg bg-default"><div class="container text-center" style="padding:80px 0;"><h3>景区不存在</h3><a href="ScenicService.jsp" class="button button-primary">返回景区列表</a></div></section>
</c:if>

<c:if test="${not empty scenic}">

<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);" data-preset='{"title":"Breadcrumbs","category":"header","reload":false,"id":"breadcrumbs"}'>
    <div class="container">
        <h4 class="breadcrumbs-custom-title">景区详情</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="ScenicService.jsp">景区服务</a></li>
            <li class="active">景区详情</li>
        </ul>
    </div>
</section>

<section class="section section-lg bg-default">
    <div class="container">
        <div class="row row-30 offset-lg">
            <div class="col-xl-5">
                <div class="scenic-cover">
                    <img src="${empty scenic.coverImage ? 'images/single-tour-1-470x464.jpg' : scenic.coverImage}" alt="${scenic.name}" style="max-width:100%;height:auto;"/>
                </div>
                <div class="scenic-stats mt-4 d-flex justify-content-around">
                    <div class="stat-item text-center">
                        <div class="stat-icon" style="width: 48px; height: 48px; background: #00a8a8; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px;">
                            <i class="fa fa-eye" style="color: white;"></i>
                        </div>
                        <div class="stat-value" style="font-size: 18px; font-weight: bold; color: #333;">${scenic.viewCount}</div>
                        <div class="stat-label" style="font-size: 12px; color: #999;">浏览次数</div>
                    </div>
                    <div class="stat-item text-center">
                        <div id="favorite-icon" onclick="toggleFavorite()" style="width: 48px; height: 48px; background: #ccc; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; cursor: pointer;">
                            <i class="fa fa-heart" style="color: white;"></i>
                        </div>
                        <div id="favorite-count" style="font-size: 18px; font-weight: bold; color: #333;">${scenic.favoriteCount}</div>
                        <div class="stat-label" style="font-size: 12px; color: #999;">收藏次数</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-7">
                <div class="single-service__caption">
<div class="heading-4 text-xl mb-3">
    ${scenic.name}
    <c:set var="urlLat" value="${scenic.latitude != null ? scenic.latitude : ''}"/>
    <c:set var="urlLng" value="${scenic.longitude != null ? scenic.longitude : ''}"/>
    <a href="ScenicRoute.jsp?id=${scenic.id}&name=${fn:escapeXml(scenic.name)}&lat=${urlLat}&lng=${urlLng}&address=${fn:escapeXml(scenic.address)}"
       class="button button-sm button-default-outline"
       style="margin-left:12px; padding:4px 14px; font-size:14px; border-color:#00a8a8; color:#00a8a8; border-radius:20px; display:inline-block; text-decoration:none; vertical-align:middle;"
       title="查看地图并规划路线">
        <i class="fa fa-location-arrow" style="margin-right:4px;"></i> 到这里
    </a>
</div>
<div class="price-group mb-4"><span class="price-group__sale">¥${empty scenic.minPrice ? '--' : scenic.minPrice}</span></div>
                    <div class="scenic-info-list mb-4">
                        <div class="info-item d-flex align-items-center py-2 border-bottom border-light">
                            <i class="fa fa-map-marker" style="color: #00a8a8; margin-right: 12px; width: 20px;"></i>
                            <span style="color: #666;">地址：${empty scenic.address ? '暂无' : scenic.address}</span>
                        </div>
                        <div class="info-item d-flex align-items-center py-2 border-bottom border-light">
                            <i class="fa fa-clock-o" style="color: #00a8a8; margin-right: 12px; width: 20px;"></i>
                            <span style="color: #666;">开放时间：${empty scenic.openingHours ? '全天' : scenic.openingHours}</span>
                        </div>
                        <div class="info-item d-flex align-items-center py-2 border-bottom border-light">
                            <i class="fa fa-phone" style="color: #00a8a8; margin-right: 12px; width: 20px;"></i>
                            <span style="color: #666;">联系电话：${empty scenic.contactPhone ? '暂无' : scenic.contactPhone}</span>
                        </div>
                        <div class="info-item d-flex align-items-center py-2 border-bottom border-light">
                            <i class="fa fa-map" style="color: #00a8a8; margin-right: 12px; width: 20px;"></i>
                            <span style="color: #666;">城市：${empty scenic.city ? '宁夏' : scenic.city}</span>
                        </div>
                        <div class="info-item d-flex align-items-center py-2">
                            <i class="fa fa-star" style="color: #00a8a8; margin-right: 12px; width: 20px;"></i>
                            <span style="color: #666;">景区等级：国家AAAAA级景区</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row mt-8">
            <div class="col-xl-12">
                <div class="tabs-custom tabs-horizontal tabs-line" id="tabs-1">
                    <ul class="nav nav-tabs">
                        <li class="nav-item" role="presentation"><a class="nav-link active" href="#tabs-1-1" data-bs-toggle="tab"><span class="icon linearicons-menu"></span>景区介绍</a></li>
                        <li class="nav-item" role="presentation"><a class="nav-link" href="#tabs-1-2" data-bs-toggle="tab"><span class="icon linearicons-plane"></span>游玩攻略</a></li>
                        <li class="nav-item" role="presentation"><a class="nav-link" href="#tabs-1-3" data-bs-toggle="tab"><span class="icon linearicons-picture3"></span>图片画廊</a></li>
                        </ul>
                        <div class="tab-content">
                        <div class="tab-pane fade active show" id="tabs-1-1">
                            <div class="scenic-detail-intro">
                                <h3 class="mb-4" style="color: #333; font-size: 20px;">景区概况</h3>
                                <div style="color: #666; line-height: 1.8;">${formattedDesc}</div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="tabs-1-2">
                            <div class="scenic-detail-guide">
                                <h3 class="mb-4" style="color: #333; font-size: 20px;">游玩路线推荐</h3>
                                <div class="guide-card p-4" style="background: #f8f9fa; border-radius: 8px; margin-bottom: 16px;">
                                    <h4 style="color: #00a8a8; font-size: 16px; margin-bottom: 12px;"><i class="fa fa-map-signs"></i> 一日游路线</h4>
                                    <ol style="color: #666; line-height: 1.8; padding-left: 20px;">
                                        <li><strong>上午</strong>：从景区南门进入，乘坐观光车前往北区沙漠景区，体验沙漠冲浪车和骑骆驼项目，感受沙漠的雄浑与壮美。</li>
                                        <li><strong>中午</strong>：在沙漠餐厅品尝宁夏特色美食（手抓羊肉、中卫酿皮等）。</li>
                                        <li><strong>下午</strong>：返回南区，体验黄河滑索、羊皮筏子漂流等项目，欣赏黄河日落美景。</li>
                                    </ol>
                                </div>
                                <div class="guide-card p-4" style="background: #f8f9fa; border-radius: 8px; margin-bottom: 16px;">
                                    <h4 style="color: #00a8a8; font-size: 16px; margin-bottom: 12px;"><i class="fa fa-camping"></i> 两日游路线</h4>
                                    <ol style="color: #666; line-height: 1.8; padding-left: 20px;">
                                        <li><strong>第一天</strong>：体验北区沙漠项目，晚上在沙漠露营，欣赏星空银河。</li>
                                        <li><strong>第二天</strong>：体验南区黄河项目，下午参观景区内的黄河文化博物馆。</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="tabs-1-3">
                            <div class="row row-10 row-narrow-10 text-center">
                                <c:choose>
                                    <c:when test="${not empty scenic.images}">
                                        <c:forTokens items="${scenic.images}" delims='["],[]{} ' var="img">
                                            <c:if test="${not empty img && fn:length(img) > 5}">
                                                <div class="col-lg-4 col-sm-6" style="margin-bottom:20px;"><img src="${img}" alt="" width="370" height="250" onclick="openLightbox('${img}')" style="cursor:pointer;width:100%;height:220px;object-fit:cover;border-radius:8px;"/></div>
                                            </c:if>
                                        </c:forTokens>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12 text-center" style="padding:60px 0;color:#999;">暂无图片</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        </div>
                    </div>
                </div>

                <!-- 评论区 -->
                <div style="margin-top:30px;">
                    <input type="hidden" id="scenic-id-hidden" value="${scenic.id}">
                    <h5 style="margin-bottom:16px;">用户评论</h5>
                    <div id="comment-list" style="margin-bottom:20px;"></div>
                            <div style="border:1px solid #eee;border-radius:8px;padding:16px;">
                                <textarea id="comment-input" rows="3" style="width:100%;border:1px solid #ddd;border-radius:6px;padding:10px;resize:vertical;" placeholder="写下你的评论..."></textarea>
                                <div style="text-align:right;margin-top:10px;">
                                    <button onclick="postCommentScenic()" class="button button-primary" type="button" style="padding:6px 20px;font-size:14px;">发表评论</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
            </div>
        </div>
    </div>
</section>

<%@include file="Footer.jsp"%>

<style>
    .gallery-item {
        opacity: 0;
        transform: translateY(30px);
        animation: fadeInUp 0.6s ease-out forwards;
    }
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    .gallery-item.hidden {
        opacity: 0;
        transform: translateY(30px);
        animation: none;
    }
    .comment-item {
        padding: 20px;
        background: #f8f9fa;
        border-radius: 8px;
        margin-bottom: 16px;
        display: flex;
    }
    .comment-avatar {
        width: 48px;
        height: 48px;
        background: #00a8a8;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 18px;
        font-weight: bold;
        margin-right: 16px;
        flex-shrink: 0;
    }
    .comment-content {
        flex-grow: 1;
    }
    .comment-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
    }
    .comment-author {
        font-weight: bold;
        color: #333;
    }
    .comment-time {
        font-size: 12px;
        color: #999;
    }
    .comment-text {
        color: #666;
        line-height: 1.6;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var sid = '${scenic.id}';
        if (sid) {
            // 浏览数+1（AJAX）
            fetch('/scenic?action=view&id=' + sid).then(function(){
                var el = document.querySelector('.stat-value');
                if (el) el.textContent = parseInt(el.textContent.replace(/,/g,'')) + 1;
            });
            // 检查收藏状态
            fetch('/fav?type=SCENIC&id=' + sid + '&check=1')
            .then(function(r){ return r.json(); })
            .then(function(d){
                if (d.faved) {
                    document.getElementById('favorite-icon').style.background = '#ff6b6b';
                }
            });
        }

        var galleryItems = document.querySelectorAll('.gallery-item');
        galleryItems.forEach(function(item) {
            item.classList.add('hidden');
        });

        $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function(e) {
            var target = $(e.target).attr('href');
            if (target === '#tabs-1-3') {
                galleryItems.forEach(function(item) {
                    item.classList.remove('hidden');
                });
            } else {
                galleryItems.forEach(function(item) {
                    item.classList.add('hidden');
                    item.style.animation = 'none';
                    item.offsetHeight;
                    item.style.animation = null;
                });
            }
            if (target === '#tabs-1-4') {
                loadComments();
            }
        });

        loadComments();
    });

    // 评论
    function loadComments() {
        var sid = '${scenic.id}';
        fetch('/comment?action=list&targetType=SCENIC&targetId=' + sid)
        .then(function(r){ return r.json(); })
        .then(function(list){
            var html = '';
            if (list.length === 0) html = '<div style="color:#999;text-align:center;padding:20px;">暂无评论</div>';
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
    function postCommentScenic() {
        var c = document.getElementById('comment-input').value;
        if (c == null || c.replace(/\s/g, '') === '') { alert('请输入评论内容'); return; }
        var fd = new FormData();
        fd.append('targetType', 'SCENIC');
        fd.append('targetId', document.getElementById('scenic-id-hidden').value);
        fd.append('content', c);
        fetch('/comment', { method: 'POST', body: fd })
        .then(function(r) { return r.json(); })
        .then(function(d) {
            if (d.ok) { document.getElementById('comment-input').value = ''; loadComments(); }
            else { alert(d.msg || '评论失败'); }
        })
        .catch(function() { alert('网络错误'); });
    }
    function escHtml(s){if(!s)return'';return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
    loadComments();

    function toggleFavorite() {
        var isLoggedIn = sessionStorage.getItem('isLoggedIn') === 'true';
        var isAdminLoggedIn = sessionStorage.getItem('isAdminLoggedIn') === 'true';
        
        if (!isLoggedIn && !isAdminLoggedIn) {
            alert('请先登录后再收藏！');
            var loginModal = new bootstrap.Modal(document.getElementById('login-modal'));
            loginModal.show();
            return;
        }
        
        var sid = '${scenic.id}';
        fetch('/fav?type=SCENIC&id=' + sid)
        .then(function(r){ return r.json(); })
        .then(function(d){
            if (d.ok) {
                document.getElementById('favorite-count').textContent = d.count;
                document.getElementById('favorite-icon').style.background = d.faved ? '#ff6b6b' : '#ccc';
            } else if (d.msg) {
                alert(d.msg);
            }
        });
    }
</script>

<!-- 图片灯箱 -->
<div class="lightbox-overlay" id="lightboxOverlay" onclick="closeLightbox()" style="display:none;position:fixed;z-index:9999;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,0.9);justify-content:center;align-items:center;">
    <span onclick="closeLightbox()" style="position:absolute;top:20px;right:30px;color:#fff;font-size:40px;cursor:pointer;z-index:10000;">&times;</span>
    <img id="lightboxImage" src="" style="max-width:90%;max-height:90%;object-fit:contain;"/>
</div>
<script>
function openLightbox(src) {
    document.getElementById('lightboxImage').src = src;
    document.getElementById('lightboxOverlay').style.display = 'flex';
}
function closeLightbox() {
    document.getElementById('lightboxOverlay').style.display = 'none';
}
</script>
</c:if>
</body></html>