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
            <c:forEach items="${guideList}" var="g">
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
            </c:forEach>
        </tbody>
    </table>
</div>
</div></div></div></body></html>
