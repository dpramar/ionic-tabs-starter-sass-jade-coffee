'use strict'

DashCtrl = ($log) ->
  $log.info "Creating DashCtrl"

DashCtrl.$inject = ['$log']

angular.module 'starter.dash'
  .controller 'DashCtrl', DashCtrl
