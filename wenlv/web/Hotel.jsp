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
                        <a class="card-classic__media" href="Hotel-detail.jsp?id=${h.id}" style="width:100%;"><img src="${empty h.coverImage ? 'images/service-1-370x389.jpg' : h.coverImage}" alt="${h.name}" width="370" height="284" style="width:100%;height:220px;object-fit:cover;"/></a>
                        <h5><a href="Hotel-detail.jsp?id=${h.id}">${h.name}</a></h5>
                        <p style="flex:1;overflow:hidden;display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;min-height:3.6em;">${h.description}</p>
                        <div class="card-classic__actions" style="margin-top:auto;"><a class="button button-primary-2 button-md" href="Hotel-detail.jsp?id=${h.id}">了解更多</a>
                            <span style="cursor:pointer;font-size:14px;color:#999;font-style:normal;" onclick="toggleFavHotel(${h.id}, this)" data-fav-id="${h.id}"><span class="icon fa fa-heart fav-heart" style="color:#ccc;margin-right:4px;"></span><span class="fav-cnt">${h.favoriteCount}</span> 收藏</span>
                            <span class="card-classic__price"><span class="card-classic__price-currency">￥</span><span class="card-classic__price-amount">${empty h.minPrice ? '299' : h.minPrice}</span><span class="card-classic__price-starting">起</span></span></div>
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
function toggleFavHotel(hid, el) {
    fetch('/fav?type=HOTEL&id=' + hid)
    .then(function(r){ return r.json(); })
    .then(function(d){
        if (d.ok) {
            var icon = el.querySelector('.fa-heart');
            var cnt = el.querySelector('.fav-cnt');
            icon.style.color = d.faved ? '#e74c3c' : '#ccc';
            cnt.textContent = d.count;
        } else if (d.msg) { alert(d.msg); }
    });
}
(function(){
    fetch('/fav?type=HOTEL&list=1')
    .then(function(r){ return r.json(); })
    .then(function(ids){
        document.querySelectorAll('[data-fav-id]').forEach(function(el){
            var hid = el.getAttribute('data-fav-id');
            if (ids.indexOf(Number(hid)) >= 0) {
                el.querySelector('.fa-heart').style.color = '#e74c3c';
            }
        });
    });
})();
</script>
</body>
</html>