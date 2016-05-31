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
    res.send("var allData = '"+'{"message":"success","data":[{"id":"181","title":"\u4e70\u4e00\u9001\u4e00","intro":"\u6d3b\u52a8\u7b80\u4ecb","content":"\u6d3b\u52a8\u8be6\u60c5","pic":"mig8dtig5cwizz5iqykaakwdss8xavbx","date_begin":"0","date_end":"0","type":"theme"},{"id":"183","title":"\u9648\u6653\u96c52","intro":"\u54c8\u54c8\u54c8","content":"\u5566\u5566\u5566","pic":"lmkd5gglr5y5a0oma3ucnnz3g5h7pbib","date_begin":"0","date_end":"0","type":"theme"},{"id":"184","title":"333","intro":"222","content":"222","pic":"disleeb4tdgkk25adlaqypyht88nwnu9","date_begin":"0","date_end":"0","type":"theme"},{"id":"185","title":"111","intro":"111","content":"1111","pic":"0vh3iwsdvkrzn54zzrcyl4lvqojghnwh","date_begin":"0","date_end":"0","type":"theme"},{"id":"187","title":"test1","intro":"111","content":"111","pic":"erlm9q28jh5ss4xlt9120bvg9m1ej0ey","date_begin":"0","date_end":"0","type":"theme"},{"id":"188","title":"test2","intro":"111","content":"111","pic":"y37z1idzq6c6ue6uhvsf2y86y4nnoe4n","date_begin":"0","date_end":"0","type":"theme"},{"id":"189","title":"11","intro":"11","content":"111","pic":"r0l0qn994f2wjzid8jf9vbq4yrjisxgj","date_begin":"0","date_end":"0","type":"theme"},{"id":"190","title":"1111","intro":"11","content":"11","pic":"hcnju0jl7vr1axvrto7wng2lkq894dwm","date_begin":"0","date_end":"0","type":"theme"},{"id":"191","title":"111","intro":"111","content":"111","pic":"x1kopuyu90rtz978snioy8tx0cfs9wc7","date_begin":"0","date_end":"0","type":"theme"},{"id":"192","title":"11","intro":"1","content":"1","pic":"pj6kkp6rlysvwonpcvl0bolwet5j715x","date_begin":"0","date_end":"0","type":"theme"},{"id":"193","title":"111","intro":"11","content":"11","pic":"xwvnqth0t8uth12aokynsrls30ldwxku","date_begin":"0","date_end":"0","type":"theme"},{"id":"195","title":"\u80dc\u591a\u8d1f\u5c11","intro":"\u6536\u5230","content":"\u6c34\u7535\u8d39","pic":"tghk9zl37fwpgyz5jytbpe4tep7bms5g","date_begin":"0","date_end":"0","type":"sales"}]}'+"';"+
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

  router.post('/Activity/Profile/Update/:activityId', function(req, res) {
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
