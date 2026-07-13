<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.HotelMapper" %>
<%@ page import="com.niit.pojo.Hotel" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    try (SqlSession s = DBUtil.getSession()) {
        request.setAttribute("hotels", s.getMapper(HotelMapper.class).findOpen());
    } catch (Exception e) {}
%>

<%@include file="Head.jsp"%>

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
                <c:choose>
                    <c:when test="${empty hotels}">
                        <div class="col-12 text-center" style="padding:60px 0;color:#999;">酒店正在上架中，敬请期待...</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${hotels}" var="h">
                <div class="col-lg-4 col-sm-6">
                    <article class="card-classic" style="display:flex;flex-direction:column;height:100%;">
                        <a class="card-classic__media" href="Hotel-detail.jsp?id=${h.id}"><img src="${empty h.coverImage ? 'images/service-1-370x389.jpg' : h.coverImage}" alt="${h.name}" width="370" height="389"/></a>
                        <h5><a href="Hotel-detail.jsp?id=${h.id}">${h.name}</a> <i class="fa fa-star-o bookmark-star" data-bookmarked="false"></i></h5>
                        <p style="flex:1;overflow:hidden;display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;min-height:3.6em;">${h.description}</p>
                        <div class="card-classic__actions" style="margin-top:auto;"><a class="button button-primary-2 button-md" href="Hotel-detail.jsp?id=${h.id}">了解更多</a><span class="card-classic__price"><span class="card-classic__price-currency">￥</span><span class="card-classic__price-amount">${empty h.minPrice ? '299' : h.minPrice}</span><span class="card-classic__price-starting">起</span></span></div>
                    </article>
                </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
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
<script>
// Bookmark star toggle
document.addEventListener('click', function(e) {
    var star = e.target.closest('.bookmark-star');
    if (star) {
        e.preventDefault();
        var bookmarked = star.getAttribute('data-bookmarked') === 'true';
        if (bookmarked) {
            star.className = 'fa fa-star-o bookmark-star' + (star.classList.contains('bookmark-star--lg') ? ' bookmark-star--lg' : '');
            star.setAttribute('data-bookmarked', 'false');
        } else {
            star.className = 'fa fa-star bookmark-star active' + (star.classList.contains('bookmark-star--lg') ? ' bookmark-star--lg' : '');
            star.setAttribute('data-bookmarked', 'true');
        }
    }
});
</script>
</body>
</html>