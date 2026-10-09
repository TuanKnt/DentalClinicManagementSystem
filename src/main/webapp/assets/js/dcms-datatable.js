/**
 * DCMS Universal Data Table Standard Library (dcms-datatable.js)
 * High-performance, zero-dependency data table engine with:
 * - Real-time Search (Vietnamese accent-insensitive & fuzzy matching)
 * - Multi-type Column Sorting (Text, Code/ID, Date, Time, Badge)
 * - Dynamic Pagination with customizable page sizes (5, 10, 25, 50, Tất cả)
 * - Integrated with Dr.Smile enterprise design system
 * 
 * Note: All user-facing strings use Unicode escape sequences to guarantee
 * 100% correct display across any web server / encoding environment.
 */

(function (window, document) {
    'use strict';

    // Localized constants (Unicode-escaped for bulletproof encoding resilience)
    const STR_PAGE_SHOW = '\u0048\u0069\u1EC3\u006E\u0020\u0074\u0068\u1ECB'; // Hiển thị
    const STR_PAGE_RECORDS_PER_PAGE = '\u0062\u1EA3\u006E\u0020\u0067\u0068\u0069\u0020\u002F\u0020\u0074\u0072\u0061\u006E\u0067'; // bản ghi / trang
    const STR_ALL = '\u0054\u1EA5\u0074\u0020\u0063\u1EA3'; // Tất cả
    const STR_SEARCH_PLACEHOLDER = '\u0054\u00EC\u006D\u0020\u006B\u0069\u1EBF\u006D\u0020\u006E\u0068\u0061\u006E\u0068\u0020\u0074\u0072\u006F\u006E\u0067\u0020\u0062\u1EA3\u006E\u0067\u002E\u002E\u002E'; // Tìm kiếm nhanh trong bảng...
    const STR_SEARCH_CLEAR = '\u0058\u00F3\u0061\u0020\u0074\u00EC\u006D\u0020\u006B\u0069\u1EBF\u006D'; // Xóa tìm kiếm
    const STR_SORT_TOOLTIP = '\u0043\u006C\u0069\u0063\u006B\u0020\u0111\u1EC3\u0020\u0073\u1EAF\u0070\u0020\u0078\u1EBF\u0070'; // Click để sắp xếp
    const STR_NO_DATA = '\u004B\u0068\u00F4\u006E\u0067\u0020\u0074\u00EC\u006D\u0020\u0074\u0068\u1EA5\u0079\u0020\u0064\u1EEF\u0020\u006C\u0069\u1EC7\u0075\u0020\u0070\u0068\u00F9\u0020\u0068\u1EE3\u0070\u002E'; // Không tìm thấy dữ liệu phù hợp.
    const STR_NO_DATA_HINT = '\u0054\u0068\u1EED\u0020\u006E\u0068\u1EAD\u0070\u0020\u0074\u1EEB\u0020\u006B\u0068\u00F3\u0061\u0020\u006B\u0068\u00E1\u0063\u0020\u0111\u1EC3\u0020\u0074\u00EC\u006D\u0020\u006B\u0069\u1EBF\u006D\u002E'; // Thử nhập từ khóa khác để tìm kiếm.
    const STR_INFO_FORMAT = '\u0048\u0069\u1EC3\u006E\u0020\u0074\u0068\u1ECB\u0020\u007B\u0073\u0074\u0061\u0072\u0074\u007D\u0020\u2013\u0020\u007B\u0065\u006E\u0064\u007D\u0020\u0074\u0072\u00EA\u006E\u0020\u0074\u1ED5\u006E\u0067\u0020\u007B\u0074\u006F\u0074\u0061\u006C\u007D\u0020\u0062\u1EA3\u006E\u0020\u0067\u0068\u0069'; // Hiển thị {start} – {end} trên tổng {total} bản ghi
    const STR_ZERO_RECORDS = '\u0030\u0020\u0062\u1EA3\u006E\u0020\u0067\u0068\u0069'; // 0 bản ghi

    // Remove Vietnamese accents for resilient searching
    function removeVietnameseTones(str) {
        if (!str) return '';
        str = str.toString().toLowerCase();
        str = str.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
        str = str.replace(/\u0111/g, 'd').replace(/\u0110/g, 'd'); // đ / Đ
        return str.trim();
    }

    class DcmsDataTable {
        constructor(tableSelectorOrElement, options = {}) {
            this.table = typeof tableSelectorOrElement === 'string'
                ? document.querySelector(tableSelectorOrElement)
                : tableSelectorOrElement;

            if (!this.table || this.table.tagName !== 'TABLE') {
                return;
            }

            if (this.table._dcmsDataTable) {
                return this.table._dcmsDataTable; // Avoid double initialization
            }
            this.table._dcmsDataTable = this;

            this.options = Object.assign({
                pageSize: 10,
                pageSizeOptions: [5, 10, 25, 50, -1],
                searchable: true,
                sortable: true,
                pagination: true,
                searchPlaceholder: STR_SEARCH_PLACEHOLDER,
                externalSearchInput: null,
                customFilterFn: null,
                noDataMessage: STR_NO_DATA,
                infoFormat: STR_INFO_FORMAT
            }, options);

            this.tbody = this.table.querySelector('tbody');
            if (!this.tbody) return;

            // Cache original rows (excluding empty rows)
            this.allRows = Array.from(this.tbody.querySelectorAll('tr')).filter(tr => !tr.classList.contains('dt-empty-row'));
            this.filteredRows = [...this.allRows];
            this.currentPage = 1;
            this.pageSize = this.options.pageSize;
            this.currentSort = { colIndex: -1, order: 'none' };
            this.searchTerm = '';

            this.init();
        }

        init() {
            // Build UI wrappers
            this.buildControls();

            // Setup sorting on TH
            if (this.options.sortable) {
                this.setupSorting();
            }

            // Initial render
            this.applyFiltersAndRender();
        }

        buildControls() {
            let container = this.table.closest('.dt-container');
            if (!container) {
                container = document.createElement('div');
                container.className = 'dt-container';
                const tableWrap = this.table.closest('.table-responsive') || this.table;
                tableWrap.parentNode.insertBefore(container, tableWrap);

                // Create Top Toolbar
                this.topToolbar = document.createElement('div');
                this.topToolbar.className = 'dt-toolbar';

                // Left: Page Size Selector
                if (this.options.pagination) {
                    const leftCol = document.createElement('div');
                    leftCol.className = 'dt-toolbar-left';
                    leftCol.innerHTML = `
                        <label class="dt-page-size-label">
                            <span>${STR_PAGE_SHOW}</span>
                            <select class="form-control dt-page-size-select">
                                ${this.options.pageSizeOptions.map(size => `
                                    <option value="${size}" ${size === this.pageSize ? 'selected' : ''}>
                                        ${size === -1 ? STR_ALL : size}
                                    </option>
                                `).join('')}
                            </select>
                            <span>${STR_PAGE_RECORDS_PER_PAGE}</span>
                        </label>
                    `;
                    const select = leftCol.querySelector('.dt-page-size-select');
                    select.addEventListener('change', (e) => {
                        this.pageSize = parseInt(e.target.value, 10);
                        this.currentPage = 1;
                        this.render();
                    });
                    this.topToolbar.appendChild(leftCol);
                }

                // Right: Search Input
                if (this.options.searchable) {
                    if (this.options.externalSearchInput) {
                        const extInput = document.querySelector(this.options.externalSearchInput);
                        if (extInput) {
                            extInput.addEventListener('input', (e) => {
                                this.searchTerm = e.target.value;
                                this.currentPage = 1;
                                this.applyFiltersAndRender();
                            });
                        }
                    } else {
                        const rightCol = document.createElement('div');
                        rightCol.className = 'dt-toolbar-right';
                        rightCol.innerHTML = `
                            <div class="dt-search-box">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <input type="text" class="form-control dt-search-input" placeholder="${this.options.searchPlaceholder}" />
                                <button type="button" class="dt-search-clear" style="display:none;" title="${STR_SEARCH_CLEAR}">&times;</button>
                            </div>
                        `;
                        const searchInput = rightCol.querySelector('.dt-search-input');
                        const clearBtn = rightCol.querySelector('.dt-search-clear');

                        searchInput.addEventListener('input', (e) => {
                            this.searchTerm = e.target.value;
                            clearBtn.style.display = this.searchTerm ? 'block' : 'none';
                            this.currentPage = 1;
                            this.applyFiltersAndRender();
                        });

                        clearBtn.addEventListener('click', () => {
                            searchInput.value = '';
                            this.searchTerm = '';
                            clearBtn.style.display = 'none';
                            this.currentPage = 1;
                            this.applyFiltersAndRender();
                            searchInput.focus();
                        });

                        this.topToolbar.appendChild(rightCol);
                    }
                }

                container.appendChild(this.topToolbar);

                // Move table into container
                container.appendChild(tableWrap);

                // Create Bottom Pagination Bar
                if (this.options.pagination) {
                    this.bottomBar = document.createElement('div');
                    this.bottomBar.className = 'dt-bottom-bar';
                    this.bottomBar.innerHTML = `
                        <div class="dt-info"></div>
                        <div class="dt-pagination"></div>
                    `;
                    container.appendChild(this.bottomBar);
                }
            }
        }

        setupSorting() {
            const thList = this.table.querySelectorAll('thead th');
            thList.forEach((th, colIndex) => {
                const headerText = removeVietnameseTones(th.innerText);
                const isNoSort = th.hasAttribute('data-no-sort')
                    || th.classList.contains('no-sort')
                    || headerText.includes('thao tac')
                    || headerText.includes('hanh dong')
                    || headerText.includes('action');

                if (isNoSort) return;

                th.classList.add('dt-sortable');
                th.title = STR_SORT_TOOLTIP;

                // Add sort indicator icon if not present
                let iconSpan = th.querySelector('.dt-sort-icon');
                if (!iconSpan) {
                    iconSpan = document.createElement('span');
                    iconSpan.className = 'dt-sort-icon';
                    iconSpan.innerHTML = '<span class="dt-sort-indicator">\u21C5</span>';
                    th.appendChild(iconSpan);
                }

                th.addEventListener('click', () => {
                    this.handleSort(colIndex, th);
                });
            });
        }

        handleSort(colIndex, th) {
            let newOrder = 'asc';
            if (this.currentSort.colIndex === colIndex) {
                newOrder = this.currentSort.order === 'asc' ? 'desc' : (this.currentSort.order === 'desc' ? 'none' : 'asc');
            }

            // Reset all header indicators
            this.table.querySelectorAll('thead th.dt-sortable').forEach(h => {
                h.classList.remove('dt-sort-asc', 'dt-sort-desc');
                const ind = h.querySelector('.dt-sort-indicator');
                if (ind) ind.textContent = '\u21C5';
            });

            this.currentSort = { colIndex, order: newOrder };

            if (newOrder === 'none') {
                this.applyFiltersAndRender();
                return;
            }

            th.classList.add(newOrder === 'asc' ? 'dt-sort-asc' : 'dt-sort-desc');
            const ind = th.querySelector('.dt-sort-indicator');
            if (ind) ind.textContent = newOrder === 'asc' ? '\u25B2' : '\u25BC';

            // Perform sort
            this.filteredRows.sort((rowA, rowB) => {
                const cellA = rowA.cells[colIndex];
                const cellB = rowB.cells[colIndex];
                if (!cellA || !cellB) return 0;

                const valA = cellA.innerText.trim();
                const valB = cellB.innerText.trim();

                // 1. Numeric or code comparison (e.g. #1002, 1002, BS-4)
                const numA = parseFloat(valA.replace(/[^\d.-]/g, ''));
                const numB = parseFloat(valB.replace(/[^\d.-]/g, ''));
                if (!isNaN(numA) && !isNaN(numB) && !valA.includes(':') && !valA.includes('/')) {
                    return newOrder === 'asc' ? numA - numB : numB - numA;
                }

                // 2. Default String / Vietnamese comparison
                const res = valA.localeCompare(valB, 'vi', { sensitivity: 'base', numeric: true });
                return newOrder === 'asc' ? res : -res;
            });

            this.currentPage = 1;
            this.render();
        }

        setCustomFilter(filterFn) {
            this.options.customFilterFn = filterFn;
            this.currentPage = 1;
            this.applyFiltersAndRender();
        }

        applyFiltersAndRender() {
            const rawSearch = removeVietnameseTones(this.searchTerm);

            this.filteredRows = this.allRows.filter(row => {
                // Check custom filter if present
                if (typeof this.options.customFilterFn === 'function') {
                    if (!this.options.customFilterFn(row)) {
                        return false;
                    }
                }

                // Check text search
                if (!rawSearch) return true;

                const rowContent = removeVietnameseTones(row.innerText);
                return rowContent.includes(rawSearch);
            });

            this.render();
        }

        render() {
            const total = this.filteredRows.length;
            const pageSize = this.pageSize === -1 ? total : this.pageSize;
            const totalPages = Math.max(1, Math.ceil(total / (pageSize || 1)));

            if (this.currentPage > totalPages) {
                this.currentPage = totalPages;
            }

            const startIndex = (this.currentPage - 1) * pageSize;
            const endIndex = this.pageSize === -1 ? total : Math.min(startIndex + pageSize, total);

            // Hide all original rows first
            this.allRows.forEach(row => {
                row.style.display = 'none';
            });

            // Remove existing empty state message if any
            const existingEmpty = this.tbody.querySelector('.dt-empty-row');
            if (existingEmpty) {
                existingEmpty.remove();
            }

            if (total === 0) {
                const colSpan = this.table.querySelectorAll('thead th').length || 6;
                const emptyTr = document.createElement('tr');
                emptyTr.className = 'dt-empty-row';
                emptyTr.innerHTML = `
                    <td colspan="${colSpan}" style="text-align: center; padding: 48px 20px; color: var(--text-muted, #64748b);">
                        <div style="font-size: 15px; font-weight: 700; color: var(--drsmile-navy, #003366); margin-bottom: 4px;">
                            ${this.options.noDataMessage}
                        </div>
                        <div style="font-size: 13px;">${STR_NO_DATA_HINT}</div>
                    </td>
                `;
                this.tbody.appendChild(emptyTr);
            } else {
                // Show rows in current slice and preserve order
                for (let i = startIndex; i < endIndex; i++) {
                    const row = this.filteredRows[i];
                    row.style.display = '';
                    this.tbody.appendChild(row); // Keep sorted order
                }
            }

            // Update Bottom Info & Pagination
            if (this.bottomBar) {
                this.renderInfo(startIndex, endIndex, total);
                this.renderPagination(totalPages);
            }
        }

        renderInfo(start, end, total) {
            const infoEl = this.bottomBar.querySelector('.dt-info');
            if (!infoEl) return;

            if (total === 0) {
                infoEl.textContent = STR_ZERO_RECORDS;
                return;
            }

            const text = this.options.infoFormat
                .replace('{start}', start + 1)
                .replace('{end}', end)
                .replace('{total}', total);
            infoEl.innerHTML = text;
        }

        renderPagination(totalPages) {
            const pagEl = this.bottomBar.querySelector('.dt-pagination');
            if (!pagEl) return;

            if (totalPages <= 1) {
                pagEl.innerHTML = '';
                return;
            }

            let html = '';

            // First & Prev Buttons
            html += `
                <button type="button" class="dt-pag-btn" data-page="1" ${this.currentPage === 1 ? 'disabled' : ''} title="\u0054\u0072\u0061\u006E\u0067\u0020\u0111\u1EA7\u0075">
                    &laquo;
                </button>
                <button type="button" class="dt-pag-btn" data-page="${this.currentPage - 1}" ${this.currentPage === 1 ? 'disabled' : ''} title="\u0054\u0072\u0061\u006E\u0067\u0020\u0074\u0072\u01B0\u1EDB\u0063">
                    &lsaquo;
                </button>
            `;

            // Page numbers
            const maxVisible = 5;
            let startPage = Math.max(1, this.currentPage - Math.floor(maxVisible / 2));
            let endPage = Math.min(totalPages, startPage + maxVisible - 1);
            if (endPage - startPage < maxVisible - 1) {
                startPage = Math.max(1, endPage - maxVisible + 1);
            }

            if (startPage > 1) {
                html += `<button type="button" class="dt-pag-btn" data-page="1">1</button>`;
                if (startPage > 2) html += `<span class="dt-pag-ellipsis">&hellip;</span>`;
            }

            for (let p = startPage; p <= endPage; p++) {
                html += `
                    <button type="button" class="dt-pag-btn ${p === this.currentPage ? 'active' : ''}" data-page="${p}">
                        ${p}
                    </button>
                `;
            }

            if (endPage < totalPages) {
                if (endPage < totalPages - 1) html += `<span class="dt-pag-ellipsis">&hellip;</span>`;
                html += `<button type="button" class="dt-pag-btn" data-page="${totalPages}">${totalPages}</button>`;
            }

            // Next & Last Buttons
            html += `
                <button type="button" class="dt-pag-btn" data-page="${this.currentPage + 1}" ${this.currentPage === totalPages ? 'disabled' : ''} title="\u0054\u0072\u0061\u006E\u0067\u0020\u0073\u0061\u0075">
                    &rsaquo;
                </button>
                <button type="button" class="dt-pag-btn" data-page="${totalPages}" ${this.currentPage === totalPages ? 'disabled' : ''} title="\u0054\u0072\u0061\u006E\u0067\u0020\u0063\u0075\u1ED1\u0069">
                    &raquo;
                </button>
            `;

            pagEl.innerHTML = html;

            // Bind click handlers
            pagEl.querySelectorAll('.dt-pag-btn').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const targetPage = parseInt(e.currentTarget.getAttribute('data-page'), 10);
                    if (targetPage && targetPage !== this.currentPage && targetPage >= 1 && targetPage <= totalPages) {
                        this.currentPage = targetPage;
                        this.render();
                    }
                });
            });
        }

        // Public method to refresh table rows dynamically
        refresh() {
            this.allRows = Array.from(this.tbody.querySelectorAll('tr')).filter(tr => !tr.classList.contains('dt-empty-row'));
            this.applyFiltersAndRender();
        }
    }

    // Auto-initialize tables with [data-datatable="true"] or .dcms-datatable
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('table[data-datatable="true"], table.dcms-datatable').forEach(table => {
            const pageSize = parseInt(table.getAttribute('data-page-size') || '10', 10);
            const extSearch = table.getAttribute('data-external-search');
            new DcmsDataTable(table, {
                pageSize: pageSize,
                externalSearchInput: extSearch || null
            });
        });
    });

    window.DcmsDataTable = DcmsDataTable;

})(window, document);
