<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>

    <!-- Breadcrumbs-->
    <section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);" data-preset='{"title":"Breadcrumbs","category":"header","reload":false,"id":"breadcrumbs"}'>
        <div class="container">
            <h4 class="breadcrumbs-custom-title">咨询</h4>
            <ul class="breadcrumbs-custom-path">
                <li><a href="index.jsp">首页</a></li>
                <li class="active">咨询</li>
            </ul>
        </div>
    </section>
    <section class="section section-lg bg-image-5">
        <div class="container">
            <div class="row row-40 flex-column-reverse flex-xl-row">
                <div class="col-xl-7 position-relative">
                    <div class="image-box inverse wow fadeInLeft">
                        <div class="image-box__static"><img src="images/img-about-2-364x459.jpg" alt="" width="364" height="459"/>
                        </div>
                        <div class="image-box__float"><img src="images/img-about-1-364x459.jpg" alt="" width="364" height="459"/>
                        </div>
                    </div>
                </div>
                <div class="col-xl-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2><span class="wow fadeInRight d-xl-block">新闻动态</span></h2>
                        <a href="news-list.jsp" style="font-size: 14px; color: #00a8a8; text-decoration: none;">更多>></a>
                    </div>
                    <div id="news-list-container" class="news-list"></div>
                    <style>
                        .news-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f0f0f0; }
                        .news-item:last-child { border-bottom: none; }
                        .news-number { width: 24px; height: 24px; background: #00a8a8; color: white; display: inline-flex; align-items: center; justify-content: center; border-radius: 50%; font-size: 12px; margin-right: 12px; flex-shrink: 0; }
                        .news-title { flex-grow: 1; font-size: 14px; color: #333; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
                        .news-date { font-size: 12px; color: #999; margin-left: 12px; flex-shrink: 0; }
                    </style>
                    <script>
                        var newsData = [
                            { title: '宁夏夏季旅游旺季即将到来，各大景区准备就绪', date: '2026-06-12' },
                            { title: '沙湖景区新开放水上项目，吸引游客体验', date: '2026-06-08' },
                            { title: '宁夏旅游文化节盛大开幕，展现塞上江南魅力', date: '2026-06-01' },
                            { title: '镇北堡西部影城推出暑期优惠活动', date: '2026-05-28' },
                            { title: '中卫沙漠旅游度假区升级改造完成', date: '2026-05-20' }
                        ];
                        var container = document.getElementById('news-list-container');
                        newsData.forEach(function(item, index) {
                            var newsItem = document.createElement('div');
                            newsItem.className = 'news-item';
                            newsItem.innerHTML = '<span class="news-number">' + (index + 1) + '</span>' +
                                '<span class="news-title">' + item.title + '</span>' +
                                '<span class="news-date">' + item.date + '</span>';
                            container.appendChild(newsItem);
                        });
                    </script>
                </div>
            </div>
        </div>
    </section>
    <!--特色亮点-->
    <section class="section section-lg bg-image-6">
        <div class="container">
            <div class="row">
                <div class="col-xl-6">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2><span class="wow fadeInRight d-xl-block">通知公告</span></h2>
                        <a href="notice-list.jsp" style="font-size: 14px; color: #00a8a8; text-decoration: none;">更多>></a>
                    </div>
                    <div id="notice-list-container"></div>
                    <style>
                        #notice-list-container { padding-left: 0; }
                        .notice-item { display: flex; align-items: center; padding: 8px 0; }
                        .notice-badge { background: #00a8a8; color: white; font-size: 12px; padding: 2px 6px; border-radius: 3px; margin-right: 12px; flex-shrink: 0; }
                        .notice-title { font-size: 14px; color: #333; }
                    </style>
                    <script>
                        var noticeData = [
                            { badge: '公告', title: '宁夏旅游景区门票价格调整通知' },
                            { badge: '公告', title: '暑期旅游安全提示' },
                            { badge: '公告', title: '部分景区临时闭园维护通知' },
                            { badge: '公告', title: '宁夏旅游惠民政策解读' }
                        ];
                        var container = document.getElementById('notice-list-container');
                        noticeData.forEach(function(item) {
                            var noticeItem = document.createElement('div');
                            noticeItem.className = 'notice-item';
                            noticeItem.innerHTML = '<span class="notice-badge">' + item.badge + '</span>' +
                                '<span class="notice-title">' + item.title + '</span>';
                            container.appendChild(noticeItem);
                        });
                    </script>
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