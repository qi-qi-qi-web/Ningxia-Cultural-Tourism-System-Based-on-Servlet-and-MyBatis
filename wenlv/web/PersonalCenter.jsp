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
        .profile-page {
            min-height: calc(100vh - 200px);
            background-color: #f5f7fa;
        }
        .user-header-card {
            background: linear-gradient(135deg, #00a8a8 0%, #008a8a 100%);
            padding: 40px 30px;
            border-radius: 12px;
            color: #fff;
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }
        .user-header-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }
        .user-header-card::after {
            content: '';
            position: absolute;
            bottom: -30%;
            left: -10%;
            width: 150px;
            height: 150px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
        }
        .avatar-container {
            position: relative;
            z-index: 1;
        }
        .avatar-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255, 255, 255, 0.3);
        }
        .user-info {
            position: relative;
            z-index: 1;
        }
        .user-nickname {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .user-role {
            display: inline-block;
            padding: 4px 12px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            font-size: 12px;
            margin-bottom: 15px;
        }
        .user-stats {
            display: flex;
            gap: 30px;
        }
        .stat-item {
            text-align: center;
        }
        .stat-value {
            font-size: 22px;
            font-weight: 700;
        }
        .stat-label {
            font-size: 12px;
            opacity: 0.8;
        }
        .edit-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            z-index: 1;
            padding: 8px 20px;
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 20px;
            color: #fff;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .edit-btn:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        .sidebar-nav {
            background: #fff;
            border-radius: 12px;
            padding: 15px 0;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
        }
        .nav-item-custom {
            padding: 12px 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 15px;
            color: #555;
        }
        .nav-item-custom:hover {
            background: #f0f8f8;
            color: #00a8a8;
        }
        .nav-item-custom.active {
            background: linear-gradient(90deg, #e8f7f7 0%, #fff 100%);
            color: #00a8a8;
            font-weight: 500;
        }
        .nav-item-custom.active::before {
            content: '';
            width: 4px;
            height: 20px;
            background: #00a8a8;
            border-radius: 2px;
        }
        .nav-icon {
            font-size: 18px;
            width: 24px;
            text-align: center;
        }
        .content-card {
            background: #fff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            min-height: 400px;
        }
        .content-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 25px;
            color: #333;
            padding-bottom: 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        .form-group-custom {
            margin-bottom: 20px;
        }
        .form-label-custom {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #555;
            margin-bottom: 8px;
        }
        .form-input-custom {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
        }
        .form-input-custom:focus {
            outline: none;
            border-color: #00a8a8;
            box-shadow: 0 0 0 3px rgba(0, 168, 168, 0.1);
        }
        .form-input-custom[readonly] {
            background: #fafafa;
            color: #999;
        }
        .btn-primary-custom {
            padding: 12px 30px;
            background: linear-gradient(135deg, #00a8a8 0%, #00d4aa 100%);
            border: none;
            border-radius: 8px;
            color: #fff;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 168, 168, 0.3);
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-icon {
            font-size: 64px;
            color: #e0e0e0;
            margin-bottom: 20px;
        }
        .empty-text {
            font-size: 16px;
            color: #bbb;
        }
        .order-card {
            border: 1px solid #f0f0f0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        .order-card:hover {
            border-color: #00a8a8;
            box-shadow: 0 2px 8px rgba(0, 168, 168, 0.1);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .order-no {
            font-size: 14px;
            color: #666;
        }
        .order-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        .order-status.paid {
            background: #e8f5e9;
            color: #4caf50;
        }
        .order-status.unpaid {
            background: #fff3e0;
            color: #ff9800;
        }
        .order-status.used {
            background: #f5f5f5;
            color: #999;
        }
        .order-content {
            display: flex;
            gap: 15px;
        }
        .order-img {
            width: 80px;
            height: 60px;
            border-radius: 6px;
            object-fit: cover;
        }
        .order-info {
            flex: 1;
        }
        .order-title {
            font-size: 16px;
            font-weight: 500;
            color: #333;
            margin-bottom: 5px;
        }
        .order-detail {
            font-size: 13px;
            color: #999;
        }
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #f5f5f5;
        }
        .order-price {
            font-size: 18px;
            font-weight: 600;
            color: #e74c3c;
        }
        .collection-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        .collection-item {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }
        .collection-item:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
        }
        .collection-img {
            width: 100%;
            height: 160px;
            object-fit: cover;
        }
        .collection-info {
            padding: 15px;
        }
        .collection-title {
            font-size: 16px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
        }
        .collection-desc {
            font-size: 13px;
            color: #999;
            margin-bottom: 12px;
        }
        .collection-actions {
            display: flex;
            justify-content: flex-end;
        }
        .collection-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .filter-btn {
            padding: 8px 18px;
            background: #f5f5f5;
            border: none;
            border-radius: 20px;
            color: #666;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .filter-btn:hover {
            background: #e8f5f5;
            color: #00a8a8;
        }
        .filter-btn.active {
            background: linear-gradient(135deg, #00a8a8 0%, #00d4aa 100%);
            color: #fff;
        }
        .btn-secondary-custom {
            padding: 6px 14px;
            background: #f5f5f5;
            border: none;
            border-radius: 6px;
            color: #666;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-secondary-custom:hover {
            background: #eee;
            color: #00a8a8;
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

    <section class="profile-page section section-lg">
        <div class="container">
            <div class="row">
                <div class="col-xl-3 col-lg-4">
                    <div class="sidebar-nav">
                        <div class="nav-item-custom active" onclick="showTab('profile', event)">
                            <span class="nav-icon"><i class="fa fa-user"></i></span>
                            个人资料
                        </div>
                        <div class="nav-item-custom" onclick="showTab('posts', event)">
                            <span class="nav-icon"><i class="fa fa-edit"></i></span>
                            我的发布
                        </div>
                        <div class="nav-item-custom" onclick="showTab('comments', event)">
                            <span class="nav-icon"><i class="fa fa-comment"></i></span>
                            我的评论
                        </div>
                        <div class="nav-item-custom" onclick="showTab('collections', event)">
                            <span class="nav-icon"><i class="fa fa-heart"></i></span>
                            我的收藏
                        </div>
                        <div class="nav-item-custom" onclick="showTab('orders', event)">
                            <span class="nav-icon"><i class="fa fa-shopping-cart"></i></span>
                            我的订单
                        </div>
                        <div class="nav-item-custom" onclick="handleLogout()">
                            <span class="nav-icon"><i class="fa fa-sign-out"></i></span>
                            退出登录
                        </div>
                    </div>
                </div>

                <div class="col-xl-9 col-lg-8">
                    <div id="tab-profile" class="tab-content-main">
                        <div class="user-header-card">
                            <div class="user-info">
                                <div class="user-nickname" id="user-nickname">用户</div>
                                <div class="user-role" id="user-role-tag">普通用户</div>
                                <div class="user-role" id="user-role-tag">状态正常</div>
                                <div class="user-role" id="user-role-tag">不可发表</div>
                            </div>
                        </div>

                        <div class="content-card" id="profile-content">
                            <div class="content-title">基本信息</div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group-custom">
                                        <div class="form-label-custom">账号</div>
                                        <input class="form-input-custom" id="info-username" type="text" name="username" placeholder="请输入用户名" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group-custom">
                                        <div class="form-label-custom">昵称</div>
                                        <input class="form-input-custom" id="info-nickname" type="text" name="nickname" placeholder="请输入昵称" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group-custom">
                                        <div class="form-label-custom">手机号</div>
                                        <input class="form-input-custom" id="info-phone" type="tel" name="phone" placeholder="请输入手机号" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group-custom">
                                        <div class="form-label-custom">邮箱</div>
                                        <input class="form-input-custom" id="info-email" type="email" name="email" placeholder="请输入邮箱" readonly>
                                    </div>
                                </div>
                            </div>
                            <div style="margin-top: 25px;">
                                <button class="btn-primary-custom" onclick="openEditModal()">编辑</button>
                                <button class="btn-primary-custom" onclick="showChangePassword()">修改密码</button>
                            </div>
                        </div>
                    </div>

                    <div id="tab-posts" class="tab-content-main" style="display: none;">
                        <div class="content-card">
                            <div class="content-title">我的攻略</div>
                            <div class="empty-state">
                                <div class="empty-icon"><i class="fa fa-pencil"></i></div>
                                <div class="empty-text">暂无发布内容</div>
                            </div>
                        </div>
                    </div>

                    <div id="tab-comments" class="tab-content-main" style="display: none;">
                        <div class="content-card">
                            <div class="content-title">我的评论</div>
                            <div class="empty-state">
                                <div class="empty-icon"><i class="fa fa-comment"></i></div>
                                <div class="empty-text">暂无评论</div>
                            </div>
                        </div>
                    </div>

                    <div id="tab-collections" class="tab-content-main" style="display: none;">
                        <div class="content-card">
                            <div class="content-title">我的收藏</div>
                            <div class="collection-filter">
                                <button class="filter-btn active" onclick="switchCollection('scenic')">景区收藏</button>
                                <button class="filter-btn" onclick="switchCollection('product')">特产收藏</button>
                                <button class="filter-btn" onclick="switchCollection('hotel')">酒店收藏</button>
                                <button class="filter-btn" onclick="switchCollection('guide')">攻略收藏</button>
                            </div>
                            <div id="collection-scenic" class="collection-grid">
                                <div class="collection-item">
                                    <img src="images/img-1-720x400.jpg" alt="沙坡头景区" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">沙坡头景区</div>
                                        <div class="collection-desc">国家5A级景区，沙漠与黄河交汇的奇观</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="collection-item">
                                    <img src="images/img-2-720x400.jpg" alt="西夏王陵" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">西夏王陵</div>
                                        <div class="collection-desc">神秘的东方金字塔，探寻西夏文明</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="collection-item">
                                    <img src="images/img-3-720x400.jpg" alt="沙湖景区" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">沙湖景区</div>
                                        <div class="collection-desc">沙水相依的美景，候鸟的天堂</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collection-product" class="collection-grid" style="display: none;">
                                <div class="collection-item">
                                    <img src="images/service-1-370x389.jpg" alt="宁夏枸杞" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">宁夏枸杞</div>
                                        <div class="collection-desc">中宁特产，滋补养生佳品</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="collection-item">
                                    <img src="images/service-2-370x389.jpg" alt="盐池滩羊肉" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">盐池滩羊肉</div>
                                        <div class="collection-desc">肉质鲜嫩，无膻味，舌尖上的美味</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="collection-item">
                                    <img src="images/service-3-370x389.jpg" alt="贺兰山东麓葡萄酒" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">贺兰山东麓葡萄酒</div>
                                        <div class="collection-desc">中国葡萄酒之乡，品质卓越</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collection-hotel" class="collection-grid" style="display: none;">
                                <div class="collection-item">
                                    <img src="images/service-4-370x389.jpg" alt="黄河宿集·西坡" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">黄河宿集·西坡</div>
                                        <div class="collection-desc">网红民宿聚集地，体验慢生活</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="collection-item">
                                    <img src="images/service-5-370x389.jpg" alt="银川凯宾斯基酒店" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">银川凯宾斯基酒店</div>
                                        <div class="collection-desc">国际品牌，尊享奢华体验</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="collection-item">
                                    <img src="images/service-6-370x389.jpg" alt="腾格里沙漠营地" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">腾格里沙漠营地</div>
                                        <div class="collection-desc">星空下的沙漠露营，极致体验</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="collection-guide" class="collection-grid" style="display: none;">
                                <div class="collection-item">
                                    <img src="images/img-1-720x400.jpg" alt="宁夏三日游攻略" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">宁夏三日游攻略</div>
                                        <div class="collection-desc">经典路线，玩转宁夏精华景点</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="collection-item">
                                    <img src="images/img-2-720x400.jpg" alt="沙漠穿越攻略" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">沙漠穿越攻略</div>
                                        <div class="collection-desc">挑战自我，征服腾格里沙漠</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="collection-item">
                                    <img src="images/img-3-720x400.jpg" alt="美食探店攻略" class="collection-img">
                                    <div class="collection-info">
                                        <div class="collection-title">美食探店攻略</div>
                                        <div class="collection-desc">寻味宁夏，舌尖上的西北风情</div>
                                        <div class="collection-actions">
                                            <button class="btn-secondary-custom" onclick="removeCollection(this)">取消收藏</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="tab-orders" class="tab-content-main" style="display: none;">
                        <div class="content-card">
                            <div class="content-title">我的订单</div>
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="order-no">订单号: DD20260705001</div>
                                    <div class="order-status paid">已支付</div>
                                </div>
                                <div class="order-content">
                                    <img src="images/img-1-720x400.jpg" alt="沙坡头景区" class="order-img">
                                    <div class="order-info">
                                        <div class="order-title">沙坡头景区门票</div>
                                        <div class="order-detail">数量: 2张 | 使用日期: 2026-07-10</div>
                                    </div>
                                </div>
                                <div class="order-footer">
                                    <div class="order-price">￥280.00</div>
                                    <button class="btn-secondary-custom">查看详情</button>
                                </div>
                            </div>
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="order-no">订单号: JD20260705001</div>
                                    <div class="order-status paid">已预订</div>
                                </div>
                                <div class="order-content">
                                    <img src="images/service-1-370x389.jpg" alt="黄河宿集" class="order-img">
                                    <div class="order-info">
                                        <div class="order-title">黄河宿集·西坡</div>
                                        <div class="order-detail">入住日期: 2026-07-10 | 房型: 精致大床房</div>
                                    </div>
                                </div>
                                <div class="order-footer">
                                    <div class="order-price">￥1280.00</div>
                                    <button class="btn-secondary-custom">查看详情</button>
                                </div>
                            </div>
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="order-no">订单号: DD20260708002</div>
                                    <div class="order-status unpaid">待支付</div>
                                </div>
                                <div class="order-content">
                                    <img src="images/img-2-720x400.jpg" alt="西夏王陵" class="order-img">
                                    <div class="order-info">
                                        <div class="order-title">西夏王陵门票</div>
                                        <div class="order-detail">数量: 1张 | 使用日期: 2026-07-15</div>
                                    </div>
                                </div>
                                <div class="order-footer">
                                    <div class="order-price">￥75.00</div>
                                    <button class="btn-primary-custom">立即支付</button>
                                </div>
                            </div>
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="order-no">订单号: DD20260702005</div>
                                    <div class="order-status used">已使用</div>
                                </div>
                                <div class="order-content">
                                    <img src="images/img-3-720x400.jpg" alt="镇北堡西部影城" class="order-img">
                                    <div class="order-info">
                                        <div class="order-title">镇北堡西部影城门票</div>
                                        <div class="order-detail">数量: 4张 | 使用日期: 2026-07-02</div>
                                    </div>
                                </div>
                                <div class="order-footer">
                                    <div class="order-price">￥320.00</div>
                                    <button class="btn-secondary-custom" disabled>已完成</button>
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

    <div id="edit-profile-modal" class="modal" style="display: none;">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">编辑资料</h4>
                    <button type="button" class="close" onclick="closeEditModal()">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="edit-profile-form" onsubmit="return saveEditInfo(event)">
                        <div class="form-group-custom">
                            <div class="form-label-custom">用户名</div>
                            <input class="form-input-custom" id="edit-username" type="text" name="username" placeholder="请输入用户名">
                        </div>
                        <div class="form-group-custom">
                            <div class="form-label-custom">昵称</div>
                            <input class="form-input-custom" id="edit-nickname" type="text" name="nickname" placeholder="请输入昵称">
                        </div>
                        <div class="form-group-custom">
                            <div class="form-label-custom">手机号</div>
                            <input class="form-input-custom" id="edit-phone" type="tel" name="phone" placeholder="请输入手机号">
                        </div>
                        <div class="form-group-custom">
                            <div class="form-label-custom">邮箱</div>
                            <input class="form-input-custom" id="edit-email" type="email" name="email" placeholder="请输入邮箱">
                        </div>
                        <div style="margin-top: 25px;">
                            <button class="btn-primary-custom" type="submit">保存修改</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div id="change-password-modal" class="modal" style="display: none;">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">修改密码</h4>
                    <button type="button" class="close" onclick="closeChangePassword()">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="change-password-form">
                        <div class="form-group-custom">
                            <div class="form-label-custom">旧密码</div>
                            <input class="form-input-custom" id="old-password" type="password" placeholder="请输入旧密码">
                        </div>
                        <div class="form-group-custom">
                            <div class="form-label-custom">新密码</div>
                            <input class="form-input-custom" id="new-password" type="password" placeholder="请输入新密码（至少6位）">
                        </div>
                        <div class="form-group-custom">
                            <div class="form-label-custom">确认密码</div>
                            <input class="form-input-custom" id="confirm-password" type="password" placeholder="请再次输入新密码">
                        </div>
                        <div style="margin-top: 20px;">
                            <button class="btn-primary-custom" type="button" onclick="changePassword()">确认修改</button>
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
    document.addEventListener('DOMContentLoaded', function() {
        loadUserInfo();
    });

    function showTab(tabId, event) {
        document.querySelectorAll('.nav-item-custom').forEach(function(item) {
            item.classList.remove('active');
        });
        if (event && event.currentTarget) {
            event.currentTarget.classList.add('active');
        } else {
            document.querySelector('.nav-item-custom[onclick*="' + tabId + '"]').classList.add('active');
        }

        document.querySelectorAll('.tab-content-main').forEach(function(content) {
            content.style.display = 'none';
        });
        document.getElementById('tab-' + tabId).style.display = 'block';
    }

    function loadUserInfo() {
        var username = localStorage.getItem('userUsername') || localStorage.getItem('userEmail') || 'user';
        var nickname = localStorage.getItem('userNickname') || '';
        var phone = localStorage.getItem('userPhone') || '';
        var email = localStorage.getItem('userEmail') || '';
        var role = localStorage.getItem('userRole') || '普通用户';
        var status = localStorage.getItem('userStatus') || '正常';
        var created_at = localStorage.getItem('userCreatedAt') || '';
        var updated_at = localStorage.getItem('userUpdatedAt') || '';

        document.getElementById('user-nickname').textContent = nickname || username;
        document.getElementById('user-role-tag').textContent = role;
        document.getElementById('info-username').value = username;
        document.getElementById('info-nickname').value = nickname;
        document.getElementById('info-phone').value = phone;
        document.getElementById('info-email').value = email;
        document.getElementById('info-role').value = role;
        document.getElementById('info-status').value = status;
        document.getElementById('info-created').value = created_at;
        document.getElementById('info-updated').value = updated_at;
    }

    function showEditProfile() {
        showTab('profile');
    }

    function openEditModal() {
        var username = document.getElementById('info-username').value;
        var nickname = document.getElementById('info-nickname').value;
        var phone = document.getElementById('info-phone').value;
        var email = document.getElementById('info-email').value;

        document.getElementById('edit-username').value = username;
        document.getElementById('edit-nickname').value = nickname;
        document.getElementById('edit-phone').value = phone;
        document.getElementById('edit-email').value = email;

        document.getElementById('edit-profile-modal').style.display = 'block';
        document.body.style.overflow = 'hidden';
    }

    function closeEditModal() {
        document.getElementById('edit-profile-modal').style.display = 'none';
        document.body.style.overflow = '';
    }

    function saveEditInfo(e) {
        e.preventDefault();
        var username = document.getElementById('edit-username').value;
        var nickname = document.getElementById('edit-nickname').value;
        var phone = document.getElementById('edit-phone').value;
        var email = document.getElementById('edit-email').value;

        localStorage.setItem('userUsername', username);
        localStorage.setItem('userNickname', nickname);
        localStorage.setItem('userPhone', phone);
        localStorage.setItem('userEmail', email);

        document.getElementById('info-username').value = username;
        document.getElementById('info-nickname').value = nickname;
        document.getElementById('info-phone').value = phone;
        document.getElementById('info-email').value = email;
        document.getElementById('user-nickname').textContent = nickname || username;

        closeEditModal();
        showToast('信息保存成功！', 'success');
        return false;
    }

    function showChangePassword() {
        document.getElementById('change-password-modal').style.display = 'block';
        document.body.style.overflow = 'hidden';
    }

    function closeChangePassword() {
        document.getElementById('change-password-modal').style.display = 'none';
        document.body.style.overflow = '';
    }

    function changePassword() {
        var oldPassword = document.getElementById('old-password').value;
        var newPassword = document.getElementById('new-password').value;
        var confirmPassword = document.getElementById('confirm-password').value;

        if (!oldPassword || !newPassword || !confirmPassword) {
            showToast('请填写所有字段', 'error');
            return;
        }

        if (newPassword !== confirmPassword) {
            showToast('两次输入的密码不一致', 'error');
            return;
        }

        if (newPassword.length < 6) {
            showToast('密码长度至少6位', 'error');
            return;
        }

        showToast('密码修改成功！', 'success');
        closeChangePassword();
        document.getElementById('change-password-form').reset();
    }

    function removeCollection(btn) {
        var card = btn.closest('.collection-item');
        card.style.opacity = '0';
        card.style.transform = 'scale(0.9)';
        setTimeout(function() {
            card.remove();
            showToast('已取消收藏', 'info');
        }, 300);
    }

    function handleLogout() {
        var previousPage = localStorage.getItem('previousPage') || 'index.jsp';
        
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('userUsername');
        localStorage.removeItem('userNickname');
        localStorage.removeItem('userPhone');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('userRole');
        localStorage.removeItem('userStatus');
        localStorage.removeItem('userCreatedAt');
        localStorage.removeItem('userUpdatedAt');
        localStorage.removeItem('previousPage');
        
        window.location.href = previousPage;
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

    function switchCollection(type) {
        var filters = document.querySelectorAll('.filter-btn');
        filters.forEach(function(btn) {
            btn.classList.remove('active');
        });
        
        event.target.classList.add('active');
        
        var collections = ['scenic', 'product', 'hotel', 'guide'];
        collections.forEach(function(col) {
            var el = document.getElementById('collection-' + col);
            if (el) {
                el.style.display = (col === type) ? 'grid' : 'none';
            }
        });
    }
</script>
</body>
</html>