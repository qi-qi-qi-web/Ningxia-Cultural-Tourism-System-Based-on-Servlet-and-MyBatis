<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.CommentMapper" %>
<%@ page import="com.niit.pojo.Comment" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.*" %>

<%
    if (request.getAttribute("commentList") == null) {
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("commentList", s.getMapper(CommentMapper.class).findAll());
        } catch (Exception e) {}
    }
    Object obj = request.getAttribute("commentList");
    int pn = 1, ps = 10;
    try { pn = Integer.parseInt(request.getParameter("page")); } catch(Exception e){}
    int tt = obj instanceof List ? ((List)obj).size() : 0;
    int tp = (int)Math.ceil((double)tt/ps);
    if(pn<1)pn=1; if(pn>tp&&tp>0)pn=tp;
    request.setAttribute("pn", pn); request.setAttribute("tp", tp);
    request.setAttribute("tt", tt); request.setAttribute("st", (pn-1)*ps);
    request.setAttribute("ed", Math.min((pn-1)*ps+ps, tt));
    Map<String,String> typeNames = new LinkedHashMap<>();
    typeNames.put("SCENIC","景区"); typeNames.put("HOTEL","酒店");
    typeNames.put("GUIDE","攻略"); typeNames.put("SPECIALTY","特产");
    request.setAttribute("typeNames", typeNames);
%>

<%@ include file="Admin-Head_And_Side.jsp" %>

<div class="admin-card">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>评论管理</h3>
        <span style="color:#999;font-size:13px;">共 <strong>${tt}</strong> 条评论</span>
    </div>

    <div class="mb-3" style="display:flex;gap:8px;flex-wrap:wrap;">
        <button class="filter-btn active" onclick="filterComments('ALL', this)" style="padding:6px 16px;border-radius:20px;border:1px solid #00a8a8;background:#00a8a8;color:#fff;cursor:pointer;font-size:13px;">全部</button>
        <button class="filter-btn" onclick="filterComments('SCENIC', this)" style="padding:6px 16px;border-radius:20px;border:1px solid #ddd;background:#fff;color:#666;cursor:pointer;font-size:13px;">景区</button>
        <button class="filter-btn" onclick="filterComments('HOTEL', this)" style="padding:6px 16px;border-radius:20px;border:1px solid #ddd;background:#fff;color:#666;cursor:pointer;font-size:13px;">酒店</button>
        <button class="filter-btn" onclick="filterComments('GUIDE', this)" style="padding:6px 16px;border-radius:20px;border:1px solid #ddd;background:#fff;color:#666;cursor:pointer;font-size:13px;">攻略</button>
        <button class="filter-btn" onclick="filterComments('SPECIALTY', this)" style="padding:6px 16px;border-radius:20px;border:1px solid #ddd;background:#fff;color:#666;cursor:pointer;font-size:13px;">特产</button>
    </div>

    <c:if test="${not empty sessionScope.msg}">
        <div class="alert alert-info"><c:out value="${sessionScope.msg}"/></div>
        <c:remove var="msg" scope="session"/>
    </c:if>

    <table class="table table-striped table-hover">
        <thead><tr>
            <th>ID</th><th>用户</th><th>类型</th><th>评论对象</th><th>内容</th><th>状态</th><th>时间</th><th>操作</th>
        </tr></thead>
        <tbody>
            <c:if test="${ed > 0}"><c:forEach items="${commentList}" var="c" begin="${st}" end="${ed - 1}">
            <tr class="comment-row" data-type="${c.targetType}">
                <td>${c.id}</td>
                <td>${empty c.userName ? '匿名' : c.userName}</td>
                <td>${typeNames[c.targetType]}</td>
                <td>
                    <c:set var="detailPage" value="Specialty-detail.jsp"/>
                    <c:if test="${c.targetType eq 'SCENIC'}"><c:set var="detailPage" value="ScenicService-detail.jsp"/></c:if>
                    <c:if test="${c.targetType eq 'HOTEL'}"><c:set var="detailPage" value="Hotel-detail.jsp"/></c:if>
                    <c:if test="${c.targetType eq 'GUIDE'}"><c:set var="detailPage" value="TravelGuide-detail.jsp"/></c:if>
                    <c:choose>
                        <c:when test="${not empty c.targetName}">
                            <a href="${pageContext.request.contextPath}/${detailPage}?id=${c.targetId}" target="_blank" style="color:#00a8a8;">${c.targetName}</a>
                        </c:when>
                        <c:otherwise><span style="color:#999;">--</span></c:otherwise>
                    </c:choose>
                </td>
                <td>${fn:substring(c.content, 0, 30)}${fn:length(c.content) > 30 ? '...' : ''}</td>
                <td>
                    <c:choose>
                        <c:when test="${c.status == 1}"><span class="badge bg-success">显示</span></c:when>
                        <c:otherwise><span class="badge bg-danger">已屏蔽</span></c:otherwise>
                    </c:choose>
                </td>
                <td style="font-size:12px;">${c.createdAt}</td>
                <td style="white-space:nowrap;">
                    <c:choose>
                        <c:when test="${c.status == 1}">
                            <a href="${pageContext.request.contextPath}/admin/comment?action=hide&id=${c.id}" class="btn btn-warning btn-sm">屏蔽</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/admin/comment?action=show&id=${c.id}" class="btn btn-success btn-sm">显示</a>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/admin/comment?action=delete&id=${c.id}" class="btn btn-danger btn-sm" onclick="return confirm('确认删除？')">删除</a>
                </td>
            </tr>
            </c:forEach></c:if>
        </tbody>
    </table>

    <c:if test="${tp > 1}">
    <div class="page-nav">
        <c:if test="${pn > 1}"><a href="?page=1">首页</a><a href="?page=${pn-1}">上一页</a></c:if>
        <c:forEach begin="1" end="${tp}" var="p">
            <c:choose><c:when test="${p==pn}"><span class="current">${p}</span></c:when><c:otherwise><a href="?page=${p}">${p}</a></c:otherwise></c:choose>
        </c:forEach>
        <c:if test="${pn < tp}"><a href="?page=${pn+1}">下一页</a><a href="?page=${tp}">末页</a></c:if>
        <span class="info">共 ${tp} 页 / ${tt} 条</span>
    </div>
    </c:if>
</div></div></div>
<script>
function filterComments(type, btn) {
    document.querySelectorAll('.filter-btn').forEach(function(b) {
        b.style.background = '#fff';
        b.style.color = '#666';
        b.style.borderColor = '#ddd';
        b.classList.remove('active');
    });
    btn.style.background = '#00a8a8';
    btn.style.color = '#fff';
    btn.style.borderColor = '#00a8a8';
    btn.classList.add('active');

    document.querySelectorAll('.comment-row').forEach(function(row) {
        if (type === 'ALL' || row.getAttribute('data-type') === type) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}
</script>
</body></html>
