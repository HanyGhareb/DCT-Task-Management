define(['viewModels/secRolesBase'], function (SecRolesBase) {
  'use strict';
  return function DutyRolesViewModel() { SecRolesBase.call(this, 'DUTY'); };
});
