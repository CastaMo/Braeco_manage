'use strict';

var http = require('http');
var StringDecoder = require('string_decoder').StringDecoder;
var cookie = 'sid=wb67x0mxec71i2usadx9l7oqq6y73puz';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
  router.get('/Manage/Data/Statistics', function(req, res) {
    res.render('./CanteenManageData/Statistics/develop');
  });

  router.post('/Dinner/Manage/Statistic', getCallbackHandleForRequest("POST", cookie));

  return router;
};