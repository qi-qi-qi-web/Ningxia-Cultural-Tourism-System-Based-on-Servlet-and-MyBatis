<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.SpecialtyMapper" %>
<%@ page import="com.niit.pojo.Specialty" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    if (request.getAttribute("specialtyList") == null) {
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("specialtyList", s.getMapper(SpecialtyMapper.class).findAllWithCategory());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
    }
    if (request.getAttribute("categoryMap") == null) {
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("categoryMap", s.getMapper(SpecialtyMapper.class).selectCategories());
        } catch (Exception e) {}
    }
    java.util.List pageList = (java.util.List) request.getAttribute("specialtyList");
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
        <h3>特产管理</h3>
        <button class="btn btn-primary btn-sm" onclick="openEdit()">+ 新增特产</button>
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
            <th>ID</th><th>名称</th><th>分类</th><th>价格</th><th>库存</th><th>销量</th><th>状态</th><th>操作</th>
        </tr></thead>
        <tbody>
            <c:if test="${ed > 0}"><c:forEach items="${specialtyList}" var="s" begin="${st}" end="${ed - 1}">
            <tr>
                <td>${s.id}</td>
                <td>${s.name}</td>
                <td>${s.categoryName}</td>
                <td>¥${s.price}</td>
                <td>${s.stock}</td>
                <td>${s.salesCount}</td>
                <td>
                    <c:choose>
                        <c:when test="${s.status == 1}"><span class="badge bg-success">上架</span></c:when>
                        <c:otherwise><span class="badge bg-warning">下架</span></c:otherwise>
                    </c:choose>
                </td>
                <td style="white-space:nowrap;">
                    <button class="btn btn-info btn-sm" onclick="openEdit(${s.id})">编辑</button>
                    <c:choose>
                        <c:when test="${s.status == 1}">
                            <a href="${pageContext.request.contextPath}/admin/specialty?action=down&id=${s.id}" class="btn btn-warning btn-sm">下架</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/admin/specialty?action=up&id=${s.id}" class="btn btn-success btn-sm">上架</a>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/admin/specialty?action=delete&id=${s.id}" class="btn btn-danger btn-sm" onclick="return confirm('确认删除？')">删除</a>
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

<div id="edit-modal" style="display:none;position:fixed;z-index:2000;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,0.5);">
    <div style="background:#fff;border-radius:8px;max-width:650px;margin:5% auto;padding:25px;max-height:80vh;overflow-y:auto;">
        <h4 id="modal-title">新增特产</h4>
        <form method="post" action="${pageContext.request.contextPath}/admin/specialty" enctype="multipart/form-data">
            <input type="hidden" name="action" value="save"><input type="hidden" name="id" id="sp-id">
            <div class="mb-2"><label>名称</label><input class="form-control" name="name" id="sp-name" required></div>
            <div class="mb-2"><label>分类</label>
                <select class="form-control" name="categoryId" id="sp-cat" required>
                    <option value="">-- 请选择分类 --</option>
                    <c:forEach items="${categoryMap}" var="cat">
                        <option value="${cat['id']}">${cat['name']}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-2"><label>描述</label><textarea class="form-control" name="description" id="sp-desc" rows="3"></textarea></div>
            <div class="row mb-2">
                <div class="col-4"><label>价格</label><input class="form-control" name="price" id="sp-price" step="0.01" required></div>
                <div class="col-4"><label>库存</label><input class="form-control" name="stock" id="sp-stock" type="number" required></div>
                <div class="col-4"><label>状态</label><select class="form-control" name="status" id="sp-status"><option value="1">上架</option><option value="0">下架</option></select></div>
            </div>
            <div class="mb-2"><label>主图（可上传文件或填写URL）</label><input class="form-control" type="file" name="mainImageFile" id="sp-img-file" accept="image/*" style="margin-bottom:5px;"></div>
            <div class="mb-2"><input class="form-control" name="mainImage" id="sp-img" placeholder="或填写图片URL"></div>
            <div class="mb-2"><label>图片列表（可多选上传文件或填写URL数组）</label><input class="form-control" type="file" name="imagesFiles" id="sp-images-file" multiple accept="image/*" style="margin-bottom:5px;"><div id="sp-images-file-list" style="font-size:12px;color:#888;margin:3px 0;"></div></div>
            <div class="mb-3"><textarea class="form-control" name="images" id="sp-images" placeholder='或手动填写图片URL数组，JSON格式：["url1","url2"]' rows="2"></textarea></div>
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-secondary" onclick="document.getElementById('edit-modal').style.display='none'">取消</button>
        </form>
    </div>
</div>

<script>
// 文件选择预览
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('sp-images-file').addEventListener('change', function() {
        var list = document.getElementById('sp-images-file-list');
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
        document.getElementById('modal-title').textContent = '编辑特产';
        fetch('${pageContext.request.contextPath}/admin/specialty?action=edit&id=' + id)
        .then(function(r){ return r.json(); })
        .then(function(d){
            document.getElementById('sp-id').value = d.id;
            document.getElementById('sp-name').value = d.name;
            document.getElementById('sp-desc').value = d.description || '';
            document.getElementById('sp-cat').value = d.categoryId;
            document.getElementById('sp-price').value = d.price;
            document.getElementById('sp-stock').value = d.stock;
            document.getElementById('sp-img').value = d.mainImage || '';
            document.getElementById('sp-images').value = d.images || '';
            document.getElementById('sp-status').value = d.status;
        })
        .catch(function(){ alert('加载失败'); });
    } else {
        document.getElementById('modal-title').textContent = '新增特产';
        ['sp-id','sp-name','sp-desc','sp-price','sp-stock','sp-img','sp-images'].forEach(function(f){ document.getElementById(f).value = ''; });
        document.getElementById('sp-cat').value = ''; document.getElementById('sp-status').value = '1';
    }
}
</script>
</div></div></div></body></html>
