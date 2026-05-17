define(['knockout', 'mockData'],
function (ko, mockData) {
  'use strict';

  var STORE_KEY = 'ifinance_dt_country_groups';

  function loadGroups() {
    try { var r = localStorage.getItem(STORE_KEY); if (r) return JSON.parse(r); } catch(e) {}
    return {
      groups:  JSON.parse(JSON.stringify(mockData.COUNTRY_GROUPS)),
      members: JSON.parse(JSON.stringify(mockData.COUNTRY_GROUP_MEMBERS)),
    };
  }
  function saveGroups(s) { localStorage.setItem(STORE_KEY, JSON.stringify(s)); }

  function CountryGroupsViewModel() {
    var self = this;

    self.groups    = ko.observableArray([]);
    self.countries = ko.observableArray(mockData.COUNTRIES.filter(function(c){ return c.tier !== 'HOME'; }));
    self.loading   = ko.observable(false);
    self.successMsg = ko.observable('');

    // Expanded group (show members)
    self.expandedGroupId = ko.observable(null);
    self.groupMembers    = ko.observableArray([]);

    function _buildGroups(s) {
      return s.groups.map(function(g) {
        var memberCodes = s.members.filter(function(m){ return m.groupId === g.groupId; }).map(function(m){ return m.countryCode; });
        var memberCountries = self.countries().filter(function(c){ return memberCodes.includes(c.countryCode); });
        return Object.assign({}, g, { members: memberCountries, memberCount: memberCountries.length });
      });
    }

    self.toggleGroup = function (group) {
      if (self.expandedGroupId() === group.groupId) {
        self.expandedGroupId(null);
      } else {
        self.expandedGroupId(group.groupId);
        var s = loadGroups();
        var memberCodes = s.members.filter(function(m){ return m.groupId === group.groupId; }).map(function(m){ return m.countryCode; });
        self.groupMembers(self.countries().filter(function(c){ return memberCodes.includes(c.countryCode); }));
      }
    };

    self.isExpanded = function (group) { return self.expandedGroupId() === group.groupId; };

    self.countryName = function (code) {
      var c = self.countries().find(function(x){ return x.countryCode === code; });
      return c ? c.countryName : code;
    };

    var s = loadGroups();
    self.groups(_buildGroups(s));
  }

  return CountryGroupsViewModel;
});
