'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {

  router.get("/Manage/Market/Member/Setting/Data", getCallbackHandleForRequest("GET"));

  return router;
};
