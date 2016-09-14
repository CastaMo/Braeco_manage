'use strict';

var http            = require('http');
var BufferHelper    = require('./BufferHelper.js');
var defaultCookie   = 'Dname=15; menu=4294967295; marketing=4294967295; Cname=%E6%B5%8B%E8%AF%95%E4%B8%80%E4%B8%8B; sid=s4sz863hsxnc022csl8pp76puwdo3psw; auth=2147483647';
var cookie;
var zlib            = require('zlib');

function getOptionsForProxySendRequestConfig(url, method) {
  method = method.toUpperCase();
  var options = {
    hostname: 'devel.brae.co',
    path: url,
    headers: {
      'Cookie': cookie
    }
  };
  options.method = method;
  if (method === "POST") {
    options.headers["Content-Type"] = "application/json";
  }
  return options;
};

function getCallbackProxyHandleResponse(res) {
  return function(remoteRes) {
    var headers = remoteRes.headers;
    for (var header in headers) {
      res.setHeader(header, headers[header]);
    }
    //延时抛出异常
    // var timer = setTimeout(function () {
    //   err(new Error('timeout'));
    // }, 30000);
    //
    // var bufferHelper = new BufferHelper();
    //
    // remoteRes.on('data', function(chunk) {
    //   bufferHelper.concat(chunk);
    // });
    //
    // remoteRes.on('end', function() {
    //   var buffer = bufferHelper.toBuffer();
    //   try {
    //     var encode = remoteRes.headers['content-encoding'];
    //     if (encode === "gzip") {
    //       // zlib.unzip(buffer, function(err, buffer) {
    //       // });
    //       var result = buffer.toString();
    //       //console.log(result);
    //       res.set({
    //           "Content-Encoding": "gzip"
    //       });
    //       res.send(buffer);
    //     } else {
    //       var result = buffer.toString();
    //       res.send(result);
    //     }
    //   } catch (e) {
    //     clearTimeout(timer);
    //     err(new Error('The result has syntax error. ' + e));
    //     return;
    //   }
    //   clearTimeout(timer);
    // });
    remoteRes.pipe(res);
  }
}

function proxySendRequest(options, callbackProxyHandleResponse, body) {
  console.log(options);
  var request = http.request(options, callbackProxyHandleResponse);
  request.on('error', function(e) {console.log('Remote server error:', e);});
  if (options.method === "POST" && body) {
    request.write(JSON.stringify(body));
    console.log("data: " + JSON.stringify(body));
  }
  request.end();
}

function getCallbackHandleForRequest(method, devCookie) {

  return function(req, res) {
    cookie = defaultCookie;
    if (devCookie) cookie = devCookie;
    var options = getOptionsForProxySendRequestConfig(req.url, method),
        callback = getCallbackProxyHandleResponse(res);
    console.log('\nAt url:', req.url);
    console.log('Method:', options.method);
    console.log('Remote server:', options.hostname);
    console.log('Request remote server start');
    proxySendRequest(options, callback, req.body);
  }
}
module.exports = getCallbackHandleForRequest;
