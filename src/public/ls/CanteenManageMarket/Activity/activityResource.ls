# 'use strict';

# ActivityResource类用来实现activity模块前后端纯JSON数据传输

class Resource
  ->
    @action!

  action: ->
    console.log 'This is resource action!'

module.exports = Resource