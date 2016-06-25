'use strict';

var getCallbackHandleForRequest = require("../../common/getCallbackHandleForRequest.js");

module.exports = function(router) {

  router.get('/Manage/Menu/Food/Single', function(req, res) {
    res.render('./CanteenManageMenu/Food/Single/develop');
  });

  router.post('/Dish/Add/:categoryId', getCallbackHandleForRequest("POST"));

  router.post('/Dish/Remove', getCallbackHandleForRequest("POST"));

  router.post('/Dish/Copy', getCallbackHandleForRequest("POST"));

  router.post('/Dish/Sort', getCallbackHandleForRequest("POST"));

  router.post('/Dish/Update/Top', getCallbackHandleForRequest("POST"));

  router.post('/Dish/Update/Category', getCallbackHandleForRequest("POST"));

  router.post('/Dish/Update/All/:dishId', getCallbackHandleForRequest("POST"));

  router.post('/Dish/Update/Able/:flag', getCallbackHandleForRequest("POST"));

  router.post('/pic/upload/token/dishupdate/:dishId', getCallbackHandleForRequest("POST"));

  return router;
};
