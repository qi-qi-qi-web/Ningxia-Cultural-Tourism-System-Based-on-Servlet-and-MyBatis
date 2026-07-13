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
                                <!--Brand--><a class="brand" href="index.jsp"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt="" width="112" height="19"/><img class="brand-logo-light" src="images/logo-default-225x39.png" alt="" width="112" height="19"/></a>
                            </div>
                        </div>
                        <div class="rd-navbar-main-element">
                            <div class="rd-navbar-nav-wrap">
                                <ul class="rd-navbar-nav">
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="index.jsp">首页</a>
                                    </li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="AboutNingXia.jsp">关于宁夏</a>
                                    </li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="ScenicService.jsp">景区服务</a>
                                    </li>
                                    <li class="rd-nav-item"><a class="rd-nav-link" href="Specialty.jsp">宁夏特产</a>
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
            <div class="modal-content wechat-modal">
                <div class="modal-header wechat-modal__header">
                    <h4 class="modal-title wechat-modal__title" id="login-modal-label">用户登录</h4>
                    <button type="button" class="close wechat-modal__close" data-bs-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body wechat-modal__body">
                    <form id="login-form" method="post" action="/login" novalidate>
                        <div class="wechat-modal__field">
                            <input class="wechat-modal__input" id="login-email" type="text" name="phoneOrEmail" placeholder="用户名/邮箱">
                        </div>
                        <div class="wechat-modal__field">
                            <input class="wechat-modal__input" id="login-password" type="password" name="password" placeholder="密码">
                        </div>
                        <div class="wechat-modal__action">
                            <button class="wechat-modal__btn" type="button" onclick="handleLogin()">登录</button>
                        </div>
                        <div class="wechat-modal__links">
                            <a href="javascript:void(0)" class="wechat-modal__link" onclick="switchModal('login-modal','register-modal')">注册账户</a>
                            <span class="wechat-modal__sep">|</span>
                            <a href="javascript:void(0)" class="wechat-modal__link" onclick="switchModal('login-modal','admin-login-modal')">管理员登录</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- Register Modal -->
    <div class="modal fade" id="register-modal" tabindex="-1" role="dialog" aria-labelledby="register-modal-label" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content wechat-modal">
                <div class="modal-header wechat-modal__header">
                    <h4 class="modal-title wechat-modal__title" id="register-modal-label">用户注册</h4>
                    <button type="button" class="close wechat-modal__close" data-bs-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body wechat-modal__body">
                    <form id="register-form" method="post" action="#" onsubmit="return handleRegister(event)" novalidate>
                        <div class="wechat-modal__field">
                            <input class="wechat-modal__input" id="register-username" type="text" name="username" placeholder="用户名">
                        </div>
                        <div class="wechat-modal__field">
                            <input class="wechat-modal__input" id="register-phone" type="tel" name="phone" placeholder="手机号">
                        </div>
                        <div class="wechat-modal__field">
                            <input class="wechat-modal__input" id="register-password" type="password" name="password" placeholder="密码（至少6位）">
                        </div>
                        <div class="wechat-modal__field">
                            <input class="wechat-modal__input" id="register-confirm-password" type="password" name="confirmPassword" placeholder="确认密码">
                        </div>
                        <div class="wechat-modal__action">
                            <button class="wechat-modal__btn" type="submit">注册</button>
                        </div>
                        <div class="wechat-modal__links">
                            <span style="font-size: 14px; color: #888;">已有账号?</span>
                            <a href="javascript:void(0)" class="wechat-modal__link" style="margin-left: 4px;" onclick="switchModal('register-modal','login-modal')">立即登录</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- Admin Login Modal -->
    <div class="modal fade" id="admin-login-modal" tabindex="-1" role="dialog" aria-labelledby="admin-login-modal-label" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content wechat-modal">
                <div class="modal-header wechat-modal__header">
                    <h4 class="modal-title wechat-modal__title" id="admin-login-modal-label">管理员登录</h4>
                    <button type="button" class="close wechat-modal__close" onclick="closeModal('admin-login-modal')" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body wechat-modal__body">
                    <form id="admin-login-form" method="post" action="#" onsubmit="return handleAdminLogin(event)" novalidate>
                        <div class="wechat-modal__field">
                            <input class="wechat-modal__input" id="admin-username" type="text" name="username" placeholder="管理员账号">
                        </div>
                        <div class="wechat-modal__field">
                            <input class="wechat-modal__input" id="admin-password" type="password" name="password" placeholder="密码">
                        </div>
                        <div class="wechat-modal__action">
                            <button class="wechat-modal__btn" type="submit">管理员登录</button>
                        </div>
                        <div class="wechat-modal__links">
                            <a href="javascript:void(0)" class="wechat-modal__link" onclick="switchModal('admin-login-modal','login-modal')">普通用户登录</a>
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
    <script>
        // Close modal via Bootstrap API + safety cleanup
        function closeModal(id) {
            var el = document.getElementById(id);
            if (el) {
                var modal = bootstrap.Modal.getInstance(el);
                if (modal) {
                    modal.hide();
                }
            }
            // Safety: if backdrop remains after animation, force-remove it
            setTimeout(function() {
                var backdrop = document.querySelector('.modal-backdrop');
                if (backdrop) {
                    backdrop.remove();
                    document.body.classList.remove('modal-open');
                    document.body.style.paddingRight = '';
                    document.body.style.overflow = '';
                }
            }, 400);
        }
        // Switch from one modal to another – smooth, no jank
        function switchModal(fromId, toId) {
            var fromEl = document.getElementById(fromId);
            if (!fromEl) return;
            var bsModal = bootstrap.Modal.getInstance(fromEl);
            if (bsModal) {
                var handler = function() {
                    fromEl.removeEventListener('hidden.bs.modal', handler);
                    var target = document.getElementById(toId);
                    if (target) {
                        var old = bootstrap.Modal.getInstance(target);
                        if (old) old.dispose();
                        (new bootstrap.Modal(target)).show();
                    }
                };
                fromEl.addEventListener('hidden.bs.modal', handler);
                bsModal.hide();
            }
        }
        // Global safety: auto-cleanup when any modal finishes hiding
        document.addEventListener('hidden.bs.modal', function() {
            var backdrops = document.querySelectorAll('.modal-backdrop');
            if (backdrops.length) {
                backdrops.forEach(function(b) { b.remove(); });
                document.body.classList.remove('modal-open');
                document.body.style.paddingRight = '';
                document.body.style.overflow = '';
            }
        });
        document.addEventListener('DOMContentLoaded', function() {
            var currentUrl = window.location.pathname;
            var currentPage = currentUrl.substring(currentUrl.lastIndexOf('/') + 1);
            
            if (!currentPage || currentPage === '') {
                currentPage = 'index.jsp';
            }
            
            var navItems = document.querySelectorAll('.rd-navbar-nav .rd-nav-item');
            navItems.forEach(function(item) {
                item.classList.remove('active');
            });
            
            navItems.forEach(function(item) {
                var link = item.querySelector('a');
                if (link) {
                    var href = link.getAttribute('href');
                    if (href && (href === currentPage || 
                        (currentPage === 'index.html' && href === 'index.jsp') ||
                        (currentPage === 'index.jsp' && href === 'index.html'))) {
                        item.classList.add('active');
                    }
                }
	        });
		    });
		</script>
