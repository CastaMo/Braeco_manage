var express = require('express');
var app = express();
var router = express.Router();
var renew = require('../renew');

module.exports = function(passport) {

	router.get('/', function(req, res) {
		res.redirect('/Manage');
	});

	router.get('/Manage', function(req, res) {
		res.render('./CanteenManage/develop');
	});

	router.get('/Menu/Food', function(req, res) {
		res.render('./CanteenManageMenu/Food/develop');
	});

	router.get('/Menu/Category', function(req, res) {
		res.render('./CanteenManageMenu/Category/develop');
	});

	router.get('/renew', function(req, res) {
		renew.renew(res);
	});


	router.get('/Table/Data', function(req, res) {
		setTimeout(function() {
			res.send("var allData = '"+'{"message":"success","data":{"dish":[{"dishes":[{"groups":[],"dishid":535,"dishname":"\u5957\u99102","dishname2":"name2","dishpic":null,"defaultprice":2147,"tag":null,"like":0,"detail":"","dc_type":"combo_sum","combo":[{"discount":40,"require":2,"name":"\u7ec4a","content":[517,518,519]},{"discount":60,"require":1,"name":"\u7ec4b","content":[522,524,526,527,502]},{"discount":80,"require":0,"name":"abc","content":[510,511,521,531]}]},{"groups":[],"dishid":528,"dishname":"3","dishname2":"yingyingying","dishpic":"http:\/\/static.brae.co\/images\/dish\/6tck2d0imvvgpvh1sxb7fzhobi8qzdt5","defaultprice":0.01,"tag":null,"like":0,"detail":"\u8d39\u7389\u6e05 \u563f\u563f\u563f","dc_type":"discount","dc":80},{"groups":[{"groupname":"\u5c5e\u6027\u7ec41","property":[{"name":"1","price":1},{"name":"2","price":2}]},{"groupname":"\u5c5e\u6027\u7ec42","property":[{"name":"33","price":33}]}],"dishid":502,"dishname":"\u86cb\u7cd5\u86cb\u7cd5\u86cb\u7cd5","dishname2":"4","dishpic":"http:\/\/static.brae.co\/images\/dish\/ktkmkmdyw759m4xqwwegqn6b2kvvagdv","defaultprice":6666,"tag":"1221","like":0,"detail":"\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a\u554a","dc_type":"half"},{"groups":[],"dishid":526,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/uo9mq4iynxx9f77vu5h6fwj129euty0n","defaultprice":2,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":527,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/85jhyfsteveqm66ax6sqm4ixzonis5l1","defaultprice":2,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":501,"dishname":"haha","dishname2":"sad","dishpic":"http:\/\/static.brae.co\/images\/dish\/76q9jqs6lnmai3bb1nihmz6yiepirjoy","defaultprice":23,"tag":null,"like":0,"detail":"","dc_type":"limit","dc":1},{"groups":[],"dishid":510,"dishname":"1","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/dz7eh22mpd8h6x8kj8huxn0an1m66gej","defaultprice":1,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":511,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/88zlxj9m0tm9nsnur1afqxqu2jz5q08z","defaultprice":2,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":512,"dishname":"3","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/x7juhxm6n0hckbtetc4ovvwayw4axmhu","defaultprice":3,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":513,"dishname":"213","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/o461mhjcu5ul6cug45dnvdrqxs70dca2","defaultprice":123,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":517,"dishname":"3","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/ps3nq2dh4dmhdpbjrnj96flngco8xjgm","defaultprice":3,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":518,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/bja2mokr178fwkzn8iwexi2euqnsa3em","defaultprice":2,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":519,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/z17xdpjophj09t5d7yegoona34t53602","defaultprice":2,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":521,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/npo9e80fg9uctt01cxgafio98b1jfg52","defaultprice":2,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":522,"dishname":"233","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/iq1omei4v9plfxkrvqqih8lryfwfogv7","defaultprice":3,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":524,"dishname":"2","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/81o8y3jdjlhuuqkkeyi4sxyplrc2ov9w","defaultprice":22,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":530,"dishname":"22","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/wx5v1p8lapf5gzpuy7zq5ygrqstfo3bl","defaultprice":22,"tag":null,"like":0,"detail":"","dc_type":"none"}],"categoryid":214,"categoryname":"\u5662\u54c8\u554a\u597d\u54c8\u563f\u563f","categorypic":"http:\/\/static.brae.co\/images\/category\/lodkbx7vqwkiymwqf5x7nzecuc1u2sgo"},{"dishes":[{"groups":[],"dishid":531,"dishname":"123","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/uuzlh870r8aye5y288vegxoitq9jj18e","defaultprice":213,"tag":null,"like":0,"detail":"","dc_type":"none"}],"categoryid":215,"categoryname":"\u5496\u5561","categorypic":"http:\/\/static.brae.co\/images\/category\/avemumn6pgi8nev4ozr7mshivk9zo23z"},{"dishes":[{"groups":[],"dishid":503,"dishname":"222","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/12q49zfdkr17tmliggoupvbn8rdlpzir","defaultprice":2,"tag":null,"like":0,"detail":"","dc_type":"none"},{"groups":[],"dishid":504,"dishname":"111","dishname2":"","dishpic":"http:\/\/static.brae.co\/images\/dish\/elrvazq4qvqnzjaa65ucjdedgwph9gxo","defaultprice":1,"tag":null,"like":0,"detail":"","dc_type":"none"}],"categoryid":216,"categoryname":"\u86cb\u7cd5","categorypic":"http:\/\/static.brae.co\/images\/category\/1ljfqmfl28fzfyi4ckf6bhdn2yqbn1to"},{"dishes":[{"groups":[],"dishid":534,"dishname":"name","dishname2":"name2","dishpic":null,"defaultprice":12,"tag":null,"like":0,"detail":"","dc_type":"combo_static","combo":[{"require":2,"name":"\u7ec4a","content":[517,518,519,502]},{"require":1,"name":"\u7ec4b","content":[522,524,526,527]}]},{"groups":[],"dishid":536,"dishname":"haha","dishname2":"hehe","dishpic":null,"defaultprice":15,"tag":null,"like":0,"detail":"","dc_type":"none"}],"categoryid":217,"categoryname":"\u5976\u8336","categorypic":"http:\/\/static.brae.co\/images\/category\/mnw6fnwsish5ogkz2bimxqgeq5rznmla"}],"activity":[{"date_begin":"2015-07-30","date_end":"2020-07-24","title":"\u5475\u5475","intro":"\u5168\u573a\u6ee1\u003Cstrong\u003E10\u003C\/strong\u003E\u9001\u003Cstrong\u003E\u7eb8\u5dfe\u003C\/strong\u003E","content":"\u6ee110\u9001\u7eb8\u5dfe\u4e00\u4efd","pic":"http:\/\/static.brae.co\/images\/activity\/xdkufbn21mx8a4y9hpmkgojjjqcy5302.png","is_valid":true,"type":"give","detail":[{"least":10,"dish":"\u7eb8\u5dfe"}]},{"date_begin":"2015-10-01","date_end":"2015-12-31","title":"\u6d4b\u8bd5\u003Cspan\u003E\uff08\u5df2\u7ecf\u7ed3\u675f\uff09\u003C\/span\u003E","intro":"\u554a","content":"1","pic":"http:\/\/static.brae.co\/images\/activity\/9xnqj4sljc7yf4v0v55da3v8a9d2slo1.png","is_valid":false,"type":"other","detail":"\u554a"},{"pic":"http:\/\/static.brae.co\/images\/acitivity\/668748898728661347.jpg","title":"\u4f1a\u5458\u5361\u4f18\u60e0","is_valid":1,"intro":"\u5728\u672c\u5e97\u6d88\u8d39\u6216\u5145\u503c\u5373\u53ef\u7d2f\u8ba1\u79ef\u5206\uff0c\u4eab\u53d7\u6298\u6263","type":"other","content":"\u5145\u503c1\u5143=10\u79ef\u5206\uff0c\u975e\u4f59\u989d\u652f\u4ed81\u5143=10\u79ef\u5206\u3002\u003CBR\u003E\u9ed1\u94c1\u7ea7 0\u79ef\u5206\uff1a100\u6298\u003CBR\u003E\u9752\u94dc\u7ea7 1000\u79ef\u5206\uff1a90\u6298\u003CBR\u003E\u767d\u94f6\u7ea7 2000\u79ef\u5206\uff1a88\u6298\u003CBR\u003E\u9ec4\u91d1\u7ea7 3000\u79ef\u5206\uff1a85\u6298\u003CBR\u003E\u767d\u91d1\u7ea7 5000\u79ef\u5206\uff1a80\u6298\u003CBR\u003E\u94bb\u77f3\u7ea7 8000\u79ef\u5206\uff1a75\u6298\u003CBR\u003E","detail":[],"date_begin":"2015-10-1","date_end":"2025-10-1"},{"date_begin":"2015-10-02","date_end":"2015-12-31","title":"asdfasdf\u003Cspan\u003E\uff08\u5df2\u7ecf\u7ed3\u675f\uff09\u003C\/span\u003E","intro":"\u5168\u573a\u6ee1\u003Cstrong\u003E10\u003C\/strong\u003E\u51cf\u003Cstrong\u003E2\u003C\/strong\u003E","content":"fdsadsdagdsag","pic":"http:\/\/static.brae.co\/images\/activity\/8l10fwbnsl0uzxy2isufwyumy31xrwp0.png","is_valid":false,"type":"reduce","detail":[{"least":10,"reduce":2}]},{"date_begin":"2015-10-01","date_end":"2015-12-16","title":"213\u003Cspan\u003E\uff08\u5df2\u7ecf\u7ed3\u675f\uff09\u003C\/span\u003E","intro":null,"content":"21","pic":"http:\/\/static.brae.co\/images\/activity\/zkd1jixngl25u8hif0546rnuw2818437.png","is_valid":false,"type":"theme","detail":[]},{"date_begin":"2015-10-01","date_end":"2015-10-30","title":"\u963f\u4ec0\u798f\u003Cspan\u003E\uff08\u5df2\u7ecf\u7ed3\u675f\uff09\u003C\/span\u003E","intro":null,"content":"\u53d1\u58eb\u5927\u592b\u6492\u6cd5","pic":"http:\/\/static.brae.co\/images\/activity\/2z2mfz7rw7mhn2irzm2j19vn9w2c4dt7.png","is_valid":false,"type":"theme","detail":[]},{"date_begin":"2015-10-01","date_end":"2015-10-31","title":"asd\u003Cspan\u003E\uff08\u5df2\u7ecf\u7ed3\u675f\uff09\u003C\/span\u003E","intro":null,"content":"123","pic":"http:\/\/static.brae.co\/images\/activity\/m76comqsbrzfjbgkfaf1ogre2c5kzs9l.png","is_valid":false,"type":"theme","detail":[]}],"channel":{"cash":1,"alipay_wap":1,"bfb_wap":1},"member":{"user":4,"nickname":"Casta","avatar":"http:\/\/static.brae.co\/images\/avatar\/q13xybp6x3102no7pn8r6g91gz070oeq.png","mobile":"18819473259","membership":{"ladder":[{"name":"\u9ed1\u94c1","EXP":0,"discount":100},{"name":"\u9752\u94dc","EXP":1000,"discount":90},{"name":"\u767d\u94f6","EXP":2000,"discount":88},{"name":"\u9ec4\u91d1","EXP":3000,"discount":85},{"name":"\u767d\u91d1","EXP":5000,"discount":80},{"name":"\u94bb\u77f3","EXP":8000,"discount":75}],"EXP":2341105,"balance":2826.88},"like":true},"covers":["http:\/\/static.brae.co\/images\/dinner\/dig5t410ogxe7enfwb4r4klnbwc96odj","http:\/\/static.brae.co\/images\/dinner\/6rw495arsnxua2t7e0s5qss6zr06h0ro","http:\/\/static.brae.co\/images\/dinner\/3izwm3gj7asn2xnzr68id3ib4w9di5ol","http:\/\/static.brae.co\/images\/dinner\/pia1wrnlmklmicnyxkqfksciya25nbfc"],"compatible":14,"dinner":{"id":3,"name":"\u827e\u6668\u65af\u5496\u5561"},"sum_like":4}}'+"';"+
			"if (typeof window.mainInit !== 'undefined') {mainInit(JSON.parse(allData));mainInit = null;}");
		}, 0);
	});

	router.get('/Menu/Category/Data', function(req, res) {
		setTimeout(function() {
			res.send("var allData = '"+'{"message":"success","data":{"category":[{"dishes":[],"categoryid":234,"categoryname":"a","categorypic":"http:\/\/static.brae.co\/images\/category\/8hicrfu2qp8areusucya3ruu322sskn0"},{"dishes":[],"categoryid":214,"categoryname":"\u5662\u54c8\u554a\u597d\u54c8\u563f\u563f","categorypic":"http:\/\/static.brae.co\/images\/category\/lodkbx7vqwkiymwqf5x7nzecuc1u2sgo"},{"dishes":[],"categoryid":215,"categoryname":"\u5496\u5561","categorypic":"http:\/\/static.brae.co\/images\/category\/avemumn6pgi8nev4ozr7mshivk9zo23z"},{"dishes":[],"categoryid":216,"categoryname":"\u86cb\u7cd5","categorypic":"http:\/\/static.brae.co\/images\/category\/1ljfqmfl28fzfyi4ckf6bhdn2yqbn1to"},{"dishes":[],"categoryid":217,"categoryname":"\u5976\u8336","categorypic":"http:\/\/static.brae.co\/images\/category\/mnw6fnwsish5ogkz2bimxqgeq5rznmla"}]}}'+"';"+
			"if (typeof window.mainInit !== 'undefined') {mainInit(JSON.parse(allData));mainInit = null;}");
		}, 0);
	});

	router.post('/test', function(req, res) {
	    res.json({
	        message: "success"
	    });
	});

	router.post('/server/captcha', function(req, res) {
		res.json({
	        message: "success"
	    });
	});

	router.post('/Eater/Login/Mobile', function(req, res) {
		res.json({
	        message: "success",
	        id : 4
	    });
	});

	router.post('/Order/Add', function(req, res) {
		res.json({
	        message: "success",
	        id: Number(Math.floor(100000 + Math.random() * 100000))
	    });
	});

	router.post('/Membership/Card/Charge', function(req, res) {
		res.json({
			message:"success"
		})
	});

	router.post('/Eater/Like/Dinner/:id', function(req, res) {
		res.json({
			message:"success"
		})
	});

	return router;
};