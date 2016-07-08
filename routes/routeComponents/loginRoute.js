'use strict';

var http = require('http');
var StringDecoder = require('string_decoder').StringDecoder;
var cookie = 'sid=bqsmheyfarzdlfmwu64igixjwbo0fasr';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
  router.get('/Login', function(req, res) {
    res.render('./CanteenManage/Login/develop');
  });
  return router;
};
