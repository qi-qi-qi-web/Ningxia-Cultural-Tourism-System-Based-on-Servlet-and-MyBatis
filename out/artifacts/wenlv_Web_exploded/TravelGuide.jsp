<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.TravelGuideMapper" %>
<%@ page import="com.niit.pojo.TravelGuide" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.List" %>

<%
    // 如果 servlet 没有设置 guideList（直接访问 jsp），则自行加载
    if (request.getAttribute("guideList") == null) {
        try (SqlSession s = DBUtil.getSession()) {
            request.setAttribute("guideList", s.getMapper(TravelGuideMapper.class).findPublished());
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
    }
%>

<!-- Breadcrumbs-->
<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);" data-preset='{"title":"Breadcrumbs","category":"header","reload":false,"id":"breadcrumbs"}'>
    <div class="container">
        <h4 class="breadcrumbs-custom-title">宁夏旅游攻略</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li class="active">旅游攻略</li>
        </ul>
    </div>
</section>

<!-- 精选攻略 -->
<section class="section section-lg bg-default">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-center text-md-start">宁夏精选旅游攻略</h2>
            <button onclick="showPublishGuideModal()" class="button button-primary" type="button"><span class="icon fa fa-plus"></span> 发布攻略</button>
        </div>
        <div class="row row-40 offset-lg row-xl-40">

            <c:choose>
                <c:when test="${empty guideList}">
                    <div class="col-12 text-center" style="padding: 60px 0;">
                        <p style="color: #999; font-size: 16px;">暂无攻略，快来发布第一篇吧！</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${guideList}" var="g" varStatus="vs">
                        <c:set var="delay" value="${(vs.index % 3) * 0.1 + 0.1}"/>
                        <c:set var="displayName" value="${empty g.nickname ? (empty g.userName ? '匿名用户' : g.userName) : g.nickname}"/>
                        <c:set var="avatarSrc" value="${empty g.avatar ? 'images/avatar-1.png' : g.avatar}"/>
                        <div class="col-lg-4 col-md-6 wow fadeInUp" data-wow-delay="${delay}s">
                            <div class="service-box-creative">
                                <a class="service-box-creative__media" href="TravelGuide-detail.jsp?id=${g.id}" style="display:block;height:220px;overflow:hidden;">
                                    <c:choose>
                                        <c:when test="${not empty g.coverImage}">
                                            <img src="${g.coverImage}" alt="" style="width:100%;height:100%;object-fit:cover;"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="images/tour-${(vs.index % 8) + 1}-370x284.jpg" alt="" style="width:100%;height:100%;object-fit:cover;"/>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <div class="service-box-creative__caption">
                                    <div class="d-flex align-items-center mb-2">
                                        <img src="${avatarSrc}" style="width:36px;height:36px;border-radius:50%;object-fit:cover;" onerror="this.src='images/avatar-1.png'"/>
                                        <div style="margin-left: 10px; font-weight: bold; color: #333; font-size: 14px;">${displayName}</div>
                                    </div>
                                    <h5><a href="TravelGuide-detail.jsp?id=${g.id}">${g.title}</a></h5>
                                    <c:if test="${not empty g.tags}">
                                    <div style="margin:8px 0;">
                                        <c:set var="tagArr" value="${fn:split(g.tags, ',')}"/>
                                        <c:forEach items="${tagArr}" var="tag">
                                            <c:if test="${not empty tag}">
                                            <span style="display:inline-block;padding:2px 10px;margin:2px;border-radius:12px;font-size:11px;background:#e8f5f5;color:#00a8a8;">${tag}</span>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    </c:if>
                                    <ul class="icon-list">
                                        <li><span class="icon linearicons-eye"></span><span>${g.viewCount} 浏览</span></li>
                                        <li style="cursor:pointer;" onclick="toggleFavList(${g.id}, this)" data-fav-id="${g.id}"><span class="icon fa fa-heart" style="color:#ccc;"></span><span class="fav-text">${g.favoriteCount} 收藏</span></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</section>

<!-- 四季游玩攻略 -->
<section class="section section-lg bg-gray-100">
    <div class="container">
        <h2 class="text-center mb-5">宁夏四季旅游攻略</h2>
        <div class="row row-30 text-center">
            <div class="col-md-3 col-sm-6 wow fadeInUp">
                <div class="box-classic">
                    <h5 class="text-primary">🌱 春季（3-5月）</h5>
                    <p>赏花踏青、沙湖观鸟、气候舒适</p>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 wow fadeInUp" data-wow-delay=".1s">
                <div class="box-classic">
                    <h5 class="text-primary">☀️ 夏季（6-8月）</h5>
                    <p>沙漠露营、黄河漂流、避暑胜地</p>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 wow fadeInUp" data-wow-delay=".2s">
                <div class="box-classic">
                    <h5 class="text-primary">🍂 秋季（9-10月）</h5>
                    <p>最佳旅游季，景色最美，拍照绝佳</p>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 wow fadeInUp" data-wow-delay=".3s">
                <div class="box-classic">
                    <h5 class="text-primary">❄️ 冬季（11-2月）</h5>
                    <p>温泉度假、人少景美、性价比极高</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 旅行必备贴士 -->
<section class="section section-lg bg-default">
    <div class="container">
        <h2 class="text-center mb-5">旅行必备攻略贴士</h2>
        <div class="row justify-content-center">
            <div class="col-xl-10">
                <div class="row row-30">
                    <div class="col-md-6">
                        <ul class="list-marked list-marked-primary">
                            <li>宁夏气候干燥，务必做好保湿防晒</li>
                            <li>沙漠紫外线强，墨镜、帽子、防晒霜必备</li>
                            <li>昼夜温差大，夏季也需携带薄外套</li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <ul class="list-marked list-marked-primary">
                            <li>景区间距较远，建议包车、自驾或跟团</li>
                            <li>尊重回族习俗，清真餐厅禁止外带猪肉食品</li>
                            <li>提前线上购票，避免现场排队浪费时间</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Quote -->
<section class="section section-lg bg-image-10 inset-xl">
    <div class="container">
        <div class="row">
            <div class="col-xl-8 column-bg-4">
                <div class="quote-classic-wrap wow fadeInLeft">
                    <div class="heading-4 text-xl">塞上江南，神奇宁夏</div>
                    <p class="fst-italic wow fadeInUp" data-wow-delay=".2s">一次宁夏行，一生西北情。沙漠、黄河、古迹、美食，尽在宁夏旅游攻略。</p>
                </div>
            </div>
        </div>
    </div>
</section>

<%@include file="Footer.jsp"%>
</div>

<!-- 发布攻略弹窗 -->
<div class="modal fade" id="publish-guide-modal" tabindex="-1" role="dialog" aria-labelledby="publish-guide-modal-label" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="publish-guide-modal-label">发布旅游攻略</h5>
                <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" style="padding: 30px;">
                <div style="margin-bottom: 20px;">
                    <div style="font-family: Oswald, sans-serif; font-size: 14px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.05em; color: #333; margin-bottom: 8px;">封面图片（可选）</div>
                    <input style="width: 100%; padding: 12px 16px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 15px; background: #fafafa; box-sizing: border-box; color: #333;" id="guide-cover" type="file" accept="image/*">
                </div>
                <div style="margin-bottom: 20px;">
                    <div style="font-family: Oswald, sans-serif; font-size: 14px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.05em; color: #333; margin-bottom: 8px;">攻略标题</div>
                    <input style="width: 100%; padding: 14px 16px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 15px; background: #fafafa; box-sizing: border-box; color: #333;" id="guide-title" type="text" placeholder="请输入攻略标题">
                </div>
                <div style="margin-bottom: 20px;">
                    <div style="font-family: Oswald, sans-serif; font-size: 14px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.05em; color: #333; margin-bottom: 8px;">攻略详情</div>
                    <textarea style="width: 100%; padding: 14px 16px; border: 2px solid #e0e0e0; border-radius: 6px; font-size: 15px; background: #fafafa; box-sizing: border-box; color: #333; resize: vertical;" id="guide-content" rows="8" placeholder="请详细描述您的攻略内容，包括行程安排、注意事项等"></textarea>
                </div>
                <!-- 标签选择 -->
                <div style="margin-bottom: 20px;">
                    <div style="font-family: Oswald, sans-serif; font-size: 14px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.05em; color: #333; margin-bottom: 10px;">选择标签（点击选中/取消）</div>
                    <div id="guide-tag-area" style="max-height: 280px; overflow-y: auto;">
                        <div style="text-align:center;color:#999;padding:20px;">加载标签中...</div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">

                <button type="button" class="button button-primary" onclick="submitGuide()">发布攻略</button>
            </div>
        </div>
    </div>
</div>

<div class="snackbars" id="form-output-global"></div>
<script src="js/core.min.js"></script>
<script src="js/script.js"></script>
<style>
.tag-chip { display:inline-block; padding:5px 12px; margin:3px; border:2px solid #ddd; border-radius:20px; font-size:13px; cursor:pointer; transition:all 0.2s; user-select:none; }
.tag-chip:hover { border-color:#00a8a8; background:#e8f5f5; }
.tag-chip.selected { border-color:#00a8a8; background:#00a8a8; color:#fff; }
.tag-cat-title { font-size:13px; font-weight:600; color:#666; margin:8px 0 4px 3px; }
</style>
<script>
    var guideSelectedTags = {};

    function showPublishGuideModal() {
        var isLoggedIn = sessionStorage.getItem('isLoggedIn') === 'true';
        var isAdminLoggedIn = sessionStorage.getItem('isAdminLoggedIn') === 'true';
        
        if (!isLoggedIn && !isAdminLoggedIn) {
            alert('请先登录后再发布攻略！');
            var loginModal = new bootstrap.Modal(document.getElementById('login-modal'));
            loginModal.show();
            return;
        }
        
        document.getElementById('guide-title').value = '';
        document.getElementById('guide-content').value = '';
        document.getElementById('guide-cover').value = '';
        guideSelectedTags = {};
        loadGuideTags();
        var modal = new bootstrap.Modal(document.getElementById('publish-guide-modal'));
        modal.show();
    }

    function loadGuideTags() {
        var area = document.getElementById('guide-tag-area');
        area.innerHTML = '<div style="text-align:center;color:#999;padding:20px;">加载标签中...</div>';
        fetch('/admin/guideTag?action=list')
        .then(function(r) { return r.json(); })
        .then(function(tags) {
            var catMap = { 'FEATURE': [], 'TIME': [], 'AUDIENCE': [], 'BUDGET': [] };
            var catNames = { 'FEATURE': '特点', 'TIME': '时间', 'AUDIENCE': '适合人群', 'BUDGET': '预算' };
            tags.forEach(function(t) {
                if (catMap[t.category]) catMap[t.category].push(t);
            });
            var html = '';
            for (var cat in catMap) {
                html += '<div class="tag-cat-title">' + catNames[cat] + '</div>';
                catMap[cat].forEach(function(t) {
                    html += '<span class="tag-chip" data-id="' + t.id + '" data-name="' + escHtml(t.name) + '" data-cat="' + cat + '" onclick="toggleTag(this)">' + escHtml(t.name) + '</span>';
                });
            }
            area.innerHTML = html;
        })
        .catch(function() {
            area.innerHTML = '<div style="text-align:center;color:#999;padding:20px;">加载失败</div>';
        });
    }

    function toggleTag(el) {
        var name = el.getAttribute('data-name');
        if (el.classList.contains('selected')) {
            el.classList.remove('selected');
            delete guideSelectedTags[name];
        } else {
            el.classList.add('selected');
            guideSelectedTags[name] = true;
        }
    }

    function submitGuide() {
        var title = document.getElementById('guide-title').value.trim();
        var content = document.getElementById('guide-content').value.trim();
        
        if (!title) { alert('请输入攻略标题！'); return; }
        if (!content) { alert('请输入攻略详情！'); return; }
        
        var selectedNames = Object.keys(guideSelectedTags);
        var tags = selectedNames.join(',');
        
        var formData = new FormData();
        formData.append('action', 'publish');
        formData.append('title', title);
        formData.append('tags', tags);
        formData.append('content', content);
        
        var coverFile = document.getElementById('guide-cover').files[0];
        if (coverFile) { formData.append('coverImage', coverFile); }
        
        fetch('guide', { method: 'POST', body: formData })
        .then(function(res) { return res.json(); })
        .then(function(resp) {
            if (resp.success) {
                $('#publish-guide-modal').modal('hide');
                alert('攻略发布成功！');
                window.location.reload();
            } else {
                alert(resp.message || '发布失败');
            }
        })
        .catch(function() { alert('网络错误，请重试'); });
    }

    function escHtml(s) {
        if (!s) return '';
        return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    function toggleFavList(gid, el) {
        fetch('/fav?type=GUIDE&id=' + gid)
        .then(function(r){ return r.json(); })
        .then(function(d){
            if (d.ok) {
                var icon = el.querySelector('.fa-heart');
                var text = el.querySelector('.fav-text');
                icon.style.color = d.faved ? '#e74c3c' : '#ccc';
                text.textContent = d.count + ' 收藏';
            } else if (d.msg) { alert(d.msg); }
        });
    }
    (function(){
        fetch('/fav?type=GUIDE&list=1')
        .then(function(r){ return r.json(); })
        .then(function(ids){
            document.querySelectorAll('[data-fav-id]').forEach(function(el){
                var gid = el.getAttribute('data-fav-id');
                if (ids.indexOf(Number(gid)) >= 0) {
                    el.querySelector('.fa-heart').style.color = '#e74c3c';
                }
            });
        });
    })();
</script>
</body>
</html>