'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {

  router.get("/manage/Extra/basic/data", getCallbackHandleForRequest("GET"));

  return router;
};