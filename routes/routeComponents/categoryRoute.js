'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
  router.get('/Manage/Menu/Category', function(req, res) {
    res.render('./CanteenManageMenu/Category/develop');
  });

  router.post('/Category/Add', getCallbackHandleForRequest("POST"));

  router.post('/Category/Remove', getCallbackHandleForRequest("POST"));

  router.post('/Category/Update/Profile', getCallbackHandleForRequest("POST"));

  router.post('/pic/upload/token/category/:id', getCallbackHandleForRequest("POST"));

  router.post('/Category/Update/Top/:id', getCallbackHandleForRequest("POST"));

  return router;
};
