define(['knockout', 'services/rptService', 'shared/i18n', 'shared/chartLoader', 'shared/fusionLinks',
        'shared/toast', 'shared/components/interactiveReport'],
function (ko, rpt, i18n, charts, fusionLinks, toast) {
  'use strict';

  var chartInstances = [];
  var AGING_KEYS = ['exec.bucket.current','exec.bucket.1_30','exec.bucket.31_60',
                    'exec.bucket.61_90','exec.bucket.91_180','exec.bucket.180p'];
  var DRILL_TITLE_KEYS = {
    outstanding:'exec.drill.outstanding', overdue:'exec.drill.overdue', credits:'exec.drill.credits',
    net:'exec.drill.net', partial:'exec.drill.partial', due7:'exec.drill.due7',
    due14:'exec.drill.due14', due30:'exec.drill.due30', aging:'exec.drill.aging',
    supplier:'exec.drill.supplier'
  };

  function ExecutiveDashboardViewModel() {
    var self = this;
    self.t = i18n.t;
    self.loading = ko.observable(true);
    self.loadError = ko.observable(false);
    self.data = ko.observable(null);
    self.businessUnits = ko.observableArray([]);
    self.selectedBu = ko.observable('');
    self.selectedSupplier = ko.observable('');
    self.selectedAging = ko.observable('');
    var savedUnit = localStorage.getItem('bi_exec_display_unit') || 'auto';
    self.displayUnit = ko.observable(['auto','B','M','K','X'].indexOf(savedUnit)>=0?savedUnit:'auto');
    self.displayUnitOptions = ko.pureComputed(function(){return [
      {value:'auto',label:i18n.t('exec.unitAuto')},{value:'B',label:i18n.t('exec.unitB')},
      {value:'M',label:i18n.t('exec.unitM')},{value:'K',label:i18n.t('exec.unitK')},
      {value:'X',label:i18n.t('exec.unitExact')}];});
    self.searchOpen = ko.observable(true);
    self.appliedFilters = ko.observable({bu:'',supplier:'',aging:''});
    self.attentionIr = ko.observable(null);
    self.drawerIr = ko.observable(null);
    self.drawerIrSection = ko.observable('');
    self.briefingBusy = ko.observable(false);
    self.drawerOpen = ko.observable(false);
    self.drawerMax = ko.observable(false);
    self.drawerLoading = ko.observable(false);
    self.drawerError = ko.observable(false);
    self.drawerInfo = ko.observable(false);
    self.drawerTitle = ko.observable('');
    self.drawerSubtitle = ko.observable('');
    self.drawerRows = ko.observableArray([]);
    self.drawerCount = ko.observable(0);
    self.drawerTotal = ko.observable(0);
    self.drawerCapped = ko.observable(false);
    self.regionMax = ko.observable('');

    function locale() { return i18n.lang() === 'ar' ? 'ar-AE' : 'en-AE'; }
    self.fmtAmt = function (n) {
      var v=Number(n)||0,u=self.displayUnit(),div=u==='B'?1e9:u==='M'?1e6:u==='K'?1e3:1;
      if(u==='X') return new Intl.NumberFormat(locale(),{style:'currency',currency:'AED',maximumFractionDigits:0}).format(v);
      if(u==='auto') return new Intl.NumberFormat(locale(),{style:'currency',currency:'AED',maximumFractionDigits:1,notation:Math.abs(v)>=1000?'compact':'standard'}).format(v);
      return 'AED '+new Intl.NumberFormat(locale(),{minimumFractionDigits:u==='K'?0:1,maximumFractionDigits:u==='K'?0:1}).format(v/div)+u;
    };
    self.fmtFull = function (n) {
      return new Intl.NumberFormat(locale(), { style:'currency', currency:'AED', maximumFractionDigits:2 }).format(Number(n)||0);
    };
    self.fmtInt = function (n) { return new Intl.NumberFormat(locale()).format(Number(n)||0); };
    self.overdueShare = function () {
      var d=self.data(); return d && d.ap ? (Number(d.ap.overduePct)||0).toFixed(1)+'%' : '—';
    };
    self.pct = function (n) { return (Number(n)||0).toFixed(1)+'%'; };
    self.kpiMeta = function (count, pct) {
      return self.fmtInt(count)+' '+i18n.t('exec.documents')+' · '+self.pct(pct);
    };
    self.agingHintStats = function () {
      var d=self.data(); return d&&d.ap ? self.fmtInt(d.ap.openCount)+' '+i18n.t('exec.invoices')+' · 100%' : '';
    };
    self.supplierHintStats = function () {
      var d=self.data(), rows=d&&d.ap?(d.ap.topSuppliers||[]):[], count=0, amount=0;
      rows.forEach(function(r){count+=Number(r.count)||0;amount+=Number(r.amount)||0;});
      return self.fmtInt(count)+' '+i18n.t('exec.invoices')+' · '+self.pct(d&&d.ap&&d.ap.overdueAed?amount/d.ap.overdueAed*100:0);
    };
    function columns(drawer) {
      var c=[{key:'invoiceNumber',label:i18n.t('exec.invoice'),type:'text'},
        {key:'supplier',label:i18n.t('exec.supplier'),type:'text'},
        {key:'businessUnit',label:i18n.t('exec.unit'),type:'text'}];
      if(drawer)c.push({key:'invoiceDate',label:i18n.t('exec.invoiceDate'),type:'date'});
      c.push({key:'dueDate',label:i18n.t('exec.dueDate'),type:'date'},
        {key:'daysPastDue',label:i18n.t('exec.daysLate'),type:'num'});
      if(drawer)c.push({key:'agingBucket',label:i18n.t('exec.agingBucket'),type:'text'});
      c.push({key:'balanceAed',label:i18n.t('exec.balance'),type:'money'},
        {key:'paymentStatus',label:i18n.t('exec.payment'),type:'text'});
      if(drawer)c.push({key:'validationStatus',label:i18n.t('exec.validation'),type:'text'},
        {key:'approvalStatus',label:i18n.t('exec.approval'),type:'text'});
      return c;
    }
    function envelope(items, total, capped, drawer, section) {
      return {columns:columns(drawer),items:items||[],total:total||0,truncated:!!capped,maxRows:1000,
        section:section||'',stateRev:1,zebra:true,cellLink:function(row,key){
          return key==='invoiceNumber'&&row.invoiceId?fusionLinks.invoice(row.invoiceId):null;
        }};
    }
    self.reconciled = ko.computed(function () {
      var d=self.data(); return !!(d && d.ap && d.ap.reconciliation && d.ap.reconciliation.trusted);
    });
    self.displayUnit.subscribe(function(v){
      localStorage.setItem('bi_exec_display_unit',v);
      var d=self.data(); if(d)setTimeout(function(){renderCharts(d);},0);
    });

    function destroyCharts() {
      chartInstances.forEach(function (c) { if (c && c.destroy) c.destroy(); });
      chartInstances=[];
    }
    function valueLabelPlugin(horizontal) {
      return {
        id:'execValueLabels'+(horizontal?'H':'V'),
        afterDatasetsDraw:function(chart){
          var ctx=chart.ctx; ctx.save();
          ctx.font='600 11px Oracle Sans, sans-serif'; ctx.fillStyle='#3f3c38';
          chart.data.datasets.forEach(function(ds,di){
            var meta=chart.getDatasetMeta(di);
            meta.data.forEach(function(el,i){
              var value=Number(ds.data[i])||0; if(!value)return;
              var p=el.tooltipPosition(); var label=self.fmtAmt(value);
              ctx.textBaseline='middle'; ctx.textAlign=horizontal?'left':'center';
              ctx.fillText(label,horizontal?p.x+7:p.x,horizontal?p.y:p.y-10);
            });
          });
          ctx.restore();
        }
      };
    }
    function renderCharts(d) {
      destroyCharts();
      var p=charts.palette();
      var aging=document.getElementById('execAgingChart');
      if (aging) chartInstances.push(charts.makeChart(aging, {
        type:'bar',
        data:{
          labels:AGING_KEYS.map(function(k){return i18n.t(k);}),
          datasets:[{label:i18n.t('exec.apOutstanding'), data:(d.ap.aging||[]).map(function(x){return x.amount;}),
            backgroundColor:['#2f7f7a','#c9a227','#d88c27','#d4683b','#c74634','#8f2d25'],
            borderRadius:3, borderSkipped:false}]
        },
        plugins:[valueLabelPlugin(false)],
        options:{responsive:true,maintainAspectRatio:false,layout:{padding:{top:24}},onClick:function(e,els){
          if(els&&els.length) self.openDrill('aging',{bucket:(d.ap.aging[els[0].index]||{}).bucket});
        },plugins:{legend:{display:false},tooltip:{callbacks:{
          label:function(c){return self.fmtFull(c.raw);},
          afterLabel:function(c){var r=d.ap.aging[c.dataIndex];return self.fmtInt(r.count)+' '+i18n.t('exec.invoices')+' · '+self.pct(d.ap.grossOutstandingAed?r.amount/d.ap.grossOutstandingAed*100:0);}
        }}},scales:{y:{beginAtZero:true,ticks:{callback:function(v){return self.fmtAmt(v);}},grid:{color:'rgba(31,54,44,.08)'}},x:{grid:{display:false}}}}
      }));
      var suppliers=document.getElementById('execSuppliersChart');
      if (suppliers) chartInstances.push(charts.makeChart(suppliers, {
        type:'bar',
        data:{labels:(d.ap.topSuppliers||[]).map(function(x){return x.supplier;}),
          datasets:[{data:(d.ap.topSuppliers||[]).map(function(x){return x.amount;}),backgroundColor:'#147e78',borderRadius:3}]},
        plugins:[valueLabelPlugin(true)],
        options:{indexAxis:'y',responsive:true,maintainAspectRatio:false,layout:{padding:{right:76}},onClick:function(e,els){
          if(els&&els.length) self.openDrill('supplier',{party:(d.ap.topSuppliers[els[0].index]||{}).supplier});
        },plugins:{legend:{display:false},tooltip:{callbacks:{
          label:function(c){return self.fmtFull(c.raw);},
          afterLabel:function(c){var r=d.ap.topSuppliers[c.dataIndex];return self.fmtInt(r.count)+' '+i18n.t('exec.invoices')+' · '+self.pct(d.ap.overdueAed?r.amount/d.ap.overdueAed*100:0);}
        }}},scales:{x:{beginAtZero:true,ticks:{callback:function(v){return self.fmtAmt(v);}},grid:{color:'rgba(31,54,44,.08)'}},y:{grid:{display:false}}}}
      }));
    }

    self.load = function () {
      self.loading(true); self.loadError(false);
      var f=self.appliedFilters();
      rpt.getExecutiveAging(f).then(function (d) {
        self.data(d); self.businessUnits(d.businessUnits||[]); self.loading(false);
        self.attentionIr(envelope(d.ap.attention,d.ap.attention.length,false,false,'attention'));
        setTimeout(function(){renderCharts(d);},0);
      }).catch(function () { self.loading(false); self.loadError(true); });
    };
    self.applySearch = function () {
      self.appliedFilters({bu:self.selectedBu(),supplier:self.selectedSupplier().trim(),aging:self.selectedAging()}); self.load();
    };
    self.resetSearch = function () {
      self.selectedBu('');self.selectedSupplier('');self.selectedAging('');self.applySearch();
    };
    self.refresh = function () { self.load(); };
    self.openInvoice = function (r) {
      window.open(fusionLinks.invoice(r.invoiceId),'_blank','noopener,noreferrer');
    };
    self.openArInfo = function () {
      self.drawerTitle(i18n.t('exec.arGapTitle')); self.drawerSubtitle(i18n.t('exec.dataReadiness'));
      self.drawerInfo(true); self.drawerRows([]); self.drawerCount(0); self.drawerTotal(0);
      self.drawerError(false); self.drawerLoading(false); self.drawerMax(false); self.drawerOpen(true);
    };
    self.openDrill = function (metric, extra, event) {
      if(event&&event.stopPropagation) event.stopPropagation();
      extra=extra||{}; self.drawerInfo(false); self.drawerError(false); self.drawerLoading(true);
      self.drawerRows([]); self.drawerCount(0); self.drawerTotal(0); self.drawerCapped(false); self.drawerMax(false);
      self.drawerTitle(i18n.t(DRILL_TITLE_KEYS[metric]||'exec.attentionTitle'));
      self.drawerSubtitle(extra.party||extra.bucket||self.selectedBu()||i18n.t('exec.allUnits'));
      self.drawerOpen(true);
      var q=Object.assign({},self.appliedFilters(),{metric:metric,bucket:extra.bucket,party:extra.party});
      rpt.getExecutiveAgingLines(q)
        .then(function(d){self.drawerRows(d.items||[]);self.drawerCount(d.count||0);self.drawerTotal(d.totalAed||0);self.drawerCapped(!!d.capped);self.drawerIrSection(metric);self.drawerIr(envelope(d.items,d.count,d.capped,true,metric));})
        .catch(function(){self.drawerError(true);}).then(function(){self.drawerLoading(false);});
    };
    self.closeDrawer = function () { self.drawerOpen(false); self.drawerMax(false); };
    self.toggleDrawerMax = function () { self.drawerMax(!self.drawerMax()); };
    self.toggleRegionMax = function (name) {
      self.regionMax(self.regionMax()===name?'':name);
      setTimeout(function(){chartInstances.forEach(function(c){if(c&&c.resize)c.resize();});},80);
    };
    self.exportDrawerCsv = function () {
      var rows=[['Invoice','Supplier','Business Unit','Invoice Date','Due Date','Days Past Due','Aging Bucket','Balance AED','Payment Status','Validation Status','Approval Status']];
      self.drawerRows().forEach(function(r){rows.push([r.invoiceNumber,r.supplier,r.businessUnit,r.invoiceDate,r.dueDate,r.daysPastDue,r.agingBucket,r.balanceAed,r.paymentStatus,r.validationStatus,r.approvalStatus]);});
      rows.push([i18n.t('exec.drawerTotal'),'','','','','','',''+self.drawerTotal(),'','','']);
      var csv=rows.map(function(row){return row.map(function(v){return '"'+String(v==null?'':v).replace(/"/g,'""')+'"';}).join(',');}).join('\r\n');
      var a=document.createElement('a');a.href=URL.createObjectURL(new Blob(['\ufeff'+csv],{type:'text/csv;charset=utf-8'}));
      a.download='executive-aging-drill.csv';a.click();setTimeout(function(){URL.revokeObjectURL(a.href);},0);
    };
    document.addEventListener('keydown',function(e){
      if(e.key==='Escape'&&self.drawerOpen()){if(self.drawerMax())self.drawerMax(false);else self.closeDrawer();}
      else if(e.key==='Escape'&&self.regionMax())self.regionMax('');
    });
    self.exportCsv = function () {
      var d=self.data(); if(!d||!d.ap) return;
      var rows=[['Invoice','Supplier','Business Unit','Due Date','Days Past Due','Balance AED','Payment Status','Validation Status','Approval Status']];
      (d.ap.attention||[]).forEach(function(r){rows.push([r.invoiceNumber,r.supplier,r.businessUnit,r.dueDate,r.daysPastDue,r.balanceAed,r.paymentStatus,r.validationStatus,r.approvalStatus]);});
      var csv=rows.map(function(row){return row.map(function(v){return '"'+String(v==null?'':v).replace(/"/g,'""')+'"';}).join(',');}).join('\r\n');
      var a=document.createElement('a'); a.href=URL.createObjectURL(new Blob(['\ufeff'+csv],{type:'text/csv;charset=utf-8'}));
      a.download='executive-ap-aging-'+d.asOf+'.csv'; a.click(); setTimeout(function(){URL.revokeObjectURL(a.href);},0);
    };
    self.generateBriefing = function () {
      if(self.briefingBusy())return; self.briefingBusy(true);
      rpt.runExecutiveBriefing(self.appliedFilters()).then(function(r){
        toast.success(i18n.t('exec.briefingQueued')+' #'+r.runId);
        window._jetApp.navigate('runDetail',{runId:r.runId});
      }).catch(function(){toast.error(i18n.t('exec.briefingError'));}).then(function(){self.briefingBusy(false);});
    };

    self.load();
  }
  return ExecutiveDashboardViewModel;
});
