/**
 * beneficiaries.js — Beneficiaries dashboard (App 212).
 * The AP dashboard locked to the generic BENEFICIARY supplier (supplier
 * number 26553): the beneficiary name acts as the supplier name and the
 * supplier SITE number as the beneficiary's supplier number. Reuses the
 * dashboard view + ViewModel in benef mode via a nested `module` binding,
 * so the two dashboards can never drift apart.
 */
define(['text!views/dashboard.html', 'viewModels/dashboard'],
function (dashboardView, DashboardViewModel) {
  'use strict';

  function BeneficiariesViewModel() {
    this.inner = {
      view: dashboardView,
      viewModel: new DashboardViewModel({ benef: true, suppnum: '26553' })
    };
  }

  return BeneficiariesViewModel;
});
