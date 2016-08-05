'use strict';

var http = require('http');
var StringDecoder = require('string_decoder').StringDecoder;

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
  router.get('/Manage/Data/Statistics', function(req, res) {
    res.render('./CanteenManageData/Statistics/develop');
  });

  router.post('/Dinner/Manage/Statistic', getCallbackHandleForRequest("POST"));
  router.post('/Dinner/Manage/Statistic/Print', getCallbackHandleForRequest("POST"));

  return router;
};
