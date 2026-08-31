define(['viewModels/secRolesBase'], function (SecRolesBase) {
  'use strict';
  return function AbstractRolesViewModel() { SecRolesBase.call(this, 'ABSTRACT'); };
});
