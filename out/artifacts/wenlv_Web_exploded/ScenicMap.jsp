<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String scenicName = request.getParameter("name");
    String scenicAddress = request.getParameter("address");
    String scenicCity = request.getParameter("city");
    String latStr = request.getParameter("lat");
    String lngStr = request.getParameter("lng");
    String scenicId = request.getParameter("id");

    if (scenicName == null) scenicName = "";
    if (scenicAddress == null) scenicAddress = "";
    if (scenicCity == null) scenicCity = "";
    if (scenicId == null) scenicId = "";

    request.setAttribute("scenicName", scenicName);
    request.setAttribute("scenicAddress", scenicAddress);
    request.setAttribute("scenicCity", scenicCity);
    request.setAttribute("latitude", latStr);
    request.setAttribute("longitude", lngStr);
    request.setAttribute("scenicId", scenicId);
%>
<%@include file="Head.jsp"%>

<section class="breadcrumbs-custom-inset">
    <div class="breadcrumbs-custom context-dark bg-overlay-60">
        <div class="container">
            <h2 class="breadcrumbs-custom-title">地图查看</h2>
            <ul class="breadcrumbs-custom-path">
                <li><a href="index.jsp">首页</a></li>
                <li><a href="ScenicService.jsp">景区服务</a></li>
                <c:if test="${not empty scenicId}">
                    <li><a href="ScenicService-detail.jsp?id=${scenicId}">${scenicName}</a></li>
                </c:if>
                <li class="active">地图查看</li>
            </ul>
        </div>
    </div>
</section>

<section class="section section-lg bg-default">
    <div class="container">
        <div class="row mb-3">
            <div class="col-12 d-flex align-items-center justify-content-between">
                <div>
                    <h4 class="mb-0" style="color: #333;">
                        <i class="fa fa-map-marker" style="color: #00a8a8; margin-right: 8px;"></i>
                        ${scenicName}
                    </h4>
                    <c:if test="${not empty scenicAddress}">
                        <p class="mt-2 mb-0" style="color: #999; font-size: 14px;">${scenicAddress}</p>
                    </c:if>
                </div>
                <c:choose>
                    <c:when test="${not empty scenicId}">
                        <a href="ScenicService-detail.jsp?id=${scenicId}" class="button button-sm button-default-outline" style="border-color: #00a8a8; color: #00a8a8;">
                            <i class="fa fa-arrow-left"></i> 返回详情
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="ScenicService.jsp" class="button button-sm button-default-outline" style="border-color: #00a8a8; color: #00a8a8;">
                            <i class="fa fa-arrow-left"></i> 返回列表
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div id="map-container" style="width: 100%; height: 500px; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.1);"></div>
            </div>
        </div>

        <div class="row mt-3">
            <div class="col-12">
                <div id="map-tip" class="alert alert-info" role="alert" style="background: #f0f9f9; border-color: #d0eded; color: #555;">
                    <i class="fa fa-info-circle"></i>
                    <span id="map-status">正在加载地图...</span>
                </div>
            </div>
        </div>
    </div>
</section>

<%@include file="Footer.jsp"%>

<script>
    window._AMapSecurityConfig = {
        securityJsCode: 'f641ddae397c9c8e0e9bcc244cef2536'
    };
</script>
<script src="https://webapi.amap.com/maps?v=2.0&key=5e163e289690bcbea95fb961cba20a02"></script>

<script>
(function() {

    // ==========================================
    // 宁夏 8 大景区经纬度坐标（硬编码，无需数据库）
    // 需要修改坐标时直接改这里即可
    // ==========================================
    var SCENIC_COORDS = {
        '沙坡头景区':     { lng: 104.9988, lat: 37.4655 },
        '沙湖景区':       { lng: 106.3655, lat: 38.8268 },
        '西夏王陵':       { lng: 106.0025, lat: 38.4350 },
        '镇北堡西部影城': { lng: 106.0715, lat: 38.6150 },
        '贺兰山岩画':     { lng: 106.0188, lat: 38.7195 },
        '水洞沟遗址':     { lng: 106.5215, lat: 38.3180 },
        '青铜峡108塔':    { lng: 105.9820, lat: 37.8815 },
        '须弥山石窟':     { lng: 106.1985, lat: 36.2750 }
    };

    // ---------- read scenic data from JSP ----------
    var scenicName    = '${fn:escapeXml(scenicName)}';
    var scenicAddress = '${fn:escapeXml(scenicAddress)}';
    var dbLat         = '${latitude}';
    var dbLng         = '${longitude}';

    var $status = document.getElementById('map-status');

    console.log('[ScenicMap] name=' + scenicName + '  dbLat=' + dbLat + '  dbLng=' + dbLng);

    if (typeof AMap === 'undefined') {
        $status.textContent = '❌ 高德地图加载失败，请检查网络。';
        return;
    }

    // ---------- create map ----------
    var map = new AMap.Map('map-container', {
        zoom: 5,
        center: [106.278, 38.47],
        resizeEnable: true
    });
    map.addControl(new AMap.ToolBar({ position: 'RT' }));
    map.addControl(new AMap.Scale({ position: 'LB' }));

    // ---------- place marker ----------
    function mark(lng, lat, title) {
        console.log('[ScenicMap] marker → ' + lng + ', ' + lat + '  ' + title);
        new AMap.Marker({
            position: [lng, lat],
            title: title,
            animation: 'AMAP_ANIMATION_DROP',
            map: map
        });
        var info = new AMap.InfoWindow({
            content: '<div style="padding:8px 12px;"><strong style="color:#00a8a8;">' + title + '</strong>'
                + '<br><span style="font-size:12px;color:#999;">' + lat.toFixed(6) + ', ' + lng.toFixed(6) + '</span></div>',
            offset: new AMap.Pixel(0, -35)
        });
        info.open(map, [lng, lat]);
    }

    // ---------- determine coordinates ----------
    var targetLng = null, targetLat = null;

    // Step 1: try database coordinates (if user ran the SQL update)
    var latF = parseFloat(dbLat), lngF = parseFloat(dbLng);
    if (!isNaN(latF) && !isNaN(lngF) && latF > 0 && lngF > 0) {
        targetLng = lngF;
        targetLat = latF;
        console.log('[ScenicMap] using DB coords');
    }

    // Step 2: try hardcoded coordinates by exact name match
    if (!targetLng && SCENIC_COORDS[scenicName]) {
        targetLng = SCENIC_COORDS[scenicName].lng;
        targetLat = SCENIC_COORDS[scenicName].lat;
        console.log('[ScenicMap] using hardcoded coords for: ' + scenicName);
    }

    // Step 3: try fuzzy match (remove "景区" suffix)
    if (!targetLng && scenicName) {
        var short = scenicName.replace(/景区$/, '').replace(/旅游区$/, '').replace(/风景区$/, '');
        var keys = Object.keys(SCENIC_COORDS);
        for (var i = 0; i < keys.length; i++) {
            if (keys[i].indexOf(short) !== -1 || short.indexOf(keys[i].replace(/景区$/, '')) !== -1) {
                targetLng = SCENIC_COORDS[keys[i]].lng;
                targetLat = SCENIC_COORDS[keys[i]].lat;
                console.log('[ScenicMap] fuzzy match: ' + scenicName + ' → ' + keys[i]);
                break;
            }
        }
    }

    // ---------- result ----------
    if (targetLng && targetLat) {
        mark(targetLng, targetLat, scenicName);
        map.setCenter([targetLng, targetLat]);
        map.setZoom(16);
        $status.textContent = '✅ 已定位到：' + scenicName;
        return;
    }

    // Not found — show fallback
    $status.innerHTML = '⚠️ 未找到「' + scenicName + '」的坐标，'
        + '<a href="https://uri.amap.com/search?keyword=' + encodeURIComponent(scenicName) + '" target="_blank" style="color:#00a8a8;font-weight:bold;">点击在高德地图中查看</a>';

})();
</script>
</div><!-- .page close -->
<div class="snackbars" id="form-output-global"></div>
<script src="js/core.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>