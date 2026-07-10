<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>

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
                    <img src="images/single-tour-1-470x464.jpg" alt="沙坡头景区封面" width="470" height="464"/>
                </div>
                <div class="scenic-stats mt-4 d-flex justify-content-around">
                    <div class="stat-item text-center">
                        <div class="stat-icon" style="width: 48px; height: 48px; background: #00a8a8; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px;">
                            <i class="fa fa-eye" style="color: white;"></i>
                        </div>
                        <div class="stat-value" style="font-size: 18px; font-weight: bold; color: #333;">12,345</div>
                        <div class="stat-label" style="font-size: 12px; color: #999;">浏览次数</div>
                    </div>
                    <div class="stat-item text-center">
                        <div id="favorite-icon" onclick="toggleFavorite()" style="width: 48px; height: 48px; background: #ccc; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 8px; cursor: pointer;">
                            <i class="fa fa-heart" style="color: white;"></i>
                        </div>
                        <div id="favorite-count" style="font-size: 18px; font-weight: bold; color: #333;">2,345</div>
                        <div class="stat-label" style="font-size: 12px; color: #999;">收藏次数</div>
                    </div>
                </div>
            </div>
            <div class="col-xl-7">
                <div class="single-service__caption">
                    <div class="heading-4 text-xl mb-3">沙坡头景区</div>
                    <div class="price-group mb-4"><span class="price-group__sale">¥100.00</span><span class="price-group__price-old">¥120.00</span></div>
                    <div class="scenic-info-list mb-4">
                        <div class="info-item d-flex align-items-center py-2 border-bottom border-light">
                            <i class="fa fa-map-marker" style="color: #00a8a8; margin-right: 12px; width: 20px;"></i>
                            <span style="color: #666;">地址：宁夏回族自治区中卫市沙坡头区迎水桥镇沙坡头旅游景区</span>
                        </div>
                        <div class="info-item d-flex align-items-center py-2 border-bottom border-light">
                            <i class="fa fa-clock-o" style="color: #00a8a8; margin-right: 12px; width: 20px;"></i>
                            <span style="color: #666;">开放时间：08:00 - 18:00（全年开放）</span>
                        </div>
                        <div class="info-item d-flex align-items-center py-2 border-bottom border-light">
                            <i class="fa fa-phone" style="color: #00a8a8; margin-right: 12px; width: 20px;"></i>
                            <span style="color: #666;">联系电话：0955-7689103</span>
                        </div>
                        <div class="info-item d-flex align-items-center py-2 border-bottom border-light">
                            <i class="fa fa-map" style="color: #00a8a8; margin-right: 12px; width: 20px;"></i>
                            <span style="color: #666;">地理位置：北纬37.54°，东经105.14°</span>
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
                                <p class="mb-4" style="color: #666; line-height: 1.8;">沙坡头景区是宁夏最具代表性的旅游目的地之一，以其独特的自然景观和丰富的娱乐项目吸引着无数游客。景区位于腾格里沙漠东南边缘，黄河穿境而过，形成了独特的沙水相依景观。景区总面积约80.6平方公里，是集沙漠、黄河、高山、绿洲于一体的国家AAAAA级旅游景区。</p>
                                <h3 class="mb-4" style="color: #333; font-size: 20px;">景区特色</h3>
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <div class="feature-card p-4" style="background: #f8f9fa; border-radius: 8px; margin-bottom: 16px;">
                                            <h4 style="color: #00a8a8; font-size: 16px; margin-bottom: 12px;"><i class="fa fa-desert"></i> 沙漠体验区</h4>
                                            <p style="color: #666; font-size: 14px; line-height: 1.6;">北区以沙漠体验为主，可进行沙漠冲浪、骑骆驼、沙漠露营、滑沙等活动，感受大漠雄浑与壮美。</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="feature-card p-4" style="background: #f8f9fa; border-radius: 8px; margin-bottom: 16px;">
                                            <h4 style="color: #00a8a8; font-size: 16px; margin-bottom: 12px;"><i class="fa fa-ship"></i> 黄河文化区</h4>
                                            <p style="color: #666; font-size: 14px; line-height: 1.6;">南区以黄河文化为主，可体验羊皮筏子漂流、黄河滑索、黄河蹦极等项目，欣赏黄河日落美景。</p>
                                        </div>
                                    </div>
                                </div>
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
                            <div class="row row-10 row-narrow-10 text-center" data-lightgallery="group">
                                <div class="col-lg-4 col-sm-6 gallery-item" style="animation-delay: 1s;"><a class="gallery-link" href="images/grid-gallery-1-1200x800-original.jpg" data-lightgallery="item"><img src="images/grid-gallery-1-370x250.jpg" alt="景区图片1" width="370" height="250"/></a></div>
                                <div class="col-lg-4 col-sm-6 gallery-item" style="animation-delay: 1.5s;"><a class="gallery-link" href="images/grid-gallery-2-1200x800-original.jpg" data-lightgallery="item"><img src="images/grid-gallery-2-370x250.jpg" alt="景区图片2" width="370" height="250"/></a></div>
                                <div class="col-lg-4 col-sm-6 gallery-item" style="animation-delay: 2s;"><a class="gallery-link" href="images/grid-gallery-3-1200x800-original.jpg" data-lightgallery="item"><img src="images/grid-gallery-3-370x250.jpg" alt="景区图片3" width="370" height="250"/></a></div>
                                <div class="col-lg-4 col-sm-6 gallery-item" style="animation-delay: 2.5s;"><a class="gallery-link" href="images/grid-gallery-4-1200x800-original.jpg" data-lightgallery="item"><img src="images/grid-gallery-4-370x250.jpg" alt="景区图片4" width="370" height="250"/></a></div>
                                <div class="col-lg-4 col-sm-6 gallery-item" style="animation-delay: 3s;"><a class="gallery-link" href="images/grid-gallery-5-1200x800-original.jpg" data-lightgallery="item"><img src="images/grid-gallery-5-370x250.jpg" alt="景区图片5" width="370" height="250"/></a></div>
                                <div class="col-lg-4 col-sm-6 gallery-item" style="animation-delay: 3.5s;"><a class="gallery-link" href="images/grid-gallery-6-1200x800-original.jpg" data-lightgallery="item"><img src="images/grid-gallery-6-370x250.jpg" alt="景区图片6" width="370" height="250"/></a></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

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
                        <a class="brand" href="index.jsp"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt="" width="112" height="19"/><img class="brand-logo-light" src="images/logo-default-225x39.png" alt="" width="112" height="19"/></a>
                        <p class="rights"><span>版权</span><span>&nbsp;</span><span>&copy;&nbsp;</span><span class="copyright-year"></span><span>&nbsp;</span><span>保留所有权利</span> <a target="_blank" href="https://www.mobanwang.com/" title="网站模板">网站模板</a></p>
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
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
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
        });
    });

    var isFavorited = false;
    var favoriteCount = 2345;

    function toggleFavorite() {
        var isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
        var isAdminLoggedIn = localStorage.getItem('isAdminLoggedIn') === 'true';
        
        if (!isLoggedIn && !isAdminLoggedIn) {
            alert('请先登录后再收藏！');
            var loginModal = new bootstrap.Modal(document.getElementById('login-modal'));
            loginModal.show();
            return;
        }
        
        var icon = document.getElementById('favorite-icon');
        var countSpan = document.getElementById('favorite-count');
        
        if (isFavorited) {
            icon.style.background = '#ccc';
            favoriteCount--;
            isFavorited = false;
        } else {
            icon.style.background = '#ff6b6b';
            favoriteCount++;
            isFavorited = true;
        }
        
        countSpan.textContent = favoriteCount.toLocaleString();
    }
</script>