'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {

  router.post('/Membership/Card/Setexp', getCallbackHandleForRequest("POST"));
  router.post('/Membership/Card/Charge', getCallbackHandleForRequest("POST"));

  return router;
};
