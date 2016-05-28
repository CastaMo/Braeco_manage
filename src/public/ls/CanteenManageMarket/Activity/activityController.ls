# 'use strict';

# ActivityController类定义finite-state-machine，进行数据绑定和相应的DOM操作

class Controller
  ->
    @action!

  action: ->
    console.log 'This is controller action!'

module.exports = Controller

page-manage = let
  _state = null

  $("\#Activity-sub-menu").addClass "choose"

  # _simple-state-machine = ()!->

  module =
    initial: ->

    toggle-page: (page)->
      _toggle-page-callback[page]?!
      set-timeout "scrollTo(0, 0)", 0

# module.exports = page-manage


dom-operator = let
  # 活动图片上传预览
  _upload-image-preview-handler = ->
    $ "\#activity-upload-image" .change !->
      read-url @

    read-url = (input)!->
      if input.files && input.files[0]
        reader = new FileReader!
        reader.onload = (e)->
          $ '\#upload-image-preview' .attr 'src', e.target.result

        reader.readAsDataURL input.files[0]

  # 模块接口
  module =
    initial: !->
      _upload-image-preview-handler!

# module.exports = dom-operator

