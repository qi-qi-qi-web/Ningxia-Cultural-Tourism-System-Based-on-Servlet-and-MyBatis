<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.niit.utils.DBUtil,com.niit.mapper.ScenicSpotMapper,com.niit.pojo.ScenicSpot,org.apache.ibatis.session.SqlSession,java.util.List" %>

<%
    try (SqlSession s = DBUtil.getSession()) { request.setAttribute("scenics", s.getMapper(ScenicSpotMapper.class).findOpen()); }
    catch (Exception e) {}
%>

<%@include file="Head.jsp"%>

    <!-- Breadcrumbs-->
    <section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);" data-preset='{"title":"Breadcrumbs","category":"header","reload":false,"id":"breadcrumbs"}'>
        <div class="container">
            <h4 class="breadcrumbs-custom-title">景区服务</h4>
            <ul class="breadcrumbs-custom-path">
                <li><a href="index.jsp">首页</a></li>
                <li class="active">景区服务</li>
            </ul>
        </div>
    </section>
    <!--Destinations-->
    <section class="section section-lg bg-default">
        <div class="container">
            <h2 class="text-center text-md-start">宁夏景区精选</h2>
            <div class="row row-40 offset-lg row-xl-40">
                <c:choose>
                    <c:when test="${empty scenics}"><div class="col-12 text-center" style="padding:60px 0;color:#999;">景区正在上架中，敬请期待...</div></c:when>
                    <c:otherwise>
                        <c:forEach items="${scenics}" var="s" varStatus="st">
                <div class="col-lg-4 col-md-6 wow fadeInUp" data-wow-delay=".${st.index % 10}s">
                    <div class="service-box-creative" style="display:flex;flex-direction:column;height:100%;">
                        <a class="service-box-creative__media" href="ScenicService-detail.jsp?id=${s.id}"><img src="${empty s.coverImage ? 'images/tour-1-370x284.jpg' : s.coverImage}" alt="${s.name}" width="370" height="284"/></a>
                        <div class="service-box-creative__caption" style="flex:1;display:flex;flex-direction:column;">
                            <h5><a href="ScenicService-detail.jsp?id=${s.id}">${s.name}</a></h5>
                            <div class="price-group"><span class="price-group__sale">¥${empty s.minPrice ? '--' : s.minPrice}</span></div>
                            <p style="flex:1;overflow:hidden;display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;min-height:3.6em;">${s.description}</p>
                            <ul class="icon-list" style="margin-top:auto;">
                                <li><span class="icon linearicons-clock3"></span><span>${empty s.openingHours ? '全天' : s.openingHours}</span></li>
                                <li><span class="icon linearicons-map-marker"></span><span>${empty s.city ? '宁夏' : s.city}</span></li>
                                <c:if test="${not empty s.contactPhone}"><li><span class="icon linearicons-phone"></span><span>${s.contactPhone}</span></li></c:if>
                            </ul>
                        </div>
                    </div>
                </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            </div>
        </div>
    </section>
    <!--Quote Creative-->
    <section class="section section-lg bg-image-10 inset-xl">
        <div class="container">
            <div class="row">
                <div class="col-xl-8 column-bg-4">
                    <div class="quote-classic-wrap wow fadeInLeft">
                        <div class="heading-4 text-xl">我们致力于为每一位旅行者提供难忘的旅行体验，从精心策划的行程到贴心的服务，让您的旅途充满惊喜与美好回忆。</div>
                        <p class="fst-italicwow fadeInUp" data-wow-delay=".2s">无论是浪漫的蜜月之旅，还是家庭亲子游，我们都能为您量身定制最完美的旅行方案。</p>
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
                        <h2>订阅新闻通讯</h2>
                        <h5 class="text-primary">立即注册，获取热门优惠和最佳旅游线路信息！</h5>
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