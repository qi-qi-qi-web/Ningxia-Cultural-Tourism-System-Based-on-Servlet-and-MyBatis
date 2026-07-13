<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html class="wide wow-animation" lang="zh-CN">
<head>
    <title>管理员后台 - 宁夏智慧文旅服务平台</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- 引入 Google Fonts 字体 -->
    <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Oswald:200,300,400,500,700|Montserrat:400,500,600">
    <!-- 引入本地样式表 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>

<body>

<script src="${pageContext.request.contextPath}/js/core.min.js"></script>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
<script src="${pageContext.request.contextPath}/js/admin.js"></script>

<%-- 覆盖 admin.js 中的 logout，使用绝对路径确保跳转正确 --%>
<script>
var _adminLogout = logout;
logout = function() {
    localStorage.clear();
    window.location.href = '${pageContext.request.contextPath}/index.jsp';
};
</script>

<div class="container-fluid">
    <div class="row">
        <!-- 左侧侧边栏 -->
        <div class="col-md-3 admin-sidebar">
            <div class="logo">宁夏智慧文旅管理后台</div>

            <nav class="nav flex-column">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/user">
                    <i class="fa fa-users"></i> 用户管理
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/news">
                    <i class="fa fa-newspaper-o"></i> 新闻动态
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/notice">
                    <i class="fa fa-bullhorn"></i> 通知公告
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/Admin-scenic.jsp">
                    <i class="fa fa-map-marker"></i> 景区管理
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/specialty">
                    <i class="fa fa-cutlery"></i> 特产管理
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/hotel">
                    <i class="fa fa-bed"></i> 酒店管理
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/strategy">
                    <i class="fa fa-file-text"></i> 攻略管理
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/order">
                    <i class="fa fa-shopping-cart"></i> 订单管理
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/Admin-comment.jsp">
                    <i class="fa fa-comments"></i> 评论管理
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/log">
                    <i class="fa fa-history"></i> 平台日志
                </a>
            </nav>
        </div>

        <!-- 右侧主内容区 开始 -->
        <div class="col-md-9 admin-main">
            <div class="admin-header">
                <div class="welcome">欢迎管理员, <span id="admin-name">管理员</span></div>
                <button class="btn btn-sm logout-btn" onclick="logout()">退出登录</button>
            </div>

            <!-- 注意：这里不关闭 div，由各个子页面负责关闭 -->