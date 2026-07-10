<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>

<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);" data-preset='{"title":"Breadcrumbs","category":"header","reload":false,"id":"breadcrumbs"}'>
    <div class="container">
        <h4 class="breadcrumbs-custom-title">通知公告</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="AboutNingXia.jsp">咨询</a></li>
            <li class="active">通知公告</li>
        </ul>
    </div>
</section>

<section class="section section-lg bg-default">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-8">
                <h2 class="text-center mb-6">通知公告</h2>
                <div id="notice-list-container"></div>
            </div>
        </div>
    </div>
</section>

<style>
    .notice-item { 
        display: flex; 
        align-items: center; 
        padding: 16px 0; 
        border-bottom: 1px solid #f0f0f0; 
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .notice-item:hover {
        background-color: #fafafa;
    }
    .notice-item:last-child { 
        border-bottom: none; 
    }
    .notice-badge { 
        background: #00a8a8; 
        color: white; 
        font-size: 14px; 
        padding: 4px 10px; 
        border-radius: 4px; 
        margin-right: 16px; 
        flex-shrink: 0; 
    }
    .notice-title { 
        font-size: 16px; 
        color: #333; 
    }
</style>

<script>
    var noticeData = [
        { badge: '公告', title: '宁夏旅游景区门票价格调整通知' },
        { badge: '公告', title: '暑期旅游安全提示' },
        { badge: '公告', title: '部分景区临时闭园维护通知' },
        { badge: '公告', title: '宁夏旅游惠民政策解读' },
        { badge: '通知', title: '关于开展文明旅游宣传月活动的通知' },
        { badge: '通知', title: '宁夏旅游投诉热线变更公告' },
        { badge: '公告', title: '节假日景区限流措施公告' },
        { badge: '通知', title: '导游资格证考试报名通知' },
        { badge: '公告', title: '旅游服务质量提升行动方案' },
        { badge: '通知', title: '冬季旅游优惠政策发布' }
    ];
    var container = document.getElementById('notice-list-container');
    noticeData.forEach(function(item) {
        var noticeItem = document.createElement('div');
        noticeItem.className = 'notice-item';
        noticeItem.innerHTML = '<span class="notice-badge">' + item.badge + '</span>' +
            '<span class="notice-title">' + item.title + '</span>';
        container.appendChild(noticeItem);
    });
</script>