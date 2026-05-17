define(['knockout', 'services/config', 'services/api', 'mockData'],
function (ko, config, api, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_dt_country_groups';

  function loadStore() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return {
      groups:  JSON.parse(JSON.stringify(mockData.COUNTRY_GROUPS)),
      members: JSON.parse(JSON.stringify(mockData.COUNTRY_GROUP_MEMBERS)),
    };
  }

  var _countries = mockData.COUNTRIES;

  // Normalise to {groupCode, groupName, memberCount, isActive, members:[{countryCode,countryName}]}
  function _normMock(s) {
    return s.groups.map(function(g) {
      var memberCodes = s.members
        .filter(function(m){ return m.groupId === g.groupId; })
        .map(function(m){ return m.countryCode; });
      var members = _countries
        .filter(function(c){ return memberCodes.includes(c.countryCode); })
        .map(function(c){ return { countryCode: c.countryCode, countryName: c.countryName }; });
      return {
        groupCode:   g.groupCode,
        groupName:   g.groupName,
        memberCount: members.length,
        isActive:    g.isActive,
        members:     members,
      };
    });
  }

  function CountryGroupsViewModel() {
    var self = this;

    self.groups         = ko.observableArray([]);
    self.loading        = ko.observable(true);
    self.successMsg     = ko.observable('');
    self.error          = ko.observable('');

    self.expandedGroupCode = ko.observable(null);
    self.groupMembers      = ko.observableArray([]);

    self.toggleGroup = function (group) {
      if (self.expandedGroupCode() === group.groupCode) {
        self.expandedGroupCode(null);
        self.groupMembers([]);
      } else {
        self.expandedGroupCode(group.groupCode);
        self.groupMembers(group.members || []);
      }
    };

    self.isExpanded = function (group) {
      return self.expandedGroupCode() === group.groupCode;
    };

    // Load
    if (config.apiBase) {
      api.get('/country-groups/').then(function(d) {
        self.groups(d.items || []);
        self.loading(false);
      }).catch(function(err) {
        self.error(err && err.message ? err.message : 'Failed to load country groups.');
        self.loading(false);
      });
    } else {
      self.groups(_normMock(loadStore()));
      self.loading(false);
    }
  }

  return CountryGroupsViewModel;
});
