'use strict';

var http = require('http');
var StringDecoder = require('string_decoder').StringDecoder;
var cookie = 'sid=bqsmheyfarzdlfmwu64igixjwbo0fasr';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
  router.get('/Manage/Data/Analysis', function(req, res) {
    res.render('./CanteenManageData/Analysis/develop');
  });
  router.get('/Manage/Data/Analysis/JSON', getCallbackHandleForRequest("GET", cookie));
  router.post('/Membership/Analysis/Get', getCallbackHandleForRequest("POST", cookie));
  router.post('/coupon/get', getCallbackHandleForRequest("POST", cookie));
  router.post('/Dinner/Manage/Membership/Excel', getCallbackHandleForRequest("POST", cookie));
  router.post('/Dinner/Manage/Excel/16', getCallbackHandleForRequest("POST", cookie));
  return router;
};
