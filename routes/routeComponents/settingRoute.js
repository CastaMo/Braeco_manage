'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
	router.get('/Manage/Market/Member/Setting/Data', getCallbackHandleForRequest("GET"));
	router.post('/Membership/Rule/Set/Ladder', getCallbackHandleForRequest("POST"));
	router.post('/Membership/Rule/Set/Charge', getCallbackHandleForRequest("POST"));
	return router;
};
