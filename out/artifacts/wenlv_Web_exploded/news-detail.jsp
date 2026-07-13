<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.NewsDynamicMapper" %>
<%@ page import="com.niit.pojo.NewsDynamic" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>

<%
    String idStr = request.getParameter("id");
    if (idStr != null) {
        try (SqlSession s = DBUtil.getSession()) {
            NewsDynamic news = s.getMapper(NewsDynamicMapper.class).findById(Long.parseLong(idStr));
            request.setAttribute("news", news);
            if (news != null && news.getContent() != null) {
                String content = news.getContent().trim();
                if (content.startsWith("<")) {
                    request.setAttribute("formattedContent", content);
                } else {
                    String[] paras = content.split("\n\n");
                    StringBuilder sb = new StringBuilder();
                    for (String p : paras) {
                        p = p.trim();
                        if (!p.isEmpty()) {
                            sb.append("<p style=\"text-indent:2em;margin-bottom:0.8em;line-height:2;\">")
                              .append(p.replace("\n", "<br/>"))
                              .append("</p>");
                        }
                    }
                    request.setAttribute("formattedContent", sb.toString());
                }
            }
        } catch (Exception e) {}
    }
%>

<%@include file="Head.jsp"%>

<c:if test="${empty news}">
    <section class="section section-lg bg-default"><div class="container text-center" style="padding:80px 0;">
        <h3>新闻不存在</h3><a href="news-list.jsp" class="button button-primary">返回新闻列表</a>
    </div></section>
</c:if>

<c:if test="${not empty news}">
<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);">
    <div class="container">
        <h4 class="breadcrumbs-custom-title">${news.title}</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="AboutNingXia.jsp">资讯</a></li>
            <li><a href="news-list.jsp">新闻动态</a></li>
            <li class="active">详情</li>
        </ul>
    </div>
</section>

<section class="section section-lg bg-default">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-8">
                <div class="blog-post-classic">
                    <h2>${news.title}</h2>
                    <div style="color:#999;font-size:14px;margin-bottom:20px;padding-bottom:15px;border-bottom:1px solid #eee;">
                        <c:if test="${not empty news.source}">来源：${news.source} &nbsp;|&nbsp; </c:if>
                        <c:if test="${not empty news.authorName}">作者：${news.authorName} &nbsp;|&nbsp; </c:if>
                        发布时间：<fmt:formatDate value="${news.publishedAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </div>
                    <c:if test="${not empty news.coverImage}">
                        <img src="${news.coverImage}" alt="${news.title}" style="max-width:100%;height:auto;max-height:500px;object-fit:contain;display:block;margin:0 auto 25px;border-radius:8px;"/>
                    </c:if>
                    <div style="font-size:16px;color:#444;">
                        ${formattedContent}
                    </div>
                    <div style="margin-top:30px;text-align:right;">
                        <a href="news-list.jsp" class="button button-primary-2 button-md">返回列表</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</c:if>

<footer class="section footer-classic context-dark">
    <div class="container"><div class="row row-narrow-40 row-30">
        <div class="col-lg-6 text-center wow fadeInLeft"><div class="footer-media"><img src="images/footer-img-570x402.jpg" alt="" width="570" height="402"/></div></div>
        <div class="col-lg-6 wow fadeInRight"><div class="footer-classic_subscribe"><h2>订阅宁夏旅游资讯</h2><h5 class="text-primary">获取最新宁夏旅游资讯和优惠信息！</h5></div></div>
    </div></div>
    <div class="footer-classic-aside"><div class="container"><div class="row justify-content-between flex-column-reverse flex-md-row row-20">
        <div class="col-xl-6 col-md-8"><div class="footer-classic-aside__group"><a class="brand" href="index.jsp"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt=""/></a><p class="rights">版权 &copy; <span class="copyright-year"></span> 保留所有权利</p></div></div>
    </div></div></div>
</footer>
</div>
<script src="js/core.min.js"></script><script src="js/script.js"></script>
</body></html>
