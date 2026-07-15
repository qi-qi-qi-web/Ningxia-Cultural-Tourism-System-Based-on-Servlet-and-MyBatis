<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.NewsDynamicMapper" %>
<%@ page import="com.niit.pojo.NewsDynamic" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    List<NewsDynamic> allNews = null;
    try (SqlSession s = DBUtil.getSession()) {
        allNews = s.getMapper(NewsDynamicMapper.class).findPublished();
    } catch (Exception e) {}

    int pageNum = 1;
    int pageSize = 8;
    try { pageNum = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
    int total = allNews != null ? allNews.size() : 0;
    int totalPages = (int) Math.ceil((double) total / pageSize);
    if (pageNum < 1) pageNum = 1;
    if (pageNum > totalPages) pageNum = totalPages;
    int start = (pageNum - 1) * pageSize;
    int end = Math.min(start + pageSize, total);
    request.setAttribute("allNews", allNews);
    request.setAttribute("pageNum", pageNum);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("totalCount", total);
    request.setAttribute("start", start);
    request.setAttribute("end", end);

%>

<%@include file="Head.jsp"%>

<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);">
    <div class="container">
        <h4 class="breadcrumbs-custom-title">新闻动态</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="Information.jsp">资讯</a></li>
            <li class="active">新闻动态</li>
        </ul>
    </div>
</section>

<section class="section section-lg bg-default">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-8">
                <h2 class="text-center mb-6">新闻动态</h2>
                <c:choose>
                    <c:when test="${totalCount == 0}">
                        <p class="text-center" style="color:#999;padding:40px 0;">暂无新闻动态</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${allNews}" var="n" begin="${start}" end="${end - 1}" varStatus="s">
                            <div class="news-item" onclick="location.href='news-detail.jsp?id=${n.id}'">
                                <span class="news-number">${s.index + 1}</span>
                                <span class="news-title">${n.title}</span>
                                <span class="news-date"><fmt:formatDate value="${n.publishedAt}" pattern="yyyy-MM-dd"/></span>
                            </div>
                        </c:forEach>

                        <%-- 分页导航 --%>
                        <c:if test="${totalPages > 1}">
                            <div style="display:flex;justify-content:center;gap:8px;margin-top:30px;flex-wrap:wrap;">
                                <c:if test="${pageNum > 1}">
                                    <a href="?page=1" style="padding:8px 14px;border:1px solid #ddd;border-radius:4px;color:#333;text-decoration:none;">首页</a>
                                    <a href="?page=${pageNum - 1}" style="padding:8px 14px;border:1px solid #ddd;border-radius:4px;color:#333;text-decoration:none;">上一页</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == pageNum}">
                                            <span style="padding:8px 14px;background:#00a8a8;color:#fff;border-radius:4px;font-weight:bold;">${p}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="?page=${p}" style="padding:8px 14px;border:1px solid #ddd;border-radius:4px;color:#333;text-decoration:none;">${p}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${pageNum < totalPages}">
                                    <a href="?page=${pageNum + 1}" style="padding:8px 14px;border:1px solid #ddd;border-radius:4px;color:#333;text-decoration:none;">下一页</a>
                                    <a href="?page=${totalPages}" style="padding:8px 14px;border:1px solid #ddd;border-radius:4px;color:#333;text-decoration:none;">末页</a>
                                </c:if>
                                <span style="padding:8px;color:#999;font-size:13px;">共 ${totalPages} 页 / ${totalCount} 条</span>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</section>

<style>
    .news-item { display:flex;justify-content:space-between;align-items:center;padding:16px 0;border-bottom:1px solid #f0f0f0;cursor:pointer;transition:background-color 0.2s; }
    .news-item:hover { background-color:#fafafa; }
    .news-item:last-child { border-bottom:none; }
    .news-number { width:28px;height:28px;background:#00a8a8;color:white;display:inline-flex;align-items:center;justify-content:center;border-radius:50%;font-size:14px;margin-right:16px;flex-shrink:0; }
    .news-title { flex-grow:1;font-size:16px;color:#333;white-space:nowrap;overflow:hidden;text-overflow:ellipsis; }
    .news-date { font-size:14px;color:#999;margin-left:16px;flex-shrink:0; }
    a:hover { color:#00a8a8 !important; }
</style>

<%@include file="Footer.jsp"%>
</div>
<script src="js/core.min.js"></script><script src="js/script.js"></script>
</body></html>
