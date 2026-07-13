<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.TravelGuideMapper" %>
<%@ page import="com.niit.pojo.TravelGuide" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    if (request.getAttribute("guideList") == null) {
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("guideList", s.getMapper(TravelGuideMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
    }
    Object obj = request.getAttribute("guideList");
    int pn = 1, ps = 5;
    try { pn = Integer.parseInt(request.getParameter("page")); } catch(Exception e){}
    int tt = obj instanceof java.util.List ? ((java.util.List)obj).size() : 0;
    int tp = (int)Math.ceil((double)tt/ps);
    if(pn<1)pn=1; if(pn>tp&&tp>0)pn=tp;
    request.setAttribute("pn", pn); request.setAttribute("tp", tp);
    request.setAttribute("tt", tt); request.setAttribute("st", (pn-1)*ps);
    request.setAttribute("ed", Math.min((pn-1)*ps+ps, tt));
%>

<%@ include file="Admin-Head_And_Side.jsp" %>

<div class="admin-card">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>攻略管理</h3>
        <span style="color:#999;font-size:13px;">共 <strong>${guideList.size()}</strong> 篇攻略</span>
    </div>

    <c:if test="${not empty sessionScope.msg}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            ${sessionScope.msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="msg" scope="session"/>
    </c:if>

    <table class="table table-striped table-hover">
        <thead><tr>
            <th>ID</th><th>标题</th><th>作者</th><th>点赞</th><th>浏览</th><th>状态</th><th>发布时间</th><th>操作</th>
        </tr></thead>
        <tbody>
            <c:if test="${ed > 0}"><c:forEach items="${guideList}" var="g" begin="${st}" end="${ed - 1}">
            <tr>
                <td>${g.id}</td>
                <td>${g.title}</td>
                <td>${g.userName}</td>
                <td>${g.likeCount}</td>
                <td>${g.viewCount}</td>
                <td>
                    <c:choose>
                        <c:when test="${g.status == 'PUBLISHED'}"><span class="badge bg-success">已发布</span></c:when>
                        <c:when test="${g.status == 'DRAFT'}"><span class="badge bg-warning">草稿</span></c:when>
                        <c:when test="${g.status == 'HIDDEN'}"><span class="badge bg-danger">已隐藏</span></c:when>
                    </c:choose>
                </td>
                <td><fmt:formatDate value="${g.createdAt}" pattern="yyyy-MM-dd"/></td>
                <td style="white-space:nowrap;">
                    <c:if test="${g.status != 'PUBLISHED'}">
                        <a href="${pageContext.request.contextPath}/admin/strategy?action=publish&id=${g.id}" class="btn btn-success btn-sm">发布</a>
                    </c:if>
                    <c:if test="${g.status == 'PUBLISHED'}">
                        <a href="${pageContext.request.contextPath}/admin/strategy?action=hide&id=${g.id}" class="btn btn-warning btn-sm">隐藏</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/admin/strategy?action=delete&id=${g.id}" class="btn btn-danger btn-sm" onclick="return confirm('确认删除？')">删除</a>
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

</div>
</div></div></div></body></html>
