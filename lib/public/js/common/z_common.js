$(document).ready(function() {
    $(document).click(function(e) {
        var target = e.target;
        if (!$(target).is('#guide-content') && !$(target).parents().is('#guide-content')) {
            if (!$(target).is("#guide-description") && !$(target).parents().is("#guide-description")) {
                $('#guide-content').hide();
            }
        }
    });
    $("#guide-description").click(function() {
        $("#guide-content").toggle();
    });
    $("#extrabar-top").click(function() {
        $("html, body").animate({ scrollTop: 0 }, "fast");
    });
    var _cookie;
    (_cookie = function(){
      var mapAuthForKey, getCookieArray, getValueByKey, getAuthByValue, cookieArray, value, auth;
      mapAuthForKey = {
        1: {
          desc: "编辑餐牌",
          unMatchCallback: function(){},
          name: "MENU_EDIT"
        },
        2: {
          desc: "隐藏、显示、移动、排序餐品或品类",
          unMatchCallback: function(){},
          name: "MENU_OAM"
        },
        4: {
          desc: "单品优惠",
          unMatchCallback: function(){},
          name: "MENU_DISCOUNT"
        },
        8: {
          desc: "(待定)",
          unMatchCallback: function(){},
          name: "Braeco-0"
        },
        16: {
          desc: "活动管理(新建、编辑、删除)",
          unMatchCallback: function(){
            $("#Activity-sub-menu").remove();
          },
          name: "MARKET_ACTIVITY"
        },
        32: {
          desc: "订单优惠",
          unMatchCallback: function(){
            $("#Order-sub-menu").remove();
          },
          name: "MARKET_DCTOOL"
        },
        64: {
          desc: "会员(会员设置 会员充值 修改积分 的前置权限)",
          unMatchCallback: function(){
            $("#Discount-sub-menu").remove();
          },
          name: "MARKET_MEMBER"
        },
        128: {
          desc: "卡券",
          unMatchCallback: function(){
            $("#Card-sub-menu").remove();
          },
          name: "MARKET_COUPON"
        },
        256: {
          desc: "会员设置(修改'等级折扣'与'充值项'阶梯)",
          unMatchCallback: function(){},
          name: "MARKET_MEMBER_LADDER"
        },
        512: {
          desc: "(待定)",
          unMatchCallback: function(){},
          name: "Braeco-1"
        },
        1024: {
          desc: "(待定)",
          unMatchCallback: function(){},
          name: "Braeco-2"
        },
        2048: {
          desc: "流水订单(退款、重打、的前置权限)",
          unMatchCallback: function(){
            $("#WaterOrder-sub-menu").remove();
          },
          name: "DATA_ORDERS"
        },
        4096: {
          desc: "数据统计(打印日结的前置权限)",
          unMatchCallback: function(){
            $("#Data-sub-menu").remove();
          },
          name: "DATA_STATISTIC"
        },
        8192: {
          desc: "营销分析",
          unMatchCallback: function(){
            $("#Market-Analysis-sub-menu").remove();
          },
          name: "DATA_ANALYSIS"
        },
        16384: {
          desc: "(待定)",
          unMatchCallback: function(){},
          name: "Braeco-4"
        },
        32768: {
          desc: "(待定)",
          unMatchCallback: function(){},
          name: "Braeco-5"
        },
        65536: {
          desc: "业务管理(堂食、外卖、预点)",
          unMatchCallback: function(){
            $("#Business-sub-menu").remove();
          },
          name: "MANAGE_FIRM"
        },
        131072: {
          desc: "店员管理(只有管理员有此权限)",
          unMatchCallback: function(){
            $("#Staff-sub-menu").remove();
          },
          name: "MANAGE_WAITER"
        },
        262144: {
          desc: "餐厅信息修改",
          unMatchCallback: function(){
            $("li#canteen-info-field").parent("a").attr({
              "href": "#"
            });
          },
          name: "MANAGE_BASIC_INFO"
        },
        524288: {
          desc: "餐厅日志",
          unMatchCallback: function(){
            $("li#canteen-log-field").parent("a").attr({
              "href": "#"
            });
          },
          name: "MANAGE_LOG"
        },
        1048576: {
          desc: "(待定)",
          name: "Braeco-6"
        },
        2097152: {
          desc: "(待定)",
          name: "Braeco-7"
        },
        4194304: {
          desc: "接单处理",
          name: "OPERATION_RECIEVE_ORDER"
        },
        8388608: {
          desc: "辅助点餐",
          name: "OPERATION_PLACE_ORDER"
        },
        16777216: {
          desc: "会员充值",
          name: "OPERATION_MEMBERSHIPCARD_CHARGE"
        },
        33554432: {
          desc: "修改积分",
          name: "OPERATION_MEMBERSHIPCARD_SETEXP"
        },
        67108864: {
          desc: "退款",
          name: "OPERATION_REFUND"
        },
        134217728: {
          desc: "重打某单",
          name: "OPERATION_REPRINT"
        },
        268435456: {
          desc: "打印日结",
          name: "OPERATION_PRINT_DAILY_STATISTIC"
        },
        536870912: {
          desc: "(待定)",
          name: "Braeco-8"
        },
        1073741824: {
          desc: "(待定)",
          name: "Braeco-9"
        }
      };
      getCookieArray = function(){
        var str;
        str = document.cookie.replace(" ", "");
        return str.split(";");
      };
      getValueByKey = function(key, cookieArray){
        var i$, len$, cookie;
        for (i$ = 0, len$ = cookieArray.length; i$ < len$; ++i$) {
          cookie = cookieArray[i$];
          if (cookie.indexOf(key) === 0) {
            return cookie.replace(key + "=", "");
          }
          return "";
        }
      };
      getAuthByValue = function(value){
        var auth, key, ref$, obj, isMatch;
        value = Number(value);
        auth = {};
        for (key in ref$ = mapAuthForKey) {
          obj = ref$[key];
          isMatch = !!(Number(key) & value);
          if (!isMatch) {
            if (typeof obj.unMatchCallback == 'function') {
              obj.unMatchCallback();
            }
          }
          auth[obj.name] = isMatch;
        }
        return auth;
      };
      cookieArray = getCookieArray();
      value = getValueByKey("auth", cookieArray) || "0";
      auth = getAuthByValue(value);
      window.auth = auth;
    })();
});