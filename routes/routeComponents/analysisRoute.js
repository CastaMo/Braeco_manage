'use strict';

var http = require('http');
var StringDecoder = require('string_decoder').StringDecoder;
var cookie = 'sid=wb67x0mxec71i2usadx9l7oqq6y73puz';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
  router.get('/Manage/Data/Analysis', function(req, res) {
    res.render('./CanteenManageData/Analysis/develop');
  });
  router.get('/Manage/Data/Analysis/JSON', getCallbackHandleForRequest("GET", cookie));
  router.post('/Membership/Analysis/Get', getCallbackHandleForRequest("POST", cookie));
  return router;
};
