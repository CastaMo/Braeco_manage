'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {

  router.post('/Manage/Market/Coupon/Add', getCallbackHandleForRequest("POST"));
  router.post('/Manage/Market/Coupon/Change', getCallbackHandleForRequest("POST"));

  return router;
};
