'use strict';

var http            = require('http');
var BufferHelper    = require('./BufferHelper.js');
var StringDecoder   = require('string_decoder').StringDecoder;
var cookie          = 'sid=tkbobycg4ycgq6kz7ir18eunzarrd5l6';
var flag            = true;

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
    var decoder = new StringDecoder('utf8');

    //延时抛出异常
    var timer = setTimeout(function () {
      err(new Error('timeout'));
    }, 5000);

    var bufferHelper = new BufferHelper();

    remoteRes.on('data', function(chunk) {
      bufferHelper.concat(chunk);
    });

    remoteRes.on('end', function() {
      var buffer = bufferHelper.toBuffer(),
          result = buffer.toString();
      try {
        res.send(result);
      } catch (e) {
        clearTimeout(timer);
        err(new Error('The result has syntax error. ' + e));
        return;
      }
      clearTimeout(timer);
    });
  }
}

function proxySendRequest(options, callbackProxyHandleResponse, body) {
  var request = http.request(options, callbackProxyHandleResponse);
  request.on('error', function(e) {console.log('Remote server error:', e);});
  if (options.method === "POST") {
    request.write(JSON.stringify(body));
    console.log("data: " + JSON.stringify(body));
  }
  request.end();
}

function getCallbackHandleForRequest(method, devCookie) {
  if (devCookie) cookie = devCookie;
  
  return function(req, res) {
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
