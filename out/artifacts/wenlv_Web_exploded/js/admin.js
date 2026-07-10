function showSection(sectionId) {
    // Hide all sections
    document.querySelectorAll('.section').forEach(section => {
        section.style.display = 'none';
    });

    // Remove active class from all navigation links
    document.querySelectorAll('.admin-sidebar .nav-link').forEach(link => {
        link.classList.remove('active');
    });

    // Show the selected section
    const targetSection = document.getElementById(sectionId);
    if (targetSection) {
        targetSection.style.display = 'block';
    }

    // Add active class to the clicked link
    const clickedLink = event.target;
    if (clickedLink && clickedLink.classList.contains('nav-link')) {
        clickedLink.classList.add('active');
    }
}

function logout() {
    localStorage.removeItem('adminUsername');
    localStorage.removeItem('isAdminLoggedIn');
    window.location.href = 'index.html';
}

window.onload = function () {
    const adminName = localStorage.getItem('adminUsername');
    const adminNameElement = document.getElementById('admin-name');
    if (adminNameElement) {
        adminNameElement.textContent = adminName || '';
    }

    // 暂时跳过登录检查，方便开发调试
    // if (!localStorage.getItem('isAdminLoggedIn')) {
    //     window.location.href = 'index.html';
    //     return;
    // }

    const hash = window.location.hash.substring(1);
    if (hash) {
        // Hide all sections and remove active classes first
        document.querySelectorAll('.section').forEach(section => {
            section.style.display = 'none';
        });
        document.querySelectorAll('.admin-sidebar .nav-link').forEach(link => {
            link.classList.remove('active');
        });

        // Show the section corresponding to hash
        const targetSection = document.getElementById(hash);
        if (targetSection) {
            targetSection.style.display = 'block';
        }

        // Activate the corresponding nav link
        const activeLink = document.querySelector(
            `.admin-sidebar .nav-link[href*="${hash}"]`
        );
        if (activeLink) {
            activeLink.classList.add('active');
        }
    } else {
        // If no hash, show default section (e.g., dashboard)
        const defaultSection = document.getElementById('dashboard');
        if (defaultSection) {
            defaultSection.style.display = 'block';
        }
        const defaultLink = document.querySelector('.admin-sidebar .nav-link[href*="dashboard"]');
        if (defaultLink) {
            defaultLink.classList.add('active');
        }
    }
};


