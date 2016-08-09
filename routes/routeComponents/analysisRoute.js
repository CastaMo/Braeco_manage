'use strict';

var http = require('http');
var StringDecoder = require('string_decoder').StringDecoder;

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
  router.get('/Manage/Data/Analysis', function(req, res) {
    res.render('./CanteenManageData/Analysis/develop');
  });
  router.get('/Manage/Data/Analysis/JSON', getCallbackHandleForRequest("GET"));
  router.post('/Membership/Analysis/Get', getCallbackHandleForRequest("POST"));
  router.post('/coupon/get', getCallbackHandleForRequest("POST"));
  router.post('/Dinner/Manage/Membership/Excel', getCallbackHandleForRequest("POST"));
  router.post('/Dinner/Manage/Excel/16', getCallbackHandleForRequest("POST"));
  return router;
};
