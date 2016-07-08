'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {

  router.get("/manage/Extra/basic/data", getCallbackHandleForRequest("GET"));

  router.get("/Manage/Extra/Login", function(req, res) {
    res.render('./CanteenManageExtra/Login/develop');
  });

  router.post("/dinner/login", getCallbackHandleForRequest("POST"));

  return router;
};
