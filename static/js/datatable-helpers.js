/**
 * ESIMPEG Datatable Helpers - Reusable Datatable Components
 * Version: 1.0
 * 
 * Usage:
 *   const dt = new DatatableHelper({
 *       tableId: 'users_table',
 *       pageKey: 'users',
 *       saveUrl: window.location.href,
 *       deleteUrl: '/permissions/users/',
 *       exportFormats: ['csv', 'excel', 'pdf']
 *   });
 *   dt.init();
 */

class DatatableHelper {
    constructor(config) {
        this.config = {
            tableId: config.tableId || 'datatable',
            pageKey: config.pageKey || 'default',
            saveUrl: config.saveUrl || window.location.href,
            deleteUrl: config.deleteUrl || window.location.href,
            csrfToken: config.csrfToken || this.getCSRFToken(),
            exportFormats: config.exportFormats || ['csv', 'excel', 'pdf'],
            entity: (config.entity || 'users'),
            useToast: config.useToast !== undefined ? config.useToast : true,
            debug: config.debug || false,
            ajaxDelete: config.ajaxDelete !== undefined ? !!config.ajaxDelete : true,
            noNavigateFallback: config.noNavigateFallback !== undefined ? !!config.noNavigateFallback : false,
            preloaderMinMs: (config.preloaderMinMs !== undefined ? config.preloaderMinMs : 250),
            timing: {
                bulkExport: config.timing?.bulkExport || 0.1,
                estimateMultiplier: config.timing?.estimateMultiplier || 1000
            }
        };
        
        this.currentSelections = [];
        this.allPagesDataCache = {};
        this.isInitialized = false;
        this.initCheckboxesRunning = false;
        this.bulkActionsAttached = false;
        this.rowDeleteAttached = false;
        this.container = null;
        this.tableEl = null;
        
        this.log('DatatableHelper initialized', this.config);
    }

    markNoLoaderOnDeleteLinks() {
        try {
            this.resolveContainer();
            const root = this.container || document;
            const links = root.querySelectorAll('#table-container a[title^="Delete"], a[title^="Delete"], [data-row-delete]');
            links.forEach((el) => {
                try {
                    if (el && el.setAttribute) el.setAttribute('data-no-loader', '1');
                } catch (e) {}
            });
        } catch (e) {}
    }
    
    resolveContainer() {
        let table = null;
        if (this.config.tableId) {
            table = document.getElementById(this.config.tableId);
        }
        if (!table) {
            const candidateContainer = document.getElementById('table-content') || document.getElementById('table-container');
            if (candidateContainer) {
                table = candidateContainer.querySelector('table');
            }
        }
        if (!table) {
            table = document.querySelector('table');
        }
        let container = null;
        if (table) {
            container = document.getElementById('table-container');
            if (!(container && container.contains(table))) {
                container = document.getElementById('table-content');
                if (!(container && container.contains(table))) {
                    container = table.closest('#table-content, #table-container, .table-wrapper');
                }
            }
        }
        if (!container) {
            container = document.getElementById('table-container') || document.getElementById('table-content') || document;
        }
        this.tableEl = table;
        this.container = container;
        return container;
    }
    
    getCSRFToken() {
        const input = document.querySelector('[name=csrfmiddlewaretoken]');
        if (input && input.value) return input.value;
        const meta = document.querySelector('meta[name=csrf-token]');
        if (meta && meta.getAttribute('content')) return meta.getAttribute('content');
        const cookie = this.getCookie('csrftoken');
        return cookie || '';
    }

    getCookie(name) {
        const cookies = document.cookie ? document.cookie.split('; ') : [];
        for (let i = 0; i < cookies.length; i++) {
            const parts = cookies[i].split('=');
            const key = parts.shift();
            const value = parts.join('=');
            if (key === name) {
                try { return decodeURIComponent(value); } catch (e) { return value; }
            }
        }
        return '';
    }
    
    showNotification(message, type = 'success') {
        if (this.config.useToast && typeof showToast === 'function') {
            showToast(message, type);
        } else {
            const icons = {
                'success': 'success',
                'error': 'error',
                'warning': 'warning',
                'info': 'info'
            };
            Swal.fire({
                icon: icons[type] || 'info',
                title: message,
                timer: 2000,
                showConfirmButton: false
            });
        }
    }
    
    handleDeleteFailure(ids){
        const msg = 'Gagal menghapus data via AJAX';
        try {
            if (this.config.noNavigateFallback) {
                this.showNotification(msg, 'error');
                return;
            }
        } catch(e){}
        this.submitDeleteForm(ids || []);
    }
    
    startPreloader(){
        const target = document.getElementById('table-content');
        const startedAt = Date.now();
        if (target) target.classList.add('htmx-request');
        const minMs = Math.max(0, Number(this.config.preloaderMinMs) || 0);
        let stopped = false;
        return {
            stop: () => {
                if (stopped) return; stopped = true;
                const elapsed = Date.now() - startedAt;
                const delay = Math.max(0, minMs - elapsed);
                setTimeout(() => {
                    const el = document.getElementById('table-content');
                    if (el) el.classList.remove('htmx-request');
                }, delay);
            }
        };
    }
    
    log(...args) {
        if (this.config.debug) {
            console.log('[DatatableHelper]', ...args);
        }
    }
    
    init() {
        if (this.isInitialized) {
            this.log('Already initialized, skipping');
            return;
        }
        
        this.log('Initializing...');
        this.resolveContainer();
        this.initCheckboxes();
        this.cacheCurrentPageData();
        this.markNoLoaderOnDeleteLinks();
        this.decoratePaginationLinks();
        
        if (!this.htmxAttached) {
            this.setupHtmxListeners();
            this.htmxAttached = true;
        }
        
        this.setupBulkActionHandlers();
        this.setupRowDeleteHandlers();
        
        this.isInitialized = true;
        this.log('Initialization complete');
    }
    
    initCheckboxes() {
        if (this.initCheckboxesRunning) {
            this.log('initCheckboxes already running, skipping');
            return;
        }
        
        this.initCheckboxesRunning = true;
        this.log('Initializing checkboxes');
        this.resolveContainer();
        
        this.loadSelectionsFromDB()
            .then(selectedIds => {
                this.currentSelections = selectedIds;
                
                const root = this.container || document;
                const checkboxes = root.querySelectorAll('.row-checkbox');
                checkboxes.forEach(checkbox => {
                    const shouldBeChecked = selectedIds.includes(checkbox.value);
                    const newCheckbox = checkbox.cloneNode(true);
                    newCheckbox.checked = shouldBeChecked;
                    checkbox.parentNode.replaceChild(newCheckbox, checkbox);
                    newCheckbox.addEventListener('change', () => this.updateBulkActions());
                });
                
                this.setupSelectAllCheckboxes();
                this.updateBulkActions();
                
                this.initCheckboxesRunning = false;
                this.log('Checkboxes initialized');
            })
            .catch(err => {
                console.error('Failed to load selections:', err);
                try {
                    const root = (this.container || document);
                    let checkboxes = root.querySelectorAll('.row-checkbox');
                    if (!checkboxes.length) checkboxes = root.querySelectorAll('tbody input[type="checkbox"]');
                    checkboxes.forEach(checkbox => {
                        const clone = checkbox.cloneNode(true);
                        clone.checked = !!checkbox.checked;
                        checkbox.parentNode.replaceChild(clone, checkbox);
                        clone.addEventListener('change', () => this.updateBulkActions());
                    });
                    this.setupSelectAllCheckboxes();
                    this.updateBulkActions();
                } catch(e) { console.warn('Fallback listener attach failed', e); }
                this.initCheckboxesRunning = false;
            });
    }
    
    setupSelectAllCheckboxes() {
        const root = this.container || document;
        const selectAllTop = root.querySelector('#select-all-top');
        const selectAllBottom = root.querySelector('#select-all-bottom');
        
        if (selectAllTop) {
            const newTop = selectAllTop.cloneNode(true);
            selectAllTop.parentNode.replaceChild(newTop, selectAllTop);
            newTop.addEventListener('change', (e) => this.handleSelectAll(e.target.checked));
        }
        
        if (selectAllBottom) {
            const newBottom = selectAllBottom.cloneNode(true);
            selectAllBottom.parentNode.replaceChild(newBottom, selectAllBottom);
            newBottom.addEventListener('change', (e) => this.handleSelectAll(e.target.checked));
        }
    }
    
    handleSelectAll(checked) {
        const checkboxes = (this.container || document).querySelectorAll('.row-checkbox');
        checkboxes.forEach(cb => cb.checked = checked);
        
        const root = this.container || document;
        const selectAllTop = root.querySelector('#select-all-top');
        const selectAllBottom = root.querySelector('#select-all-bottom');
        if (selectAllTop) selectAllTop.checked = checked;
        if (selectAllBottom) selectAllBottom.checked = checked;
        
        this.updateBulkActions();
    }
    
    updateBulkActions() {
        const root = this.container || document;
        let checkboxes = root.querySelectorAll('.row-checkbox');
        if (!checkboxes.length) {
            checkboxes = root.querySelectorAll('tbody input[type="checkbox"]');
        }
        const checkedBoxes = Array.from(checkboxes).filter(cb => cb.checked);
        
        const total = checkboxes.length;
        const selected = checkedBoxes.length;
        const selectAllTop = root.querySelector('#select-all-top');
        const selectAllBottom = root.querySelector('#select-all-bottom');
        const setMaster = (el) => {
            if (!el) return;
            if (selected === 0 || total === 0) {
                el.checked = false;
                el.indeterminate = false;
            } else if (selected === total) {
                el.checked = true;
                el.indeterminate = false;
            } else {
                el.checked = false;
                el.indeterminate = true;
            }
        };
        setMaster(selectAllTop);
        setMaster(selectAllBottom);
        
        const currentPageIds = checkedBoxes.map(cb => String(cb.value));
        const storedIds = (this.getStoredSelections() || []).map(v => String(v));
        
        const otherPageIds = storedIds.filter(id => 
            !Array.from(checkboxes).some(cb => String(cb.value) === id)
        );
        const allSelectedIds = [...new Set([...otherPageIds, ...currentPageIds])];
        
        this.saveSelectionsToDB(allSelectedIds);
        
        const countSpan = root.querySelector('#selected-count') || document.getElementById('selected-count');
        if (countSpan) {
            countSpan.textContent = allSelectedIds.length;
        }
        
        const bulkActionsBar = root.querySelector('#bulk-actions-bar') || document.getElementById('bulk-actions-bar');
        if (bulkActionsBar) {
            if (allSelectedIds.length > 0) {
                bulkActionsBar.classList.remove('hidden');
                try { bulkActionsBar.style.display = ''; } catch(e){}
            } else {
                bulkActionsBar.classList.add('hidden');
                try { bulkActionsBar.style.display = 'none'; } catch(e){}
            }
        }
        
        this.log('Updated bulk actions, selected:', allSelectedIds.length);
    }
    
    getStoredSelections() {
        return this.currentSelections;
    }
    
    loadSelectionsFromDB() {
        return fetch(this.config.saveUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'X-CSRFToken': this.config.csrfToken || this.getCSRFToken()
            },
            credentials: 'same-origin',
            body: JSON.stringify({
                action: 'load_selection',
                page_key: this.config.pageKey
            })
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }
            const ct = response.headers.get('Content-Type') || '';
            if (!ct.includes('application/json')) {
                return { success: false, selected_ids: [] };
            }
            return response.json();
        })
        .then(data => {
            if (data.success && data.selected_ids) {
                const ids = (data.selected_ids || []).map(v => String(v));
                this.log('Loaded selections from DB:', ids);
                return ids;
            }
            return [];
        });
    }
    
    saveSelectionsToDB(ids) {
        const normalized = (ids || []).map(v => String(v));
        this.currentSelections = normalized;
        
        fetch(this.config.saveUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'X-CSRFToken': this.config.csrfToken || this.getCSRFToken()
            },
            credentials: 'same-origin',
            body: JSON.stringify({
                action: 'save_selection',
                page_key: this.config.pageKey,
                selected_ids: normalized
            })
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                this.log('Saved selections to DB:', normalized.length, 'items');
            }
        })
        .catch(err => console.error('Save selections error:', err));
    }
    
    cacheCurrentPageData() {
        const rows = document.querySelectorAll('tbody tr');
        rows.forEach(row => {
            const checkbox = row.querySelector('.row-checkbox');
            if (!checkbox) return;
            
            const userId = checkbox.value;
            const cells = row.querySelectorAll('td');
            let rowData;
            if (this.config.entity === 'roles') {
                rowData = {
                    id: userId,
                    role_name: cells[3]?.textContent.trim() || '',
                    users: cells[4]?.textContent.trim() || '',
                    permissions: cells[5]?.textContent.trim() || ''
                };
            } else if (this.config.entity === 'modules') {
                rowData = {
                    id: userId,
                    order: cells[2]?.textContent.trim() || '',
                    module: cells[3]?.textContent.trim() || '',
                    icon: cells[4]?.textContent.trim() || '',
                    status: cells[5]?.textContent.trim() || '',
                    rules: cells[6]?.textContent.trim() || ''
                };
            } else if (this.config.entity === 'functions') {
                rowData = {
                    id: userId,
                    nama_fungsi: cells[3]?.textContent.trim() || '',
                    label_fungsi: cells[4]?.textContent.trim() || '',
                    rules: cells[6]?.textContent.trim() || ''
                };
            } else if (this.config.entity === 'api_documentation') {
                rowData = {
                    id: userId,
                    method_type: cells[3]?.textContent.trim() || '',
                    url: cells[4]?.textContent.trim() || '',
                    active: cells[6]?.textContent.trim() || ''
                };
            } else if (this.config.entity === 'controls') {
                rowData = {
                    id: userId,
                    nama_kontrol: cells[3]?.textContent.trim() || '',
                    label_kontrol: cells[4]?.textContent.trim() || '',
                    rules: cells[6]?.textContent.trim() || ''
                };
            } else {
                rowData = {
                    id: userId,
                    username: cells[2]?.textContent.trim() || '',
                    email: cells[3]?.textContent.trim() || '',
                    name: cells[4]?.textContent.trim() || '',
                    roles: cells[5]?.textContent.trim() || '',
                    status: cells[6]?.textContent.trim() || ''
                };
            }
            
            this.allPagesDataCache[userId] = rowData;
        });
        
        this.log('Cached data for', Object.keys(this.allPagesDataCache).length, this.config.entity);
    }
    
    setupHtmxListeners() {
        this.log('Setting up HTMX listeners');
        
        document.body.addEventListener('htmx:afterSwap', (evt) => {
            if (evt.detail.target.id === 'table-content' || evt.detail.target.id === 'table-container') {
                this.resolveContainer();
                this.log('HTMX swap detected, re-initializing');
                this.markNoLoaderOnDeleteLinks();
                this.initCheckboxes();
                this.cacheCurrentPageData();
                this.decoratePaginationLinks();
                this.updateBulkActions();
            }
        });
    }

    decoratePaginationLinks() {
        try {
            const root = this.container || document;
            const links = root.querySelectorAll('.pagination a, a[href*="page="]');
            links.forEach(link => {
                if (link.hasAttribute('hx-get')) return;
                const href = link.getAttribute('href');
                if (!href) return;
                link.setAttribute('hx-get', href);
                link.setAttribute('hx-target', '#table-container');
                link.setAttribute('hx-indicator', '#table-loading-overlay');
                link.setAttribute('hx-swap', 'innerHTML');
                link.setAttribute('hx-push-url', 'true');
                link.addEventListener('click', function(e){ e.preventDefault(); }, { capture: true });
            });
            this.log('Pagination links decorated:', links.length);
        } catch (e) {
            console.warn('Failed to decorate pagination links', e);
        }
    }
    
    setupBulkActionHandlers() {
        this.log('Setting up bulk action handlers');
        if (this.bulkActionsAttached) { this.log('Bulk action handlers already attached, skipping'); return; }
        const scope = document.getElementById('bulk-actions-bar') || document;
        scope.addEventListener('click', (e) => {
            const target = e.target.closest('#bulk-actions-bar [data-action]');
            if (!target) return;
            
            e.preventDefault();
            e.stopPropagation();
            e.stopImmediatePropagation();
            
            const action = target.dataset.action;
            this.log('Bulk action clicked:', action);
            
            if (target.disabled) return;
            target.disabled = true;
            setTimeout(() => target.disabled = false, 1000);
            
            switch(action) {
                case 'clear':
                    this.clearAllSelections();
                    break;
                case 'copy':
                    this.copyToClipboard();
                    break;
                case 'export-csv':
                    this.exportSelected('csv');
                    break;
                case 'export-excel':
                    this.exportSelected('excel');
                    break;
                case 'export-pdf':
                    this.exportSelected('pdf');
                    break;
                case 'print':
                    this.printSelected();
                    break;
                case 'delete':
                    this.deleteSelected();
                    break;
                default:
                    console.warn('Unknown action:', action);
            }
        }, true);
        this.bulkActionsAttached = true;
    }
    
    setupRowDeleteHandlers(){
        this.log('Setting up row delete handlers');
        if (this.rowDeleteAttached) { this.log('Row delete handlers already attached, skipping'); return; }
        document.addEventListener('click', (e) => {
            const btn = e.target.closest('[data-row-delete], #table-container a[title^="Delete"]');
            if (!btn) return;
            e.preventDefault();
            e.stopPropagation();
            e.stopImmediatePropagation();
            const tr = btn.closest('tr');
            const checkbox = tr ? tr.querySelector('.row-checkbox') : null;
            const id = (btn.dataset && btn.dataset.id) || (checkbox ? checkbox.value : null);
            const isAnchor = btn.matches('#table-container a[title^="Delete"]');
            const endpoint = isAnchor ? btn.href : (btn.dataset.url || this.config.deleteUrl);
            Swal.fire({
                title: 'Hapus Data Ini?',
                text: 'Tindakan ini tidak dapat dibatalkan',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Ya, Hapus',
                cancelButtonText: 'Batal',
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6'
            }).then((result) => {
                if (!result.isConfirmed) return;
                const loader = this.startPreloader();
                if (!this.config.ajaxDelete) { this.submitDeleteForm(id ? [id] : []); loader.stop(); return; }
                if (isAnchor) {
                    const headers = {
                        'Accept': 'application/json, text/plain, */*',
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                        'X-Requested-With': 'XMLHttpRequest',
                        'X-CSRFToken': this.config.csrfToken || this.getCSRFToken()
                    };
                    const params = new URLSearchParams();
                    params.append('csrfmiddlewaretoken', this.config.csrfToken || this.getCSRFToken());
                    fetch(endpoint, {
                        method: 'POST',
                        headers: headers,
                        credentials: 'same-origin',
                        body: params
                    }).then(async (r) => {
                        let ok = r.ok || r.status === 204;
                        let names;
                        if (!ok && r.status === 405) {
                            const rr = await fetch(endpoint, {
                                method: 'GET',
                                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                                credentials: 'same-origin'
                            });
                            ok = rr.ok || rr.status === 204;
                        }
                        const ct = r.headers.get('Content-Type') || '';
                        if (ct.includes('application/json')) {
                            try { const data = await r.json(); if (data?.name) names = [String(data.name)]; if (Array.isArray(data?.names)) names = data.names; } catch(e){}
                        }
                        if (ok) {
                            this.deleteRowDom(tr, id || '');
                            if (names && names.length) this.showNotification(`✓ Terhapus: ${names.join(', ')}`, 'success');
                            else this.showNotification('✓ 1 item terhapus', 'success');
                            try { this.refreshTableAfterDelete(1); } catch(e){}
                        } else {
                            this.handleDeleteFailure(id ? [id] : []);
                        }
                    }).catch(() => this.submitDeleteForm(id ? [id] : []))
                      .finally(() => { loader.stop(); });
                } else {
                    this.ajaxDeleteSingle(id, endpoint)
                        .then((res) => {
                            if (res && res.ok) {
                                this.deleteRowDom(tr, id);
                                if (res.names && res.names.length) this.showNotification(`✓ Terhapus: ${res.names.join(', ')}`, 'success');
                                else this.showNotification('✓ 1 item terhapus', 'success');
                                try { this.refreshTableAfterDelete(1); } catch(e){}
                            } else {
                                this.handleDeleteFailure([id]);
                            }
                        })
                        .catch(() => this.handleDeleteFailure([id]))
                        .finally(() => { loader.stop(); });
                }
            });
        }, true);
        this.rowDeleteAttached = true;
    }
    
    deleteRowDom(tr, id){
        try {
            if (tr && tr.parentNode) tr.parentNode.removeChild(tr);
            this.currentSelections = (this.currentSelections || []).filter(x => String(x) !== String(id));
            try { this.updateBulkActions(); } catch(e){}
        } catch(e){}
    }

    refreshTableAfterDelete(count){
        try {
            let urlObj = new URL(window.location.href);
            const pageParam = parseInt(urlObj.searchParams.get('page') || '1', 10);
            try {
                const rowsLeft = (document.querySelectorAll('#table-container tbody tr') || []).length;
                if (rowsLeft === 0 && pageParam > 1) {
                    urlObj.searchParams.set('page', String(pageParam - 1));
                }
            } catch(e){}
            const url = urlObj.toString();
            if (typeof htmx !== 'undefined') {
                htmx.ajax('GET', url, { target: '#table-container', swap: 'innerHTML', indicator: '#table-loading-overlay' });
            } else {
                window.location.href = url;
            }
        } catch(e){}
    }
    
    ajaxDeleteSingle(id, endpoint){
        const url = endpoint || this.config.deleteUrl;
        const headers = {
            'Accept': 'application/json, text/plain, */*',
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRFToken': this.config.csrfToken || this.getCSRFToken()
        };
        const body = new URLSearchParams();
        body.append('csrfmiddlewaretoken', this.config.csrfToken || this.getCSRFToken());
        body.append('action', 'delete_single');
        body.append('id', id);
        return fetch(url, {
            method: 'POST',
            headers: headers,
            credentials: 'same-origin',
            body: body
        }).then(async (r) => {
            const result = { ok: false, names: undefined };
            if (r.status === 204) { result.ok = true; return result; }
            const ct = r.headers.get('Content-Type') || '';
            result.ok = r.ok;
            if (ct.includes('application/json')){
                try {
                    const data = await r.json();
                    result.ok = !!(data && (data.success || data.deleted || data.status === 'ok')) || result.ok;
                    if (data) {
                        if (Array.isArray(data.names) && data.names.length) result.names = data.names;
                        else if (data.name) result.names = [String(data.name)];
                    }
                } catch(e){}
            }
            return result;
        }).catch(() => ({ ok: false }));
    }
    
    ajaxBulkDelete(ids){
        const headers = {
            'Accept': 'application/json, text/plain, */*',
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRFToken': this.config.csrfToken || this.getCSRFToken()
        };
        const body = new URLSearchParams();
        body.append('csrfmiddlewaretoken', this.config.csrfToken || this.getCSRFToken());
        body.append('action', 'bulk_delete');
        ids.forEach(id => body.append('selected_ids', id));
        return fetch(this.config.deleteUrl, {
            method: 'POST',
            headers: headers,
            credentials: 'same-origin',
            body: body
        }).then(async (r) => {
            const result = { ok: false, names: undefined };
            if (r.status === 204) { result.ok = true; return result; }
            const ct = r.headers.get('Content-Type') || '';
            result.ok = r.ok;
            if (ct.includes('application/json')){
                try {
                    const data = await r.json();
                    result.ok = !!(data && (data.success || data.deleted || data.status === 'ok')) || result.ok;
                    if (data && Array.isArray(data.names) && data.names.length) {
                        result.names = data.names;
                    }
                } catch(e){}
            }
            return result;
        }).catch(() => ({ ok: false }));
    }
    
    clearAllSelections() {
        const count = this.currentSelections.length;
        
        this.saveSelectionsToDB([]);
        this.currentSelections = [];
        
        document.querySelectorAll('.row-checkbox').forEach(cb => cb.checked = false);
        const selectAllTop = document.getElementById('select-all-top');
        const selectAllBottom = document.getElementById('select-all-bottom');
        if (selectAllTop) selectAllTop.checked = false;
        if (selectAllBottom) selectAllBottom.checked = false;
        
        this.updateBulkActions();
        this.log('Cleared all selections');
        
        if (count > 0) {
            this.showNotification(`✓ ${count} item selection cleared`, 'info');
        }
    }
    
    copyToClipboard() {
        const ids = this.getStoredSelections();
        if (ids.length === 0) {
            Swal.fire({
                icon: 'warning',
                title: 'Tidak Ada Item Terpilih',
                text: 'Pilih minimal 1 item untuk copy',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        const selectedData = ids.map(id => this.allPagesDataCache[id]).filter(Boolean);
        const missingCount = ids.length - selectedData.length;
        let text;
        if (this.config.entity === 'roles') {
            text = selectedData.map(row => `${row.id}\t${row.role_name}\t${row.users}\t${row.permissions}`).join('\n');
        } else if (this.config.entity === 'modules') {
            text = selectedData.map(row => `${row.id}\t${row.order}\t${row.module}\t${row.rules}`).join('\n');
        } else if (this.config.entity === 'functions') {
            text = selectedData.map(row => `${row.id}\t${row.nama_fungsi}\t${row.label_fungsi}\t${row.rules}`).join('\n');
        } else if (this.config.entity === 'api_documentation') {
            text = selectedData.map(row => `${row.id}\t${row.method_type}\t${row.url}\t${row.active}`).join('\n');
        } else if (this.config.entity === 'controls') {
            text = selectedData.map(row => `${row.id}\t${row.nama_kontrol}\t${row.label_kontrol}\t${row.rules}`).join('\n');
        } else {
            text = selectedData.map(row => `${row.username}\t${row.email}\t${row.name}\t${row.roles}\t${row.status}`).join('\n');
        }
        
        navigator.clipboard.writeText(text).then(() => {
            if (typeof Swal !== 'undefined') {
                const copied = selectedData.length;
                const total = ids.length;
                const note = missingCount > 0 ? `<br><small>(${missingCount} item belum dikunjungi pagenya)</small>` : '';
                Swal.fire({
                    icon: 'info',
                    title: 'Berhasil Copy',
                    html: `${copied} dari ${total} item berhasil di-copy.${note}`,
                    confirmButtonText: 'OK'
                });
            } else {
                this.showNotification(`✓ ${selectedData.length} dari ${ids.length} item dicopy`, 'success');
            }
        }).catch(err => {
            console.error('Copy failed:', err);
            this.showNotification('Gagal copy ke clipboard', 'error');
        });
    }
    
    printSelected() {
        const ids = this.getStoredSelections();
        if (ids.length === 0) {
            Swal.fire({
                icon: 'warning',
                title: 'Tidak Ada Item Terpilih',
                text: 'Pilih minimal 1 item untuk print',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        const selectedData = ids.map(id => this.allPagesDataCache[id]).filter(Boolean);
        const missingCount = ids.length - selectedData.length;
        const entityTitle = this.config.entity === 'roles' ? 'Selected Roles' : (this.config.entity === 'modules' ? 'Selected Modules' : (this.config.entity === 'functions' ? 'Selected Functions' : (this.config.entity === 'api_documentation' ? 'Selected API Docs' : (this.config.entity === 'controls' ? 'Selected Controls' : 'Selected Users'))));
        let thead;
        let rowsHtml;
        if (this.config.entity === 'roles') {
            thead = `
                <tr>
                    <th>No</th>
                    <th>ID</th>
                    <th>Nama Role</th>
                    <th>Users</th>
                    <th>Permissions</th>
                </tr>`;
            rowsHtml = selectedData.map((row, index) => `
                <tr>
                    <td>${index + 1}</td>
                    <td>${row.id}</td>
                    <td>${row.role_name}</td>
                    <td>${row.users}</td>
                    <td>${row.permissions}</td>
                </tr>
            `).join('');
        } else if (this.config.entity === 'modules') {
            thead = `
                <tr>
                    <th>No</th>
                    <th>ID</th>
                    <th>Order</th>
                    <th>Module</th>
                    <th>Rules</th>
                </tr>`;
            rowsHtml = selectedData.map((row, index) => `
                <tr>
                    <td>${index + 1}</td>
                    <td>${row.id}</td>
                    <td>${row.order}</td>
                    <td>${row.module}</td>
                    <td>${row.rules}</td>
                </tr>
            `).join('');
        } else if (this.config.entity === 'functions') {
            thead = `
                <tr>
                    <th>No</th>
                    <th>ID</th>
                    <th>Nama Fungsi</th>
                    <th>Label</th>
                    <th>Rules</th>
                </tr>`;
            rowsHtml = selectedData.map((row, index) => `
                <tr>
                    <td>${index + 1}</td>
                    <td>${row.id}</td>
                    <td>${row.nama_fungsi}</td>
                    <td>${row.label_fungsi}</td>
                    <td>${row.rules}</td>
                </tr>
            `).join('');
        } else if (this.config.entity === 'api_documentation') {
            thead = `
                <tr>
                    <th>No</th>
                    <th>ID</th>
                    <th>Method</th>
                    <th>URL</th>
                    <th>Aktif</th>
                </tr>`;
            rowsHtml = selectedData.map((row, index) => `
                <tr>
                    <td>${index + 1}</td>
                    <td>${row.id}</td>
                    <td>${row.method_type}</td>
                    <td>${row.url}</td>
                    <td>${row.active}</td>
                </tr>
            `).join('');
        } else if (this.config.entity === 'controls') {
            thead = `
                <tr>
                    <th>No</th>
                    <th>ID</th>
                    <th>Nama Kontrol</th>
                    <th>Label</th>
                    <th>Rules</th>
                </tr>`;
            rowsHtml = selectedData.map((row, index) => `
                <tr>
                    <td>${index + 1}</td>
                    <td>${row.id}</td>
                    <td>${row.nama_kontrol}</td>
                    <td>${row.label_kontrol}</td>
                    <td>${row.rules}</td>
                </tr>
            `).join('');
        } else {
            thead = `
                <tr>
                    <th>No</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Name</th>
                    <th>Roles</th>
                    <th>Status</th>
                </tr>`;
            rowsHtml = selectedData.map((row, index) => `
                <tr>
                    <td>${index + 1}</td>
                    <td>${row.username}</td>
                    <td>${row.email}</td>
                    <td>${row.name}</td>
                    <td>${row.roles}</td>
                    <td>${row.status}</td>
                </tr>
            `).join('');
        }
        const caution = missingCount > 0 ? `
            <div style="margin-top:16px;padding:12px;border:1px solid #fbbf24;background:#fffbeb;color:#92400e;border-radius:8px;">
                <b>Perhatian:</b><br>
                Hanya ${selectedData.length} dari ${ids.length} item yang ter-print.<br>
                ${missingCount} item tidak terprint karena pagenya belum dikunjungi.<br>
                <small>Untuk print semua data terpilih, gunakan Export PDF (backend fetch dari database).</small>
            </div>
        ` : '';
        const w = window.open('', '', 'width=900,height=700');
        w.document.write(`
            <html>
            <head>
                <title>Print - ${this.config.pageKey}</title>
                <style>
                    body { font-family: Arial, sans-serif; padding: 20px; }
                    table { width: 100%; border-collapse: collapse; }
                    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                    th { background-color: #f2f2f2; }
                </style>
            </head>
            <body>
                <h2>${entityTitle} (${selectedData.length} items)</h2>
                <table>
                    <thead>${thead}</thead>
                    <tbody>${rowsHtml}</tbody>
                </table>
                ${caution}
            </body>
            </html>
        `);
        w.document.close();
        setTimeout(() => w.print(), 300);
    }
    
    exportSelected(format) {
        const ids = this.getStoredSelections();
        if (ids.length === 0) {
            Swal.fire({
                icon: 'warning',
                title: 'Tidak Ada Item Terpilih',
                text: 'Pilih minimal 1 item untuk export',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        const loadingTime = ids.length * this.config.timing.bulkExport * this.config.timing.estimateMultiplier;
        const loadingSeconds = (loadingTime / 1000).toFixed(1);
        
        Swal.fire({
            title: `Memproses Export ${format.toUpperCase()}`,
            html: `
                <div style="margin: 20px 0;">
                    <p style="margin-bottom: 10px;"><b>${ids.length} records</b></p>
                    <p style="margin-bottom: 15px;">Estimasi: ~${loadingSeconds} detik</p>
                </div>
            `,
            allowOutsideClick: false,
            allowEscapeKey: false,
            didOpen: () => Swal.showLoading()
        });
        
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = this.config.deleteUrl;
        try {
            let ifr = document.getElementById('download_iframe');
            if (!ifr) {
                ifr = document.createElement('iframe');
                ifr.style.display = 'none';
                ifr.id = 'download_iframe';
                ifr.name = 'download_iframe';
                document.body.appendChild(ifr);
            }
            form.target = 'download_iframe';
        } catch(e) {}
        
        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = 'csrfmiddlewaretoken';
        csrfInput.value = this.config.csrfToken;
        form.appendChild(csrfInput);
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'export_' + format;
        form.appendChild(actionInput);
        
        try {
            const search = document.getElementById('search-input')?.value || '';
            const moduleSel = document.getElementById('module')?.value || '';
            if (search) {
                const i1 = document.createElement('input'); i1.type = 'hidden'; i1.name = 'search'; i1.value = search; form.appendChild(i1);
            }
            if (moduleSel) {
                const i2 = document.createElement('input'); i2.type = 'hidden'; i2.name = 'module'; i2.value = moduleSel; form.appendChild(i2);
            }
        } catch(e) {}

        ids.forEach(id => {
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'selected_ids';
            idInput.value = id;
            form.appendChild(idInput);
        });
        
        document.body.appendChild(form);
        form.submit();
        
        setTimeout(() => {
            Swal.close();
            Swal.fire({
                icon: 'success',
                title: 'Berhasil!',
                text: `File ${format.toUpperCase()} dengan ${ids.length} item berhasil didownload`,
                confirmButtonText: 'OK',
                confirmButtonColor: '#3085d6'
            });
        }, loadingTime);
    }
    
    deleteSelected(idsOverride) {
        let ids = Array.isArray(idsOverride) && idsOverride.length ? idsOverride : this.getStoredSelections();
        if (!ids || ids.length === 0) {
            ids = Array.from(document.querySelectorAll('.row-checkbox:checked')).map(cb => cb.value);
        }
        if (ids.length === 0) {
            Swal.fire({
                icon: 'warning',
                title: 'Tidak Ada Item Terpilih',
                text: 'Pilih minimal 1 item untuk dihapus',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        Swal.fire({
            title: 'Konfirmasi Hapus',
            html: `Yakin ingin menghapus <b>${ids.length} item</b> terpilih?<br><br><small style="color:#dc2626">⚠️ Tindakan ini tidak dapat dibatalkan!</small>`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Ya, Hapus!',
            cancelButtonText: 'Batal',
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6'
        }).then((result) => {
            if (!result.isConfirmed) return;
            this.log('Delete confirmed');
            if (!this.config.ajaxDelete) { this.submitDeleteForm(ids); return; }
            const loader = this.startPreloader();
            this.ajaxBulkDelete(ids)
                .then((res) => {
                    if (res && res.ok) {
                        const idSet = new Set(ids.map(String));
                        document.querySelectorAll('tbody tr').forEach(tr => {
                            const cb = tr.querySelector('.row-checkbox');
                            if (cb && idSet.has(String(cb.value))) this.deleteRowDom(tr, cb.value);
                        });
                        if (res.names && res.names.length) {
                            const remaining = Math.max(0, ids.length - res.names.length);
                            const suffix = remaining > 0 ? ` (+${remaining} lainnya)` : '';
                            this.showNotification(`✓ Terhapus: ${res.names.join(', ')}${suffix}`, 'success');
                        } else {
                            this.showNotification(`✓ ${ids.length} item terhapus`, 'success');
                        }
                        try { this.refreshTableAfterDelete(ids.length); } catch(e){}
                    } else {
                        this.handleDeleteFailure(ids);
                    }
                })
                .catch(() => this.handleDeleteFailure(ids))
                .finally(() => { loader.stop(); });
        });
    }

    submitDeleteForm(ids){
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = this.config.deleteUrl;
        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = 'csrfmiddlewaretoken';
        csrfInput.value = this.config.csrfToken;
        form.appendChild(csrfInput);
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'bulk_delete';
        form.appendChild(actionInput);
        ids.forEach(id => {
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'selected_ids';
            idInput.value = id;
            form.appendChild(idInput);
        });
        document.body.appendChild(form);
        form.submit();
    }
}

if (typeof module !== 'undefined' && module.exports) {
    module.exports = DatatableHelper;
}
