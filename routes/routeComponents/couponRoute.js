'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {

  router.get("/Manage/Market/Coupon/Data", getCallbackHandleForRequest("GET"));

  return router;
};
