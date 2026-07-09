// 弹出消息提示
function showToast(message, type) {
    var toast = document.createElement('div');
    toast.className = 'toast-notification ' + (type || 'success');
    toast.innerHTML = '<span>' + message + '</span><button onclick="this.parentElement.remove()">×</button>';
    document.body.appendChild(toast);

    setTimeout(function () {
        if (toast.parentNode) {
            toast.style.opacity = '0';
            setTimeout(function () {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 300);
        }
    }, 3000);
}

// 检测登录状态，切换右上角登录按钮/用户下拉菜单
function checkLoginStatus() {
    var isLoggedIn = localStorage.getItem('isLoggedIn') === 'true';
    var isAdminLoggedIn = localStorage.getItem('isAdminLoggedIn') === 'true';
    var container = document.getElementById('navbar-login-container');

    if (!container) return;

    if (isAdminLoggedIn) {
        var username = localStorage.getItem('adminUsername') || '管理员';
        container.innerHTML = '<div class="user-dropdown">' +
            '<a href="#" class="rd-nav-link user-dropdown-toggle" onclick="toggleUserDropdown(event)">欢迎，' + username + ' <i class="fa fa-caret-down"></i></a>' +
            '<div class="user-dropdown-menu">' +
            '<a href="admin.html" class="user-dropdown-item">管理后台</a>' +
            '<a href="#" class="user-dropdown-item" onclick="goToPersonalCenter()">个人中心</a>' +
            '<div class="user-dropdown-divider"></div>' +
            '<a href="#" class="user-dropdown-item" onclick="logout()">退出登录</a>' +
            '</div>' +
            '</div>';
    } else if (isLoggedIn) {
        var email = localStorage.getItem('userEmail') || localStorage.getItem('userUsername') || '用户';
        container.innerHTML = '<div class="user-dropdown">' +
            '<a href="#" class="rd-nav-link user-dropdown-toggle" onclick="toggleUserDropdown(event)">欢迎，' + email + ' <i class="fa fa-caret-down"></i></a>' +
            '<div class="user-dropdown-menu">' +
            '<a href="#" class="user-dropdown-item" onclick="goToPersonalCenter()">个人中心</a>' +
            '<div class="user-dropdown-divider"></div>' +
            '<a href="#" class="user-dropdown-item" onclick="logout()">退出登录</a>' +
            '</div>' +
            '</div>';
    } else {
        container.innerHTML = '<a href="#" class="rd-nav-link rd-navbar-login-toggle" data-bs-toggle="modal" data-bs-target="#login-modal">登录</a>';
    }
}

// 展开/收起用户下拉菜单
function toggleUserDropdown(event) {
    event.preventDefault();
    var dropdown = event.currentTarget.closest('.user-dropdown');
    var menu = dropdown.querySelector('.user-dropdown-menu');
    menu.classList.toggle('show');
}

// 点击空白处关闭下拉菜单
document.addEventListener('click', function (event) {
    var dropdowns = document.querySelectorAll('.user-dropdown-menu');
    dropdowns.forEach(function (menu) {
        if (!menu.contains(event.target) && !event.target.closest('.user-dropdown')) {
            menu.classList.remove('show');
        }
    });
});

// 跳转到个人中心，保存当前页面
function goToPersonalCenter() {
    var currentUrl = window.location.href;
    var currentPath = window.location.pathname;
    var personalCenterPath = '/PersonalCenter.jsp';
    
    if (currentPath !== personalCenterPath) {
        localStorage.setItem('previousPage', currentUrl);
    }
    
    window.location.href = 'PersonalCenter.jsp';
}

// 退出登录，清空本地存储
function logout() {
    var previousPage = localStorage.getItem('previousPage') || 'index.jsp';
    
    localStorage.removeItem('isLoggedIn');
    localStorage.removeItem('isAdminLoggedIn');
    localStorage.removeItem('userEmail');
    localStorage.removeItem('userUsername');
    localStorage.removeItem('userPhone');
    localStorage.removeItem('adminUsername');
    localStorage.removeItem('previousPage');
    
    showToast('已退出登录', 'info');
    window.location.href = previousPage;
}

// 通用关闭弹窗，手动清除遮罩
function closeModal(modalId) {
    var modalDom = document.getElementById(modalId);
    var modal = bootstrap.Modal.getInstance(modalDom);
    if (modal) {
        modal.hide();
    }
    // 强制移除遮罩层，解决黑屏无法点击
    document.querySelectorAll('.modal-backdrop').forEach(function(el) {
        el.remove();
    });
    document.body.classList.remove('modal-open');
}

// 普通用户登录提交
function handleLogin(event) {
    event.preventDefault();

    var email = document.getElementById('login-email').value;
    var password = document.getElementById('login-password').value;

    if (!email || !password) {
        alert('请填写用户名/邮箱和密码');
        return false;
    }

    if (email.length < 3) {
        alert('用户名/邮箱至少需要3个字符');
        return false;
    }

    if (password.length < 6) {
        alert('密码长度不能少于6位');
        return false;
    }

    localStorage.setItem('userEmail', email);
    localStorage.setItem('isLoggedIn', 'true');

    // 调用通用关闭弹窗，清除遮罩
    closeModal('login-modal');

    showToast('登录成功！欢迎回来', 'success');
    checkLoginStatus();

    return false;
}

// 管理员登录提交
function handleAdminLogin(event) {
    event.preventDefault();

    var username = document.getElementById('admin-username').value;
    var password = document.getElementById('admin-password').value;

    if (!username || !password) {
        alert('请填写管理员账号和密码');
        return false;
    }

    if (username.length < 3) {
        alert('管理员账号至少需要3个字符');
        return false;
    }

    if (password.length < 6) {
        alert('密码长度不能少于6位');
        return false;
    }

    localStorage.setItem('adminUsername', username);
    localStorage.setItem('isAdminLoggedIn', 'true');

    // 关闭弹窗清除遮罩
    closeModal('admin-login-modal');

    showToast('管理员登录成功！', 'success');

    setTimeout(function () {
        window.location.href = 'admin.html';
    }, 1000);

    return false;
}

// 用户注册提交
function handleRegister(event) {
    event.preventDefault();

    var username = document.getElementById('register-username').value;
    var phone = document.getElementById('register-phone').value;
    var password = document.getElementById('register-password').value;
    var confirmPassword = document.getElementById('register-confirm-password').value;
    var agree = document.getElementById('register-agree').checked;

    if (!username || !phone || !password || !confirmPassword) {
        alert('请填写所有必填字段');
        return false;
    }

    if (username.length < 3) {
        alert('用户名至少需要3个字符');
        return false;
    }

    if (!/^1[3-9]\d{9}$/.test(phone)) {
        alert('请输入有效的手机号');
        return false;
    }

    if (password.length < 6) {
        alert('密码长度不能少于6位');
        return false;
    }

    if (password !== confirmPassword) {
        alert('两次输入的密码不一致');
        return false;
    }

    if (!agree) {
        alert('请阅读并同意服务条款和隐私政策');
        return false;
    }

    localStorage.setItem('userUsername', username);
    localStorage.setItem('userPhone', phone);
    localStorage.setItem('isLoggedIn', 'true');

    // 关闭注册弹窗，清除遮罩
    closeModal('register-modal');

    showToast('注册成功！欢迎加入', 'success');
    checkLoginStatus();

    return false;
}

// 页面加载完成执行登录状态检测
window.addEventListener('load', function () {
    checkLoginStatus();
    document.querySelectorAll('.user-dropdown-menu').forEach(function(menu) {
        menu.classList.remove('show');
    });
    document.querySelectorAll('.modal-backdrop').forEach(function(el) {
        el.remove();
    });
    document.body.classList.remove('modal-open');
});