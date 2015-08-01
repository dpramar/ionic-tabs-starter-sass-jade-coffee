'use strict'

AccountCtrl = ($log, $scope) ->
  $log.info "Creating AccountCtrl"

  $scope.settings =
    enableFriends: true

AccountCtrl.$inject = ['$log', '$scope']

angular
  .module 'starter.account'
  .controller 'AccountCtrl', AccountCtrl
