<%@include file="Head.jsp"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.niit.utils.DBUtil" %>
<%@ page import="com.niit.mapper.TravelGuideMapper" %>
<%@ page import="com.niit.mapper.GuideTagMapper" %>
<%@ page import="com.niit.pojo.TravelGuide" %>
<%@ page import="com.niit.pojo.GuideTag" %>
<%@ page import="org.apache.ibatis.session.SqlSession" %>
<%@ page import="java.util.*" %>

<%
    String idParam = request.getParameter("id");
    TravelGuide guide = null;
    List<GuideTag> tagList = new ArrayList<>();
    if (idParam != null) {
        try (SqlSession s = DBUtil.getSession()) {
            long gid = Long.parseLong(idParam);
            guide = s.getMapper(TravelGuideMapper.class).findById(gid);
            if (guide != null) {
                tagList = s.getMapper(GuideTagMapper.class).findByGuideId(gid);
            }
        } catch (Exception e) {
            request.setAttribute("error", "加载失败：" + e.getMessage());
        }
    }
    if (guide == null) {
        response.sendRedirect("TravelGuide.jsp");
        return;
    }
    request.setAttribute("guide", guide);
    request.setAttribute("tagList", tagList);
    // 按分类分组标签
    java.util.Map<String, java.util.List<GuideTag>> grouped = new java.util.LinkedHashMap<>();
    grouped.put("FEATURE", new java.util.ArrayList<>());
    grouped.put("TIME", new java.util.ArrayList<>());
    grouped.put("AUDIENCE", new java.util.ArrayList<>());
    grouped.put("BUDGET", new java.util.ArrayList<>());
    for (GuideTag t : tagList) {
        java.util.List<GuideTag> g = grouped.get(t.getCategory());
        if (g != null) g.add(t);
    }
    java.util.Map<String, String> catColors = new java.util.LinkedHashMap<>();
    catColors.put("FEATURE", "#2196f3");
    catColors.put("TIME", "#4caf50");
    catColors.put("AUDIENCE", "#ff9800");
    catColors.put("BUDGET", "#9c27b0");
    request.setAttribute("grouped", grouped);
    request.setAttribute("catColors", catColors);
%>

<!-- Breadcrumbs-->
<section class="breadcrumbs-custom bg-image context-dark" style="background-image: url(images/breadcrumbs-bg.jpg);" data-preset='{"title":"Breadcrumbs","category":"header","reload":false,"id":"breadcrumbs"}'>
    <div class="container">
        <h4 class="breadcrumbs-custom-title">${guide.title}</h4>
        <ul class="breadcrumbs-custom-path">
            <li><a href="index.jsp">首页</a></li>
            <li><a href="TravelGuide.jsp">旅游攻略</a></li>
            <li class="active">${guide.title}</li>
        </ul>
    </div>
</section>

<!-- 攻略详情 -->
<section class="section section-lg bg-default">
    <div class="container">
        <div class="row row-50">
            <div class="col-xl-8">
                <div class="box-classic">
                    <div class="mb-6">
                        <c:choose>
                            <c:when test="${not empty guide.coverImage}">
                                <img src="${guide.coverImage}" alt="${guide.title}" class="img-fluid rounded-lg" style="width: 100%; height: 300px; object-fit: cover;"/>
                            </c:when>
                            <c:otherwise>
                                <img src="images/tour-1-370x284.jpg" alt="${guide.title}" class="img-fluid rounded-lg" style="width: 100%; height: 300px; object-fit: cover;"/>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="mb-6">
                        <h1 style="font-size: 28px; color: #333; font-weight: bold; margin-bottom: 20px;">${guide.title}</h1>
                        
                        <div class="d-flex flex-wrap align-items-center gap-2 mb-4">
                            <c:choose>
                                <c:when test="${guide.status == 'PUBLISHED'}"><span class="badge bg-success text-white">已发布</span></c:when>
                                <c:when test="${guide.status == 'DRAFT'}"><span class="badge bg-warning text-white">草稿</span></c:when>
                                <c:when test="${guide.status == 'HIDDEN'}"><span class="badge bg-danger text-white">已隐藏</span></c:when>
                                <c:otherwise><span class="badge bg-secondary text-white">${guide.status}</span></c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 分类标签 -->
                        <c:set var="catNames" value="${{'FEATURE':'特点','TIME':'时间','AUDIENCE':'适合人群','BUDGET':'预算'}}"/>
                        <c:forEach items="${grouped}" var="entry">
                            <c:if test="${not empty entry.value}">
                            <div style="margin-bottom:6px;">
                                <span style="display:inline-block;font-size:11px;font-weight:600;color:#888;width:52px;">${catNames[entry.key]}</span>
                                <c:forEach items="${entry.value}" var="t">
                                    <span style="display:inline-block;padding:2px 10px;margin:1px 3px;border-radius:12px;font-size:12px;background:${catColors[entry.key]};color:#fff;">${t.name}</span>
                                </c:forEach>
                            </div>
                            </c:if>
                        </c:forEach>

                        <div class="d-flex align-items-center">
                            <div class="review-avatar" style="width: 40px; height: 40px; font-size: 16px;">${fn:substring(guide.userName, 0, 1)}</div>
                            <div style="margin-left: 12px;">
                                <div style="font-weight: bold; color: #333;">${empty guide.userName ? '匿名用户' : guide.userName}</div>
                            </div>
                        </div>

                    </div>

                    <!-- 攻略正文 -->
                    <div style="margin-top:20px; padding:20px; background:#fafafa; border-radius:8px; line-height:1.9; color:#444; white-space:pre-wrap;">${guide.content}</div>

                    <!-- 用户点评 -->
                    <div style="margin-top:30px;">
                        <div class="mb-6">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h3 style="color: #333; font-size: 20px; margin-bottom: 10px;">用户点评 <span style="font-size: 14px; font-weight: normal; color: #999;">(128条)</span></h3>
                                </div>
                                <div class="col-md-6 text-right">
                                    <button onclick="showWriteReviewModal()" class="button button-primary" type="button">写点评</button>
                                </div>
                            </div>
                            <div class="mt-4">
                                <span class="badge bg-primary text-white mr-2">全部(128)</span>
                                <span class="badge bg-gray-100 text-gray-600 mr-2">好评(112)</span>
                                <span class="badge bg-gray-100 text-gray-600 mr-2">中评(10)</span>
                                <span class="badge bg-gray-100 text-gray-600">差评(6)</span>
                            </div>
                        </div>
                        <div id="reviews-container"></div>
                    </div>
                </div>
            </div>

            <div class="col-xl-4">
                <div class="box-classic sticky-top" style="top: 20px;">
                    <div class="p-4 bg-gray-50 rounded-lg mb-4">
                        <h5 style="font-weight: bold; color: #333; margin-bottom: 16px;">攻略信息</h5>
                        <div class="space-y-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-gray-500"><span class="icon linearicons-eye"></span> 浏览数</span>
                                <span class="font-weight-bold">${guide.viewCount}</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-gray-500"><span class="icon linearicons-thumbs-up"></span> 点赞数</span>
                                <span class="font-weight-bold">${guide.likeCount}</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-gray-500"><span class="icon fa fa-comment"></span> 评论数</span>
                                <span class="font-weight-bold">${guide.commentCount}</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-gray-500"><span class="icon linearicons-heart"></span> 收藏数</span>
                                <span class="font-weight-bold">${guide.favoriteCount}</span>
                            </div>
                            <hr style="margin: 12px 0;"/>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-gray-500">发布时间</span>
                                <span style="font-size: 12px;">${guide.createdAt}</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-gray-500">更新时间</span>
                                <span style="font-size: 12px;">${guide.updatedAt}</span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="text-gray-500">状态</span>
                                <c:choose>
                                    <c:when test="${guide.status == 'PUBLISHED'}"><span class="badge bg-success text-white" style="font-size:12px;">已发布</span></c:when>
                                    <c:when test="${guide.status == 'DRAFT'}"><span class="badge bg-warning text-white" style="font-size:12px;">草稿</span></c:when>
                                    <c:otherwise><span class="badge bg-danger text-white" style="font-size:12px;">已隐藏</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 写点评弹窗 -->
<div class="modal fade" id="write-review-modal" tabindex="-1" role="dialog" aria-labelledby="write-review-modal-label" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="write-review-modal-label">写点评</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-4">
                    <input type="text" id="review-title" class="form-control" placeholder="请输入点评标题">
                </div>
                <div class="mb-4">
                    <textarea id="review-content" class="form-control" rows="6" placeholder="请分享您的游玩体验..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="submitReview()">发表点评</button>
            </div>
        </div>
    </div>
</div>

<!-- 提问弹窗 -->
<div class="modal fade" id="ask-modal" tabindex="-1" role="dialog" aria-labelledby="ask-modal-label" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="ask-modal-label">我要提问</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-4">
                    <label class="form-label">问题标题</label>
                    <input type="text" id="ask-title" class="form-control" placeholder="请输入问题标题">
                </div>
                <div class="mb-4">
                    <label class="form-label">问题详情</label>
                    <textarea id="ask-content" class="form-control" rows="4" placeholder="请详细描述您的问题..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="submitAsk()">提交问题</button>
            </div>
        </div>
    </div>
</div>

<!-- Footer-->
<footer class="section footer-classic context-dark">
    <div class="container">
        <div class="row row-narrow-40 row-30">
            <div class="col-lg-6 text-center wow fadeInLeft" data-wow-delay=".1s">
                <div class="footer-media"><img src="images/footer-img-570x402.jpg" alt="" width="570" height="402"/>
                </div>
            </div>
            <div class="col-lg-6 wow fadeInRight" data-wow-delay=".2s">
                <div class="footer-classic_subscribe">
                    <h2>订阅攻略</h2>
                    <h5 class="text-primary">获取最新宁夏旅游攻略、特价线路、本地美食推荐</h5>
                    <form class="rd-form rd-mailform rd-form-inline subscribe-form" data-form-output="form-output-global" data-form-type="subscribe" method="post" action="bat/rd-mailform.php">
                        <div class="form-wrap">
                            <input class="form-input" id="subscribe-form-email-5" type="email" name="email" data-constraints="@Email @Required">
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
                        <a class="brand" href="index.jsp"><img class="brand-logo-dark" src="images/logo-default-225x39.png" alt="" width="112" height="19"/></a>
                        <p class="rights">版权 &copy; 2025 宁夏旅游平台 保留所有权利</p>
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
</div>

<style>
    .review-item {
        padding: 24px;
        background: #fff;
        border: 1px solid #eee;
        border-radius: 12px;
        margin-bottom: 16px;
    }
    .review-header {
        display: flex;
        align-items: center;
        margin-bottom: 16px;
    }
    .review-avatar {
        width: 50px;
        height: 50px;
        background: #00a8a8;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 20px;
        font-weight: bold;
        margin-right: 16px;
    }
    .review-user-info {
        flex-grow: 1;
    }
    .review-author {
        font-weight: bold;
        color: #333;
        font-size: 16px;
    }
    .review-time {
        font-size: 12px;
        color: #999;
        margin-top: 4px;
    }
    .review-rating {
        color: #ffc107;
        font-size: 16px;
    }
    .review-title {
        font-weight: bold;
        color: #333;
        font-size: 16px;
        margin-bottom: 8px;
    }
    .review-text {
        color: #666;
        line-height: 1.7;
        font-size: 14px;
    }
    .review-images {
        display: flex;
        gap: 8px;
        margin-top: 12px;
    }
    .review-image {
        width: 80px;
        height: 80px;
        object-fit: cover;
        border-radius: 8px;
    }
    .review-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 12px;
        padding-top: 12px;
        border-top: 1px solid #eee;
    }
    .review-tags {
        display: flex;
        gap: 8px;
    }
    .review-tag {
        padding: 4px 10px;
        background: #f0f9ff;
        color: #00a8a8;
        font-size: 12px;
        border-radius: 4px;
    }
    .review-actions {
        display: flex;
        gap: 20px;
    }
    .review-action {
        font-size: 13px;
        color: #999;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 4px;
    }
    .review-action:hover {
        color: #00a8a8;
    }
    .star-rating i {
        font-size: 32px;
        color: #ddd;
        cursor: pointer;
        transition: color 0.2s;
    }
    .star-rating i.active,
    .star-rating i:hover,
    .star-rating i:hover ~ i {
        color: #ffc107;
    }
</style>

<script>
    var selectedRating = 0;

    document.addEventListener('DOMContentLoaded', function() {
        renderReviews();
        
        $('#star-rating i').click(function() {
            selectedRating = $(this).data('value');
            $('#star-rating i').removeClass('active');
            $(this).addClass('active');
            $(this).prevAll().addClass('active');
        });
    });

    var reviews = [
        { 
            author: '旅行达人小王', avatar: '王', rating: 5, title: '重温大话西游，感动满满！', 
            content: '终于来到了《大话西游》的拍摄地！站在城楼上，仿佛看到了至尊宝和紫霞仙子的身影。景区维护得很好，每个场景都原汁原味，非常值得一来！', 
            time: '2026-06-15 14:20', tags: ['经典场景', '值得一来'], helpful: 89, photos: 6 
        },
        { 
            author: '小李带你玩', avatar: '李', rating: 5, title: '电影迷的天堂', 
            content: '作为一个电影迷，这里简直是天堂！看到了《红高粱》《龙门客栈》等经典电影的拍摄场景，还体验了一把当演员的感觉。强烈推荐给所有影迷！', 
            time: '2026-06-14 09:35', tags: ['电影场景', '体验感强'], helpful: 76, photos: 8 
        },
        { 
            author: '爱旅游的张姐', avatar: '张', rating: 4, title: '带孩子来很合适', 
            content: '带孩子一起来的，孩子特别喜欢这里，租了古装拍照，玩得很开心。景区内有很多互动项目，适合亲子游。唯一建议是夏季来的话要做好防晒。', 
            time: '2026-06-13 16:45', tags: ['适合亲子', '互动性强'], helpful: 54, photos: 3 
        },
        { 
            author: '摄影师阿杰', avatar: '杰', rating: 5, title: '摄影圣地！', 
            content: '镇北堡影城太适合拍照了！每个角落都是天然的摄影棚，尤其是夕阳时分，古堡在余晖下显得格外壮观。建议带上广角镜头，大片不断！', 
            time: '2026-06-12 11:10', tags: ['摄影圣地', '出片率高'], helpful: 92, photos: 12 
        },
        { 
            author: '美食家陈哥', avatar: '陈', rating: 5, title: '西北美食体验', 
            content: '在景区内品尝了正宗的手抓羊肉和臊子面，味道非常地道！尤其是手抓羊肉，鲜嫩多汁，一点都不膻。推荐大家一定要尝尝！', 
            time: '2026-06-11 20:00', tags: ['美食推荐', '味道正宗'], helpful: 63, photos: 4 
        }
    ];

    function renderReviews() {
        var container = document.getElementById('reviews-container');
        if (!container) return;
        
        container.innerHTML = '';
        reviews.forEach(function(review, index) {
            var tagsHtml = review.tags.map(function(tag) {
                return '<span class="review-tag">' + tag + '</span>';
            }).join('');
            
            var photosHtml = '';
            for (var j = 0; j < Math.min(review.photos, 6); j++) {
                photosHtml += '<img src="images/tour-1-370x284.jpg" class="review-image" />';
            }
            
            var repliesHtml = '';
            if (review.replies && review.replies.length > 0) {
                repliesHtml = '<div class="replies-container" style="margin-top: 16px; padding-top: 16px; border-top: 1px dashed #eee;">';
                review.replies.forEach(function(reply) {
                    repliesHtml += 
                        '<div class="reply-item" style="padding: 12px; background: #f9f9f9; border-radius: 8px; margin-bottom: 8px;">' +
                        '<div style="font-weight: bold; color: #333; font-size: 13px;">' + reply.author + '</div>' +
                        '<div style="color: #666; font-size: 14px; margin-top: 4px;">' + reply.content + '</div>' +
                        '<div style="font-size: 11px; color: #999; margin-top: 4px;">' + reply.time + '</div>' +
                        '</div>';
                });
                repliesHtml += '</div>';
            }
            
            var reviewItem = document.createElement('div');
            reviewItem.className = 'review-item';
            reviewItem.innerHTML = 
                '<div class="review-header">' +
                '<div class="review-avatar">' + review.avatar + '</div>' +
                '<div class="review-user-info">' +
                '<div class="review-author">' + review.author + '</div>' +
                '<div class="review-time">' + review.time + '</div>' +
                '</div>' +
                '</div>' +
                '<div class="review-title">' + review.title + '</div>' +
                '<div class="review-text">' + review.content + '</div>' +
                (photosHtml ? '<div class="review-images">' + photosHtml + '</div>' : '') +
                (repliesHtml ? repliesHtml : '') +
                '<div class="reply-input-container" id="reply-input-' + index + '" style="display: none; margin-top: 16px; padding: 12px; background: #f9f9f9; border-radius: 8px;">' +
                '<textarea id="reply-content-' + index + '" class="form-control" rows="2" placeholder="请输入回复内容..." style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; resize: vertical;"></textarea>' +
                '<div style="display: flex; justify-content: flex-end; margin-top: 8px;">' +
                '<button onclick="cancelReply(' + index + ')" class="btn btn-secondary btn-sm" style="margin-right: 8px;">取消</button>' +
                '<button onclick="submitReply(' + index + ')" class="btn btn-primary btn-sm">提交回复</button>' +
                '</div>' +
                '</div>' +
                '<div class="review-footer">' +
                '<div class="review-tags">' + tagsHtml + '</div>' +
                '<div class="review-actions">' +
                '<span class="review-action" onclick="toggleHelpful(' + index + ', this)"><i class="fa fa-thumbs-up"></i> 有用 (' + review.helpful + ')</span>' +
                '<span class="review-action" onclick="showReplyInput(' + index + ')"><i class="fa fa-comment"></i> 回复</span>' +
                '</div>' +
                '</div>';
            
            container.appendChild(reviewItem);
        });
    }

    function toggleHelpful(index, element) {
        var isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
        var isAdminLoggedIn = localStorage.getItem('isAdminLoggedIn') === 'true';
        
        if (!isLoggedIn && !isAdminLoggedIn) {
            alert('请先登录后再进行操作！');
            var loginModal = new bootstrap.Modal(document.getElementById('login-modal'));
            loginModal.show();
            return;
        }
        
        if (reviews[index].liked) {
            reviews[index].helpful--;
            reviews[index].liked = false;
            element.style.color = '#999';
            element.querySelector('i').style.color = '#999';
        } else {
            reviews[index].helpful++;
            reviews[index].liked = true;
            element.style.color = '#00a8a8';
            element.querySelector('i').style.color = '#00a8a8';
        }
        
        element.innerHTML = '<i class="fa fa-thumbs-up' + (reviews[index].liked ? ' active' : '') + '"></i> 有用 (' + reviews[index].helpful + ')';
    }

    function showReplyInput(index) {
        var isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
        var isAdminLoggedIn = localStorage.getItem('isAdminLoggedIn') === 'true';
        
        if (!isLoggedIn && !isAdminLoggedIn) {
            alert('请先登录后再进行操作！');
            var loginModal = new bootstrap.Modal(document.getElementById('login-modal'));
            loginModal.show();
            return;
        }
        
        var container = document.getElementById('reply-input-' + index);
        if (container) {
            container.style.display = 'block';
            document.getElementById('reply-content-' + index).focus();
        }
    }

    function cancelReply(index) {
        var container = document.getElementById('reply-input-' + index);
        if (container) {
            container.style.display = 'none';
            document.getElementById('reply-content-' + index).value = '';
        }
    }

    function submitReply(index) {
        var content = document.getElementById('reply-content-' + index).value.trim();
        
        if (!content) {
            alert('请输入回复内容！');
            return;
        }
        
        var username = localStorage.getItem('username') || localStorage.getItem('adminUsername') || '游客';
        var now = new Date();
        var timeStr = now.getFullYear() + '-' + 
            String(now.getMonth() + 1).padStart(2, '0') + '-' + 
            String(now.getDate()).padStart(2, '0') + ' ' + 
            String(now.getHours()).padStart(2, '0') + ':' + 
            String(now.getMinutes()).padStart(2, '0');
        
        if (!reviews[index].replies) {
            reviews[index].replies = [];
        }
        
        reviews[index].replies.push({
            author: username,
            content: content,
            time: timeStr
        });
        
        cancelReply(index);
        renderReviews();
    }

    function showWriteReviewModal() {
        var isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
        var isAdminLoggedIn = localStorage.getItem('isAdminLoggedIn') === 'true';
        
        if (!isLoggedIn && !isAdminLoggedIn) {
            alert('请先登录后再发表点评！');
            var loginModal = new bootstrap.Modal(document.getElementById('login-modal'));
            loginModal.show();
            return;
        }
        
        selectedRating = 0;
        $('#star-rating i').removeClass('active');
        $('#review-title').val('');
        $('#review-content').val('');
        var modal = new bootstrap.Modal(document.getElementById('write-review-modal'));
        modal.show();
    }

    function submitReview() {
        var title = $('#review-title').val().trim();
        var content = $('#review-content').val().trim();
        
        if (!title) {
            alert('请输入点评标题！');
            return;
        }
        if (!content) {
            alert('请输入点评内容！');
            return;
        }
        
        var username = localStorage.getItem('username') || localStorage.getItem('adminUsername') || '游客';
        var avatar = username.charAt(0);
        var now = new Date();
        var timeStr = now.getFullYear() + '-' + 
            String(now.getMonth() + 1).padStart(2, '0') + '-' + 
            String(now.getDate()).padStart(2, '0') + ' ' + 
            String(now.getHours()).padStart(2, '0') + ':' + 
            String(now.getMinutes()).padStart(2, '0');
        
        reviews.unshift({
            author: username,
            avatar: avatar,
            rating: selectedRating,
            title: title,
            content: content,
            time: timeStr,
            tags: ['推荐'],
            helpful: 0,
            photos: 0
        });
        
        $('#write-review-modal').modal('hide');
        renderReviews();
        alert('点评发表成功！');
    }

    function showAskModal() {
        var isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
        var isAdminLoggedIn = localStorage.getItem('isAdminLoggedIn') === 'true';
        
        if (!isLoggedIn && !isAdminLoggedIn) {
            alert('请先登录后再提问！');
            var loginModal = new bootstrap.Modal(document.getElementById('login-modal'));
            loginModal.show();
            return;
        }
        
        $('#ask-title').val('');
        $('#ask-content').val('');
        var modal = new bootstrap.Modal(document.getElementById('ask-modal'));
        modal.show();
    }

    function submitAsk() {
        var title = $('#ask-title').val().trim();
        var content = $('#ask-content').val().trim();
        
        if (!title) {
            alert('请输入问题标题！');
            return;
        }
        if (!content) {
            alert('请输入问题详情！');
            return;
        }
        
        $('#ask-modal').modal('hide');
        alert('问题提交成功！我们会尽快回复您。');
    }
</script>

<div class="snackbars" id="form-output-global"></div>
<script src="js/core.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>