<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>
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
                        <h2>黄河宿集 <i class="fa fa-star-o bookmark-star bookmark-star--lg" data-bookmarked="false"></i></h2><img src="images/blog-post-1-1170x544.jpg" alt="" width="1170" height="544"/>
                        <p class="fw-sbold">黄河宿集位于宁夏中卫市黄河岸边，是一处融合传统与现代的高端民宿集群。这里不仅是一处住宿之地，更是一种生活方式的体验。</p>
                        <p class="offset-md">黄河宿集由多家知名民宿品牌共同打造，包括大乐之野、西坡、墟里、南岸等。每家民宿都有独特的设计风格，但都共同秉承着对自然的尊重和对品质的追求。在这里，您可以感受到黄河文化的深厚底蕴，体验田园生活的宁静美好。</p>
                        <p class="fw-sbold offset-xl">在黄河宿集，您将体验到与众不同的住宿体验，远离城市喧嚣，回归自然本真。</p>
                        <p class="offset-md">黄河宿集提供多种房型选择，从温馨的大床房到宽敞的家庭套房，满足不同客人的需求。每间客房都采用高品质的家具和用品，确保您的入住体验舒适惬意。此外，宿集还提供丰富的活动体验，包括黄河漂流、沙漠探险、枸杞采摘、星空观测等，让您的宁夏之旅更加丰富多彩。</p>
                        <div class="blog-post-classic__media-group">
                            <div class="row row-30 justify-content-center">
                                <div class="col-lg-3 col-md-4 col-sm-6"><a class="info-box-classic hotel-category" href="javascript:void(0)" data-category="room"><img src="images/single-service-1-270x260.jpg" alt="" width="270" height="260"/>
                                    <div class="info-box-classic__description">
                                        <div class="heading-4">客房</div>
                                    </div></a></div>
                                <div class="col-lg-3 col-md-4 col-sm-6"><a class="info-box-classic hotel-category" href="javascript:void(0)" data-category="restaurant"><img src="images/single-service-2-270x260.jpg" alt="" width="270" height="260"/>
                                    <div class="info-box-classic__description">
                                        <div class="heading-4">餐厅</div>
                                    </div></a></div>
                                <div class="col-lg-3 col-md-4 col-sm-6"><a class="info-box-classic hotel-category" href="javascript:void(0)" data-category="lobby"><img src="images/single-service-3-270x260.jpg" alt="" width="270" height="260"/>
                                    <div class="info-box-classic__description">
                                        <div class="heading-4">酒店大堂</div>
                                    </div></a></div>
                                <div class="col-lg-3 col-md-4 col-sm-6"><a class="info-box-classic hotel-category" href="javascript:void(0)" data-category="landscape"><img src="images/single-service-4-270x260.jpg" alt="" width="270" height="260"/>
                                    <div class="info-box-classic__description">
                                        <div class="heading-4">景观</div>
                                    </div></a></div>
                            </div>
                            <!-- Gallery display area -->
                            <div class="hotel-gallery" id="hotelGallery">
                                <div class="hotel-gallery__grid" id="hotelGalleryGrid"></div>
                            </div>
                        </div>
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
    <!--Footer-->
    <footer class="section footer-classic context-dark">
        <div class="container">
            <div class="row row-narrow-40 row-30">
                <div class="col-lg-6 text-center wow fadeInLeft" data-wow-delay=".1s">
                    <div class="footer-media"><img src="images/footer-img-570x402.jpg" alt="" width="570" height="402"/>
                    </div>
                </div>
                <div class="col-lg-6 wow fadeInRight" data-wow-delay=".2s">
                    <div class="footer-classic_subscribe">
                        <h2>订阅宁夏旅游资讯</h2>
                        <h5 class="text-primary">立即注册，获取宁夏最新旅游资讯和优惠信息！</h5>
                        <form class="rd-form rd-mailform rd-form-inline subscribe-form" data-form-output="form-output-global" data-form-type="subscribe" method="post" action="bat/rd-mailform.php">
                            <div class="form-wrap">
                                <input class="form-input" id="subscribe-form-email-5" type="email" name="email" data-constraints="@Email @Required">
                                <label class="form-label" for="subscribe-form-email-5">输入您的邮箱</label>
                                <div class="form-button">
                                    <button class="button button-primary fa fa-chevron-circle-right" type="submit"></button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-classic-aside">
            <div class="container">
                <div class="row justify-content-between flex-column-reverse flex-md-row row-20">
                    <div class="col-xl-6 col-md-8">
                        <div class="footer-classic-aside__group">
                            <!--Brand--><a class="brand" href="index.jsp"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt="" width="112" height="19"/><img class="brand-logo-light" src="images/logo-default-225x39.png" alt="" width="112" height="19"/></a>
                            <p class="rights"><span>版权所有</span><span>&nbsp;</span><span>&copy;&nbsp;</span><span class="copyright-year"></span><span>&nbsp;</span><span>保留所有权利</span> <a target="_blank" href="https://www.mobanwang.com/" title="网站模板">网站模板</a></p>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-4">
                        <ul class="social-list">
                            <li class="wow fadeInUp" data-wow-delay=".1s"><a href="#"><span class="icon fa fa-facebook"></span></a></li>
                            <li class="wow fadeInUp" data-wow-delay=".2s"><a href="#"><span class="icon fa fa-twitter"></span></a></li>
                            <li class="wow fadeInUp" data-wow-delay=".3s"><a href="#"><span class="icon fa fa-instagram"></span></a></li>
                            <li class="wow fadeInUp" data-wow-delay=".4s"><a href="#"><span class="icon fa fa-pinterest"></span></a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </footer>
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
</body>
</html>