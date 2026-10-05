<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="app-header">
    <div class="header-search">
        <div class="search-input-wrapper">
            <span class="search-icon-fixed">🔍</span>
            <input type="text" 
                   id="globalSearchInput" 
                   class="header-search-input" 
                   placeholder="Tìm nhanh theo SĐT, Họ tên, CCCD..." 
                   autocomplete="off" />
            <span class="search-shortcut">Ctrl+K</span>
        </div>
        <div id="globalSearchResults" class="search-results-dropdown"></div>
    </div>

    <div class="header-right">
        <div class="clinic-status-pill">
            <span class="pulse-dot"></span>
            <span>Phòng Khám Hoạt Động</span>
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
                                a.innerHTML = '<div><strong>' + p.fullName + '</strong> <span style="color:var(--text-muted);font-size:12px;">(' + (p.gender || '') + ')</span></div>' +
                                              '<div style="color:var(--primary);font-family:monospace;font-weight:600;">' + p.phone + '</div>';
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
</script>
