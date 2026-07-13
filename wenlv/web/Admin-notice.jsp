<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.OfficialNoticeMapper" %>
<%@ page import="com.niit.pojo.OfficialNotice" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    if (request.getAttribute("noticeList") == null) {
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("noticeList", s.getMapper(OfficialNoticeMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
    }
    java.util.List pageList = (java.util.List) request.getAttribute("noticeList");
    int pn = 1, ps = 5;
    try { pn = Integer.parseInt(request.getParameter("page")); } catch(Exception e){}
    int tt = pageList != null ? pageList.size() : 0;
    int tp = (int)Math.ceil((double)tt/ps);
    if(pn<1)pn=1; if(pn>tp&&tp>0)pn=tp;
    request.setAttribute("pn", pn); request.setAttribute("tp", tp);
    request.setAttribute("tt", tt); request.setAttribute("st", (pn-1)*ps);
    request.setAttribute("ed", Math.min((pn-1)*ps+ps, tt));
%>

<%@ include file="Admin-Head_And_Side.jsp" %>

<div class="admin-card">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>通知公告管理</h3>
        <button class="btn btn-primary btn-sm" onclick="openNoticeEdit()">+ 新增公告</button>
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
            <th>ID</th><th>标题</th><th>关联景区</th><th>置顶</th><th>状态</th><th>发布时间</th><th>操作</th>
        </tr></thead>
        <tbody>
            <c:if test="${ed > 0}"><c:forEach items="${noticeList}" var="n" begin="${st}" end="${ed - 1}">
            <tr>
                <td>${n.id}</td>
                <td>${n.title}</td>
                <td>${empty n.scenicSpotId ? '平台级' : n.scenicSpotId}</td>
                <td>
                    <c:choose>
                        <c:when test="${n.isTop == 1}"><span class="badge bg-danger">置顶</span></c:when>
                        <c:otherwise><span class="badge bg-secondary">普通</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${n.isPublished == 1}"><span class="badge bg-success">已发布</span></c:when>
                        <c:otherwise><span class="badge bg-warning">草稿</span></c:otherwise>
                    </c:choose>
                </td>
                <td><fmt:formatDate value="${n.publishedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td style="white-space:nowrap;">
                    <button class="btn btn-info btn-sm" onclick="openNoticeEdit(${n.id})">编辑</button>
                    <c:choose>
                        <c:when test="${n.isTop == 1}">
                            <a href="${pageContext.request.contextPath}/admin/notice?action=untop&id=${n.id}" class="btn btn-secondary btn-sm">取消置顶</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/admin/notice?action=top&id=${n.id}" class="btn btn-danger btn-sm">置顶</a>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${n.isPublished == 1}">
                            <a href="${pageContext.request.contextPath}/admin/notice?action=unpublish&id=${n.id}" class="btn btn-warning btn-sm">下架</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/admin/notice?action=publish&id=${n.id}" class="btn btn-success btn-sm">发布</a>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/admin/notice?action=delete&id=${n.id}" class="btn btn-danger btn-sm" onclick="return confirm('确认删除？')">删除</a>
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

<%-- 新增/编辑弹窗 --%>
<div id="notice-modal" style="display:none;position:fixed;z-index:2000;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,0.5);">
    <div style="background:#fff;border-radius:8px;max-width:700px;margin:5% auto;padding:25px;max-height:80vh;overflow-y:auto;">
        <h4 id="notice-modal-title">新增公告</h4>
        <form method="post" action="${pageContext.request.contextPath}/admin/notice">
            <input type="hidden" name="action" value="save">
            <input type="hidden" name="id" id="notice-id">
            <div class="mb-2"><label>标题</label><input class="form-control" name="title" id="notice-title" required></div>
            <div class="mb-2"><label>正文</label><textarea class="form-control" name="content" id="notice-content" rows="6" required></textarea></div>
            <div class="mb-2"><label>封面图URL</label><input class="form-control" name="coverImage" id="notice-cover"></div>
            <div class="row mb-2">
                <div class="col-6"><label>关联景区ID</label><input class="form-control" name="scenicSpotId" id="notice-spot" placeholder="留空=平台级公告"></div>
                <div class="col-3"><label>置顶</label>
                    <select class="form-control" name="isTop" id="notice-top">
                        <option value="0">否</option><option value="1">是</option>
                    </select>
                </div>
                <div class="col-3"><label>发布状态</label>
                    <select class="form-control" name="isPublished" id="notice-publish">
                        <option value="0">草稿</option><option value="1">发布</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-secondary" onclick="document.getElementById('notice-modal').style.display='none'">取消</button>
        </form>
    </div>
</div>

<script>
function openNoticeEdit(id) {
    document.getElementById('notice-modal').style.display = 'block';
    if (id) {
        document.getElementById('notice-modal-title').textContent = '编辑公告';
        fetch('${pageContext.request.contextPath}/admin/notice?action=edit&id=' + id)
        .then(function(r){ return r.json(); })
        .then(function(d){
            document.getElementById('notice-id').value = d.id;
            document.getElementById('notice-title').value = d.title;
            document.getElementById('notice-content').value = d.content;
            document.getElementById('notice-cover').value = d.coverImage || '';
            document.getElementById('notice-spot').value = d.scenicSpotId || '';
            document.getElementById('notice-top').value = d.isTop;
            document.getElementById('notice-publish').value = d.isPublished;
        })
        .catch(function(){ alert('加载失败'); });
    } else {
        document.getElementById('notice-modal-title').textContent = '新增公告';
        ['notice-id','notice-title','notice-content','notice-cover','notice-spot'].forEach(function(f){
            document.getElementById(f).value = '';
        });
        document.getElementById('notice-top').value = '0';
        document.getElementById('notice-publish').value = '1';
    }
}
</script>

</div></div></div></body></html>
