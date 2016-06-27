'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {

  router.get('/Manage/Menu/Food/Property', function(req, res) {
    res.render('./CanteenManageMenu/Food/Property/develop');
  });

  router.get('/Manage/Menu/Combo/Subitem', function(req, res) {
    res.render('./CanteenManageMenu/Combo/Subitem/develop');
  });

  router.post('/Dish/Group/Add', getCallbackHandleForRequest("POST"));

  router.post('/Dish/Group/Update/:groupId', getCallbackHandleForRequest("POST"));

  router.post('/Dish/Group/Remove/:groupId', getCallbackHandleForRequest("POST"));

  return router;
};
