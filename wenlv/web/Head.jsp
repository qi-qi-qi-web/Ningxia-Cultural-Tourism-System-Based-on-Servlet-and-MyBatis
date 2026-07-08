<%@page contentType="text/html;charset=UTF-8"%>

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
                                    </li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="Food.jsp">特色美食</a>
                                    </li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="Hotel.jsp">民俗酒店</a>
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
                            <div id="navbar-login-container" class="rd-navbar-login" style="display: flex; align-items: center; justify-content: flex-end; float: right; margin-top: 8px;">
                                <a href="#" class="rd-nav-link rd-navbar-login-toggle" data-bs-toggle="modal" data-bs-target="#login-modal">登录</a>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
    </header>

    <!-- 登录/注册/管理员弹窗 -->
    <!-- Login Modal -->
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
    <!-- Register Modal -->
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
    <!-- Admin Login Modal -->
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
    <div class="snackbars" id="form-output-global"></div>

    <!--引入登录js-->
    <script src="js/core.min.js"></script>
    <script src="js/script.js"></script>
    <script src="js/login-script.js"></script>