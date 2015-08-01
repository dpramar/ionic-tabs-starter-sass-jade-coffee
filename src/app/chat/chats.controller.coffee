'use strict'

ChatsCtrl = ($log, $scope, Chats) ->
  $log.info "Creating ChatsCtrl"
#	  With the new view caching in Ionic, Controllers are only called
#	  when they are recreated or on app start, instead of every page change.
#	  To listen for when this page is active (for example, to refresh data),
#	  listen for the $ionicView.enter event:
#
#	  $scope.$on '$ionicView.enter', (e) ->

  $scope.chats = Chats.all()
  $scope.remove = (chat) ->
    Chats.remove chat

ChatsCtrl.$inject = ['$log', '$scope', 'Chats']

angular.module 'starter.chat'
  .controller 'ChatsCtrl', ChatsCtrl
