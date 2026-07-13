<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.NewsDynamicMapper" %>
<%@ page import="com.niit.pojo.NewsDynamic" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    if (request.getAttribute("newsList") == null) {
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("newsList", s.getMapper(NewsDynamicMapper.class).findAll());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
    }
    java.util.List pageList = (java.util.List) request.getAttribute("newsList");
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
        <h3>新闻动态管理</h3>
        <button class="btn btn-primary btn-sm" onclick="openNewsEdit()">+ 新增新闻</button>
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
            <th>ID</th><th>标题</th><th>来源</th><th>作者</th><th>状态</th><th>发布时间</th><th>操作</th>
        </tr></thead>
        <tbody>
            <c:if test="${ed > 0}"><c:forEach items="${newsList}" var="n" begin="${st}" end="${ed - 1}">
            <tr>
                <td>${n.id}</td>
                <td>${n.title}</td>
                <td>${empty n.source ? '-' : n.source}</td>
                <td>${empty n.authorName ? '-' : n.authorName}</td>
                <td>
                    <c:choose>
                        <c:when test="${n.isPublished == 1}"><span class="badge bg-success">已发布</span></c:when>
                        <c:otherwise><span class="badge bg-warning">草稿</span></c:otherwise>
                    </c:choose>
                </td>
                <td><fmt:formatDate value="${n.publishedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td style="white-space:nowrap;">
                    <button class="btn btn-info btn-sm" onclick="openNewsEdit(${n.id})">编辑</button>
                    <c:choose>
                        <c:when test="${n.isPublished == 1}">
                            <a href="${pageContext.request.contextPath}/admin/news?action=unpublish&id=${n.id}" class="btn btn-warning btn-sm">下架</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/admin/news?action=publish&id=${n.id}" class="btn btn-success btn-sm">发布</a>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/admin/news?action=delete&id=${n.id}" class="btn btn-danger btn-sm" onclick="return confirm('确认删除？')">删除</a>
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
<div id="news-modal" style="display:none;position:fixed;z-index:2000;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,0.5);">
    <div style="background:#fff;border-radius:8px;max-width:700px;margin:5% auto;padding:25px;max-height:80vh;overflow-y:auto;">
        <h4 id="news-modal-title">新增新闻</h4>
        <form method="post" action="${pageContext.request.contextPath}/admin/news">
            <input type="hidden" name="action" value="save">
            <input type="hidden" name="id" id="news-id">
            <div class="mb-2"><label>标题</label><input class="form-control" name="title" id="news-title" required></div>
            <div class="mb-2"><label>正文</label><textarea class="form-control" name="content" id="news-content" rows="6" required></textarea></div>
            <div class="mb-2"><label>封面图URL</label><input class="form-control" name="coverImage" id="news-cover"></div>
            <div class="row mb-2">
                <div class="col-6"><label>来源</label><input class="form-control" name="source" id="news-source"></div>
                <div class="col-6"><label>作者</label><input class="form-control" name="authorName" id="news-author"></div>
            </div>
            <div class="mb-3"><label>发布状态</label>
                <select class="form-control" name="isPublished" id="news-publish">
                    <option value="0">草稿</option><option value="1">发布</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-secondary" onclick="document.getElementById('news-modal').style.display='none'">取消</button>
        </form>
    </div>
</div>

<script>
function openNewsEdit(id) {
    document.getElementById('news-modal').style.display = 'block';
    if (id) {
        document.getElementById('news-modal-title').textContent = '编辑新闻';
        fetch('${pageContext.request.contextPath}/admin/news?action=edit&id=' + id)
        .then(function(r){ return r.json(); })
        .then(function(d){
            document.getElementById('news-id').value = d.id;
            document.getElementById('news-title').value = d.title;
            document.getElementById('news-content').value = d.content;
            document.getElementById('news-cover').value = d.coverImage || '';
            document.getElementById('news-source').value = d.source || '';
            document.getElementById('news-author').value = d.authorName || '';
            document.getElementById('news-publish').value = d.isPublished;
        })
        .catch(function(){ alert('加载失败'); });
    } else {
        document.getElementById('news-modal-title').textContent = '新增新闻';
        ['news-id','news-title','news-content','news-cover','news-source','news-author'].forEach(function(f){
            document.getElementById(f).value = '';
        });
        document.getElementById('news-publish').value = '1';
    }
}
</script>

</div></div></div></body></html>
