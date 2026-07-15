<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.OfficialNoticeMapper" %>
<%@ page import="com.niit.pojo.OfficialNotice" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>

<%
    String idStr = request.getParameter("id");
    if (idStr != null) {
        try (SqlSession s = DBUtil.getSession()) {
            OfficialNotice notice = s.getMapper(OfficialNoticeMapper.class).findById(Long.parseLong(idStr));
            request.setAttribute("notice", notice);
            if (notice != null && notice.getContent() != null) {
                String content = notice.getContent().trim();
                // 已是HTML则直接输出，纯文本则分段+缩进
                if (content.startsWith("<")) {
                    request.setAttribute("formattedContent", content);
                } else {
                    String[] paras = content.split("\n\n");
                    StringBuilder sb = new StringBuilder();
                    for (String p : paras) {
                        p = p.trim();
                        if (!p.isEmpty()) {
                            sb.append("<p style=\"text-indent:2em;margin-bottom:0.8em;line-height:2;\">")
                              .append(p.replace("\n", "<br/>"))
                              .append("</p>");
                        }
                    }
                    request.setAttribute("formattedContent", sb.toString());
                }
            }
        } catch (Exception e) {}
    }
%>

<%@include file="Head.jsp"%>

<c:if test="${empty notice}">
    <section class="section section-lg bg-default"><div class="container text-center" style="padding:80px 0;">
        <h3>公告不存在</h3><a href="notice-list.jsp" class="button button-primary">返回公告列表</a>
    </div></section>
</c:if>

<c:if test="${not empty notice}">
<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);">
    <div class="container">
        <h4 class="breadcrumbs-custom-title">${notice.title}</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="Information.jsp">资讯</a></li>
            <li><a href="notice-list.jsp">通知公告</a></li>
            <li class="active">详情</li>
        </ul>
    </div>
</section>

<section class="section section-lg bg-default">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-8">
                <!-- 公告正式格式 -->
                <div style="border:2px solid #c0392b;border-radius:4px;padding:40px 35px;background:#fff;position:relative;">
                    <!-- 红色标题栏 -->
                    <div style="text-align:center;border-bottom:2px solid #c0392b;padding-bottom:20px;margin-bottom:30px;">
                        <h2 style="color:#c0392b;font-weight:bold;margin:0 0 5px;">${notice.title}</h2>
                        <p style="color:#999;font-size:14px;margin:0;">
                            发布时间：<fmt:formatDate value="${notice.publishedAt}" pattern="yyyy年MM月dd日"/>
                            <c:if test="${not empty notice.scenicSpotId}"> | 关联景区：${notice.scenicSpotId}</c:if>
                        </p>
                    </div>

                    <!-- 正文 -->
                    <div style="font-size:16px;color:#333;min-height:200px;">
                        ${formattedContent}
                    </div>

                    <!-- 底部公章区 -->
                    <div style="text-align:right;margin-top:40px;padding-top:20px;border-top:1px dashed #ddd;color:#666;font-size:14px;">
                        <p style="margin:0;">宁夏回族自治区文化和旅游厅</p>
                        <p style="margin:5px 0 0;"><fmt:formatDate value="${notice.publishedAt}" pattern="yyyy年MM月dd日"/></p>
                    </div>
                </div>

                <div style="text-align:center;margin-top:25px;">
                    <a href="notice-list.jsp" class="button button-primary-2 button-md">返回列表</a>
                </div>
            </div>
        </div>
    </div>
</section>
</c:if>

<%@include file="Footer.jsp"%>
</div>
<script src="js/core.min.js"></script><script src="js/script.js"></script>
</body></html>
