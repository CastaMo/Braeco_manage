'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
  router.get('/Manage/Menu/Combo/Sinlge', function(req, res) {
    res.render('./CanteenManageMenu/Combo/Single/develop');
  });


  router.get('/Manage/Menu/Data', getCallbackHandleForRequest("GET"));

  return router;
};
