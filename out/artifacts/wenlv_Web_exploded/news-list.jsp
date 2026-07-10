<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>

<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);" data-preset='{"title":"Breadcrumbs","category":"header","reload":false,"id":"breadcrumbs"}'>
    <div class="container">
<%--        <h4 class="breadcrumbs-custom-title">新闻动态</h4>--%>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="AboutNingXia.jsp">咨询</a></li>
            <li class="active">新闻动态</li>
        </ul>
    </div>
</section>

<section class="section section-lg bg-default">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-8">
                <h2 class="text-center mb-6">新闻动态</h2>
                <div id="news-list-container"></div>
            </div>
        </div>
    </div>
</section>

<style>
    .news-item { 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        padding: 16px 0; 
        border-bottom: 1px solid #f0f0f0; 
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .news-item:hover {
        background-color: #fafafa;
    }
    .news-item:last-child { 
        border-bottom: none; 
    }
    .news-number { 
        width: 28px; 
        height: 28px; 
        background: #00a8a8; 
        color: white; 
        display: inline-flex; 
        align-items: center; 
        justify-content: center; 
        border-radius: 50%; 
        font-size: 14px; 
        margin-right: 16px; 
        flex-shrink: 0; 
    }
    .news-title { 
        flex-grow: 1; 
        font-size: 16px; 
        color: #333; 
        white-space: nowrap; 
        overflow: hidden; 
        text-overflow: ellipsis; 
    }
    .news-date { 
        font-size: 14px; 
        color: #999; 
        margin-left: 16px; 
        flex-shrink: 0; 
    }
</style>

<script>
    var newsData = [
        { title: '宁夏夏季旅游旺季即将到来，各大景区准备就绪', date: '2026-06-12' },
        { title: '沙湖景区新开放水上项目，吸引游客体验', date: '2026-06-08' },
        { title: '宁夏旅游文化节盛大开幕，展现塞上江南魅力', date: '2026-06-01' },
        { title: '镇北堡西部影城推出暑期优惠活动', date: '2026-05-28' },
        { title: '中卫沙漠旅游度假区升级改造完成', date: '2026-05-20' },
        { title: '贺兰山岩画景区新增VR体验项目', date: '2026-05-15' },
        { title: '宁夏美食文化节将于本月底举办', date: '2026-05-10' },
        { title: '青铜峡黄河大峡谷景区开放夜游项目', date: '2026-05-05' },
        { title: '宁夏智慧旅游平台正式上线运行', date: '2026-04-28' },
        { title: '沙坡头景区荣获国家5A级旅游景区称号', date: '2026-04-20' }
    ];
    var container = document.getElementById('news-list-container');
    newsData.forEach(function(item, index) {
        var newsItem = document.createElement('div');
        newsItem.className = 'news-item';
        newsItem.innerHTML = '<span class="news-number">' + (index + 1) + '</span>' +
            '<span class="news-title">' + item.title + '</span>' +
            '<span class="news-date">' + item.date + '</span>';
        container.appendChild(newsItem);
    });
</script>