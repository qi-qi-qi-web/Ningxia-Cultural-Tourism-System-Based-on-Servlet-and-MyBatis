<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html class="wide wow-animation" lang="zh-CN">
<head>
    <title>个人中心 - 宁夏智慧文旅服务平台</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="icon" href="images/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Oswald:200,300,400,500,700%7CMontserrat:400,500,600">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/fonts.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/login-styles.css">
    <style>
        .profile-form-group {
            margin-bottom: 20px;
        }
        .profile-form-label {
            display: block;
            font-family: Oswald, sans-serif;
            font-size: 14px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #333;
            margin-bottom: 8px;
        }
        .profile-form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            font-size: 15px;
            background: #fafafa;
            box-sizing: border-box;
            color: #333;
            transition: border-color 0.3s ease;
        }
        .profile-form-input:focus {
            outline: none;
            border-color: #00a8a8;
        }
        .profile-form-textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            font-size: 15px;
            background: #fafafa;
            box-sizing: border-box;
            color: #333;
            resize: vertical;
            min-height: 100px;
        }
        .profile-form-textarea:focus {
            outline: none;
            border-color: #00a8a8;
        }
    </style>
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
        <div class="rd-navbar-wrap">
            <nav class="rd-navbar rd-navbar-classic" data-layout="rd-navbar-fixed" data-sm-layout="rd-navbar-fixed" data-md-layout="rd-navbar-fixed" data-md-device-layout="rd-navbar-fixed" data-lg-layout="rd-navbar-static" data-lg-device-layout="rd-navbar-static" data-xl-layout="rd-navbar-static" data-xl-device-layout="rd-navbar-static" data-lg-stick-up-offset="46px" data-xl-stick-up-offset="46px" data-xxl-stick-up-offset="46px" data-lg-stick-up="true" data-xl-stick-up="true" data-xxl-stick-up="true">
                <div class="rd-navbar-collapse-toggle rd-navbar-fixed-element-1" data-rd-navbar-toggle=".rd-navbar-collapse"><span></span></div>
                <div class="rd-navbar-main-outer">
                    <div class="rd-navbar-main">
                        <div class="rd-navbar-panel">
                            <button class="rd-navbar-toggle" data-rd-navbar-toggle=".rd-navbar-nav-wrap"><span></span></button>
                            <div class="rd-navbar-brand">
                                <a class="brand" href="index.jsp"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt="" width="112" height="19"/><img class="brand-logo-light" src="images/logo-default-225x39.png" alt="" width="112" height="19"/></a>
                            </div>
                        </div>
                        <div class="rd-navbar-main-element">
                            <div class="rd-navbar-nav-wrap">
                                <ul class="rd-navbar-nav">
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="index.jsp">首页</a></li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="AboutNingXia.jsp">关于宁夏</a></li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="ScenicService.jsp">景区服务</a></li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="Food.jsp">特色美食</a></li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="Hotel.jsp">民俗酒店</a></li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="TravelGuide.jsp">旅游攻略</a></li>
                                </ul>
                            </div>
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
                            <div id="navbar-login-container" class="rd-navbar-login" style="display: flex; align-items: center; justify-content: flex-end; float: right; margin-top: 8px;">
                                <a href="#" class="rd-nav-link rd-navbar-login-toggle" data-bs-toggle="modal" data-bs-target="#login-modal">登录</a>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
    </header>

    <section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);">
        <div class="container">
            <h4 class="breadcrumbs-custom-title">个人中心</h4>
            <ul class="breadcrumbs-custom-path">
                <li><a href="index.jsp">首页</a></li>
                <li class="active">个人中心</li>
            </ul>
        </div>
    </section>

    <section class="section section-lg">
        <div class="container">
            <div class="row">
                <div class="col-xl-3 col-lg-4">
                    <div class="sidebar sidebar-left">
                        <div class="team-member-box">
                            <div class="team-member-box__media"><img src="images/team-member-1-370x510.jpg" alt="" width="370" height="370" style="object-fit: cover; border-radius: 50%;"/></div>
                            <div class="team-member-box__caption">
                                <h5><a href="#" id="user-name">欢迎，用户</a></h5><span class="subtitle">普通会员</span>
                                <ul class="social-list">
                                    <li><a href="#" onclick="showEditProfile()"><span class="icon fa fa-edit"></span></a></li>
                                </ul>
                            </div>
                        </div>
                        <ul class="nav flex-column nav-pills">
                            <li class="nav-item"><a class="nav-link active" href="#user-info">基本信息</a></li>
                            <li class="nav-item"><a class="nav-link" href="#collections">我的收藏</a></li>
                            <li class="nav-item"><a class="nav-link" href="#orders">我的订单</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-xl-9 col-lg-8">
                    <div id="user-info" class="tab-content">
                        <div class="section-sm">
                            <h3>基本信息</h3>
                            <form onsubmit="return saveUserInfo(event)" style="margin-top: 20px;">
                                <div class="row row-30">
                                    <div class="col-md-6">
                                        <div class="profile-form-group">
                                            <div class="profile-form-label">用户名</div>
                                            <input class="profile-form-input" id="info-name" type="text" name="name" placeholder="请输入用户名">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="profile-form-group">
                                            <div class="profile-form-label">手机号</div>
                                            <input class="profile-form-input" id="info-phone" type="tel" name="phone" placeholder="请输入手机号">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="profile-form-group">
                                            <div class="profile-form-label">邮箱</div>
                                            <input class="profile-form-input" id="info-email" type="email" name="email" placeholder="请输入邮箱">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="profile-form-group">
                                            <div class="profile-form-label">生日</div>
                                            <input class="profile-form-input" id="info-birthday" type="date" name="birthday">
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="profile-form-group">
                                            <div class="profile-form-label">个性签名</div>
                                            <textarea class="profile-form-textarea" id="info-signature" name="signature" rows="3" placeholder="分享你的旅行感悟..."></textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div style="margin-top: 20px;">
                                            <button class="button button-primary" type="submit">保存修改</button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div id="collections" class="tab-content" style="display: none;">
                        <div class="section-sm">
                            <h3>我的收藏</h3>
                            <div class="row row-30">
                                <div class="col-md-4">
                                    <article class="post post-grid">
                                        <div class="post-grid__media"><a href="#"><img src="images/img-1-720x400.jpg" alt="" width="720" height="400"/></a></div>
                                        <div class="post-grid__body">
                                            <h4 class="post-grid__title"><a href="#">沙坡头景区</a></h4>
                                            <p class="post-grid__text">国家5A级景区，沙漠与黄河交汇的奇观</p>
                                            <div class="post-grid__footer">
                                                <button class="button button-xs button-primary" onclick="removeCollection(this)">取消收藏</button>
                                            </div>
                                        </div>
                                    </article>
                                </div>
                                <div class="col-md-4">
                                    <article class="post post-grid">
                                        <div class="post-grid__media"><a href="#"><img src="images/img-2-720x400.jpg" alt="" width="720" height="400"/></a></div>
                                        <div class="post-grid__body">
                                            <h4 class="post-grid__title"><a href="#">黄河宿集</a></h4>
                                            <p class="post-grid__text">网红民宿聚集地，体验慢生活</p>
                                            <div class="post-grid__footer">
                                                <button class="button button-xs button-primary" onclick="removeCollection(this)">取消收藏</button>
                                            </div>
                                        </div>
                                    </article>
                                </div>
                                <div class="col-md-4">
                                    <article class="post post-grid">
                                        <div class="post-grid__media"><a href="#"><img src="images/img-3-720x400.jpg" alt="" width="720" height="400"/></a></div>
                                        <div class="post-grid__body">
                                            <h4 class="post-grid__title"><a href="#">沙湖景区</a></h4>
                                            <p class="post-grid__text">沙水相依的美景，候鸟的天堂</p>
                                            <div class="post-grid__footer">
                                                <button class="button button-xs button-primary" onclick="removeCollection(this)">取消收藏</button>
                                            </div>
                                        </div>
                                    </article>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="orders" class="tab-content" style="display: none;">
                        <div class="section-sm">
                            <h3>我的订单</h3>
                            <div class="tabs-custom tabs-horizontal tabs-line">
                                <ul class="nav nav-tabs">
                                    <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#tab-tickets">景区门票</a></li>
                                    <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#tab-hotels">酒店民宿</a></li>
                                </ul>
                                <div class="tab-content">
                                    <div class="tab-pane fade show active" id="tab-tickets">
                                        <div class="table-custom-responsive">
                                            <table class="table-custom table-custom-primary">
                                                <thead>
                                                    <tr>
                                                        <th>订单号</th>
                                                        <th>景区名称</th>
                                                        <th>数量</th>
                                                        <th>金额</th>
                                                        <th>状态</th>
                                                        <th>操作</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>DD20260705001</td>
                                                        <td><a href="#">沙坡头景区</a></td>
                                                        <td>2</td>
                                                        <td>￥280.00</td>
                                                        <td><span class="badge badge-success">已支付</span></td>
                                                        <td><button class="button button-xs button-primary">查看详情</button></td>
                                                    </tr>
                                                    <tr>
                                                        <td>DD20260708002</td>
                                                        <td><a href="#">西夏王陵</a></td>
                                                        <td>1</td>
                                                        <td>￥75.00</td>
                                                        <td><span class="badge badge-info">待支付</span></td>
                                                        <td><button class="button button-xs button-primary">立即支付</button></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="tab-hotels">
                                        <div class="table-custom-responsive">
                                            <table class="table-custom table-custom-primary">
                                                <thead>
                                                    <tr>
                                                        <th>订单号</th>
                                                        <th>酒店名称</th>
                                                        <th>入住日期</th>
                                                        <th>金额</th>
                                                        <th>状态</th>
                                                        <th>操作</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>JD20260705001</td>
                                                        <td><a href="#">黄河宿集·西坡</a></td>
                                                        <td>2026-07-10</td>
                                                        <td>￥1280.00</td>
                                                        <td><span class="badge badge-success">已预订</span></td>
                                                        <td><button class="button button-xs button-primary">查看详情</button></td>
                                                    </tr>
                                                    <tr>
                                                        <td>JD20260706002</td>
                                                        <td><a href="#">沙湖星空营地</a></td>
                                                        <td>2026-07-15</td>
                                                        <td>￥680.00</td>
                                                        <td><span class="badge badge-warning">待确认</span></td>
                                                        <td><button class="button button-xs button-primary">取消订单</button></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer-classic context-dark">
        <div class="footer-classic-inner">
            <div class="container">
                <div class="row row-30 justify-content-md-between">
                    <div class="col-xl-3 col-lg-6 col-md-12">
                        <h5>关于我们</h5>
                        <ul class="footer-classic-list">
                            <li><a href="AboutNingXia.jsp">关于宁夏</a></li>
                            <li><a href="#">联系方式</a></li>
                            <li><a href="#">隐私政策</a></li>
                        </ul>
                    </div>
                    <div class="col-xl-3 col-lg-6 col-md-12">
                        <h5>旅游服务</h5>
                        <ul class="footer-classic-list">
                            <li><a href="ScenicService.jsp">景区服务</a></li>
                            <li><a href="Food.jsp">特色美食</a></li>
                            <li><a href="#">民宿酒店</a></li>
                        </ul>
                    </div>
                    <div class="col-xl-3 col-lg-6 col-md-12">
                        <h5>帮助中心</h5>
                        <ul class="footer-classic-list">
                            <li><a href="#">常见问题</a></li>
                            <li><a href="#">用户协议</a></li>
                            <li><a href="#">退款政策</a></li>
                        </ul>
                    </div>
                    <div class="col-xl-3 col-lg-6 col-md-12">
                        <h5>订阅我们</h5>
                        <form class="rd-form rd-mailform" data-form-output="form-output-global" data-form-type="subscribe" method="post" action="#">
                            <div class="form-wrap">
                                <label class="form-label" for="subscribe-form-email-5">输入您的邮箱</label>
                                <div class="form-button">
                                    <button class="button button-primary fa fa-chevron-circle-right" type="submit"></button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-classic-aside">
            <div class="container">
                <div class="row justify-content-between flex-column-reverse flex-md-row row-20">
                    <div class="col-xl-6 col-md-8">
                        <div class="footer-classic-aside__group">
                            <a class="brand" href="index.jsp"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt="" width="112" height="19"/><img class="brand-logo-light" src="images/logo-default-225x39.png" alt="" width="112" height="19"/></a>
                            <p class="rights"><span>版权</span><span>&nbsp;</span><span>&copy;&nbsp;</span><span class="copyright-year"></span><span>&nbsp;</span><span>保留所有权利</span></p>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-4">
                        <ul class="social-list">
                            <li class="wow fadeInUp" data-wow-delay=".1s"><a href="#"><span class="icon fa fa-facebook"></span></a></li>
                            <li class="wow fadeInUp" data-wow-delay=".2s"><a href="#"><span class="icon fa fa-twitter"></span></a></li>
                            <li class="wow fadeInUp" data-wow-delay=".3s"><a href="#"><span class="icon fa fa-instagram"></span></a></li>
                            <li class="wow fadeInUp" data-wow-delay=".4s"><a href="#"><span class="icon fa fa-pinterest"></span></a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <div class="modal fade" id="login-modal" tabindex="-1" role="dialog" aria-labelledby="login-modal-label" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="login-modal-label">用户登录</h4>
                    <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="login-form" method="post" action="#" onsubmit="return handleLogin(event)" novalidate>
                        <div class="form-wrap">
                            <label class="form-label" for="login-email">用户名/邮箱</label>
                            <input class="form-input" id="login-email" type="text" name="email" placeholder="请输入用户名或邮箱">
                        </div>
                        <div class="form-wrap">
                            <label class="form-label" for="login-password">密码</label>
                            <input class="form-input" id="login-password" type="password" name="password" placeholder="请输入密码">
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" id="login-remember" type="checkbox" name="remember">
                            <label class="form-check-label" for="login-remember">记住我</label>
                        </div>
                        <div class="form-button">
                            <button class="button button-primary button-block" type="submit">登录</button>
                        </div>
                        <div class="form-links">
                            <a href="#" class="link-default">忘记密码?</a>
                            <span class="text-separator">|</span>
                            <a href="#" class="link-default" data-bs-toggle="modal" data-bs-target="#register-modal">注册账户</a>
                            <span class="text-separator">|</span>
                            <a href="#" class="link-default" data-bs-toggle="modal" data-bs-target="#admin-login-modal">管理员登录</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="register-modal" tabindex="-1" role="dialog" aria-labelledby="register-modal-label" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="register-modal-label">用户注册</h4>
                    <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="padding: 30px;">
                    <form id="register-form" method="post" action="#" onsubmit="return handleRegister(event)" novalidate style="margin: 0;">
                        <div style="margin-bottom: 20px;">
                            <div style="font-family: Oswald, sans-serif; font-size: 14px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.05em; color: #333; margin-bottom: 8px;">用户名</div>
                            <input style="width: 100%; padding: 14px 16px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 15px; background: #fafafa; box-sizing: border-box; color: #333;" id="register-username" type="text" name="username" placeholder="请输入用户名">
                        </div>
                        <div style="margin-bottom: 20px;">
                            <div style="font-family: Oswald, sans-serif; font-size: 14px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.05em; color: #333; margin-bottom: 8px;">手机号</div>
                            <input style="width: 100%; padding: 14px 16px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 15px; background: #fafafa; box-sizing: border-box; color: #333;" id="register-phone" type="tel" name="phone" placeholder="请输入手机号">
                        </div>
                        <div style="margin-bottom: 20px;">
                            <div style="font-family: Oswald, sans-serif; font-size: 14px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.05em; color: #333; margin-bottom: 8px;">密码</div>
                            <input style="width: 100%; padding: 14px 16px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 15px; background: #fafafa; box-sizing: border-box; color: #333;" id="register-password" type="password" name="password" placeholder="请输入密码（至少6位）">
                        </div>
                        <div style="margin-bottom: 20px;">
                            <div style="font-family: Oswald, sans-serif; font-size: 14px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.05em; color: #333; margin-bottom: 8px;">确认密码</div>
                            <input style="width: 100%; padding: 14px 16px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 15px; background: #fafafa; box-sizing: border-box; color: #333;" id="register-confirm-password" type="password" name="confirmPassword" placeholder="请再次输入密码">
                        </div>
                        <div style="margin-bottom: 24px;">
                            <input style="margin-right: 10px; cursor: pointer;" id="register-agree" type="checkbox" name="agree">
                            <span style="font-size: 13px; color: #666; cursor: pointer;">我已阅读并同意<a href="#" style="color: #00a8a8; text-decoration: none;">服务条款</a>和<a href="#" style="color: #00a8a8; text-decoration: none;">隐私政策</a></span>
                        </div>
                        <div style="margin-bottom: 15px;">
                            <button style="width: 100%; padding: 14px 30px; font-family: Oswald, sans-serif; font-size: 16px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.1em; background: linear-gradient(135deg, #00a8a8 0%, #00d4aa 100%); border: none; border-radius: 6px; color: #fff; cursor: pointer; transition: transform 0.2s ease, box-shadow 0.2s ease;" type="submit">注册</button>
                        </div>
                        <div style="text-align: center;">
                            <span style="font-size: 14px; color: #666;">已有账号?</span>
                            <a href="#" style="font-size: 14px; color: #00a8a8; text-decoration: none; margin-left: 5px;" data-bs-toggle="modal" data-bs-target="#login-modal" data-bs-dismiss="modal">立即登录</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="admin-login-modal" tabindex="-1" role="dialog" aria-labelledby="admin-login-modal-label" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header admin-header">
                    <h4 class="modal-title" id="admin-login-modal-label">管理员登录</h4>
                    <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="admin-login-form" method="post" action="#" onsubmit="return handleAdminLogin(event)" novalidate>
                        <div class="form-wrap">
                            <label class="form-label" for="admin-username">管理员账号</label>
                            <input class="form-input" id="admin-username" type="text" name="username" placeholder="请输入管理员账号">
                        </div>
                        <div class="form-wrap">
                            <label class="form-label" for="admin-password">密码</label>
                            <input class="form-input" id="admin-password" type="password" name="password" placeholder="请输入密码">
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" id="admin-remember" type="checkbox" name="remember">
                            <label class="form-check-label" for="admin-remember">记住我</label>
                        </div>
                        <div class="form-button">
                            <button class="button button-primary button-block" type="submit">管理员登录</button>
                        </div>
                        <div class="form-links">
                            <a href="#" class="link-default">忘记密码?</a>
                            <span class="text-separator">|</span>
                            <a href="#" class="link-default" data-bs-toggle="modal" data-bs-target="#register-modal">注册账户</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="snackbars" id="form-output-global"></div>
<script src="js/core.min.js"></script>
<script src="js/script.js"></script>
<script src="js/login-script.js"></script>
<script>
    document.querySelectorAll('.nav-pills .nav-link').forEach(function(el) {
        el.addEventListener('click', function(e) {
            document.querySelectorAll('.nav-pills .nav-link').forEach(function(item) {
                item.classList.remove('active');
            });
            this.classList.add('active');
            var targetId = this.getAttribute('href');
            if (targetId.startsWith('#')) {
                e.preventDefault();
                document.querySelectorAll('.tab-content').forEach(function(content) {
                    content.style.display = 'none';
                });
                document.querySelector(targetId).style.display = 'block';
            }
        });
    });

    function loadUserInfo() {
        var username = localStorage.getItem('userUsername') || localStorage.getItem('userEmail') || '用户';
        var phone = localStorage.getItem('userPhone') || '';
        var email = localStorage.getItem('userEmail') || '';

        document.getElementById('user-name').textContent = '欢迎，' + username;
        document.getElementById('info-name').value = username;
        document.getElementById('info-phone').value = phone;
        document.getElementById('info-email').value = email;
    }

    function saveUserInfo(e) {
        e.preventDefault();
        var name = document.getElementById('info-name').value;
        var phone = document.getElementById('info-phone').value;
        var email = document.getElementById('info-email').value;

        localStorage.setItem('userUsername', name);
        localStorage.setItem('userPhone', phone);
        localStorage.setItem('userEmail', email);

        document.getElementById('user-name').textContent = '欢迎，' + name;
        showToast('信息保存成功！', 'success');
        return false;
    }

    function removeCollection(btn) {
        var card = btn.closest('.post');
        card.style.opacity = '0';
        setTimeout(function() {
            card.remove();
            showToast('已取消收藏', 'info');
        }, 300);
    }

    function showEditProfile() {
        document.querySelectorAll('.nav-pills .nav-link').forEach(function(item) {
            item.classList.remove('active');
        });
        document.querySelector('.nav-pills .nav-link[href="#user-info"]').classList.add('active');
        document.querySelectorAll('.tab-content').forEach(function(content) {
            content.style.display = 'none';
        });
        document.getElementById('user-info').style.display = 'block';
    }

    window.onload = function() {
        loadUserInfo();
        checkLoginStatus();
        
        var currentUrl = window.location.pathname;
        var currentPage = currentUrl.substring(currentUrl.lastIndexOf('/') + 1);
        
        var navItems = document.querySelectorAll('.rd-navbar-nav .rd-nav-item');
        navItems.forEach(function(item) {
            item.classList.remove('active');
        });
        
        navItems.forEach(function(item) {
            var link = item.querySelector('a');
            if (link) {
                var href = link.getAttribute('href');
                if (href && href === currentPage) {
                    item.classList.add('active');
                }
            }
        });
    };
</script>
</body>
</html>