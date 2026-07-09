<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>

<!-- Breadcrumbs-->
<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);" data-preset='{"title":"Breadcrumbs","category":"header","reload":false,"id":"breadcrumbs"}'>
    <div class="container">
        <h4 class="breadcrumbs-custom-title">特色美食</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li class="active">特色美食</li>
        </ul>
    </div>
</section>
<!--美食列表-->
<section class="section section-lg bg-image-8">
    <div class="container">
        <h2 class="text-center text-sm-start">宁夏特色美食</h2>
        <div class="row row-40 offset-lg">
            <div class="col-lg-4 col-sm-6">
                <article class="card-classic">
                    <a class="card-classic__media" href="Food-detail.jsp">
                        <img src="images/service-1-370x389.jpg" alt="" width="370" height="389"/>
                    </a>
                    <h5><a href="Food-detail.jsp">盐池手抓滩羊</a></h5>
                    <p>盐池滩羊无膻味，清水焖煮，肉质细嫩，宁夏必吃招牌硬菜。</p>
                    <a class="button button-primary-2 button-md" href="Food-detail.jsp>了解更多</a>
                </article>
            </div>
            <div class="col-lg-4 col-sm-6">
                <article class="card-classic">
                    <a class="card-classic__media" href="Food-detail.jsp">
                        <img src="images/service-2-370x389.jpg" alt="" width="370" height="389"/>
                    </a>
                    <h5><a href="Food-detail.jsp">吴忠八宝茶</a></h5>
                    <p>枸杞、红枣、桂圆、葡萄干搭配冲泡，解肉腻、润喉养生。</p>
                    <a class="button button-primary-2 button-md" href="Food-detail.jsp">了解更多</a>
                </article>
            </div>
            <div class="col-lg-4 col-sm-6">
                <article class="card-classic">
                    <a class="card-classic__media" href="Food-detail.jsp">
                        <img src="images/service-3-370x389.jpg" alt="" width="370" height="389"/>
                    </a>
                    <h5><a href="Food-detail.jsp">中卫粗粮酿皮</a></h5>
                    <p>粗粮制成筋道面皮，秘制酸辣料汁，本地人气小吃。</p>
                    <a class="button button-primary-2 button-md" href="Food-detail.jsp">了解更多</a>
                </article>
            </div>
            <div class="col-lg-4 col-sm-6">
                <article class="card-classic">
                    <a class="card-classic__media" href="Food-detail.jsp">
                        <img src="images/service-4-370x389.jpg" alt="" width="370" height="389"/>
                    </a>
                    <h5><a href="Food-detail.jsp">贺兰炒糊饽</a></h5>
                    <p>手工面饼切条搭配羊肉爆炒，烟火气十足的西北面食。</p>
                    <a class="button button-primary-2 button-md" href="Food-detail.jsp">了解更多</a>
                </article>
            </div>
            <div class="col-lg-4 col-sm-6">
                <article class="card-classic">
                    <a class="card-classic__media" href="Food-detail.jsp">
                        <img src="images/service-5-370x389.jpg" alt="" width="370" height="389"/>
                    </a>
                    <h5><a href="Food-detail.jsp">黄河鲤鱼</a></h5>
                    <p>黄河野生鲤鱼红烧，肉质肥美，宁夏宴席经典菜品。</p>
                    <a class="button button-primary-2 button-md" href="Food-detail.jsp">了解更多</a>
                </article>
            </div>
            <div class="col-lg-4 col-sm-6">
                <article class="card-classic">
                    <a class="card-classic__media" href="Food-detail.jsp">
                        <img src="images/service-6-370x389.jpg" alt="" width="370" height="389"/>
                    </a>
                    <h5><a href="Food-detail.jsp">油香馓子</a></h5>
                    <p>回族传统油炸面点，香酥可口，节庆待客必备点心。</p>
                    <a class="button button-primary-2 button-md" href="Food-detail.jsp">了解更多</a>
                </article>
            </div>
        </div>
    </div>
</section>
<!--爆款美食推荐-->
<section class="section section-lg bg-image-9">
    <div class="container">
        <div class="row">
            <div class="col-lg-8 creative-bg-2">
                <h4 class="font-lg text-transform-none">招牌盐池滩羊套餐</h4>
                <div class="group-sm price-group">
                    <span class="price-group__sale">¥168</span>
                    <span class="price-group__price-old">¥228</span>
                </div>
                <p class="text-dark-gray offset-xl">选用正宗盐池散养滩羊，手抓羊肉+羊杂+八宝茶组合套餐，来宁夏必尝地道西北风味。</p>
            </div>
        </div>
    </div>
</section>
<!--Footer-->
<footer class="section footer-classic context-dark">
    <div class="container">
        <div class="row row-narrow-40 row-30">
            <div class="col-lg-6 text-center wow fadeInLeft" data-wow-delay=".1s">
                <div class="footer-media">
                    <img src="images/footer-img-570x402.jpg" alt="" width="570" height="402"/>
                </div>
            </div>
            <div class="col-lg-6 wow fadeInRight" data-wow-delay=".2s">
                <div class="footer-classic_subscribe">
                    <h2>订阅宁夏旅游资讯</h2>
                    <h5 class="text-primary">立即注册，获取宁夏最新旅游资讯和美食优惠！</h5>
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
                        <a class="brand" href="index.html">
                            <img class="brand-logo-dark" src="images/logo-default-225x39.png" alt="" width="112" height="19"/>
                            <img class="brand-logo-light" src="images/logo-default-225x39.png" alt="" width="112" height="19"/>
                        </a>
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