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

    <%@include file="Footer.jsp"%>
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