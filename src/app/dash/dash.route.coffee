'use strict'

appRun = (routerHelper) ->
  routerHelper.configureStates getStates()

getStates = ->
  [
    state: 'tab.dash'
    config:
      url: '/dash'
      views:
        'tab-dash':
          templateUrl: 'dash/tab-dash.html'
          controller: 'DashCtrl'
  ]

appRun.$inject = ['routerHelper']

angular
  .module 'starter.dash'
  .run appRun
