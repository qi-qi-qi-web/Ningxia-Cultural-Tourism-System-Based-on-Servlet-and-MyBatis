<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.HotelMapper" %>
<%@ page import="com.niit.pojo.Hotel" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>

<%
    String idStr = request.getParameter("id");
    Hotel hotel = null;
    if (idStr != null) {
        try (SqlSession s = DBUtil.getSession()) {
            hotel = s.getMapper(HotelMapper.class).findById(Long.parseLong(idStr));
        } catch (Exception e) {}
    }
    request.setAttribute("hotel", hotel);
    if (hotel != null && hotel.getDescription() != null && hotel.getDescription().trim().startsWith("<")) {
        request.setAttribute("formattedDesc", hotel.getDescription());
    } else if (hotel != null && hotel.getDescription() != null) {
        String[] paras = hotel.getDescription().split("\n\n"); StringBuilder sb = new StringBuilder();
        for (String p : paras) { p = p.trim(); if (!p.isEmpty()) sb.append("<p style=\"text-indent:2em;margin-bottom:0.8em;line-height:2;\">").append(p.replace("\n","<br/>")).append("</p>"); }
        request.setAttribute("formattedDesc", sb.toString());
    }
%>

<%@include file="Head.jsp"%>

<c:if test="${empty hotel}">
    <section class="section section-lg bg-default"><div class="container text-center" style="padding:80px 0;"><h3>酒店不存在或已下架</h3><a href="Hotel.jsp" class="button button-primary">返回酒店列表</a></div></section>
</c:if>

<c:if test="${not empty hotel}">
    <!-- Breadcrumbs-->
    <section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);" data-preset='{"title":"Breadcrumbs","category":"header","reload":false,"id":"breadcrumbs"}'>
        <div class="container">
            <h4 class="breadcrumbs-custom-title">酒店详情</h4>
            <ul class="breadcrumbs-custom-path">
                <li><a href="index.jsp">首页</a></li>
                <li><a href="Hotel.jsp">民宿酒店</a></li>
                <li class="active">酒店详情</li>
            </ul>
        </div>
    </section>
    <section class="section section-lg bg-default">
        <div class="container">
            <div class="row">
                <div class="col-12">
	                    <div class="blog-post-classic">
	                        <h2>${hotel.name} <i class="fa fa-star-o bookmark-star bookmark-star--lg" data-bookmarked="false"></i></h2>
	                        <c:choose>
	                            <c:when test="${not empty hotel.coverImage}">
	                                <img src="${hotel.coverImage}" alt="${hotel.name}" style="max-width:100%;height:auto;max-height:500px;object-fit:contain;display:block;margin:0 auto 20px;border-radius:10px;"/>
	                            </c:when>
	                            <c:otherwise>
	                                <img src="images/blog-post-1-1170x544.jpg" alt="${hotel.name}" style="max-width:100%;height:auto;max-height:500px;object-fit:contain;display:block;margin:0 auto 20px;border-radius:10px;"/>
	                            </c:otherwise>
	                        </c:choose>

	                        <!-- 酒店基本信息 -->
	                        <div style="display:flex;flex-wrap:wrap;gap:20px;align-items:center;margin:20px 0;padding:15px 20px;background:#f9fafb;border-radius:8px;">
	                            <c:if test="${not empty hotel.city}"><span style="color:#666;">📍 ${hotel.city}</span></c:if>
	                            <c:if test="${not empty hotel.starRating}">
	                                <span style="color:#f39c12;">
	                                    <c:forEach begin="1" end="${hotel.starRating}">★</c:forEach>
	                                    ${hotel.starRating}星
	                                </span>
	                            </c:if>
	                            <c:if test="${not empty hotel.minPrice}"><span style="font-size:24px;color:#e74c3c;font-weight:bold;">¥${hotel.minPrice}<small style="font-size:14px;color:#999;"> 起/晚</small></span></c:if>
	                            <c:if test="${not empty hotel.contactPhone}"><span style="color:#666;">📞 ${hotel.contactPhone}</span></c:if>
	                        </div>

	                        <!-- 描述 -->
	                        <div style="font-size:16px;color:#444;margin-bottom:25px;">${formattedDesc}</div>

	                        <!-- 设施标签 -->
	                        <c:if test="${not empty hotel.facilities}">
	                        <div style="margin:25px 0;">
	                            <h4 style="border-left:4px solid #00a8a8;padding-left:12px;margin-bottom:15px;">配套设施</h4>
	                            <div style="display:flex;flex-wrap:wrap;gap:10px;" id="facility-tags">
	                                <c:forTokens items="${hotel.facilities}" delims='["],[]{} ' var="f">
	                                    <c:if test="${not empty f && f.length() > 1}">
	                                        <span style="background:#e8f8f8;color:#00a8a8;border:1px solid #00a8a8;padding:6px 16px;border-radius:20px;font-size:14px;">${f}</span>
	                                    </c:if>
	                                </c:forTokens>
	                            </div>
	                        </div>
	                        </c:if>

	                        <!-- 酒店图片画廊 -->
	                        <c:if test="${not empty hotel.images}">
	                        <div class="blog-post-classic__media-group">
	                            <h4 style="border-left:4px solid #00a8a8;padding-left:12px;margin-bottom:15px;">实景展示</h4>
	                            <div class="row row-30 justify-content-center" id="hotelGalleryContainer">
	                                <c:forTokens items="${hotel.images}" delims='["],[]{} ' var="img">
	                                    <c:if test="${not empty img && img.length() > 5}">
                                        <div class="col-lg-3 col-md-4 col-sm-6" style="margin-bottom:20px;">
                                            <img src="${img}" alt="实景" onclick="openLightbox('${img}')" style="width:100%;height:220px;object-fit:cover;border-radius:8px;cursor:pointer;transition:transform 0.2s;" onmouseover="this.style.transform='scale(1.03)'" onmouseout="this.style.transform='scale(1)'"/>
                                        </div>
	                                    </c:if>
	                                </c:forTokens>
	                            </div>
	                        </div>
	                        </c:if>
                        <div class="blog-post-classic__reviews">
                            <div class="reviews-header">
                                <h2>住客评价</h2>
                                <button class="button button-review" onclick="toggleReviewForm()">发表评论</button>
                            </div>
                            <!-- Hidden review form (appears between header and existing reviews) -->
                            <div class="review-form-wrapper" id="reviewFormWrapper" style="display: none;">
                                <div class="review-form">
                                    <div class="row row-15">
                                        <div class="col-lg-2">
                                            <img src="images/user-1-170x164.jpg" alt="" width="170" height="164" style="border-radius: 50%;">
                                        </div>
                                        <div class="col-lg-10">
                                            <h5>我的评论</h5>
                                            <div class="form-wrap">
                                                <textarea class="form-input review-form__textarea" id="reviewContent" rows="4" placeholder="分享您的入住体验..."></textarea>
                                            </div>
                                            <div class="review-form__actions">
                                                <button class="button button-primary-2 button-sm" onclick="var c=document.getElementById('reviewContent'); if(c.value.trim().length<10){alert('评论内容至少10个字');return;} alert('评论提交成功！'); c.value=''; document.getElementById('reviewFormWrapper').style.display='none';">提交评论</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row row-30">
                                <div class="col-12">
                                    <div class="blog-post-classic__comment">
                                        <div class="row row-15">
                                            <div class="col-lg-2"><img src="images/user-1-170x164.jpg" alt="" width="170" height="164"/>
                                            </div>
                                            <div class="col-lg-10">
                                                <h5>张明 <i class="fa fa-star-o bookmark-star" data-bookmarked="false"></i></h5>
                                                <p>黄河宿集真的太美了！坐在院子里就能看到黄河，晚上还能看到满天星空。服务非常贴心，早餐也很美味，强烈推荐！</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="blog-post-classic__comment">
                                        <div class="row row-15">
                                            <div class="col-lg-2"><img src="images/user-2-170x164.jpg" alt="" width="170" height="164"/>
                                            </div>
                                            <div class="col-lg-10">
                                                <h5>李婷 <i class="fa fa-star-o bookmark-star" data-bookmarked="false"></i></h5>
                                                <p>这是我住过最有特色的民宿！设计感十足，每个角落都充满了艺术气息。管家服务非常周到，帮我们安排了沙漠和黄河的体验活动，非常难忘的一次旅行！</p>
                                            </div>
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
</div>
<div class="snackbars" id="form-output-global"></div>
<!-- Image lightbox overlay -->
<div class="lightbox-overlay" id="lightboxOverlay" onclick="closeLightbox()">
    <span class="lightbox-close" onclick="closeLightbox()">&times;</span>
    <img class="lightbox-image" id="lightboxImage" src="" alt="">
</div>
<script src="js/core.min.js"></script>
<script src="js/script.js"></script>
<script>
// Hotel category gallery switching
(function() {
    var categories = document.querySelectorAll('.hotel-category');
    var galleryGrid = document.getElementById('hotelGalleryGrid');

    // Sample gallery images for each category (using existing project images)
    var galleryData = {
        room: [
            'images/grid-gallery-1-370x250.jpg',
            'images/grid-gallery-2-370x250.jpg',
            'images/grid-gallery-3-370x250.jpg',
            'images/grid-gallery-4-370x250.jpg',
            'images/grid-gallery-5-370x250.jpg',
            'images/grid-gallery-6-370x250.jpg'
        ],
        restaurant: [
            'images/grid-gallery-2-370x250.jpg',
            'images/grid-gallery-3-370x250.jpg',
            'images/grid-gallery-4-370x250.jpg',
            'images/grid-gallery-5-370x250.jpg',
            'images/grid-gallery-6-370x250.jpg',
            'images/grid-gallery-1-370x250.jpg'
        ],
        lobby: [
            'images/grid-gallery-3-370x250.jpg',
            'images/grid-gallery-4-370x250.jpg',
            'images/grid-gallery-5-370x250.jpg',
            'images/grid-gallery-6-370x250.jpg',
            'images/grid-gallery-1-370x250.jpg',
            'images/grid-gallery-2-370x250.jpg'
        ],
        landscape: [
            'images/grid-gallery-4-370x250.jpg',
            'images/grid-gallery-5-370x250.jpg',
            'images/grid-gallery-6-370x250.jpg',
            'images/grid-gallery-1-370x250.jpg',
            'images/grid-gallery-2-370x250.jpg',
            'images/grid-gallery-3-370x250.jpg'
        ]
    };

    function renderGallery(category) {
        var images = galleryData[category] || galleryData.room;
        var html = '';
        for (var i = 0; i < images.length; i++) {
            html += '<div class="hotel-gallery__item"><img src="' + images[i] + '" alt=""></div>';
        }
        galleryGrid.innerHTML = html;
    }

    function setActiveCategory(activeEl) {
        for (var i = 0; i < categories.length; i++) {
            categories[i].classList.remove('active');
        }
        activeEl.classList.add('active');
    }

    // Click handler
    for (var i = 0; i < categories.length; i++) {
        categories[i].addEventListener('click', function(e) {
            var category = this.getAttribute('data-category');
            var gallery = galleryGrid.parentElement;

            // If clicking already active module, hide gallery
            if (this.classList.contains('active')) {
                this.classList.remove('active');
                gallery.style.display = 'none';
                return;
            }

            // Otherwise, show this category
            setActiveCategory(this);
            gallery.style.display = 'block';
            renderGallery(category);
        });
    }
})();

// Image lightbox
function openLightbox(src) {
    document.getElementById('lightboxImage').src = src;
    document.getElementById('lightboxOverlay').style.display = 'flex';
}
function closeLightbox() {
    document.getElementById('lightboxOverlay').style.display = 'none';
}
// Lightbox click via event delegation (works for dynamically added images too)
document.addEventListener('click', function(e) {
    var target = e.target;
    if (target.matches('.hotel-gallery__item img')) {
        e.stopPropagation();
        openLightbox(target.src);
    }
});
// Bookmark star toggle
document.addEventListener('click', function(e) {
    var star = e.target.closest('.bookmark-star');
    if (star) {
        e.preventDefault();
        var bookmarked = star.getAttribute('data-bookmarked') === 'true';
        var lg = star.classList.contains('bookmark-star--lg') ? ' bookmark-star--lg' : '';
        if (bookmarked) {
            star.className = 'fa fa-star-o bookmark-star' + lg;
            star.setAttribute('data-bookmarked', 'false');
        } else {
            star.className = 'fa fa-star bookmark-star active' + lg;
            star.setAttribute('data-bookmarked', 'true');
        }
    }
});

// Toggle review form
function toggleReviewForm() {
    var form = document.getElementById('reviewFormWrapper');
    if (form.style.display === 'none' || form.style.display === '') {
        form.style.display = 'block';
    } else {
        form.style.display = 'none';
    }
}

// Review form star rating
document.addEventListener('click', function(e) {
    var star = e.target.closest('.review-star');
    if (star) {
        var allStars = star.parentElement.querySelectorAll('.review-star');
        var value = parseInt(star.getAttribute('data-star'));
        allStars.forEach(function(s) {
            var sVal = parseInt(s.getAttribute('data-star'));
            if (sVal <= value) {
                s.className = 'fa fa-star review-star active';
            } else {
                s.className = 'fa fa-star-o review-star';
            }
        });
    }
});
</script>
</c:if>
</body>
</html>