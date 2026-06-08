/**
 * 宁夏智慧文旅 - 登录状态管理模块
 * 使用 localStorage 模拟登录状态
 */

// 登录状态 key
var AUTH_KEY = 'nxwl_user';

/**
 * 获取当前登录用户信息
 * @returns {Object|null} 用户信息或 null
 */
function getUser() {
    var user = localStorage.getItem(AUTH_KEY);
    if (user) {
        try {
            return JSON.parse(user);
        } catch (e) {
            return null;
        }
    }
    return null;
}

/**
 * 判断是否已登录
 * @returns {boolean}
 */
function isLoggedIn() {
    return getUser() !== null;
}

/**
 * 设置登录用户
 * @param {Object} user 用户信息
 */
function setUser(user) {
    localStorage.setItem(AUTH_KEY, JSON.stringify(user));
}

/**
 * 退出登录
 */
function logout() {
    localStorage.removeItem(AUTH_KEY);
    window.location.href = 'login.html';
}

/**
 * 检查登录状态，未登录则跳转登录页
 * @param {string} targetUrl 登录后要跳转的目标页面（可选，默认当前页）
 * @returns {boolean} 是否已登录
 */
function checkLogin(targetUrl) {
    if (!isLoggedIn()) {
        var returnUrl = targetUrl || window.location.href;
        // 获取当前页面相对路径
        var path = returnUrl.substring(returnUrl.lastIndexOf('/') + 1);
        window.location.href = 'login.html?returnUrl=' + encodeURIComponent(path);
        return false;
    }
    return true;
}

/**
 * 需要登录才能执行的操作包装器
 * @param {string} targetUrl 登录后跳转的目标页面
 * @param {Function} callback 已登录时执行的回调
 */
function requireLogin(targetUrl, callback) {
    if (checkLogin(targetUrl)) {
        callback();
    }
}

/**
 * 更新导航栏登录状态
 * 在所有页面加载时调用，自动更新导航栏的登录/退出链接
 */
function updateNavLoginStatus() {
    var user = getUser();
    var navLinks = document.querySelectorAll('#header .link');
    if (navLinks.length === 0) return;

    navLinks.forEach(function (ul) {
        var items = ul.querySelectorAll('li');
        items.forEach(function (li) {
            var a = li.querySelector('a');
            if (!a) return;

            // 找到登录/退出/个人中心相关链接
            var href = a.getAttribute('href');
            if (href === 'login.html' && user) {
                // 已登录，将登录链接改为退出
                a.textContent = user.username || '退出登录';
                a.href = 'javascript:logout()';
            } else if (href === 'login.html' && !user) {
                a.textContent = '登录';
                a.href = 'login.html';
            }
        });
    });
}

// 页面加载时自动更新导航栏
document.addEventListener('DOMContentLoaded', function () {
    updateNavLoginStatus();
});