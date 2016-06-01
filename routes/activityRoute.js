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
    res.send("var allData = '"+'{"message":"success","data":[{"id":"208","title":"\u9648\u6653\u96c5","intro":"\u54c8\u54c8\u54c8","content":"\u54c8\u54c8\u54c8","pic":"cxtzea3pc4sq621hgty7pwab3jsxhvvu","date_begin":"0","date_end":"0","type":"sales"},{"id":"209","title":"111","intro":"222","content":"333","pic":"ochw2w5pmrgpvrgiuixivkwi7xyinrmb","date_begin":"0","date_end":"0","type":"sales"},{"id":"210","title":"\u5c0f\u96c5\u9648","intro":"kitty\u6653\u96c5","content":"kitty","pic":"43860dwm5cc04tiycgh70dq8aoqygc9k","date_begin":"0","date_end":"0","type":"theme"}]}'+"';"+
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
