<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.SpecialtyMapper" %>
<%@ page import="com.niit.pojo.Specialty" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    try (SqlSession s = DBUtil.getSession()) {
        request.setAttribute("foodList", s.getMapper(SpecialtyMapper.class).findAll());
    } catch (Exception e) {}
%>

<%@include file="Head.jsp"%>

<!-- Breadcrumbs-->
<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);">
    <div class="container">
        <h4 class="breadcrumbs-custom-title">宁夏特产</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li class="active">宁夏特产</li>
        </ul>
    </div>
</section>

<!--特产列表-->
<section class="section section-lg bg-image-8">
    <div class="container">
        <h2 class="text-center text-sm-start">宁夏特色美食与特产</h2>
        <div class="row row-40 offset-lg">
            <c:choose>
                <c:when test="${empty foodList}">
                    <div class="col-12 text-center" style="padding:60px 0;color:#999;">
                        <p style="font-size:18px;">特产正在上架中，敬请期待...</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${foodList}" var="food">
                        <div class="col-lg-4 col-sm-6">
                            <article class="card-classic">
                                <a class="card-classic__media" href="Specialty-detail.jsp?id=${food.id}">
                                    <c:choose>
                                        <c:when test="${not empty food.mainImage}">
                                            <img src="${food.mainImage}" alt="${food.name}" width="370" height="389"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="images/service-1-370x389.jpg" alt="${food.name}" width="370" height="389"/>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <h5><a href="Specialty-detail.jsp?id=${food.id}">${food.name}</a></h5>
                                <p>${food.description}</p>
                                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
                                    <span style="font-size:18px;color:#e74c3c;font-weight:bold;">¥${food.price}</span>
                                    <span style="font-size:12px;color:#999;">已售 ${food.salesCount}</span>
                                </div>
                                <a class="button button-primary-2 button-md" href="Specialty-detail.jsp?id=${food.id}">立即购买</a>
                            </article>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<%@include file="Footer.jsp"%>
</div>
<div class="snackbars" id="form-output-global"></div>
<script src="js/core.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>
