<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.OfficialNoticeMapper" %>
<%@ page import="com.niit.pojo.OfficialNotice" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    try (SqlSession s = DBUtil.getSession()) {
        request.setAttribute("noticeList", s.getMapper(OfficialNoticeMapper.class).findPublished());
    } catch (Exception e) {}
%>

<%@include file="Head.jsp"%>

<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);">
    <div class="container">
        <h4 class="breadcrumbs-custom-title">通知公告</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="AboutNingXia.jsp">资讯</a></li>
            <li class="active">通知公告</li>
        </ul>
    </div>
</section>

<section class="section section-lg bg-default">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-8">
                <h2 class="text-center mb-6">通知公告</h2>
                <c:choose>
                    <c:when test="${empty noticeList}">
                        <p class="text-center" style="color:#999;padding:40px 0;">暂无通知公告</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${noticeList}" var="n" varStatus="s">
                            <div class="notice-item" onclick="location.href='notice-detail.jsp?id=${n.id}'">
                                <span class="notice-badge">
                                    <c:choose>
                                        <c:when test="${n.isTop == 1}">置顶</c:when>
                                        <c:otherwise>公告</c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="notice-title">${n.title}</span>
                                <span class="notice-date"><fmt:formatDate value="${n.publishedAt}" pattern="yyyy-MM-dd"/></span>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</section>

<style>
    .notice-item { display:flex;align-items:center;padding:16px 0;border-bottom:1px solid #f0f0f0;cursor:pointer;transition:background-color 0.2s; }
    .notice-item:hover { background-color:#fafafa; }
    .notice-item:last-child { border-bottom:none; }
    .notice-badge { background:#00a8a8;color:white;font-size:14px;padding:4px 10px;border-radius:4px;margin-right:16px;flex-shrink:0; }
    .notice-title { font-size:16px;color:#333;flex-grow:1; }
    .notice-date { font-size:14px;color:#999;margin-left:16px;flex-shrink:0; }
</style>

<footer class="section footer-classic context-dark">
    <div class="container"><div class="row row-narrow-40 row-30">
        <div class="col-lg-6 text-center wow fadeInLeft"><div class="footer-media"><img src="images/footer-img-570x402.jpg" alt="" width="570" height="402"/></div></div>
        <div class="col-lg-6 wow fadeInRight"><div class="footer-classic_subscribe"><h2>订阅宁夏旅游资讯</h2>
            <h5 class="text-primary">获取最新宁夏旅游资讯和优惠信息！</h5></div></div>
    </div></div>
    <div class="footer-classic-aside"><div class="container"><div class="row justify-content-between flex-column-reverse flex-md-row row-20">
        <div class="col-xl-6 col-md-8"><div class="footer-classic-aside__group"><a class="brand" href="index.jsp"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt=""/></a><p class="rights">版权 &copy; <span class="copyright-year"></span> 保留所有权利</p></div></div>
    </div></div></div>
</footer>
</div>
<script src="js/core.min.js"></script><script src="js/script.js"></script>
</body></html>
