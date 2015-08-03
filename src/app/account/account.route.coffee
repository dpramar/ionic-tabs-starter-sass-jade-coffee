'use strict'

appRun = (routerHelper) ->
  routerHelper.configureStates getStates(), '/tab/dash'

getStates = ->
  [
    state: 'tab.account'
    config:
      url: '/account'
      views:
        'tab-account':
          templateUrl: 'account/tab-account.html'
          controller: 'AccountCtrl'
  ]

appRun.$inject = ['routerHelper']

angular
  .module 'starter.account'
  .run appRun
