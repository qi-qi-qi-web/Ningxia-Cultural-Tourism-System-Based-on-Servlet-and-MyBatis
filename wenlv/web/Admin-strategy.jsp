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
        <div>
            <button class="btn btn-primary btn-sm" onclick="openStrategyEdit()">+ 新增攻略</button>
            <span style="color:#999;font-size:13px;margin-left:15px;">共 <strong>${guideList.size()}</strong> 篇攻略</span>
        </div>
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
                    <button class="btn btn-info btn-sm" onclick="openStrategyEdit(${g.id})">编辑</button>
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

<%-- 新增/编辑弹窗 --%>
<div id="strategy-modal" style="display:none;position:fixed;z-index:2000;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,0.5);">
    <div style="background:#fff;border-radius:8px;max-width:700px;margin:5% auto;padding:25px;max-height:80vh;overflow-y:auto;">
        <h4 id="strategy-modal-title">新增攻略</h4>
        <form method="post" action="${pageContext.request.contextPath}/admin/strategy" enctype="multipart/form-data">
            <input type="hidden" name="action" value="save">
            <input type="hidden" name="id" id="strategy-id">
            <div class="mb-2"><label>标题</label><input class="form-control" name="title" id="strategy-title" required></div>
            <div class="mb-2"><label>正文内容</label><textarea class="form-control" name="content" id="strategy-content" rows="8" required></textarea></div>
            <div class="mb-2"><label>封面图（可上传文件或填写URL）</label><input class="form-control" type="file" name="coverImageFile" id="strategy-cover-file" accept="image/*" style="margin-bottom:5px;"></div>
            <div class="mb-2"><input class="form-control" name="coverImage" id="strategy-cover" placeholder="或填写图片URL"></div>
            <!-- 标签选择 -->
            <div class="mb-2"><label>标签（点击选中/取消）</label>
                <div id="admin-tag-area" style="max-height:200px;overflow-y:auto;border:1px solid #ddd;border-radius:5px;padding:8px;">
                    <span style="color:#999;">加载标签中...</span>
                </div>
                <input type="hidden" name="tags" id="strategy-tags">
            </div>
            <div class="mb-2"><label>关联景区</label>
                <select class="form-control" name="scenicSpotId" id="strategy-scenic">
                    <option value="">不关联（通用攻略）</option>
                </select>
            </div>
            <div class="mb-3"><label>状态</label>
                <select class="form-control" name="status" id="strategy-status">
                    <option value="PUBLISHED">已发布</option>
                    <option value="DRAFT">草稿</option>
                    <option value="HIDDEN">已隐藏</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-secondary" onclick="document.getElementById('strategy-modal').style.display='none'">取消</button>
        </form>
    </div>
</div>

<script>
var adminSelectedTags = {};

function loadAdminTags() {
    var area = document.getElementById('admin-tag-area');
    area.innerHTML = '<span style="color:#999;">加载标签中...</span>';
    fetch('${pageContext.request.contextPath}/admin/guideTag?action=list')
    .then(function(r) { return r.json(); })
    .then(function(tags) {
        var catMap = { 'FEATURE': [], 'TIME': [], 'AUDIENCE': [], 'BUDGET': [] };
        var catNames = { 'FEATURE': '特点', 'TIME': '时间', 'AUDIENCE': '适合人群', 'BUDGET': '预算' };
        tags.forEach(function(t) {
            if (catMap[t.category]) catMap[t.category].push(t);
        });
        var html = '';
        for (var cat in catMap) {
            html += '<div style="font-size:11px;font-weight:600;color:#888;margin:4px 0 2px;">' + catNames[cat] + '</div>';
            catMap[cat].forEach(function(t) {
                var sel = adminSelectedTags[t.name] ? ' selected' : '';
                html += '<span class="tag-chip' + sel + '" data-name="' + escHtml(t.name) + '" onclick="toggleAdminTag(this)">' + escHtml(t.name) + '</span>';
            });
        }
        area.innerHTML = html;
    })
    .catch(function() { area.innerHTML = '<span style="color:#999;">加载失败</span>'; });
}

function toggleAdminTag(el) {
    var name = el.getAttribute('data-name');
    if (el.classList.contains('selected')) {
        el.classList.remove('selected');
        delete adminSelectedTags[name];
    } else {
        el.classList.add('selected');
        adminSelectedTags[name] = true;
    }
    document.getElementById('strategy-tags').value = Object.keys(adminSelectedTags).join(',');
}

function openStrategyEdit(id) {
    document.getElementById('strategy-modal').style.display = 'block';
    adminSelectedTags = {};
    if (id) {
        document.getElementById('strategy-modal-title').textContent = '编辑攻略';
        fetch('${pageContext.request.contextPath}/admin/strategy?action=edit&id=' + id)
        .then(function(r){ return r.json(); })
        .then(function(d){
            document.getElementById('strategy-id').value = d.id;
            document.getElementById('strategy-title').value = d.title;
            document.getElementById('strategy-content').value = d.content;
            document.getElementById('strategy-cover').value = d.coverImage || '';
            document.getElementById('strategy-status').value = d.status;
            // 预选已有标签
            if (d.tags) {
                d.tags.split(',').forEach(function(t) {
                    var n = t.trim();
                    if (n) adminSelectedTags[n] = true;
                });
            }
            document.getElementById('strategy-tags').value = d.tags || '';
            loadAdminTags();
            // 预选景区（需要等下拉框加载完成后设置）
            setTimeout(function() {
                if (d.scenicSpotId) {
                    document.getElementById('strategy-scenic').value = d.scenicSpotId;
                }
            }, 200);
        })
        .catch(function(){ alert('加载失败'); });
    } else {
        document.getElementById('strategy-modal-title').textContent = '新增攻略';
        ['strategy-id','strategy-title','strategy-content','strategy-cover','strategy-tags'].forEach(function(f){
            document.getElementById(f).value = '';
        });
        document.getElementById('strategy-status').value = 'PUBLISHED';
        document.getElementById('strategy-scenic').value = '';
        loadAdminTags();
    }
}

function loadAdminScenicSpots() {
    var sel = document.getElementById('strategy-scenic');
    sel.innerHTML = '<option value="">不关联（通用攻略）</option>';
    fetch('${pageContext.request.contextPath}/map?action=listOpen')
    .then(function(r) { return r.json(); })
    .then(function(scenics) {
        if (Array.isArray(scenics)) {
            scenics.forEach(function(s) {
                sel.innerHTML += '<option value="' + s.id + '">' + escHtml(s.name) + '</option>';
            });
        }
    })
    .catch(function() {});
}

function escHtml(s) {
    if (!s) return '';
    return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

// 页面加载时预加载标签和景区列表
loadAdminTags();
loadAdminScenicSpots();
</script>
</div></div></div></body></html>
