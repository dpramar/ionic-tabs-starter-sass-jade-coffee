'use strict'

ChatDetailCtrl = ($log, $scope, $stateParams, Chats) ->
  $log.info "Creating ChatDetailCtrl"

  $scope.chat = Chats.get $stateParams.chatId

ChatDetailCtrl.$inject = ['$log', '$scope', '$stateParams', 'Chats']

angular.module 'starter.chat'
  .controller 'ChatDetailCtrl', ChatDetailCtrl
