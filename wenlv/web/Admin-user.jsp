<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.UserMapper" %>
<%@ page import="com.niit.pojo.User" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    // 直接访问 JSP 时的兜底：如果 servlet 未设置 users 属性，则自行查询
    if (request.getAttribute("users") == null) {
        try (SqlSession sqlSession = DBUtil.getSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            List<User> users = mapper.findAll();
            request.setAttribute("users", users);
        } catch (Exception e) {
            request.setAttribute("error", "数据加载失败：" + e.getMessage());
        }
    }
    // 分页计算
    java.util.List pageList = (java.util.List) request.getAttribute("users");
    int pn = 1, ps = 5;
    try { pn = Integer.parseInt(request.getParameter("page")); } catch(Exception e){}
    int tt = pageList != null ? pageList.size() : 0;
    int tp = (int)Math.ceil((double)tt/ps);
    if(pn<1)pn=1; if(pn>tp&&tp>0)pn=tp;
    request.setAttribute("pn", pn);
    request.setAttribute("tp", tp);
    request.setAttribute("tt", tt);
    request.setAttribute("st", (pn-1)*ps);
    request.setAttribute("ed", Math.min((pn-1)*ps+ps, tt));
%>

<%@ include file="Admin-Head_And_Side.jsp" %>

<%-- ==================== 用户管理主内容 ==================== --%>
<div class="admin-card">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>用户管理</h3>
        <span style="color:#999;font-size:13px;">
            共 <strong>${users.size()}</strong> 位注册用户
        </span>
    </div>

    <%-- 操作提示消息 --%>
    <c:if test="${not empty sessionScope.msg}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            ${sessionScope.msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="msg" scope="session" />
    </c:if>

    <%-- 错误消息 --%>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <%-- 用户表格 --%>
    <c:choose>
        <c:when test="${empty users}">
            <div style="text-align:center;padding:60px 0;color:#999;">
                <i class="fa fa-users" style="font-size:48px;display:block;margin-bottom:15px;color:#ddd;"></i>
                暂无注册用户
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>用户名</th>
                            <th>昵称</th>
                            <th>手机号</th>
                            <th>邮箱</th>
                            <th>角色</th>
                            <th>状态</th>
                            <th>注册时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${ed > 0}">
                        <c:forEach items="${users}" var="user" begin="${st}" end="${ed - 1}">
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.username}</td>
                                <td>${empty user.nickname ? '-' : user.nickname}</td>
                                <td>${empty user.phone ? '-' : user.phone}</td>
                                <td>${empty user.email ? '-' : user.email}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.role == 'ADMIN'}">
                                            <span class="badge bg-primary">管理员</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">普通用户</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.status == 0}">
                                            <span class="badge bg-danger">已禁用</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success">正常</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                </td>
                                <td style="white-space:nowrap;">
                                    <%-- 状态切换按钮 --%>
                                    <c:choose>
                                        <c:when test="${user.role == 'ADMIN'}">
                                            <span style="color:#999;font-size:12px;">受保护</span>
                                        </c:when>
                                        <c:when test="${user.status == 0}">
                                            <a href="${pageContext.request.contextPath}/admin/user?action=toggle&id=${user.id}"
                                               class="btn btn-success btn-sm"
                                               style="padding:2px 12px;font-size:12px;">解除禁用</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/admin/user?action=toggle&id=${user.id}"
                                               class="btn btn-warning btn-sm"
                                               style="padding:2px 12px;font-size:12px;"
                                               onclick="return confirm('确定禁用用户「${user.username}」吗？\n禁用后该用户将无法发布攻略和评论。')">禁用</a>
                                        </c:otherwise>
                                    </c:choose>

                                    <%-- 删除按钮 --%>
                                    <c:choose>
                                        <c:when test="${user.role == 'ADMIN'}">
                                            <%-- 管理员不可删除 --%>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/admin/user?action=delete&id=${user.id}"
                                               class="btn btn-danger btn-sm"
                                               style="padding:2px 12px;font-size:12px;"
                                               onclick="return confirm('确定删除用户「${user.username}」吗？\n此操作不可恢复！')">删除</a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>

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

<%-- 关闭由 Admin-Head_And_Side.jsp 打开的容器 --%>
        </div><!-- /.admin-main -->
    </div><!-- /.row -->
</div><!-- /.container-fluid -->

</body>
</html>
