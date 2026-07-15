<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String scenicId = request.getParameter("id");
    String scenicName = request.getParameter("name");
    String scenicAddress = request.getParameter("address");
    String latStr = request.getParameter("lat");
    String lngStr = request.getParameter("lng");

    if (scenicId == null) scenicId = "";
    if (scenicName == null) scenicName = "";
    if (scenicAddress == null) scenicAddress = "";
    if (latStr == null) latStr = "";
    if (lngStr == null) lngStr = "";

    request.setAttribute("scenicId", scenicId);
    request.setAttribute("scenicName", scenicName);
    request.setAttribute("scenicAddress", scenicAddress);
    request.setAttribute("latitude", latStr);
    request.setAttribute("longitude", lngStr);
%>
<%@include file="Head.jsp"%>

<section class="breadcrumbs-custom-inset">
    <div class="breadcrumbs-custom context-dark bg-overlay-60">
        <div class="container">
            <h2 class="breadcrumbs-custom-title">路线规划</h2>
            <ul class="breadcrumbs-custom-path">
                <li><a href="index.jsp">首页</a></li>
                <li><a href="ScenicService.jsp">景区服务</a></li>
                <c:if test="${not empty scenicId}">
                    <li><a href="ScenicService-detail.jsp?id=${scenicId}">${fn:escapeXml(scenicName)}</a></li>
                </c:if>
                <li class="active">路线规划</li>
            </ul>
        </div>
    </div>
</section>

<section class="section section-lg bg-default">
    <div class="container">
        <%-- 景区信息头部 --%>
        <div class="row mb-4">
            <div class="col-12 d-flex align-items-center justify-content-between flex-wrap">
                <div>
                    <h4 class="mb-1" style="color: #333;">
                        <i class="fa fa-map-marker" style="color: #00a8a8; margin-right: 8px;"></i>
                        ${fn:escapeXml(scenicName)}
                    </h4>
                    <c:if test="${not empty scenicAddress}">
                        <p class="mb-0" style="color: #999; font-size: 14px;">目的地：${fn:escapeXml(scenicAddress)}</p>
                    </c:if>
                </div>
                <c:if test="${not empty scenicId}">
                    <a href="ScenicService-detail.jsp?id=${scenicId}" class="button button-sm button-default-outline" style="border-color: #00a8a8; color: #00a8a8;">
                        <i class="fa fa-arrow-left"></i> 返回详情
                    </a>
                </c:if>
            </div>
        </div>

        <div class="row">
            <%-- 左侧：地图 --%>
            <div class="col-lg-8 mb-4 mb-lg-0">
                <div id="map-container" style="width: 100%; height: 520px; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.1);"></div>
            </div>

            <%-- 右侧：路线规划面板 --%>
            <div class="col-lg-4">
                <div style="background: #fff; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); padding: 20px;">

                    <%-- 出行方式切换 --%>
                    <div class="route-tabs mb-3" style="display: flex; gap: 6px;">
                        <button id="tab-driving" class="route-tab active" data-type="driving"
                            style="flex:1; padding:8px 6px; border-radius:6px; cursor:pointer; font-size:13px; transition:all 0.2s;">
                            <i class="fa fa-car"></i> 驾车
                        </button>
                        <button id="tab-walking" class="route-tab" data-type="walking"
                            style="flex:1; padding:8px 6px; border-radius:6px; cursor:pointer; font-size:13px; transition:all 0.2s;">
                            <i class="fa fa-male"></i> 步行
                        </button>
                        <button id="tab-transit" class="route-tab" data-type="transit"
                            style="flex:1; padding:8px 6px; border-radius:6px; cursor:pointer; font-size:13px; transition:all 0.2s;">
                            <i class="fa fa-bus"></i> 公交
                        </button>
                    </div>

                    <%-- 起点输入 --%>
                    <div class="mb-3" style="position:relative;">
                        <label style="font-size:13px; color:#666; margin-bottom:4px; display:block;">起点位置</label>
                        <div style="display:flex; gap:6px;">
                            <input type="text" id="start-input" placeholder="输入起点地址..."
                                style="flex:1; padding:8px 12px; border:1px solid #ddd; border-radius:6px; font-size:13px; outline:none;">
                            <button id="btn-locate" title="使用我的位置"
                                style="padding:8px 12px; border:1px solid #00a8a8; background:#fff; color:#00a8a8; border-radius:6px; cursor:pointer; font-size:13px; white-space:nowrap;">
                                <i class="fa fa-crosshairs"></i> 定位
                            </button>
                        </div>
                    </div>

                    <%-- 搜索按钮 --%>
                    <button id="btn-search"
                        style="width:100%; padding:10px; background:#00a8a8; color:#fff; border:none; border-radius:6px; font-size:14px; cursor:pointer; margin-bottom:16px;">
                        <i class="fa fa-search"></i> 查询路线
                    </button>

                    <%-- 路线详情 --%>
                    <div id="route-detail" style="min-height:120px;">
                        <div id="route-summary" style="display:none; padding:12px; background:#f0f9f9; border-radius:6px; margin-bottom:12px;">
                            <div style="display:flex; justify-content:space-around; text-align:center;">
                                <div>
                                    <div style="font-size:20px; font-weight:bold; color:#00a8a8;" id="route-distance">--</div>
                                    <div style="font-size:11px; color:#999;">公里</div>
                                </div>
                                <div>
                                    <div style="font-size:20px; font-weight:bold; color:#00a8a8;" id="route-duration">--</div>
                                    <div style="font-size:11px; color:#999;">分钟</div>
                                </div>
                                <div id="route-cost-wrap" style="display:none;">
                                    <div style="font-size:20px; font-weight:bold; color:#00a8a8;" id="route-cost">--</div>
                                    <div style="font-size:11px; color:#999;">元</div>
                                </div>
                            </div>
                        </div>
                        <div id="route-steps" style="max-height:320px; overflow-y:auto; font-size:13px; color:#666; line-height:1.8;"></div>
                        <div id="route-placeholder" style="text-align:center; padding:30px 0; color:#bbb;">
                            <i class="fa fa-map-signs" style="font-size:36px; display:block; margin-bottom:8px;"></i>
                            输入起点，查看前往景区的路线
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- 状态提示 --%>
        <div class="row mt-3">
            <div class="col-12">
                <div id="map-tip" style="background: #f0f9f9; border:1px solid #d0eded; border-radius:6px; padding:10px 16px; color:#555; font-size:13px;">
                    <i class="fa fa-info-circle"></i>
                    <span id="map-status">正在加载地图...</span>
                </div>
            </div>
        </div>
    </div>
</section>

<%@include file="Footer.jsp"%>

<style>
.route-tab {
    outline: none;
    border: 2px solid #e0e0e0;
    background: #fff;
    color: #666;
}
.route-tab.active {
    background: #00a8a8;
    color: #fff;
    border-color: #00a8a8;
}
#route-steps::-webkit-scrollbar { width: 4px; }
#route-steps::-webkit-scrollbar-thumb { background: #ddd; border-radius: 2px; }
.route-step { padding: 6px 0; border-bottom: 1px solid #f5f5f5; display: flex; align-items: flex-start; gap: 8px; }
.route-step:last-child { border-bottom: none; }
.route-step-icon {
    width: 22px; height: 22px; border-radius: 50%; background: #e8f5f5;
    display: flex; align-items: center; justify-content: center;
    font-size: 11px; color: #00a8a8; flex-shrink: 0; margin-top: 2px;
}
.amap-sug-result { z-index: 9999 !important; }
</style>

<%-- 高德地图安全配置 --%>
<script>
    window._AMapSecurityConfig = {
        securityJsCode: 'f641ddae397c9c8e0e9bcc244cef2536'
    };
</script>
<%-- 高德地图 JS API 基础库（不在此处加载插件，改用 AMap.plugin 按需加载） --%>
<script src="https://webapi.amap.com/maps?v=2.0&key=5e163e289690bcbea95fb961cba20a02"></script>

<script>
(function() {
    'use strict';
    var TAG = '[ScenicRoute]';

    // ==================== 调试日志 ====================
    function log(msg) { console.log(TAG, msg); }
    function err(msg) { console.error(TAG, msg); }

    log('脚本开始执行, document.readyState=' + document.readyState);

    // ==================== 全局状态 ====================
    var _map = null;
    var _targetLng = null, _targetLat = null;
    var _currentRouteType = 'driving';
    var _startLngLat = null;
    var _startMarker = null, _destMarker = null;

    // 路线插件实例
    var _driving = null, _walking = null, _transfer = null;

    // 从 JSP 渲染的变量
    var _scenicName = '${fn:escapeXml(scenicName)}';
    var _dbLat = '${latitude}';
    var _dbLng = '${longitude}';

    log('景区名称=' + _scenicName + ' DB坐标=(' + _dbLat + ', ' + _dbLng + ')');

    // ==================== 硬编码坐标 fallback ====================
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

    // ==================== 工具函数 ====================
    function $(id) { return document.getElementById(id); }

    function setStatus(msg) {
        log('状态: ' + msg);
        var el = $('map-status');
        if (el) el.textContent = msg;
    }

    // 解析目标坐标
    function resolveCoords() {
        var latF = parseFloat(_dbLat), lngF = parseFloat(_dbLng);
        if (!isNaN(latF) && !isNaN(lngF) && latF > 0 && lngF > 0) {
            _targetLng = lngF; _targetLat = latF;
            log('坐标来源: 数据库 → (' + _targetLng + ', ' + _targetLat + ')');
            return true;
        }
        if (SCENIC_COORDS[_scenicName]) {
            _targetLng = SCENIC_COORDS[_scenicName].lng;
            _targetLat = SCENIC_COORDS[_scenicName].lat;
            log('坐标来源: 精确匹配 → (' + _targetLng + ', ' + _targetLat + ')');
            return true;
        }
        if (_scenicName) {
            var short = _scenicName.replace(/景区$/, '').replace(/旅游区$/, '').replace(/风景区$/, '');
            var keys = Object.keys(SCENIC_COORDS);
            for (var i = 0; i < keys.length; i++) {
                var k = keys[i].replace(/景区$/, '');
                if (keys[i].indexOf(short) !== -1 || short.indexOf(k) !== -1) {
                    _targetLng = SCENIC_COORDS[keys[i]].lng;
                    _targetLat = SCENIC_COORDS[keys[i]].lat;
                    log('坐标来源: 模糊匹配 → (' + _targetLng + ', ' + _targetLat + ')');
                    return true;
                }
            }
        }
        err('无法解析坐标: ' + _scenicName);
        return false;
    }

    // 设置起点
    function setStartPoint(lng, lat, name) {
        log('设置起点: (' + lng + ', ' + lat + ') ' + name);
        _startLngLat = [lng, lat];
        var inp = $('start-input');
        if (inp) inp.value = name || (lng.toFixed(6) + ', ' + lat.toFixed(6));
        // 起点标记
        if (_startMarker) { _startMarker.setMap(null); _startMarker = null; }
        if (_map) {
            _startMarker = new AMap.Marker({
                position: [lng, lat],
                title: '起点',
                icon: new AMap.Icon({
                    size: new AMap.Size(24, 34),
                    image: 'https://webapi.amap.com/theme/v1.3/markers/n/mark_b.png',
                    imageSize: new AMap.Size(24, 34)
                }),
                map: _map
            });
        }
        doSearchRoute();
    }

    // 切换出行方式
    window.switchRouteType = function(type) {
        log('切换出行方式: ' + type);
        _currentRouteType = type;
        var tabs = document.querySelectorAll('.route-tab');
        for (var i = 0; i < tabs.length; i++) {
            var t = tabs[i];
            if (t.getAttribute('data-type') === type) {
                t.classList.add('active');
            } else {
                t.classList.remove('active');
            }
        }
        var costWrap = $('route-cost-wrap');
        if (costWrap) costWrap.style.display = (type === 'transit') ? '' : 'none';
        if (_startLngLat) doSearchRoute();
    };

    // 我的位置定位
    window.locateMe = function() {
        log('点击定位按钮');
        setStatus('正在获取您的位置...');
        if (!navigator.geolocation) {
            setStatus('浏览器不支持定位');
            alert('您的浏览器不支持地理定位，请手动输入起点地址。');
            return;
        }
        navigator.geolocation.getCurrentPosition(function(pos) {
            setStartPoint(pos.coords.longitude, pos.coords.latitude, '我的位置');
            setStatus('已定位到您的位置 → ' + _scenicName);
        }, function(e) {
            setStatus('定位失败');
            alert('无法获取位置（错误码：' + e.code + '），请手动输入地址。');
        }, { timeout: 10000, enableHighAccuracy: true });
    };

    // 查询路线入口
    window.searchRoute = function() {
        log('触发路线查询, _startLngLat=' + JSON.stringify(_startLngLat));
        if (_startLngLat) { doSearchRoute(); return; }
        var inp = $('start-input');
        var val = inp ? inp.value.trim() : '';
        if (!val) {
            alert('请输入起点地址或点击"定位"按钮使用当前位置。');
            return;
        }
        setStatus('正在解析地址...');
        try {
            var geocoder = new AMap.Geocoder({ city: '银川' });
            geocoder.getLocation(val, function(status, result) {
                log('地理编码回调 status=' + status + ' result=' + JSON.stringify(result));
                if (status === 'complete' && result.info === 'OK' && result.geocodes && result.geocodes.length > 0) {
                    var gc = result.geocodes[0];
                    setStartPoint(gc.location.lng, gc.location.lat, gc.formattedAddress || val);
                } else {
                    setStatus('未找到该地址');
                    alert('未找到地址「' + val + '」，请输入更详细的地址（例如：银川市火车站）。');
                }
            });
        } catch(e) {
            err('地理编码异常: ' + e.message);
            setStatus('地理编码失败: ' + e.message);
        }
    };

    // 执行路线规划
    function doSearchRoute() {
        if (!_startLngLat || !_targetLng || !_targetLat) {
            log('doSearchRoute 跳过: 缺少坐标');
            return;
        }
        log('执行路线规划: ' + _currentRouteType + ' ' + JSON.stringify(_startLngLat) + ' → [' + _targetLng + ',' + _targetLat + ']');
        setStatus('正在规划' + (_currentRouteType==='driving'?'驾车':_currentRouteType==='walking'?'步行':'公交') + '路线...');
        clearRoute();

        var origin = _startLngLat;
        var dest = [_targetLng, _targetLat];

        try {
            if (_currentRouteType === 'driving' && _driving) {
                _driving.search(origin, dest, function(status, result) {
                    log('驾车回调 status=' + status);
                    handleRouteResult(status, result, 'driving');
                });
            } else if (_currentRouteType === 'walking' && _walking) {
                _walking.search(origin, dest, function(status, result) {
                    log('步行回调 status=' + status);
                    handleRouteResult(status, result, 'walking');
                });
            } else if (_currentRouteType === 'transit' && _transfer) {
                _transfer.search(origin, dest, function(status, result) {
                    log('公交回调 status=' + status);
                    handleRouteResult(status, result, 'transit');
                });
            } else {
                err('路线插件未就绪: ' + _currentRouteType);
                setStatus('路线规划插件未就绪，请刷新页面。');
            }
        } catch(e) {
            err('路线规划异常: ' + e.message);
            setStatus('路线规划失败: ' + e.message);
        }
    }

    function clearRoute() {
        try { if (_driving) _driving.clear(); } catch(e) {}
        try { if (_walking) _walking.clear(); } catch(e) {}
        try { if (_transfer) _transfer.clear(); } catch(e) {}
    }

    function handleRouteResult(status, result, type) {
        // 完整打印 result 结构用于定位公交数据位置
        log('handleRouteResult: type=' + type + ' status=' + status);
        if (result) {
            log('result keys: ' + Object.keys(result).join(', '));
            log('result.info=' + result.info + ' routes=' + (result.routes ? result.routes.length : undefined) + ' plans=' + (result.plans ? result.plans.length : undefined));
            // 递归打印前几层
            try { log('result JSON (depth 3): ' + JSON.stringify(result, null, 0).substring(0, 2000)); } catch(e) {}
        }

        if (status === 'complete' && result.info === 'OK') {
            // 兼容 Transfer 插件可能把路线放在 plans 而非 routes
            var routes = result.routes || result.plans || [];
            log('路线规划成功, 有效routes=' + routes.length);
            if (routes.length === 0 && result.routes && result.routes.length > 0) {
                routes = result.routes; // fallback
            }
            // 构建兼容的 result 对象
            var compatResult = { info: 'OK', routes: routes, originResult: result };
            displayRouteDetail(compatResult, type);
            setStatus('路线规划成功（' + (type==='driving'?'驾车':type==='walking'?'步行':'公交') + '）→ ' + _scenicName);
        } else {
            log('路线规划失败, status=' + status + ' info=' + (result ? result.info : 'null'));
            var summary = $('route-summary');
            var steps = $('route-steps');
            var placeholder = $('route-placeholder');
            if (summary) summary.style.display = 'none';
            if (steps) steps.innerHTML = '<div style="text-align:center;padding:20px;color:#e74c3c;">未找到合适路线，请更换起点或尝试其他出行方式。</div>';
            if (placeholder) placeholder.style.display = 'none';
            setStatus('路线规划失败，请尝试其他出行方式。');
        }
    }

    function displayRouteDetail(result, type) {
        var placeholder = $('route-placeholder');
        var summary = $('route-summary');
        if (placeholder) placeholder.style.display = 'none';
        if (summary) summary.style.display = 'block';

        // 兼容不同的 result 结构
        var routes = result.routes;
        var route = (routes && routes.length > 0) ? routes[0] : null;
        log('displayRouteDetail: type=' + type + ' routesCount=' + (routes ? routes.length : 0) + ' hasRoute=' + !!route);
        if (route) {
            log('route top-level keys: ' + Object.keys(route).join(', '));
            log('route.distance=' + route.distance + ' route.time=' + route.time + ' segments=' + (route.segments ? route.segments.length : 'undefined'));
        }

        if (!route) {
            if (summary) summary.style.display = 'none';
            var st = $('route-steps');
            if (st) st.innerHTML = '<div style="text-align:center;padding:20px;color:#999;">无可用路线</div>';
            return;
        }

        // 距离和时间
        var totalDist = route.distance || 0;
        var totalTime = route.time || 0;
        var distEl = $('route-distance');
        var durEl = $('route-duration');
        if (distEl) distEl.textContent = totalDist > 0 ? (totalDist / 1000).toFixed(1) : '--';
        if (durEl) durEl.textContent = totalTime > 0 ? Math.round(totalTime / 60) : '--';

        // 公交费用（cost 直接在 route/plan 对象上）
        if (type === 'transit') {
            var costWrap = $('route-cost-wrap');
            if (costWrap) costWrap.style.display = '';
            var costEl = $('route-cost');
            if (costEl) {
                if (route.cost != null && route.cost > 0) {
                    costEl.textContent = route.cost;
                    costEl.title = '';
                } else if (route.cost === 0) {
                    costEl.textContent = '0';
                    costEl.title = '该线路票价数据可能未收录，仅供参考';
                    costEl.style.cursor = 'help';
                    costEl.style.borderBottom = '1px dashed #999';
                } else {
                    costEl.textContent = '--';
                    costEl.title = '';
                    costEl.style.cursor = '';
                    costEl.style.borderBottom = '';
                }
            }
        } else {
            var costWrap2 = $('route-cost-wrap');
            if (costWrap2) costWrap2.style.display = 'none';
        }

        // 渲染步骤
        var stepsHtml = '', stepNum = 0;

        if (type === 'driving' || type === 'walking') {
            if (route.steps) {
                route.steps.forEach(function(s) {
                    stepNum++;
                    var d = s.distance > 1000 ? (s.distance/1000).toFixed(1)+'公里' : s.distance+'米';
                    stepsHtml += '<div class="route-step"><div class="route-step-icon">'+stepNum+'</div><div style="flex:1;">'+s.instruction+' <span style="color:#bbb;font-size:11px;">('+d+')</span></div></div>';
                });
            }
        } else if (type === 'transit') {
            if (route.segments && route.segments.length > 0) {
                route.segments.forEach(function(seg) {
                    var mode = seg.transit_mode || '';
                    var instr = seg.instruction || '';
                    var dist = seg.distance || 0;
                    var distText = dist > 1000 ? (dist/1000).toFixed(1)+'公里' : dist+'米';

                    if (mode === 'WALK' || mode === 'WALKING') {
                        // 步行段：优先展示 segmented steps，否则用 instruction
                        if (seg.transit && seg.transit.steps && seg.transit.steps.length > 0) {
                            seg.transit.steps.forEach(function(s) {
                                stepNum++;
                                var sd = s.distance > 1000 ? (s.distance/1000).toFixed(1)+'公里' : s.distance+'米';
                                stepsHtml += '<div class="route-step"><div class="route-step-icon"><i class="fa fa-male"></i></div><div style="flex:1;">'+s.instruction+' <span style="color:#bbb;font-size:11px;">('+sd+')</span></div></div>';
                            });
                        } else {
                            stepNum++;
                            stepsHtml += '<div class="route-step"><div class="route-step-icon"><i class="fa fa-male"></i></div><div style="flex:1;">'+instr+' <span style="color:#bbb;font-size:11px;">('+distText+')</span></div></div>';
                        }
                    } else if (mode === 'BUS' || mode === 'SUBWAY' || mode === 'RAILWAY') {
                        // 公交/地铁段
                        stepNum++;
                        var iconClass = (mode === 'SUBWAY' || mode === 'RAILWAY') ? 'fa fa-subway' : 'fa fa-bus';
                        var onName = '', offName = '', stations = '';
                        if (seg.transit) {
                            onName = (seg.transit.on_station && seg.transit.on_station.name) || '';
                            offName = (seg.transit.off_station && seg.transit.off_station.name) || '';
                        }
                        if (onName && offName) {
                            stepsHtml += '<div class="route-step"><div class="route-step-icon" style="background:#00a8a8;color:#fff;"><i class="'+iconClass+'"></i></div><div style="flex:1;"><strong>'+instr+'</strong><br><span style="font-size:11px;color:#999;">'+onName+' → '+offName+'</span></div></div>';
                        } else {
                            stepsHtml += '<div class="route-step"><div class="route-step-icon" style="background:#00a8a8;color:#fff;"><i class="'+iconClass+'"></i></div><div style="flex:1;">'+instr+'</div></div>';
                        }
                    } else {
                        // fallback：直接用 segment 的 instruction
                        stepNum++;
                        stepsHtml += '<div class="route-step"><div class="route-step-icon">'+stepNum+'</div><div style="flex:1;">'+instr+' <span style="color:#bbb;font-size:11px;">('+distText+')</span></div></div>';
                    }
                });
            }
        }

        log('渲染步骤总数: ' + stepNum);
        var stepsEl = $('route-steps');
        if (stepsEl) stepsEl.innerHTML = stepsHtml || '<div style="text-align:center;padding:10px;color:#999;">无详细步骤</div>';
    }

    // ==================== 初始化 ====================
    function initMap() {
        log('initMap 开始');

        if (typeof AMap === 'undefined') {
            err('AMap 未定义！');
            setStatus('高德地图加载失败，请检查网络连接。');
            return;
        }
        log('AMap 版本: ' + (AMap.version || '未知'));

        if (!resolveCoords()) {
            setStatus('未找到「' + _scenicName + '」的坐标，<a href="https://uri.amap.com/search?keyword=' + encodeURIComponent(_scenicName) + '" target="_blank" style="color:#00a8a8;">点击在高德地图中查看</a>');
            return;
        }

        // 创建地图（AMap.Map 是核心 API，不需要插件）
        log('创建地图...');
        try {
            _map = new AMap.Map('map-container', {
                zoom: 15,
                center: [_targetLng, _targetLat],
                resizeEnable: true
            });
            log('地图创建成功');
        } catch(e) {
            err('地图创建失败: ' + e.message);
            setStatus('地图初始化失败: ' + e.message);
            return;
        }

        // 目的地标记（Marker/InfoWindow/Pixel 都是核心 API，不需要插件）
        try {
            _destMarker = new AMap.Marker({
                position: [_targetLng, _targetLat],
                title: _scenicName,
                animation: 'AMAP_ANIMATION_DROP',
                map: _map
            });
            var infoContent = '<div style="padding:8px 14px;"><strong style="color:#00a8a8;font-size:15px;">' + _scenicName + '</strong><br><span style="font-size:12px;color:#999;">目的地</span></div>';
            var destInfo = new AMap.InfoWindow({ content: infoContent, offset: new AMap.Pixel(0, -40) });
            destInfo.open(_map, [_targetLng, _targetLat]);
            _destMarker.on('click', function() { destInfo.open(_map, [_targetLng, _targetLat]); });
            log('目的地标记完成');
        } catch(e) {
            err('标记创建失败: ' + e.message);
        }

        setStatus('目的地：' + _scenicName + ' | 插件加载中...');

        // 使用 AMap.plugin 按需加载所有插件
        // ToolBar、Scale 也是插件，必须在此加载
        log('开始加载插件...');
        AMap.plugin(
            ['AMap.ToolBar', 'AMap.Scale', 'AMap.Driving', 'AMap.Walking', 'AMap.Transfer', 'AMap.Autocomplete', 'AMap.Geocoder', 'AMap.Geolocation'],
            function() {
                log('所有插件加载完成');

                // 添加地图控件（插件已就绪）
                try {
                    _map.addControl(new AMap.ToolBar({ position: 'RT' }));
                    _map.addControl(new AMap.Scale({ position: 'LB' }));
                    log('地图控件添加完成');
                } catch(e) {
                    err('控件添加失败: ' + e.message);
                }

                // 初始化路线规划
                try {
                    _driving = new AMap.Driving({ map: _map, panel: null, autoFitView: true });
                    _walking = new AMap.Walking({ map: _map, panel: null, autoFitView: true });
                    _transfer = new AMap.Transfer({ map: _map, panel: null, autoFitView: true, city: '银川' });
                    log('路线规划插件初始化完成');
                } catch(e) {
                    err('路线插件初始化失败: ' + e.message);
                }

                // 地址自动补全
                try {
                    var auto = new AMap.Autocomplete({ input: 'start-input', city: '银川', citylimit: false });
                    AMap.Event.addListener(auto, 'select', function(e) {
                        if (e.poi && e.poi.location) {
                            setStartPoint(e.poi.location.lng, e.poi.location.lat, e.poi.name);
                        }
                    });
                    log('Autocomplete 初始化完成');
                } catch(e) {
                    err('Autocomplete 初始化失败: ' + e.message);
                }

                // 绑定按钮事件
                var btnSearch = $('btn-search');
                var btnLocate = $('btn-locate');
                var tabDriving = $('tab-driving');
                var tabWalking = $('tab-walking');
                var tabTransit = $('tab-transit');
                var startInput = $('start-input');

                log('DOM元素: btnSearch=' + !!btnSearch + ' btnLocate=' + !!btnLocate + ' tabDriving=' + !!tabDriving + ' startInput=' + !!startInput);

                if (btnSearch) btnSearch.addEventListener('click', window.searchRoute);
                else err('找不到 btn-search 元素！');

                if (btnLocate) btnLocate.addEventListener('click', window.locateMe);
                else err('找不到 btn-locate 元素！');

                if (tabDriving) tabDriving.addEventListener('click', function() { window.switchRouteType('driving'); });
                if (tabWalking) tabWalking.addEventListener('click', function() { window.switchRouteType('walking'); });
                if (tabTransit) tabTransit.addEventListener('click', function() { window.switchRouteType('transit'); });

                if (startInput) {
                    startInput.addEventListener('keydown', function(e) {
                        if (e.keyCode === 13) { e.preventDefault(); window.searchRoute(); }
                    });
                }

                setStatus('就绪 — 输入起点或点击"定位"开始路线规划');
                log('初始化完成，所有交互已绑定');
            }
        );
    }

    // ==================== 启动 ====================
    log('准备调用 initMap, readyState=' + document.readyState);
    if (document.readyState === 'loading') {
        log('等待 DOMContentLoaded...');
        document.addEventListener('DOMContentLoaded', initMap);
    } else {
        log('DOM 已就绪，直接执行 initMap');
        initMap();
    }

})();
</script>
</div><!-- .page close -->
<div class="snackbars" id="form-output-global"></div>
<script src="js/core.min.js"></script>
<script src="js/script.js"></script>
</body>
</html>
