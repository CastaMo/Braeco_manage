'use strict';

var http = require('http');
var StringDecoder = require('string_decoder').StringDecoder;
var cookie = 'sid=wb67x0mxec71i2usadx9l7oqq6y73puz';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
  router.get('/Manage/Market/Activity', function(req, res) {
    res.render('./CanteenManageMarket/Activity/develop');
  });

  router.get('/Manage/Market/Activity/Data', getCallbackHandleForRequest("GET", cookie));
  router.post('/Activity/Add/:type', getCallbackHandleForRequest("POST", cookie));
  router.post('/pic/upload/token/activityadd', getCallbackHandleForRequest("POST", cookie));
  router.post('/pic/upload/token/activityupdate/:id', getCallbackHandleForRequest("POST", cookie));
  router.post('/Activity/Update/:activity_id', getCallbackHandleForRequest("POST", cookie));
  router.post('/Activity/Remove/:activityId', getCallbackHandleForRequest("POST", cookie));
  router.post('/Activity/Get', getCallbackHandleForRequest("POST", cookie));

  return router;
};

// router.post('/pic/upload/token/activityupdate/:id', function(req, res) {
  //   var options = {
  //     hostname: 'devel.brae.co',
  //     path: req.url,
  //     method: 'POST',
  //     headers: {
  //       "Content-Type": "application/json",
  //       'Cookie': cookie
  //     }
  //   };

  //   var request = http.request(options, function(remoteRes) {
  //     console.log('\nAt url:', req.url);
  //     console.log('Method:', options.method);
  //     console.log('Remote server:', options.hostname);
  //     console.log('Request remote server start');

  //     var decoder = new StringDecoder('utf8');

  //     remoteRes.on('data', function(chunk) {
  //       var textChunk = decoder.write(chunk);
  //       console.log('Remote server response:', textChunk);
  //       res.send(textChunk);
  //     });

  //     remoteRes.on('end', function() {console.log('Remote server end\n');});
  //   });
  //   request.write(JSON.stringify(req.body));
  //   request.on('error', function(e) {console.log('Remote server error:', e);});
  //   request.end();
  // });

  // router.post('/Activity/Update/:activity_id', function(req, res) {
  //   var options = {
  //     hostname: 'devel.brae.co',
  //     path: req.url,
  //     method: 'POST',
  //     headers: {
  //       "Content-Type": "application/json",
  //       'Cookie': cookie
  //     }
  //   };

  //   var request = http.request(options, function(remoteRes) {
  //     console.log('\nAt url:', req.url);
  //     console.log('Method:', options.method);
  //     console.log('Remote server:', options.hostname);
  //     console.log('Request remote server start');

  //     var decoder = new StringDecoder('utf8');

  //     remoteRes.on('data', function(chunk) {
  //       var textChunk = decoder.write(chunk);
  //       console.log('Remote server response:', textChunk);
  //       res.send(textChunk);
  //     });

  //     remoteRes.on('end', function() {console.log('Remote server end\n');});
  //   });
  //   console.log(JSON.stringify(req.body));
  //   request.write(JSON.stringify(req.body));
  //   request.on('error', function(e) {console.log('Remote server error:', e);});
  //   request.end();
  // });

  // router.post('/Activity/Remove/:activityId', function(req, res) {
  //   var options = {
  //     hostname: 'devel.brae.co',
  //     path: req.url,
  //     method: 'POST',
  //     headers: {
  //       "Content-Type": "application/json",
  //       'Cookie': cookie
  //     }
  //   };

  //   var request = http.request(options, function(remoteRes) {
  //     console.log('\nAt url:', req.url);
  //     console.log('Method:', options.method);
  //     console.log('Remote server:', options.hostname);
  //     console.log('Request remote server start');

  //     var decoder = new StringDecoder('utf8');

  //     remoteRes.on('data', function(chunk) {
  //       var textChunk = decoder.write(chunk);
  //       console.log('Remote server response:', textChunk);
  //       res.send(textChunk);
  //     });

  //     remoteRes.on('end', function() {console.log('Remote server end\n');});
  //   });
  //   request.on('error', function(e) {console.log('Remote server error:', e);});
  //   request.end();
  // });
