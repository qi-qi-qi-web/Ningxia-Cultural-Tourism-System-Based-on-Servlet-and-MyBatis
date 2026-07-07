<%@page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="wide wow-animation" lang="zh-CN">
<head>
    <title>首页</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="icon" href="images/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Oswald:200,300,400,500,700%7CMontserrat:400,500,600">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/fonts.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/login-styles.css">
</head>
<body>
<div class="preloader">
    <div class="preloader-body">
        <div class="cssload-container">
            <div class="cssload-speeding-wheel"></div>
        </div>
        <p>加载中...</p>
    </div>
</div>
<div class="page">
    <header class="section page-header">
        <!--RD Navbar-->
        <div class="rd-navbar-wrap">
            <nav class="rd-navbar rd-navbar-classic" data-layout="rd-navbar-fixed" data-sm-layout="rd-navbar-fixed" data-md-layout="rd-navbar-fixed" data-md-device-layout="rd-navbar-fixed" data-lg-layout="rd-navbar-static" data-lg-device-layout="rd-navbar-static" data-xl-layout="rd-navbar-static" data-xl-device-layout="rd-navbar-static" data-lg-stick-up-offset="46px" data-xl-stick-up-offset="46px" data-xxl-stick-up-offset="46px" data-lg-stick-up="true" data-xl-stick-up="true" data-xxl-stick-up="true">
                <div class="rd-navbar-collapse-toggle rd-navbar-fixed-element-1" data-rd-navbar-toggle=".rd-navbar-collapse"><span></span></div>
                <div class="rd-navbar-main-outer">
                    <div class="rd-navbar-main">
                        <!--RD Navbar Panel-->
                        <div class="rd-navbar-panel">
                            <!--RD Navbar Toggle-->
                            <button class="rd-navbar-toggle" data-rd-navbar-toggle=".rd-navbar-nav-wrap"><span></span></button>
                            <!--RD Navbar Brand-->
                            <div class="rd-navbar-brand">
                                <!--Brand--><a class="brand" href="index.html"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt="" width="112" height="19"/><img class="brand-logo-light" src="images/logo-default-225x39.png" alt="" width="112" height="19"/></a>
                            </div>
                        </div>
                        <div class="rd-navbar-main-element">
                            <div class="rd-navbar-nav-wrap">
                                <ul class="rd-navbar-nav">
                                    <li class="rd-nav-item active"><a class="rd-nav-link" href="index.jsp">首页</a>
                                    </li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="AboutNingXia.jsp">关于宁夏</a>
                                    </li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="ScenicService.jsp">景区服务</a>
                                        <ul class="rd-menu rd-navbar-dropdown">
                                            <li class="rd-dropdown-item"><a class="rd-dropdown-link" href="single-tour.html">景区详情</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="Food.jsp">特色美食</a>
                                        <ul class="rd-menu rd-navbar-dropdown">
                                            <li class="rd-dropdown-item"><a class="rd-dropdown-link" href="single-service.html">服务详情</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="#">民俗酒店</a>
                                        <ul class="rd-menu rd-navbar-megamenu">
                                            <li class="rd-megamenu-item">
                                                <h6 class="rd-megamenu-title"><a href="Hotel.jsp">页面一</a></h6>
                                                <ul class="rd-megamenu-list">
                                                    <li class="rd-megamenu-list-item"><a class="rd-megamenu-list-link" href="typography.html">排版展示</a></li>
                                                    <li class="rd-megamenu-list-item"><a class="rd-megamenu-list-link" href="buttons.html">按钮样式</a></li>
                                                    <li class="rd-megamenu-list-item"><a class="rd-megamenu-list-link" href="forms.html">表单样式</a></li>
                                                    <li class="rd-megamenu-list-item"><a class="rd-megamenu-list-link" href="tabs-and-accordions.html">标签和手风琴</a></li>
                                                    <li class="rd-megamenu-list-item"><a class="rd-megamenu-list-link" href="progress-bars.html">进度条</a></li>
                                                    <li class="rd-megamenu-list-item"><a class="rd-megamenu-list-link" href="tables.html">表格</a></li>
                                                </ul>
                                            </li>
                                            <li class="rd-megamenu-item">
                                                <h6 class="rd-megamenu-title">页面二</h6>
                                                <ul class="rd-megamenu-list">
                                                    <li class="rd-megamenu-list-item"><a class="rd-megamenu-list-link" href="grid-system.html">网格系统</a></li>
                                                    <li class="rd-megamenu-list-item"><a class="rd-megamenu-list-link" href="privacy-policy.html">隐私政策</a></li>
                                                    <li class="rd-megamenu-list-item"><a class="rd-megamenu-list-link" href="search-results.html">搜索结果</a></li>
                                                    <li class="rd-megamenu-list-item"><a class="rd-megamenu-list-link" href="under-construction.html">建设中</a></li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="TravelGuide.jsp">旅游攻略</a>
                                    </li>
                                </ul>
                            </div>
                            <!--RD Navbar Search-->
                            <div class="rd-navbar-search">
                                <button class="rd-navbar-search-toggle rd-navbar-fixed-element-2" data-rd-navbar-toggle=".rd-navbar-search"><span></span></button>
                                <form class="rd-search" action="search-results.html" data-search-live="rd-search-results-live" method="GET">
                                    <div class="form-wrap">
                                        <label class="form-label" for="rd-navbar-search-form-input">搜索...</label>
                                        <input class="rd-navbar-search-form-input form-input" id="rd-navbar-search-form-input" type="text" name="s" autocomplete="off">
                                        <div class="rd-search-results-live" id="rd-search-results-live"></div>
                                    </div>
                                    <button class="rd-search-form-submit fa-search" type="submit"></button>
                                </form>
                            </div>
                            <!--RD Navbar Login-->
                            <div class="rd-navbar-login" style="display: flex; align-items: center; justify-content: flex-end; float: right; margin-top: 8px;">
                                <a href="#" class="rd-nav-link rd-navbar-login-toggle" data-bs-toggle="modal" data-bs-target="#login-modal">登录</a>
                                <a href="#" class="rd-nav-link rd-navbar-admin-login-toggle" data-bs-toggle="modal" data-bs-target="#admin-login-modal">管理</a>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
    </header>