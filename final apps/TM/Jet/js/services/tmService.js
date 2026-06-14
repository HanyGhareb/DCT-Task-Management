/**
 * tmService.js — Task Management data service (App 207, ORDS live).
 * Thin wrapper over the shared api.js fetch wrapper; one method per tm.rest
 * endpoint. All methods return Promises. Notifications come from the shared
 * Admin (/dct) module via notificationService.
 */
define(['services/api', 'services/authService', 'services/notificationService'],
function (api, authService, notifService) {
  'use strict';

  function qs(params) {
    var p = [];
    Object.keys(params || {}).forEach(function (k) {
      var v = params[k];
      if (v !== null && v !== undefined && v !== '') p.push(k + '=' + encodeURIComponent(v));
    });
    return p.length ? '?' + p.join('&') : '';
  }
  function uid() { var u = authService.getCurrentUser(); return u && (u.userId || u.user_id); }

  return {
    // boot / dashboard
    boot:         function ()          { return api.get('/boot'); },
    getDashboard: function ()          { return api.get('/dashboard'); },

    // teams
    listTeams:    function (params)    { return api.get('/teams' + qs(params)); },
    getTeam:      function (id)        { return api.get('/teams/' + id); },
    createTeam:   function (body)      { return api.post('/teams', body); },
    updateTeam:   function (id, body)  { return api.put('/teams/' + id, body); },

    // user picker (active users from DCT_USERS)
    listUsers:    function (search)    { return api.get('/users' + qs({ search: search })); },

    // members
    listMembers:  function (teamId)    { return api.get('/members' + qs({ teamId: teamId })); },
    addMember:    function (body)      { return api.post('/members/add', body); },
    setMemberRole:function (body)      { return api.post('/members/role', body); },
    removeMember: function (body)      { return api.post('/members/remove', body); },

    // permissions matrix
    getPerms:     function (teamId, roleCode) { return api.get('/perms' + qs({ teamId: teamId, roleCode: roleCode })); },
    setPerm:      function (body)      { return api.post('/perms', body); },

    // objectives
    listObjectives: function (teamId)  { return api.get('/objectives' + qs({ teamId: teamId })); },
    saveObjective:  function (body)    { return api.post('/objectives', body); },

    // tasks
    listTasks:    function (params)    { return api.get('/tasks' + qs(params)); },
    saveTask:     function (body)      { return api.post('/tasks', body); },
    setTaskStatus:function (body)      { return api.post('/tasks/status', body); },
    assignTask:   function (body)      { return api.post('/tasks/assign', body); },
    taskAssignees:function (taskId)    { return api.get('/tasks/assignees' + qs({ taskId: taskId })); },
    taskUpdates:  function (taskId)    { return api.get('/tasks/updates' + qs({ taskId: taskId })); },
    addTaskUpdate:function (body)      { return api.post('/tasks/update', body); },
    myTasks:      function (status)    { return api.get('/my-tasks' + qs({ status: status })); },

    // deliverables
    listDeliverables: function (teamId) { return api.get('/deliverables' + qs({ teamId: teamId })); },
    saveDeliverable:  function (body)  { return api.post('/deliverables', body); },
    setDeliverableStatus: function (body) { return api.post('/deliverables/status', body); },

    // RAID / milestones / meetings
    listRaid:     function (teamId, type) { return api.get('/raid' + qs({ teamId: teamId, type: type })); },
    saveRaid:     function (body)      { return api.post('/raid', body); },
    listMilestones: function (teamId)  { return api.get('/milestones' + qs({ teamId: teamId })); },
    saveMilestone:  function (body)    { return api.post('/milestones', body); },
    listMeetings: function (teamId)    { return api.get('/meetings' + qs({ teamId: teamId })); },
    saveMeeting:  function (body)      { return api.post('/meetings', body); },

    // documents library
    listDocuments: function (params)   { return api.get('/documents' + qs(params)); },
    addDocument:   function (body)     { return api.post('/documents', body); },

    // reminder preferences
    getPrefs:     function ()          { return api.get('/prefs'); },
    savePrefs:    function (body)      { return api.post('/prefs', body); },

    // shims used by the shared shell / appController
    getNotifications: function () {
      return notifService.getAll(uid()).catch(function () { return []; });
    },
    getPendingApprovals: function () { return Promise.resolve([]); }
  };
});
