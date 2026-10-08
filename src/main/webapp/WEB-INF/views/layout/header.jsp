<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="app-header">
    <button type="button" class="mobile-menu-toggle" id="mobileMenuToggle" aria-label="Mở menu điều hướng" aria-expanded="false">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
    </button>
    <div class="header-search">
        <div class="search-input-wrapper">
            <svg class="search-icon-fixed" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="position:absolute; left:12px; top:50%; transform:translateY(-50%); opacity:0.6;"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            <input type="text" 
                   id="globalSearchInput" 
                   class="header-search-input" 
                   placeholder="Tìm nhanh theo SĐT, Họ tên, CCCD..." 
                   aria-label="Tìm nhanh bệnh nhân theo số điện thoại, họ tên hoặc CCCD"
                   autocomplete="off" />
            <span class="search-shortcut">Ctrl+K</span>
        </div>
        <div id="globalSearchResults" class="search-results-dropdown"></div>
    </div>

    <div class="header-right">
        <div class="clinic-status-pill">
            <span class="pulse-dot"></span>
            <span>DCMS Dental Care — Đang tiếp đón</span>
        </div>

        <div class="live-clock" id="liveClockDisplay">
            --:--:--
        </div>
    </div>
</header>

<script>
    // Live Clock Update
    function updateClock() {
        const now = new Date();
        const options = { weekday: 'short', day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit' };
        const timeStr = now.toLocaleDateString('vi-VN', options);
        const clockEl = document.getElementById('liveClockDisplay');
        if (clockEl) clockEl.innerText = timeStr;
    }
    setInterval(updateClock, 1000);
    updateClock();

    // Ctrl+K Shortcut to focus global search
    document.addEventListener('keydown', function(e) {
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
            e.preventDefault();
            const searchInput = document.getElementById('globalSearchInput');
            if (searchInput) searchInput.focus();
        }
    });

    // Global AJAX Search autocomplete
    const searchInput = document.getElementById('globalSearchInput');
    const searchResults = document.getElementById('globalSearchResults');
    let searchDebounce = null;

    if (searchInput && searchResults) {
        searchInput.addEventListener('input', function() {
            clearTimeout(searchDebounce);
            const query = this.value.trim();
            if (query.length < 2) {
                searchResults.style.display = 'none';
                searchResults.innerHTML = '';
                return;
            }

            searchDebounce = setTimeout(() => {
                fetch('${pageContext.request.contextPath}/reception/patients/search-ajax?term=' + encodeURIComponent(query))
                    .then(res => res.json())
                    .then(data => {
                        searchResults.innerHTML = '';
                        if (data && data.length > 0) {
                            data.forEach(p => {
                                const a = document.createElement('a');
                                a.className = 'search-item';
                                a.href = '${pageContext.request.contextPath}/reception/patients/edit?id=' + p.patientId;
                                const identity = document.createElement('div');
                                const name = document.createElement('strong');
                                name.textContent = p.fullName || 'Không rõ tên';
                                identity.appendChild(name);
                                const gender = document.createElement('span');
                                gender.style.cssText = 'color:var(--text-muted);font-size:12px;';
                                gender.textContent = ' (' + (p.gender || '') + ')';
                                identity.appendChild(gender);
                                const phone = document.createElement('div');
                                phone.style.cssText = 'color:var(--primary);font-family:monospace;font-weight:600;';
                                phone.textContent = p.phone || '';
                                a.appendChild(identity);
                                a.appendChild(phone);
                                searchResults.appendChild(a);
                            });
                            searchResults.style.display = 'block';
                        } else {
                            searchResults.innerHTML = '<div style="padding:14px;color:var(--text-muted);text-align:center;font-size:13px;">Không tìm thấy bệnh nhân nào.</div>';
                            searchResults.style.display = 'block';
                        }
                    })
                    .catch(err => console.error(err));
            }, 250);
        });

        document.addEventListener('click', function(e) {
            if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
                searchResults.style.display = 'none';
            }
        });
    }

    // Compact navigation on phones and tablets.
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const appShell = document.querySelector('.app-shell');
    const appSidebar = document.querySelector('.app-sidebar');
    if (mobileMenuToggle && appShell && appSidebar) {
        mobileMenuToggle.addEventListener('click', function () {
            const open = appShell.classList.toggle('sidebar-open');
            mobileMenuToggle.setAttribute('aria-expanded', open ? 'true' : 'false');
            mobileMenuToggle.setAttribute('aria-label', open ? 'Đóng menu điều hướng' : 'Mở menu điều hướng');
        });
        appSidebar.querySelectorAll('a').forEach(link => link.addEventListener('click', () => {
            appShell.classList.remove('sidebar-open');
            mobileMenuToggle.setAttribute('aria-expanded', 'false');
        }));
        appShell.addEventListener('click', function (event) {
            if (appShell.classList.contains('sidebar-open') && event.target === appShell) {
                appShell.classList.remove('sidebar-open');
                mobileMenuToggle.setAttribute('aria-expanded', 'false');
            }
        });
    }
</script>
