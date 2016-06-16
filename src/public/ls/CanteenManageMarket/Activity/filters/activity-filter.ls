# ====== angular filter ======

angular.module 'ManageMarketActivity' .filter 'classfyActivity', ->

  classfyActivity = (activitys, type)->
    results = []

    theme-filter = (item)!-> if item.type is 'theme' then results.push item
    other-filter = (item)!-> if item.type isnt 'theme' then results.push item

    switch type
    | 'theme'   => activitys?.for-each theme-filter
    | otherwise => activitys?.for-each other-filter

    results

  classfyActivity
