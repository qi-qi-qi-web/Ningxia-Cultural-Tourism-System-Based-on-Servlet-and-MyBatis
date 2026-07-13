<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.PlatformLogMapper" %>
<%@ page import="com.niit.pojo.PlatformLog" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    if (request.getAttribute("logList") == null) {
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("logList", s.getMapper(PlatformLogMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
    }
    Object obj = request.getAttribute("logList");
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
    <h3 class="mb-3">平台日志</h3>

    <table class="table table-striped table-hover">
        <thead><tr>
            <th>ID</th><th>用户</th><th>操作类型</th><th>关联目标</th><th>IP</th><th>时间</th><th>操作</th>
        </tr></thead>
        <tbody>
            <c:if test="${ed > 0}"><c:forEach items="${logList}" var="log" begin="${st}" end="${ed - 1}">
            <tr>
                <td>${log.id}</td>
                <td>${log.userName}</td>
                <td>
                    <c:choose>
                        <c:when test="${log.logType == 'REGISTER'}"><span class="badge bg-primary">注册</span></c:when>
                        <c:when test="${log.logType == 'LOGIN'}"><span class="badge bg-info">登录</span></c:when>
                        <c:when test="${log.logType == 'LOGOUT'}"><span class="badge bg-secondary">登出</span></c:when>
                        <c:when test="${log.logType == 'POST_COMMENT'}"><span class="badge bg-success">发评论</span></c:when>
                        <c:when test="${log.logType == 'POST_GUIDE'}"><span class="badge bg-success">发攻略</span></c:when>
                        <c:when test="${log.logType == 'PLACE_ORDER'}"><span class="badge bg-warning">下单</span></c:when>
                        <c:when test="${log.logType == 'CANCEL_ORDER'}"><span class="badge bg-danger">取消订单</span></c:when>
                        <c:when test="${log.logType == 'CONFIRM_RECEIPT'}"><span class="badge bg-success">确认收货</span></c:when>
                        <c:otherwise><span class="badge bg-dark">${log.logType}</span></c:otherwise>
                    </c:choose>
                </td>
                <td>${empty log.targetName ? log.targetType : log.targetName}</td>
                <td>${empty log.ipAddress ? '-' : log.ipAddress}</td>
                <td><fmt:formatDate value="${log.createdAt}" pattern="MM-dd HH:mm:ss"/></td>
                <td>
                    <button class="btn btn-info btn-sm" onclick="showLogDetail(${log.id})">详情</button>
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

<%-- 详情弹窗 --%>
<div id="log-detail-modal" style="display:none;position:fixed;z-index:2000;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,0.5);">
    <div style="background:#fff;border-radius:8px;max-width:600px;margin:8% auto;padding:25px;max-height:80vh;overflow-y:auto;">
        <div class="d-flex justify-content-between mb-3">
            <h4>日志详情</h4>
            <button type="button" class="btn-close" onclick="document.getElementById('log-detail-modal').style.display='none'"></button>
        </div>
        <table class="table table-bordered">
            <tr><td width="100"><strong>日志ID</strong></td><td id="det-id"></td></tr>
            <tr><td><strong>用户</strong></td><td id="det-user"></td></tr>
            <tr><td><strong>操作类型</strong></td><td id="det-type"></td></tr>
            <tr><td><strong>关联目标</strong></td><td id="det-target"></td></tr>
            <tr><td><strong>IP地址</strong></td><td id="det-ip"></td></tr>
            <tr><td><strong>User-Agent</strong></td><td id="det-ua" style="word-break:break-all;font-size:12px;"></td></tr>
            <tr><td><strong>详细信息</strong></td><td id="det-detail" style="word-break:break-all;"></td></tr>
            <tr><td><strong>时间</strong></td><td id="det-time"></td></tr>
        </table>
    </div>
</div>

<script>
function showLogDetail(id) {
    fetch('${pageContext.request.contextPath}/admin/log?id=' + id)
    .then(function(r){ return r.json(); })
    .then(function(d){
        document.getElementById('det-id').textContent = d.id;
        document.getElementById('det-user').textContent = d.userName;
        document.getElementById('det-type').textContent = d.logType;
        document.getElementById('det-target').textContent = (d.targetType||'') + ' / ' + (d.targetName||'');
        document.getElementById('det-ip').textContent = d.ipAddress || '-';
        document.getElementById('det-ua').textContent = d.userAgent || '-';
        document.getElementById('det-detail').textContent = d.detail || '-';
        document.getElementById('det-time').textContent = d.createdAt;
        document.getElementById('log-detail-modal').style.display = 'block';
    });
}
</script>

</div></div></div></body></html>
