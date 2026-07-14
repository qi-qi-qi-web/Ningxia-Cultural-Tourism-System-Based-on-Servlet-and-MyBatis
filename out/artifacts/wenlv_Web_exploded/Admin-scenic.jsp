<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.niit.utils.DBUtil,com.niit.mapper.ScenicSpotMapper,com.niit.pojo.ScenicSpot,org.apache.ibatis.session.SqlSession,java.util.List" %>

<%
    if (request.getAttribute("scenicList") == null) {
        try (SqlSession s = DBUtil.getSession()) { request.setAttribute("scenicList", s.getMapper(ScenicSpotMapper.class).findAll()); }
        catch (Exception e) { request.setAttribute("error", "加载失败：" + e.getMessage()); }
    }
    Object obj = request.getAttribute("scenicList");
    int pn = 1, ps = 5;
    try { pn = Integer.parseInt(request.getParameter("page")); } catch(Exception e){}
    int tt = obj instanceof List ? ((List)obj).size() : 0;
    int tp = (int)Math.ceil((double)tt/ps);
    if(pn<1)pn=1; if(pn>tp&&tp>0)pn=tp;
    request.setAttribute("pn", pn); request.setAttribute("tp", tp);
    request.setAttribute("tt", tt); request.setAttribute("st", (pn-1)*ps);
    request.setAttribute("ed", Math.min((pn-1)*ps+ps, tt));
%>
<%@ include file="Admin-Head_And_Side.jsp" %>

<div class="admin-card">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>景区管理</h3>
        <button class="btn btn-primary btn-sm" onclick="openEdit()">+ 新增景区</button>
    </div>
    <c:if test="${not empty sessionScope.msg}"><div class="alert alert-info alert-dismissible fade show" role="alert">${sessionScope.msg}<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div><c:remove var="msg" scope="session"/></c:if>

    <table class="table table-striped table-hover">
        <thead><tr><th>ID</th><th>名称</th><th>城市</th><th>票价</th><th>浏览量</th><th>状态</th><th>操作</th></tr></thead>
        <tbody>
            <c:if test="${ed > 0}"><c:forEach items="${scenicList}" var="s" begin="${st}" end="${ed - 1}">
            <tr>
                <td>${s.id}</td><td>${s.name}</td><td>${empty s.city?'-':s.city}</td><td>¥${empty s.minPrice?'-':s.minPrice}</td><td>${s.viewCount}</td>
                <td>
                    <c:choose><c:when test="${s.status=='OPEN'}"><span class="badge bg-success">开放</span></c:when><c:when test="${s.status=='CLOSED'}"><span class="badge bg-danger">关闭</span></c:when><c:otherwise><span class="badge bg-warning">维护</span></c:otherwise></c:choose>
                </td>
                <td style="white-space:nowrap;">
                    <button class="btn btn-info btn-sm" onclick="openEdit(${s.id})">编辑</button>
                    <c:choose><c:when test="${s.status=='OPEN'}"><a href="${pageContext.request.contextPath}/admin/scenic?action=close&id=${s.id}" class="btn btn-warning btn-sm">关闭</a></c:when><c:otherwise><a href="${pageContext.request.contextPath}/admin/scenic?action=open&id=${s.id}" class="btn btn-success btn-sm">开放</a></c:otherwise></c:choose>
                    <a href="${pageContext.request.contextPath}/admin/scenic?action=delete&id=${s.id}" class="btn btn-danger btn-sm" onclick="return confirm('确认删除？')">删除</a>
                </td>
            </tr>
            </c:forEach></c:if>
        </tbody>
    </table>

    <c:if test="${tp > 1}"><div class="page-nav">
        <c:if test="${pn > 1}"><a href="?page=1">首页</a><a href="?page=${pn-1}">上一页</a></c:if>
        <c:forEach begin="1" end="${tp}" var="p"><c:choose><c:when test="${p==pn}"><span class="current">${p}</span></c:when><c:otherwise><a href="?page=${p}">${p}</a></c:otherwise></c:choose></c:forEach>
        <c:if test="${pn < tp}"><a href="?page=${pn+1}">下一页</a><a href="?page=${tp}">末页</a></c:if>
        <span class="info">共 ${tp} 页 / ${tt} 条</span>
    </div></c:if>
</div>

<div id="edit-modal" style="display:none;position:fixed;z-index:2000;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,0.5);">
    <div style="background:#fff;border-radius:8px;max-width:650px;margin:5% auto;padding:25px;max-height:80vh;overflow-y:auto;">
        <h4 id="modal-title">新增景区</h4>
        <form method="post" action="${pageContext.request.contextPath}/admin/scenic" enctype="multipart/form-data">
            <input type="hidden" name="action" value="save"><input type="hidden" name="id" id="s-id">
            <div class="mb-2"><label>名称</label><input class="form-control" name="name" id="s-name" required></div>
            <div class="mb-2"><label>描述</label><textarea class="form-control" name="description" id="s-desc" rows="3"></textarea></div>
            <div class="row mb-2"><div class="col-6"><label>城市</label><input class="form-control" name="city" id="s-city"></div><div class="col-6"><label>地址</label><input class="form-control" name="address" id="s-addr"></div></div>
            <div class="row mb-2"><div class="col-4"><label>票价</label><input class="form-control" name="minPrice" id="s-price" step="0.01"></div><div class="col-4"><label>开放时间</label><input class="form-control" name="openingHours" id="s-hours" placeholder="08:00-18:00"></div><div class="col-4"><label>状态</label><select class="form-control" name="status" id="s-status"><option value="OPEN">开放</option><option value="CLOSED">关闭</option><option value="MAINTENANCE">维护中</option></select></div></div>
            <div class="mb-2"><label>联系电话</label><input class="form-control" name="contactPhone" id="s-phone"></div>
            <div class="mb-2"><label>封面图（可上传文件或填写URL）</label><input class="form-control" type="file" name="coverImageFile" id="s-cover-file" accept="image/*" style="margin-bottom:5px;"></div>
            <div class="mb-2"><input class="form-control" name="coverImage" id="s-cover" placeholder="或填写图片URL"></div>
            <div class="mb-2"><label>图片画廊（可多选上传文件或填写URL数组）</label><input class="form-control" type="file" name="imagesFiles" id="s-imgs-file" multiple accept="image/*" style="margin-bottom:5px;"><div id="s-imgs-file-list" style="font-size:12px;color:#888;margin:3px 0;"></div></div>
            <div class="mb-3"><textarea class="form-control" name="images" id="s-imgs" placeholder='或手动填写图片URL数组，JSON格式：["url1","url2"]' rows="2"></textarea></div>
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-secondary" onclick="document.getElementById('edit-modal').style.display='none'">取消</button>
        </form>
    </div>
</div>

<script>
// 文件选择预览
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('s-imgs-file').addEventListener('change', function() {
        var list = document.getElementById('s-imgs-file-list');
        var html = '';
        for (var i = 0; i < this.files.length; i++) {
            html += '<span style="display:inline-block;margin:2px 6px 2px 0;background:#f0f0f0;padding:1px 6px;border-radius:3px;">' + escHtml(this.files[i].name) + '</span>';
        }
        list.innerHTML = html || '';
	});
});
function escHtml(s) {
    if (!s) return '';
    return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
function openEdit(id) {
    document.getElementById('edit-modal').style.display = 'block';
    if (id) {
        document.getElementById('modal-title').textContent = '编辑景区';
        fetch('${pageContext.request.contextPath}/admin/scenic?action=edit&id='+id).then(function(r){return r.json();}).then(function(d){
            document.getElementById('s-id').value=d.id; document.getElementById('s-name').value=d.name;
            document.getElementById('s-desc').value=d.description||''; document.getElementById('s-city').value=d.city||'';
            document.getElementById('s-addr').value=d.address||''; document.getElementById('s-hours').value=d.openingHours||'';
            document.getElementById('s-price').value=d.minPrice||''; document.getElementById('s-phone').value=d.contactPhone||'';
            document.getElementById('s-cover').value=d.coverImage||''; document.getElementById('s-imgs').value=d.images||'';
            document.getElementById('s-status').value=d.status;
        }).catch(function(){alert('加载失败');});
    } else {
        document.getElementById('modal-title').textContent='新增景区';
        ['s-id','s-name','s-desc','s-city','s-addr','s-hours','s-price','s-phone','s-cover','s-imgs'].forEach(function(f){document.getElementById(f).value='';});
        document.getElementById('s-status').value='OPEN';
    }
}
</script>

</div></div></div></body></html>
