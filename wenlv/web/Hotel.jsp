<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>

    <!-- Breadcrumbs-->
    <section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);" data-preset='{"title":"Breadcrumbs","category":"header","reload":false,"id":"breadcrumbs"}'>
        <div class="container">
            <h4 class="breadcrumbs-custom-title">民宿酒店</h4>
            <ul class="breadcrumbs-custom-path">
                <li><a href="index.jsp">首页</a></li>
                <li class="active">民宿酒店</li>
            </ul>
        </div>
    </section>
    <!--Tours-->
    <section class="section section-lg bg-image-8">
        <div class="container">
            <h2 class="text-center text-sm-start">宁夏特色民宿</h2>
            <div class="row row-40 offset-lg">
                <div class="col-lg-4 col-sm-6">
                    <article class="card-classic"><a class="card-classic__media" href="Hotel-detail.jsp"><img src="images/service-1-370x389.jpg" alt="" width="370" height="389"/></a>
                        <h5><a href="Hotel-detail.jsp">黄河宿集</a></h5>
                        <p>坐落于黄河岸边，融合传统与现代的高端民宿集群。</p><a class="button button-primary-2 button-md" href="Hotel-detail.jsp">了解更多</a>
                    </article>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <article class="card-classic"><a class="card-classic__media" href="Hotel-detail.jsp"><img src="images/service-2-370x389.jpg" alt="" width="370" height="389"/></a>
                        <h5><a href="Hotel-detail.jsp">星空营地</a></h5>
                        <p>沙漠中的星空营地，体验极致的观星体验。</p><a class="button button-primary-2 button-md" href="Hotel-detail.jsp">了解更多</a>
                    </article>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <article class="card-classic"><a class="card-classic__media" href="Hotel-detail.jsp"><img src="images/service-3-370x389.jpg" alt="" width="370" height="389"/></a>
                        <h5><a href="Hotel-detail.jsp">贺兰山房</a></h5>
                        <p>依山而建，享受宁静的山间度假时光。</p><a class="button button-primary-2 button-md" href="Hotel-detail.jsp">了解更多</a>
                    </article>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <article class="card-classic"><a class="card-classic__media" href="Hotel-detail.jsp"><img src="images/service-4-370x389.jpg" alt="" width="370" height="389"/></a>
                        <h5><a href="Hotel-detail.jsp">枸杞庄园</a></h5>
                        <p>田园风光中的特色民宿，体验采摘乐趣。</p><a class="button button-primary-2 button-md" href="Hotel-detail.jsp">了解更多</a>
                    </article>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <article class="card-classic"><a class="card-classic__media" href="Hotel-detail.jsp"><img src="images/service-5-370x389.jpg" alt="" width="370" height="389"/></a>
                        <h5><a href="Hotel-detail.jsp">沙漠酒店</a></h5>
                        <p>沙漠腹地的奢华体验，感受大漠孤烟的壮美。</p><a class="button button-primary-2 button-md" href="Hotel-detail.jsp">了解更多</a>
                    </article>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <article class="card-classic"><a class="card-classic__media" href="Hotel-detail.jsp"><img src="images/service-6-370x389.jpg" alt="" width="370" height="389"/></a>
                        <h5><a href="Hotel-detail.jsp">古镇客栈</a></h5>
                        <p>穿越时光的古镇体验，感受历史的韵味。</p><a class="button button-primary-2 button-md" href="Hotel-detail.jsp">了解更多</a>
                    </article>
                </div>
            </div>
        </div>
    </section>
    <!--Tour Sale-->
    <section class="section section-lg bg-image-9">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 creative-bg-2">
                    <h4 class="font-lg text-transform-none">黄河宿集精品套房</h4>
                    <div class="group-sm price-group"><span class="price-group__sale">¥888</span><span class="price-group__price-old">¥1288</span></div>
                    <p class="text-dark-gray offset-xl">位于中卫黄河岸边的高端民宿集群，融合了传统西北民居与现代设计，是您宁夏之旅的理想下榻之所。</p>
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
                            <!--Brand--><a class="brand" href="index.html"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt="" width="112" height="19"/><img class="brand-logo-light" src="images/logo-default-225x39.png" alt="" width="112" height="19"/></a>
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
</div>
<div class="snackbars" id="form-output-global"></div>
<script src="js/core.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>