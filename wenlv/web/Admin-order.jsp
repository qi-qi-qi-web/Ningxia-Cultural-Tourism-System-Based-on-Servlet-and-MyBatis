<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.OrderMapper" %>
<%@ page import="com.niit.pojo.OrderMain" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    if (request.getAttribute("orderList") == null) {
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("orderList", s.getMapper(OrderMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
    }
%>

<%@ include file="Admin-Head_And_Side.jsp" %>

<div class="admin-card">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>订单管理</h3>
        <span style="color:#999;font-size:13px;">共 <strong>${orderList.size()}</strong> 笔订单</span>
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
            <th>订单号</th><th>用户</th><th>金额</th><th>取货</th><th>状态</th><th>下单时间</th><th>操作</th>
        </tr></thead>
        <tbody>
            <c:forEach items="${orderList}" var="o">
            <tr>
                <td><small>${o.orderNo}</small></td>
                <td>${o.userName}</td>
                <td>¥${o.payAmount}</td>
                <td>
                    <c:choose>
                        <c:when test="${o.pickupMethod == 'PICKUP'}"><span class="badge bg-info">自取</span></c:when>
                        <c:otherwise><span class="badge bg-primary">快递</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${o.status == 'PENDING'}"><span class="badge bg-warning">待支付</span></c:when>
                        <c:when test="${o.status == 'PAID'}"><span class="badge bg-info">已支付</span></c:when>
                        <c:when test="${o.status == 'SHIPPED'}"><span class="badge bg-primary">已发货</span></c:when>
                        <c:when test="${o.status == 'COMPLETED'}"><span class="badge bg-success">已完成</span></c:when>
                        <c:when test="${o.status == 'CANCELLED'}"><span class="badge bg-danger">已取消</span></c:when>
                        <c:when test="${o.status == 'REFUNDED'}"><span class="badge bg-secondary">已退款</span></c:when>
                    </c:choose>
                </td>
                <td><fmt:formatDate value="${o.createdAt}" pattern="MM-dd HH:mm"/></td>
                <td style="white-space:nowrap;">
                    <c:if test="${o.status == 'PAID'}">
                        <a href="${pageContext.request.contextPath}/admin/order?action=ship&id=${o.id}" class="btn btn-primary btn-sm">发货</a>
                    </c:if>
                    <c:if test="${o.status == 'SHIPPED'}">
                        <a href="${pageContext.request.contextPath}/admin/order?action=complete&id=${o.id}" class="btn btn-success btn-sm">完成</a>
                    </c:if>
                    <c:if test="${o.status == 'PENDING'}">
                        <a href="${pageContext.request.contextPath}/admin/order?action=cancel&id=${o.id}" class="btn btn-danger btn-sm" onclick="return confirm('确认取消？')">取消</a>
                    </c:if>
                </td>
            </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
</div></div></div></body></html>
