/**
 * ESIMPEG REUSABLE DATATABLE SYSTEM
 * Version: 2.0 - Complete Reusable Solution
 * 
 * Usage:
 * const dt = new DatatableReusable({
 *     entityName: 'roles',
 *     pageKey: 'role_list',
 *     exportUrl: '/permissions/roles/',
 *     debug: true
 * });
 * dt.init();
 */

class DatatableReusable {
    constructor(config) {
        this.config = {
            entityName: config.entityName || 'items',
            pageKey: config.pageKey || 'default_list',
            exportUrl: config.exportUrl || window.location.href,
            csrfToken: config.csrfToken || this.getCSRFToken(),
            debug: config.debug || false,
            enableBulkActions: config.enableBulkActions !== false,
            enableSelection: config.enableSelection !== false,
            enableExport: config.enableExport !== false,
            exportFormats: config.exportFormats || ['csv', 'excel', 'pdf'],
            timing: {
                bulkExport: config.timing?.bulkExport || 0.1,
                excelExport: config.timing?.excelExport || 0.000175,
                pdfExport: config.timing?.pdfExport || 0.00115
            }
        };
        
        this.state = {
            currentSelections: [],
            allPagesDataCache: {},
            isInitialized: false,
            initCheckboxesRunning: false
        };
        
        this.updateBulkActions = this.updateBulkActions.bind(this);
        this.exportSelected = this.exportSelected.bind(this);
        this.deleteSelected = this.deleteSelected.bind(this);
        
        this.log('DatatableReusable initialized', this.config);
    }
    
    getCSRFToken() {
        const token = document.querySelector('[name=csrfmiddlewaretoken]')?.value || 
                     document.querySelector('meta[name=csrf-token]')?.getAttribute('content') || '';
        return token;
    }
    
    log(...args) {
        if (this.config.debug) {
            console.log(`[DatatableReusable:${this.config.entityName}]`, ...args);
        }
    }
    
    init() {
        if (this.state.isInitialized) {
            this.log('Already initialized, skipping');
            return;
        }
        
        this.log('Initializing...');
        this.setupGlobalFunctions();
        
        if (this.config.enableSelection) {
            this.initSelectionSystem();
        }
        
        this.setupHtmxListeners();
        this.setupEventHandlers();
        
        this.state.isInitialized = true;
        this.log('Initialization complete');
    }
    
    setupGlobalFunctions() {
        window.clearSearch = () => {
            const searchInput = document.getElementById('search-input');
            if (searchInput) {
                searchInput.value = '';
                htmx.trigger(searchInput, 'keyup');
            }
        };
        
        window.exportSelected = this.exportSelected;
        window.deleteSelected = this.deleteSelected;
        window.clearAllSelections = () => this.clearAllSelections();
        window.copySelectedToClipboard = () => this.copySelectedToClipboard();
        window.printSelected = () => this.printSelected();
    }
    
    initSelectionSystem() {
        this.log('Initializing selection system...');
        
        this.loadSelectionsFromDB().then(selectedIds => {
            this.state.currentSelections = selectedIds || [];
            this.setupCheckboxListeners();
            this.updateBulkActions();
            this.cacheCurrentPageData();
        });
    }
    
    async loadSelectionsFromDB() {
        try {
            const response = await fetch(this.config.exportUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRFToken': this.config.csrfToken
                },
                body: JSON.stringify({
                    action: 'load_selection',
                    page_key: this.config.pageKey
                })
            });
            
            const data = await response.json();
            return data.success ? data.selected_ids : [];
        } catch (error) {
            this.log('Error loading selections:', error);
            return [];
        }
    }
    
    async saveSelectionsToDB(ids) {
        try {
            const response = await fetch(this.config.exportUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRFToken': this.config.csrfToken
                },
                body: JSON.stringify({
                    action: 'save_selection',
                    page_key: this.config.pageKey,
                    selected_ids: ids
                })
            });
            
            const data = await response.json();
            this.log('Saved selections:', data.count, 'items');
        } catch (error) {
            this.log('Error saving selections:', error);
        }
    }
    
    setupCheckboxListeners() {
        document.querySelectorAll('.row-checkbox').forEach(checkbox => {
            checkbox.checked = this.state.currentSelections.includes(checkbox.value);
            checkbox.addEventListener('change', this.updateBulkActions);
        });
        
        const selectAllTop = document.getElementById('select-all-top');
        const selectAllBottom = document.getElementById('select-all-bottom');
        
        if (selectAllTop) {
            selectAllTop.addEventListener('change', (e) => {
                document.querySelectorAll('.row-checkbox').forEach(cb => cb.checked = e.target.checked);
                if (selectAllBottom) {
                    selectAllBottom.checked = e.target.checked;
                    selectAllBottom.indeterminate = false;
                }
                selectAllTop.indeterminate = false;
                this.updateBulkActions();
            });
        }
        
        if (selectAllBottom) {
            selectAllBottom.addEventListener('change', (e) => {
                document.querySelectorAll('.row-checkbox').forEach(cb => cb.checked = e.target.checked);
                if (selectAllTop) {
                    selectAllTop.checked = e.target.checked;
                    selectAllTop.indeterminate = false;
                }
                selectAllBottom.indeterminate = false;
                this.updateBulkActions();
            });
        }
    }
    
    updateBulkActions() {
        const allBoxes = document.querySelectorAll('.row-checkbox');
        const checkedBoxes = document.querySelectorAll('.row-checkbox:checked');
        const bulkActionsBar = document.getElementById('bulk-actions-bar');
        const selectedCountSpan = document.getElementById('selected-count');
        
        const currentPageIds = Array.from(allBoxes).map(cb => cb.value);
        const filteredIds = this.state.currentSelections.filter(id => !currentPageIds.includes(id));
        
        checkedBoxes.forEach(cb => {
            if (!filteredIds.includes(cb.value)) {
                filteredIds.push(cb.value);
            }
        });
        
        const total = allBoxes.length;
        const selected = checkedBoxes.length;
        const selectAllTop = document.getElementById('select-all-top');
        const selectAllBottom = document.getElementById('select-all-bottom');
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

        this.state.currentSelections = filteredIds;
        this.saveSelectionsToDB(filteredIds);
        
        const totalCount = filteredIds.length;
        if (selectedCountSpan) selectedCountSpan.textContent = totalCount;
        
        if (bulkActionsBar) {
            if (totalCount > 0) {
                bulkActionsBar.classList.remove('hidden');
            } else {
                bulkActionsBar.classList.add('hidden');
            }
        }
        
        this.log('Updated selections:', totalCount, 'items');
    }
    
    exportSelected(format) {
        const ids = this.state.currentSelections;
        this.log('Export', format, 'for', ids.length, 'items');
        
        if (ids.length === 0) {
            Swal.fire({
                icon: 'warning',
                title: 'Tidak Ada Item Terpilih',
                text: 'Pilih minimal 1 item untuk export',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = this.config.exportUrl;
        
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
        
        ids.forEach(id => {
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'selected_ids';
            idInput.value = id;
            form.appendChild(idInput);
        });
        
        const loadingTime = ids.length * this.config.timing.bulkExport * 1000;
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
            document.body.removeChild(form);
        }, loadingTime);
    }
    
    deleteSelected() {
        const ids = this.state.currentSelections;
        this.log('Delete requested for', ids.length, 'items');
        
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
            html: `Yakin ingin menghapus <b>${ids.length} ${this.config.entityName}</b> terpilih?<br><br><small style="color:#dc2626">⚠️ Tindakan ini tidak dapat dibatalkan!</small>`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Ya, Hapus!',
            cancelButtonText: 'Batal',
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6'
        }).then((result) => {
            if (result.isConfirmed) {
                this.performDelete(ids);
            }
        });
    }
    
    performDelete(ids) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = this.config.exportUrl;
        
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
    
    clearAllSelections() {
        this.state.currentSelections = [];
        this.saveSelectionsToDB([]);
        
        document.querySelectorAll('.row-checkbox').forEach(cb => cb.checked = false);
        const selectAllTop = document.getElementById('select-all-top');
        const selectAllBottom = document.getElementById('select-all-bottom');
        if (selectAllTop) selectAllTop.checked = false;
        if (selectAllBottom) selectAllBottom.checked = false;
        
        this.updateBulkActions();
    }
    
    copySelectedToClipboard() {
        this.log('Copy to clipboard requested');
    }
    
    printSelected() {
        this.log('Print requested');
    }
    
    cacheCurrentPageData() {
        const table = document.querySelector('table');
        if (!table) return;
        
        const rows = table.querySelectorAll('tbody tr');
        rows.forEach(row => {
            const checkbox = row.querySelector('.row-checkbox');
            if (checkbox) {
                const id = checkbox.value;
                const cells = row.querySelectorAll('td');
                const rowData = [];
                cells.forEach(cell => {
                    if (!cell.querySelector('input[type="checkbox"]')) {
                        rowData.push(cell.innerText.trim());
                    }
                });
                this.state.allPagesDataCache[id] = rowData;
            }
        });
        
        this.log('Cached data for', Object.keys(this.state.allPagesDataCache).length, 'items');
    }
    
    setupHtmxListeners() {
        if (!window.datatableHtmxHandlerAttached) {
            document.body.addEventListener('htmx:afterSwap', (evt) => {
                const targetId = evt.detail.target.id;
                if (targetId === 'table-container' || targetId === 'table-content') {
                    this.log('HTMX swap detected, re-initializing...');
                    setTimeout(() => {
                        this.setupCheckboxListeners();
                        this.cacheCurrentPageData();
                        this.updateBulkActions();
                    }, 100);
                }
            });
            window.datatableHtmxHandlerAttached = true;
        }
    }
    
    setupEventHandlers() {
        if (!window.datatableBulkActionsAttached) {
            document.addEventListener('click', (e) => {
                const target = e.target.closest('[data-action]');
                if (!target) return;
                
                e.preventDefault();
                e.stopPropagation();
                
                const action = target.dataset.action;
                this.log('Bulk action clicked:', action);
                
                switch (action) {
                    case 'clear':
                        this.clearAllSelections();
                        break;
                    case 'copy':
                        this.copySelectedToClipboard();
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
                }
            }, true);
            window.datatableBulkActionsAttached = true;
        }
    }
}

window.DatatableReusable = DatatableReusable;
