<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>

<script>
    var isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
    var isAdminLoggedIn = localStorage.getItem('isAdminLoggedIn') === 'true';
    if (!isLoggedIn && !isAdminLoggedIn) {
        alert('请先登录！');
        window.location.href = 'index.jsp';
    }

    // 从服务端获取的用户数据（由 PersonalCenterServlet 设置）
    var serverUser = {
        avatar: '${user.avatar}',
        username: '${user.username}',
        nickname: '${user.nickname}',
        phone: '${user.phone}',
        email: '${user.email}',
        role: '${user.role}'
    };

    // 如果直接访问 PersonalCenter.jsp 而没有经过 servlet，重定向到 /personalCenter
    if (!serverUser.username && isLoggedIn) {
        window.location.href = 'personalCenter';
    }

    // 页面加载后从后端获取最新的用户信息（含头像），确保与数据库同步
    function fetchServerUser() {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '/personalCenter?action=me', true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText);
                        console.log('fetchServerUser 响应:', data);
                        if (data.username) {
                            serverUser.avatar = data.avatar || '';
                            serverUser.nickname = data.nickname || '';
                            serverUser.username = data.username || '';
                            serverUser.phone = data.phone || '';
                            serverUser.email = data.email || '';
                            serverUser.role = data.role || '';
                            // 重新加载用户信息（会从 serverUser 读取最新数据）
                            loadUserInfo();
                        } else {
                            console.log('fetchServerUser: 服务端返回的头像为空');
                        }
                    } catch(e) {
                        console.error('fetchServerUser 解析失败:', e);
                    }
                } else {
                    console.error('fetchServerUser 请求失败:', xhr.status);
                }
            }
        };
        xhr.send();
    }
</script>

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
        border-radius: 10px;
        padding: 15px 0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    }
    .nav-item-custom {
        padding: 15px 25px;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 15px;
        color: #666;
        transition: all 0.3s ease;
        border-left: 3px solid transparent;
    }
    .nav-item-custom:hover {
        background: #f8f9fa;
        color: #00a8a8;
    }
    .nav-item-custom.active {
        background: #e8f5f5;
        color: #00a8a8;
        border-left-color: #00a8a8;
    }
    .nav-icon {
        font-size: 16px;
    }
    .content-card {
        background: #fff;
        border-radius: 10px;
        padding: 25px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        margin-bottom: 20px;
        position: relative;
        min-height: 200px;
    }
    .content-title {
        font-size: 18px;
        font-weight: 600;
        color: #333;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px solid #f5f5f5;
    }
    .form-group-custom {
        margin-bottom: 20px;
    }
    .form-label-custom {
        display: block;
        font-size: 14px;
        font-weight: 500;
        color: #333;
        margin-bottom: 8px;
    }
    .form-input-custom {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        font-size: 14px;
        transition: border-color 0.3s ease;
    }
    .form-input-custom:focus {
        outline: none;
        border-color: #00a8a8;
    }
    .form-input-custom:read-only {
        background: #f8f9fa;
        color: #999;
    }
    .btn-primary-custom {
        padding: 10px 30px;
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
        font-size: 48px;
        margin-bottom: 15px;
        color: #ddd;
    }
    .empty-text {
        font-size: 14px;
    }
    .tab-content-main {
        display: none;
    }
    .tab-content-main.active {
        display: block;
    }
    .order-card {
        border: 1px solid #eee;
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
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0, 0, 0, 0.5);
    }
    .modal-dialog {
        position: relative;
        width: auto;
        max-width: 500px;
        margin: 10% auto;
        background: #fff;
        border-radius: 10px;
        overflow: hidden;
    }
    .modal-content {
        padding: 0;
    }
    .modal-header {
        padding: 20px 25px;
        border-bottom: 1px solid #eee;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .modal-title {
        font-size: 18px;
        font-weight: 600;
        color: #333;
    }
    .modal-header .close {
        font-size: 24px;
        cursor: pointer;
        color: #999;
        border: none;
        background: none;
    }
    .modal-header .close:hover {
        color: #333;
    }
    .modal-body {
        padding: 25px;
    }
    .snackbar {
        position: fixed;
        bottom: 30px;
        right: 30px;
        padding: 15px 25px;
        border-radius: 8px;
        color: #fff;
        font-size: 14px;
        z-index: 2000;
        opacity: 0;
        transform: translateY(20px);
        transition: all 0.3s ease;
    }
    .snackbar.show {
        opacity: 1;
        transform: translateY(0);
    }
    .snackbar.success {
        background: linear-gradient(135deg, #4caf50 0%, #66bb6a 100%);
    }
    .snackbar.error {
        background: linear-gradient(135deg, #e74c3c 0%, #ef5350 100%);
    }
    .snackbar.info {
        background: linear-gradient(135deg, #2196f3 0%, #42a5f5 100%);
    }
</style>

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
                        我的攻略
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
                <div id="tab-profile" class="tab-content-main active">
                    <div class="content-card" id="profile-content">
                        <div class="content-title">基本信息</div>
                        <div style="display: flex; align-items: flex-start; margin-bottom: 25px;">
                            <div style="margin-right: 25px; text-align: center;">
                                <img id="profile-avatar-img" src="images/avatar-1.png" alt="头像" style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 2px solid #e0e0e0; cursor: pointer;" onclick="openAvatarModal()">
                                <div style="margin-top: 8px;">
                                    <button class="btn-secondary-custom" onclick="openAvatarModal()" style="font-size: 12px; padding: 4px 10px;">更换头像</button>
                                </div>
                            </div>
                            <div style="flex: 1;">
                                <div style="display: flex; align-items: center; margin-bottom: 8px;">
                                    <span style="font-size: 16px; color: #666; margin-right: 8px;">昵称：</span>
                                    <span id="info-nickname-text" style="font-size: 16px; color: #333;">admin</span>
                                </div>
                                <div style="display: flex; align-items: center;">
                                    <span style="font-size: 16px; color: #666; margin-right: 8px;">账号：</span>
                                    <span id="info-username-text" style="font-size: 16px; color: #333;">123004983294</span>
                                </div>
                            </div>
                        </div>
                        <div class="row" style="margin-bottom: 30px;">
                            <div class="col-md-6">
                                <div style="display: flex; align-items: center;">
                                    <span style="font-size: 16px; color: #666; margin-right: 16px;">手机号：</span>
                                    <span id="info-phone-text" style="font-size: 16px; color: #333;">12312312312</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div style="display: flex; align-items: center;">
                                    <span style="font-size: 16px; color: #666; margin-right: 8px;">邮箱：</span>
                                    <span id="info-email-text" style="font-size: 16px; color: #333;">2383921983@qq.com</span>
                                </div>
                            </div>
                        </div>
                        <div style="position: absolute; bottom: 10px; left: 25px;">
                            <button class="btn-primary-custom" onclick="openEditModal()">编辑</button>
                        </div>
                    </div>
                </div>

                <div id="tab-posts" class="tab-content-main" style="display: none;">
                    <div class="content-card">
                        <div class="content-title">我的攻略</div>
                        <div class="empty-state">
                            <div class="empty-icon"><i class="fa fa-edit"></i></div>
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
                                <div class="order-no">订单号: JD20260709004</div>
                                <div class="order-status unpaid">待支付</div>
                            </div>
                            <div class="order-content">
                                <img src="images/service-4-370x389.jpg" alt="腾格里沙漠营地" class="order-img">
                                <div class="order-info">
                                    <div class="order-title">腾格里沙漠营地</div>
                                    <div class="order-detail">入住日期: 2026-07-20 | 房型: 沙漠帐篷房</div>
                                </div>
                            </div>
                            <div class="order-footer">
                                <div class="order-price">￥880.00</div>
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
                                    <div class="order-detail">数量: 4张 | 使用日期: 2026-07-03</div>
                                </div>
                            </div>
                            <div class="order-footer">
                                <div class="order-price">￥320.00</div>
                                <button class="btn-secondary-custom">查看详情</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

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
                        <div class="form-label-custom">账号（不可修改）</div>
                        <input class="form-input-custom" id="edit-username" type="text" name="username" readonly placeholder="请输入账号">
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

<!-- 头像选择弹窗 -->
<div id="avatar-modal" class="modal" style="display: none;">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 520px;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">选择头像</h4>
                <button type="button" class="close" onclick="closeAvatarModal()">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p style="color: #999; font-size: 13px; margin-bottom: 18px;">点击选择一个你喜欢的头像</p>
                <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; justify-items: center;">
                    <div class="avatar-option" data-avatar="images/avatar-1.png" onclick="selectAvatar(this)" style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; border: 3px solid transparent; cursor: pointer; transition: all 0.3s ease;">
                        <img src="images/avatar-1.png" alt="头像1" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                    <div class="avatar-option" data-avatar="images/avatar-2.png" onclick="selectAvatar(this)" style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; border: 3px solid transparent; cursor: pointer; transition: all 0.3s ease;">
                        <img src="images/avatar-2.png" alt="头像2" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                    <div class="avatar-option" data-avatar="images/avatar-3.png" onclick="selectAvatar(this)" style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; border: 3px solid transparent; cursor: pointer; transition: all 0.3s ease;">
                        <img src="images/avatar-3.png" alt="头像3" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                    <div class="avatar-option" data-avatar="images/avatar-4.png" onclick="selectAvatar(this)" style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; border: 3px solid transparent; cursor: pointer; transition: all 0.3s ease;">
                        <img src="images/avatar-4.png" alt="头像4" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                    <div class="avatar-option" data-avatar="images/avatar-5.png" onclick="selectAvatar(this)" style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; border: 3px solid transparent; cursor: pointer; transition: all 0.3s ease;">
                        <img src="images/avatar-5.png" alt="头像5" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                    <div class="avatar-option" data-avatar="images/avatar-6.png" onclick="selectAvatar(this)" style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; border: 3px solid transparent; cursor: pointer; transition: all 0.3s ease;">
                        <img src="images/avatar-6.png" alt="头像6" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                    <div class="avatar-option" data-avatar="images/avatar-7.png" onclick="selectAvatar(this)" style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; border: 3px solid transparent; cursor: pointer; transition: all 0.3s ease;">
                        <img src="images/avatar-7.png" alt="头像7" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                    <div class="avatar-option" data-avatar="images/avatar-8.png" onclick="selectAvatar(this)" style="width: 80px; height: 80px; border-radius: 50%; overflow: hidden; border: 3px solid transparent; cursor: pointer; transition: all 0.3s ease;">
                        <img src="images/avatar-8.png" alt="头像8" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                </div>
                <div style="margin-top: 25px; text-align: center;">
                    <button class="btn-primary-custom" id="confirm-avatar-btn" onclick="confirmAvatar()" disabled style="opacity: 0.5; cursor: not-allowed;">确认更换</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function showTab(tabName, event) {
        var tabs = ['profile', 'posts', 'comments', 'collections', 'orders'];
        tabs.forEach(function(tab) {
            var el = document.getElementById('tab-' + tab);
            if (el) {
                el.style.display = (tab === tabName) ? 'block' : 'none';
            }
        });

        var navItems = document.querySelectorAll('.nav-item-custom');
        navItems.forEach(function(item) {
            item.classList.remove('active');
        });
        if (event) {
            event.currentTarget.classList.add('active');
        }
    }

    function showEditProfile() {
        showTab('profile');
    }

    function openEditModal() {
        // 从 serverUser 或 localStorage 读取真实数据，避免将 "未填写" 带入编辑框
        var username = (serverUser && serverUser.username) ? serverUser.username : (localStorage.getItem('userUsername') || '');
        var nickname = (serverUser && serverUser.nickname) ? serverUser.nickname : (localStorage.getItem('userNickname') || '');
        var phone = (serverUser && serverUser.phone) ? serverUser.phone : (localStorage.getItem('userPhone') || '');
        var email = (serverUser && serverUser.email) ? serverUser.email : (localStorage.getItem('userEmail') || '');

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
        var nickname = document.getElementById('edit-nickname').value;
        var phone = document.getElementById('edit-phone').value;
        var email = document.getElementById('edit-email').value;

        if (!nickname || nickname.trim() === '') {
            showToastLocal('昵称不能为空', 'error');
            return false;
        }

        // 先乐观更新本地显示
        var username = document.getElementById('edit-username').value;
        localStorage.setItem('userUsername', username);
        localStorage.setItem('userNickname', nickname);
        localStorage.setItem('userPhone', phone);
        localStorage.setItem('userEmail', email);

        // 同步更新 serverUser
        if (serverUser) {
            serverUser.username = username;
            serverUser.nickname = nickname;
            serverUser.phone = phone;
            serverUser.email = email;
        }

        var usernameText = document.getElementById('info-username-text');
        var nicknameText = document.getElementById('info-nickname-text');
        var phoneText = document.getElementById('info-phone-text');
        var emailText = document.getElementById('info-email-text');
        
        if (usernameText) usernameText.textContent = username;
        if (nicknameText) nicknameText.textContent = nickname || '未填写';
        if (phoneText) phoneText.textContent = phone || '未填写';
        if (emailText) emailText.textContent = email || '未填写';
        
        var userNicknameEl = document.getElementById('user-nickname');
        if (userNicknameEl) userNicknameEl.textContent = nickname || username;

        // 发送 AJAX 到后端保存
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/personalCenter', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var resp = JSON.parse(xhr.responseText);
                        if (resp.success) {
                            showToastLocal('资料保存成功！', 'success');
                            checkLoginStatus();  // 刷新右上角导航栏显示
                        } else {
                            showToastLocal(resp.message || '保存失败', 'error');
                        }
                    } catch (e) {
                        console.error('保存资料响应解析失败:', xhr.responseText.substring(0, 200));
                        showToastLocal('服务器返回异常', 'error');
                    }
                } else {
                    console.error('保存资料请求失败:', xhr.status);
                    showToastLocal('网络错误（' + xhr.status + '），请重试', 'error');
                }
            }
        };
        xhr.send('action=updateProfile&nickname=' + encodeURIComponent(nickname.trim())
            + '&phone=' + encodeURIComponent(phone.trim())
            + '&email=' + encodeURIComponent(email.trim()));

        closeEditModal();
        return false;
    }

    function removeCollection(btn) {
        var item = btn.closest('.collection-item');
        item.style.opacity = '0';
        setTimeout(function() {
            item.remove();
        }, 300);
        showToastLocal('已取消收藏', 'info');
    }

    function handleLogout() {
        var previousPage = localStorage.getItem('previousPage') || 'index.jsp';
        
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('userUsername');
        localStorage.removeItem('userNickname');
        localStorage.removeItem('userPhone');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('userAvatar');
        localStorage.removeItem('userRole');
        localStorage.removeItem('userStatus');
        localStorage.removeItem('userCreatedAt');
        localStorage.removeItem('userUpdatedAt');
        localStorage.removeItem('previousPage');
        
        window.location.href = previousPage;
    }

    function loadUserInfo() {
        // 优先使用服务端数据，其次 localStorage，最后默认值
        var username = serverUser && serverUser.username ? serverUser.username : (localStorage.getItem('userUsername') || 'admin');
        var nickname = serverUser && serverUser.nickname ? serverUser.nickname : (localStorage.getItem('userNickname') || '');
        var phone = serverUser && serverUser.phone ? serverUser.phone : (localStorage.getItem('userPhone') || '');
        var email = serverUser && serverUser.email ? serverUser.email : (localStorage.getItem('userEmail') || '');
        var role = serverUser && serverUser.role ? (serverUser.role === 'ADMIN' ? '管理员' : '普通用户') : (localStorage.getItem('userRole') || '普通用户');

        // 将服务端数据回写到 localStorage，保证后续刷新也有效
        if (serverUser && serverUser.username) {
            localStorage.setItem('userUsername', username);
            localStorage.setItem('userNickname', nickname);
            localStorage.setItem('userPhone', phone);
            localStorage.setItem('userEmail', email);
            localStorage.setItem('userRole', serverUser.role === 'ADMIN' ? '管理员' : '普通用户');
        }

        var usernameText = document.getElementById('info-username-text');
        var nicknameText = document.getElementById('info-nickname-text');
        var phoneText = document.getElementById('info-phone-text');
        var emailText = document.getElementById('info-email-text');
        
        if (usernameText) usernameText.textContent = username;
        if (nicknameText) nicknameText.textContent = nickname || '未填写';
        if (phoneText) phoneText.textContent = phone || '未填写';
        if (emailText) emailText.textContent = email || '未填写';
        
        // 这些元素可能不在页面上，需要判空
        var userNicknameEl = document.getElementById('user-nickname');
        if (userNicknameEl) userNicknameEl.textContent = nickname || username;
        var userRoleEl = document.getElementById('user-role');
        if (userRoleEl) userRoleEl.textContent = role;

        // 加载头像：服务端 > localStorage > 默认
        var profileImg = document.getElementById('profile-avatar-img');
        var avatarSrc = null;

        if (serverUser && serverUser.avatar && serverUser.avatar.length > 0) {
            avatarSrc = serverUser.avatar;
            localStorage.setItem('userAvatar', avatarSrc);
            console.log('使用服务器头像:', avatarSrc);
        } else {
            avatarSrc = localStorage.getItem('userAvatar') || 'images/avatar-1.png';
            console.log('无服务器头像，使用:', avatarSrc, 'serverUser.avatar=', serverUser && serverUser.avatar);
        }

        if (profileImg) {
            profileImg.src = avatarSrc;
        }
    }

    function showToastLocal(message, type) {
        var toast = document.createElement('div');
        toast.className = 'snackbar ' + type;
        toast.textContent = message;
        document.body.appendChild(toast);

        setTimeout(function() {
            toast.classList.add('show');
        }, 100);

        setTimeout(function() {
            toast.classList.remove('show');
            setTimeout(function() {
                toast.remove();
            }, 300);
        }, 3000);
    }

    function changePassword() {
        var oldPassword = document.getElementById('old-password').value;
        var newPassword = document.getElementById('new-password').value;
        var confirmPassword = document.getElementById('confirm-password').value;

        if (!oldPassword || !newPassword || !confirmPassword) {
            showToastLocal('请填写所有字段', 'error');
            return;
        }

        if (newPassword.length < 6) {
            showToastLocal('密码长度至少6位', 'error');
            return;
        }

        if (newPassword !== confirmPassword) {
            showToastLocal('两次输入的密码不一致', 'error');
            return;
        }

        // 发送 AJAX 到后端修改密码
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/personalCenter', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var resp = JSON.parse(xhr.responseText);
                        if (resp.success) {
                            closeChangePassword();
                            showToastLocal('密码修改成功！', 'success');
                        } else {
                            showToastLocal(resp.message || '密码修改失败', 'error');
                        }
                    } catch (e) {
                        console.error('修改密码响应解析失败:', xhr.responseText.substring(0, 200));
                        showToastLocal('服务器返回异常', 'error');
                    }
                } else {
                    console.error('修改密码请求失败:', xhr.status);
                    showToastLocal('网络错误（' + xhr.status + '），请重试', 'error');
                }
            }
        };
        xhr.send('action=changePassword&oldPassword=' + encodeURIComponent(oldPassword)
            + '&newPassword=' + encodeURIComponent(newPassword));
    }

    function closeChangePassword() {
        document.getElementById('change-password-modal').style.display = 'none';
        document.body.style.overflow = '';
    }

    /* ========== 头像选择功能 ========== */
    var selectedAvatar = null;

    function openAvatarModal() {
        selectedAvatar = null;
        document.getElementById('confirm-avatar-btn').disabled = true;
        document.getElementById('confirm-avatar-btn').style.opacity = '0.5';
        document.getElementById('confirm-avatar-btn').style.cursor = 'not-allowed';

        // 清除所有选中状态
        document.querySelectorAll('.avatar-option').forEach(function(el) {
            el.style.borderColor = 'transparent';
        });

        // 高亮当前正在使用的头像
        var currentAvatar = document.getElementById('profile-avatar-img').src;
        var currentPath = currentAvatar.substring(currentAvatar.lastIndexOf('/images/'));
        document.querySelectorAll('.avatar-option').forEach(function(el) {
            var avatarPath = el.getAttribute('data-avatar');
            if (avatarPath && currentPath.indexOf(avatarPath) !== -1) {
                el.style.borderColor = '#00a8a8';
                selectedAvatar = avatarPath;
            }
        });

        document.getElementById('avatar-modal').style.display = 'block';
        document.body.style.overflow = 'hidden';
    }

    function closeAvatarModal() {
        document.getElementById('avatar-modal').style.display = 'none';
        document.body.style.overflow = '';
        selectedAvatar = null;
    }

    function selectAvatar(element) {
        // 清除其他选中
        document.querySelectorAll('.avatar-option').forEach(function(el) {
            el.style.borderColor = 'transparent';
        });
        // 高亮当前选中
        element.style.borderColor = '#00a8a8';
        selectedAvatar = element.getAttribute('data-avatar');

        // 启用确认按钮
        document.getElementById('confirm-avatar-btn').disabled = false;
        document.getElementById('confirm-avatar-btn').style.opacity = '1';
        document.getElementById('confirm-avatar-btn').style.cursor = 'pointer';
    }

    function confirmAvatar() {
        if (!selectedAvatar) {
            showToastLocal('请先选择一个头像', 'error');
            return;
        }

        // 先更新本地显示（乐观更新）
        var profileImg = document.getElementById('profile-avatar-img');
        if (profileImg) {
            profileImg.src = selectedAvatar;
        }
        localStorage.setItem('userAvatar', selectedAvatar);

        // 发送 AJAX 请求到后端保存
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/personalCenter', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var resp = JSON.parse(xhr.responseText);
                        if (resp.success) {
                            showToastLocal('头像更换成功！', 'success');
                        } else {
                            showToastLocal(resp.message || '头像更换失败', 'error');
                        }
                    } catch (e) {
                        // 解析失败说明后端返回了非 JSON 内容（可能是错误页）
                        console.error('头像保存响应解析失败:', xhr.responseText.substring(0, 200));
                        showToastLocal('服务器返回异常，请刷新后重试', 'error');
                    }
                } else {
                    console.error('头像保存请求失败:', xhr.status, xhr.statusText);
                    showToastLocal('网络错误（' + xhr.status + '），请重试', 'error');
                }
            }
        };
        xhr.send('action=changeAvatar&avatar=' + encodeURIComponent(selectedAvatar));

        closeAvatarModal();
    }

    window.addEventListener('load', function() {
        loadUserInfo();
        fetchServerUser();
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
    });

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
