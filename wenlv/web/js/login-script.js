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
    var isLoggedIn = sessionStorage.getItem('isLoggedIn') === 'true';
    var isAdminLoggedIn = sessionStorage.getItem('isAdminLoggedIn') === 'true';
    var container = document.getElementById('navbar-login-container');

    if (!container) return;

    if (isAdminLoggedIn) {
        var username = sessionStorage.getItem('adminUsername') || '管理员';
        container.innerHTML = '<div class="user-dropdown">' +
            '<a href="#" class="rd-nav-link user-dropdown-toggle" onclick="toggleUserDropdown(event)">欢迎，' + username + ' <i class="fa fa-caret-down"></i></a>' +
            '<div class="user-dropdown-menu">' +
            '<a href="admin/user" class="user-dropdown-item">管理后台</a>' +
            '<a href="#" class="user-dropdown-item" onclick="goToPersonalCenter()">个人中心</a>' +
            '<div class="user-dropdown-divider"></div>' +
            '<a href="#" class="user-dropdown-item" onclick="logout()">退出登录</a>' +
            '</div>' +
            '</div>';
    } else if (isLoggedIn) {
        var nickname = sessionStorage.getItem('userNickname');
        var username = sessionStorage.getItem('userUsername') || '用户';
        var displayName = (nickname && nickname.trim() !== '') ? nickname : username;
        container.innerHTML = '<div class="user-dropdown">' +
            '<a href="#" class="rd-nav-link user-dropdown-toggle" onclick="toggleUserDropdown(event)">欢迎，' + displayName + ' <i class="fa fa-caret-down"></i></a>' +
            '<div class="user-dropdown-menu">' +
            '<a href="#" class="user-dropdown-item" onclick="goToPersonalCenter()">个人中心</a>' +
            '<div class="user-dropdown-divider"></div>' +
            '<a href="#" class="user-dropdown-item" onclick="logout()">退出登录</a>' +
            '</div>' +
            '</div>';
    } else {
        // 未登录时保留页面初始 HTML 中的登录链接，不替换 innerHTML
        // （否则会破坏 Bootstrap 的 data-bs-toggle 事件绑定）
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
    var personalCenterPath = '/personalCenter';
    
    if (currentPath !== personalCenterPath && currentPath !== '/PersonalCenter.jsp') {
        sessionStorage.setItem('previousPage', currentUrl);
    }
    
    window.location.href = 'personalCenter';
}

// 退出登录，清空本地存储
function logout() {
    var previousPage = sessionStorage.getItem('previousPage') || 'index.jsp';
    
    sessionStorage.removeItem('isLoggedIn');
    sessionStorage.removeItem('isAdminLoggedIn');
    sessionStorage.removeItem('userEmail');
    sessionStorage.removeItem('userUsername');
    sessionStorage.removeItem('userNickname');
    sessionStorage.removeItem('userPhone');
    sessionStorage.removeItem('userAvatar');
    sessionStorage.removeItem('adminUsername');
    sessionStorage.removeItem('previousPage');
    
    showToast('已退出登录', 'info');
    window.location.href = previousPage;
}

// 通用关闭弹窗，交由 Bootstrap 原生管理
function closeModal(modalId) {
    var modalDom = document.getElementById(modalId);
    if (modalDom) {
        var modal = bootstrap.Modal.getInstance(modalDom);
        if (modal) {
            modal.hide();
        }
    }
}

// 普通用户登录提交——调后端验证
function handleLogin() {
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

    // 调后端验证
    var formData = new FormData();
    formData.append('phoneOrEmail', email);
    formData.append('password', password);
    formData.append('_ajax', '1');

    fetch('login', { method: 'POST', body: formData })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.success) {
            // 后端验证通过 → 保存登录态到 sessionStorage
            sessionStorage.setItem('userUsername', data.username || email);
            sessionStorage.setItem('userNickname', data.nickname || '');
            sessionStorage.setItem('userPhone', data.phone || '');
            sessionStorage.setItem('userEmail', data.email || '');
            sessionStorage.setItem('userAvatar', data.avatar || '');
            sessionStorage.setItem('isLoggedIn', 'true');

            closeModal('login-modal');
            showToast('登录成功！欢迎回来', 'success');
            checkLoginStatus();
        } else {
            showToast(data.message || '登录失败', 'error');
        }
    })
    .catch(function() {
        showToast('网络错误，请确认服务器已启动', 'error');
    });

    return false;
}

// 管理员登录提交——调后端验证
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

    // 调后端验证
    var formData = new FormData();
    formData.append('action', 'adminLogin');
    formData.append('username', username);
    formData.append('password', password);

    fetch('login', { method: 'POST', body: formData })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.success) {
            sessionStorage.setItem('adminUsername', username);
            sessionStorage.setItem('isAdminLoggedIn', 'true');
            closeModal('admin-login-modal');
            showToast('管理员登录成功！', 'success');
            setTimeout(function () {
                window.location.href = 'admin/user';
            }, 800);
        } else {
            showToast(data.message || '管理员登录失败', 'error');
        }
    })
    .catch(function() {
        showToast('网络错误，请确认服务器已启动', 'error');
    });

    return false;
}

// 用户注册提交——调后端注册
function handleRegister(event) {
    event.preventDefault();

    var username = document.getElementById('register-username').value;
    var phone = document.getElementById('register-phone').value;
    var password = document.getElementById('register-password').value;
    var confirmPassword = document.getElementById('register-confirm-password').value;

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

    // 调后端注册
    var formData = new FormData();
    formData.append('action', 'register');
    formData.append('username', username);
    formData.append('phone', phone);
    formData.append('password', password);

    fetch('login', { method: 'POST', body: formData })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.success) {
            sessionStorage.setItem('userUsername', data.username || username);
            sessionStorage.setItem('userNickname', '');  // 新注册用户未设置昵称
            sessionStorage.setItem('userPhone', data.phone || phone);
            sessionStorage.setItem('userEmail', '');  // 新注册用户未设置邮箱
            sessionStorage.setItem('userAvatar', '');
            sessionStorage.setItem('isLoggedIn', 'true');

            closeModal('register-modal');
            showToast('注册成功！欢迎加入', 'success');
            checkLoginStatus();
        } else {
            showToast(data.message || '注册失败', 'error');
        }
    })
    .catch(function() {
        showToast('网络错误，请确认服务器已启动', 'error');
    });

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
