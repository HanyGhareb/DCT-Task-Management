/**
 * directap.js — Direct AP dashboard (App 212).
 * The AP dashboard locked to invoices with NO purchase-order reference and
 * NO project coding anywhere (nopo=Y facet — header_po_number IS NULL AND
 * po_count = 0 AND project_count = 0 AND no invoice LINE carrying a
 * po_number/project_number), plus the Briefing Book (Excel) button
 * (AP_DIRECT_REGISTER via the AP/db/14 bridge). Reuses the dashboard view +
 * ViewModel in nopo mode via a nested `module` binding, so the two dashboards
 * can never drift apart.
 */
define(['text!views/dashboard.html', 'viewModels/dashboard'],
function (dashboardView, DashboardViewModel) {
  'use strict';

  function DirectApViewModel() {
    this.inner = {
      view: dashboardView,
      viewModel: new DashboardViewModel({ nopo: true })
    };
  }

  return DirectApViewModel;
});
