'use strict';

var http = require('http');
var StringDecoder = require('string_decoder').StringDecoder;
var cookie = 'sid=tkbobycg4ycgq6kz7ir18eunzarrd5l6';
var flag = true;

module.exports = function(router) {
  router.get('/Manage/Market/Activity', function(req, res) {
    res.render('./CanteenManageMarket/Activity/develop');
  });

  router.get('/Manage/Market/Activity/Data', function(req, res) {
    res.send("var allData = '"+'{"message":"success","data":[]}'+"';"+
      "if (typeof window.mainInit !== 'undefined') {mainInit(JSON.parse(allData));mainInit = null;allData = null;}");
  });

  router.post('/Activity/Add/:type', function(req, res) {
    var options = {
      hostname: 'devel.brae.co',
      path: req.url,
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        'Cookie': cookie
      }
    };

    var request = http.request(options, function(remoteRes) {
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');

      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {
        console.log('Remote server end\n');
      });
    });
    request.write(JSON.stringify(req.body));
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
  });

  router.post('/pic/upload/token/activityadd', function(req, res) {
    var options = {
      hostname: 'devel.brae.co',
      path: req.url,
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        'Cookie': cookie
      }
    };

    var request = http.request(options, function(remoteRes) {
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');

      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {console.log('Remote server end\n');});
    });
    request.write(JSON.stringify(req.body));
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
  });

  router.post('/Activity/Profile/Update/:activity_id', function(req, res) {
    var options = {
      hostname: 'devel.brae.co',
      path: req.url,
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        'Cookie': cookie
      }
    };

    var request = http.request(options, function(remoteRes) {
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');

      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {console.log('Remote server end\n');});
    });
    console.log(JSON.stringify(req.body));
    request.write(JSON.stringify(req.body));
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
  });

  router.post('/Activity/Remove/:activityId', function(req, res) {
    var options = {
      hostname: 'devel.brae.co',
      path: req.url,
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        'Cookie': cookie
      }
    };

    var request = http.request(options, function(remoteRes) {
      console.log('\nAt url:', req.url);
      console.log('Method:', options.method);
      console.log('Remote server:', options.hostname);
      console.log('Request remote server start');

      var decoder = new StringDecoder('utf8');

      remoteRes.on('data', function(chunk) {
        var textChunk = decoder.write(chunk);
        console.log('Remote server response:', textChunk);
        res.send(textChunk);
      });

      remoteRes.on('end', function() {console.log('Remote server end\n');});
    });
    request.on('error', function(e) {console.log('Remote server error:', e);});
    request.end();
  });

  return router;
};
