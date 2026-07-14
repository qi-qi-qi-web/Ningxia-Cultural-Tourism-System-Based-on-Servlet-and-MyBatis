<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.GuideTagMapper" %>
<%@ page import="com.niit.pojo.GuideTag" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.*" %>

<%
    String cat = request.getParameter("cat");
    if (cat == null || cat.isEmpty()) cat = "FEATURE";

    if (request.getAttribute("tagList") == null) {
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("tagList", s.getMapper(GuideTagMapper.class).findByCategory(cat));
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
    }
    request.setAttribute("cat", cat);

    // 分页
    Object obj = request.getAttribute("tagList");
    int pn = 1, ps = 10;
    try { pn = Integer.parseInt(request.getParameter("page")); } catch(Exception e){}
    int tt = obj instanceof List ? ((List)obj).size() : 0;
    int tp = (int)Math.ceil((double)tt/ps);
    if(pn<1)pn=1; if(pn>tp&&tp>0)pn=tp;
    request.setAttribute("pn", pn); request.setAttribute("tp", tp);
    request.setAttribute("tt", tt); request.setAttribute("st", (pn-1)*ps);
    request.setAttribute("ed", Math.min((pn-1)*ps+ps, tt));

    Map<String, String> catNames = new LinkedHashMap<>();
    catNames.put("FEATURE", "特点");
    catNames.put("TIME", "时间");
    catNames.put("AUDIENCE", "适合人群");
    catNames.put("BUDGET", "预算");
    request.setAttribute("catNames", catNames);
%>

<%@ include file="Admin-Head_And_Side.jsp" %>

<div class="admin-card">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>攻略标签管理</h3>
        <button class="btn btn-primary btn-sm" onclick="openTagEdit()">+ 新增标签</button>
    </div>

    <c:if test="${not empty sessionScope.msg}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            ${sessionScope.msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="msg" scope="session"/>
    </c:if>

    <!-- 分类筛选按钮 -->
    <div class="mb-3">
        <c:forEach items="${catNames}" var="entry">
            <c:choose>
                <c:when test="${cat == entry.key}">
                    <span class="btn btn-sm" style="background:#00a8a8;color:#fff;cursor:default;margin-right:6px;">${entry.value}</span>
                </c:when>
                <c:otherwise>
                    <a href="?cat=${entry.key}" class="btn btn-sm" style="border:1px solid #ddd;color:#666;margin-right:6px;">${entry.value}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        <span style="color:#999;font-size:13px;margin-left:10px;">共 <strong>${tt}</strong> 个标签</span>
    </div>

    <table class="table table-striped table-hover">
        <thead><tr>
            <th>排序</th><th>标签名</th><th>分类</th><th>ID</th><th>操作</th>
        </tr></thead>
        <tbody>
            <c:if test="${ed > 0}"><c:forEach items="${tagList}" var="t" begin="${st}" end="${ed - 1}">
            <tr>
                <td>${t.sortOrder}</td>
                <td>${t.name}</td>
                <td>${catNames[t.category]}</td>
                <td>${t.id}</td>
                <td style="white-space:nowrap;">
                    <button class="btn btn-info btn-sm" onclick="openTagEdit(${t.id},'${t.name}','${t.category}',${t.sortOrder})">编辑</button>
                    <a href="${pageContext.request.contextPath}/admin/guideTag?action=delete&id=${t.id}&cat=${cat}" class="btn btn-danger btn-sm" onclick="return confirm('确认删除？')">删除</a>
                </td>
            </tr>
            </c:forEach></c:if>
        </tbody>
    </table>

    <c:if test="${tp > 1}">
    <div class="page-nav">
        <c:if test="${pn > 1}"><a href="?cat=${cat}&page=1">首页</a><a href="?cat=${cat}&page=${pn-1}">上一页</a></c:if>
        <c:forEach begin="1" end="${tp}" var="p">
            <c:choose><c:when test="${p==pn}"><span class="current">${p}</span></c:when><c:otherwise><a href="?cat=${cat}&page=${p}">${p}</a></c:otherwise></c:choose>
        </c:forEach>
        <c:if test="${pn < tp}"><a href="?cat=${cat}&page=${pn+1}">下一页</a><a href="?cat=${cat}&page=${tp}">末页</a></c:if>
        <span class="info">共 ${tp} 页 / ${tt} 条</span>
    </div>
    </c:if>

</div>

<%-- 新增/编辑弹窗 --%>
<div id="tag-modal" style="display:none;position:fixed;z-index:2000;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,0.5);">
    <div style="background:#fff;border-radius:8px;max-width:500px;margin:10% auto;padding:25px;">
        <h4 id="tag-modal-title">新增标签</h4>
        <form method="post" action="${pageContext.request.contextPath}/admin/guideTag?cat=${cat}">
            <input type="hidden" name="action" value="save">
            <input type="hidden" name="id" id="tag-id">
            <div class="mb-2"><label>标签名</label><input class="form-control" name="name" id="tag-name" required></div>
            <div class="mb-2"><label>分类</label>
                <select class="form-control" name="category" id="tag-category">
                    <option value="FEATURE">特点</option>
                    <option value="TIME">时间</option>
                    <option value="AUDIENCE">适合人群</option>
                    <option value="BUDGET">预算</option>
                </select>
            </div>
            <div class="mb-3"><label>排序</label><input class="form-control" name="sortOrder" id="tag-sort" type="number" value="0"></div>
            <button type="submit" class="btn btn-primary">保存</button>
            <button type="button" class="btn btn-secondary" onclick="document.getElementById('tag-modal').style.display='none'">取消</button>
        </form>
    </div>
</div>

<script>
function openTagEdit(id, name, category, sort) {
    document.getElementById('tag-modal').style.display = 'block';
    if (id) {
        document.getElementById('tag-modal-title').textContent = '编辑标签';
        document.getElementById('tag-id').value = id;
        document.getElementById('tag-name').value = name;
        document.getElementById('tag-category').value = category;
        document.getElementById('tag-sort').value = sort;
    } else {
        document.getElementById('tag-modal-title').textContent = '新增标签';
        document.getElementById('tag-id').value = '';
        document.getElementById('tag-name').value = '';
        document.getElementById('tag-category').value = '${cat}';
        document.getElementById('tag-sort').value = '0';
    }
}
</script>
</div></div></div></body></html>
