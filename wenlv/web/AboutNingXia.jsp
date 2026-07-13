<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.NewsDynamicMapper" %>
<%@ page import="com.niit.mapper.OfficialNoticeMapper" %>
<%@ page import="com.niit.pojo.NewsDynamic" %>
<%@ page import="com.niit.pojo.OfficialNotice" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    try (SqlSession s = DBUtil.getSession()) {
        List<NewsDynamic> news = s.getMapper(NewsDynamicMapper.class).findPublished();
        request.setAttribute("newsList", news);
        List<OfficialNotice> notices = s.getMapper(OfficialNoticeMapper.class).findPublished();
        request.setAttribute("noticeList", notices);
    } catch (Exception e) {}
%>

<%@include file="Head.jsp"%>

<!-- Breadcrumbs-->
<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);">
    <div class="container">
        <h4 class="breadcrumbs-custom-title">资讯</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li class="active">资讯</li>
        </ul>
    </div>
</section>

<!-- 新闻动态 -->
<section class="section section-lg bg-image-5">
    <div class="container">
        <div class="row row-40 flex-column-reverse flex-xl-row">
            <div class="col-xl-7 position-relative">
                <div class="image-box inverse wow fadeInLeft">
                    <div class="image-box__static"><img src="images/img-about-2-364x459.jpg" alt="" width="364" height="459"/></div>
                    <div class="image-box__float"><img src="images/img-about-1-364x459.jpg" alt="" width="364" height="459"/></div>
                </div>
            </div>
            <div class="col-xl-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>新闻动态</h2>
                    <a href="news-list.jsp" style="font-size:14px;color:#00a8a8;text-decoration:none;">更多>></a>
                </div>
                <div class="news-list">
                    <c:forEach items="${newsList}" var="n" begin="0" end="4" varStatus="s">
                        <div class="news-item" onclick="location.href='news-detail.jsp?id=${n.id}'" style="cursor:pointer;">
                            <span class="news-number">${s.index + 1}</span>
                            <a href="news-detail.jsp?id=${n.id}" class="news-title">${n.title}</a>
                            <span class="news-date"><fmt:formatDate value="${n.publishedAt}" pattern="MM-dd"/></span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 通知公告 -->
<section class="section section-lg bg-image-6">
    <div class="container">
        <div class="row">
            <div class="col-xl-6">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>通知公告</h2>
                    <a href="notice-list.jsp" style="font-size:14px;color:#00a8a8;text-decoration:none;">更多>></a>
                </div>
                <div class="notice-list">
                    <c:forEach items="${noticeList}" var="n" begin="0" end="3">
                        <div class="notice-item" onclick="location.href='notice-detail.jsp?id=${n.id}'" style="cursor:pointer;">
                            <span class="notice-badge">
                                <c:choose><c:when test="${n.isTop == 1}">置顶</c:when><c:otherwise>公告</c:otherwise></c:choose>
                            </span>
                            <a href="notice-detail.jsp?id=${n.id}" class="notice-title">${n.title}</a>
                            <span class="notice-date"><fmt:formatDate value="${n.publishedAt}" pattern="MM-dd"/></span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</section>

<style>
    .news-item { display:flex;justify-content:space-between;align-items:center;padding:12px 0;border-bottom:1px solid #f0f0f0; }
    .news-item:last-child { border-bottom:none; }
    .news-number { width:24px;height:24px;background:#00a8a8;color:white;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;font-size:12px;margin-right:12px;flex-shrink:0; }
    .news-title { flex-grow:1;font-size:14px;color:#333;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-decoration:none; }
    .news-title:hover { color:#00a8a8; }
    .news-date { font-size:12px;color:#999;margin-left:12px;flex-shrink:0; }
    .notice-item { display:flex;align-items:center;padding:12px 0;border-bottom:1px solid #f0f0f0; }
    .notice-item:last-child { border-bottom:none; }
    .notice-badge { background:#00a8a8;color:white;font-size:12px;padding:2px 6px;border-radius:3px;margin-right:12px;flex-shrink:0; }
    .notice-title { flex-grow:1;font-size:14px;color:#333;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-decoration:none; }
    .notice-title:hover { color:#00a8a8; }
    .notice-date { font-size:12px;color:#999;margin-left:12px;flex-shrink:0; }
</style>

<!--Footer-->
<footer class="section footer-classic context-dark">
    <div class="container">
        <div class="row row-narrow-40 row-30">
            <div class="col-lg-6 text-center wow fadeInLeft"><div class="footer-media"><img src="images/footer-img-570x402.jpg" alt="" width="570" height="402"/></div></div>
            <div class="col-lg-6 wow fadeInRight">
                <div class="footer-classic_subscribe">
                    <h2>订阅宁夏旅游资讯</h2>
                    <h5 class="text-primary">立即注册，获取宁夏最新旅游资讯和优惠信息！</h5>
                    <form class="rd-form rd-mailform rd-form-inline subscribe-form" data-form-output="form-output-global" data-form-type="subscribe" method="post" action="bat/rd-mailform.php">
                        <div class="form-wrap">
                            <input class="form-input" id="subscribe-form-email-5" type="email" name="email" data-constraints="@Email @Required">
                            <label class="form-label" for="subscribe-form-email-5">输入您的邮箱</label>
                            <div class="form-button"><button class="button button-primary fa fa-chevron-circle-right" type="submit"></button></div>
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
                        <a class="brand" href="index.jsp"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt="" width="112" height="19"/></a>
                        <p class="rights"><span>版权</span><span>&nbsp;</span><span>&copy;&nbsp;</span><span class="copyright-year"></span><span>&nbsp;</span><span>保留所有权利</span></p>
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
