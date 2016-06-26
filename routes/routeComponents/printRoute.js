'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {
	router.get('/Manage/Settings/Business/Print/Data', getCallbackHandleForRequest("GET"));
	router.post('/Dinner/Printer/Update/:printerId', getCallbackHandleForRequest("POST"));
	router.post('/Dinner/Printer/Update/Able/:able/:printerId', getCallbackHandleForRequest("POST"));
	router.post('/Dinner/Printer/test', getCallbackHandleForRequest("POST"));
	return router;
};
