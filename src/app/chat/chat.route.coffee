'use strict'

appRun = (routerHelper) ->
  routerHelper.configureStates getStates(), '/tab/dash'

getStates = ->
  [
    state: 'tab.chats'
    config:
      url: '/chats'
      views:
        'tab-chats':
          templateUrl: 'chat/tab-chats.html'
          controller: 'ChatsCtrl'
  ,
    state: 'tab.chat-detail'
    config:
      url: '/chats/:chatId'
      views:
        'tab-chats':
          templateUrl: 'chat/chat-detail.html'
          controller: 'ChatDetailCtrl'
  ]

appRun.$inject = ['routerHelper']

angular
  .module 'starter.chat'
  .run appRun
