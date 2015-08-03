####
# Routing
# Code adapted from https://github.com/johnpapa/angular-styleguide#style-y270
####

do ->
  'use strict'

  routerHelperProvider = ($locationProvider, $stateProvider, $urlRouterProvider) ->

    #	$locationProvider.html5Mode({
    #	  enabled: true,
    #	  requireBase: false
    #	});

    RouterHelper = ($state) ->
      hasOtherwise = false

      configureStates = (states, otherwisePath) ->
        states.forEach (state) ->
          $stateProvider.state state.state, state.config

        if otherwisePath and not hasOtherwise
          hasOtherwise = true
          $urlRouterProvider.otherwise otherwisePath

      getStates = ->
        $state.get()

      service =
        configureStates : configureStates
        getStates: getStates

      service

    RouterHelper.$inject = ['$state']
    @$get = RouterHelper

    return

  routerHelperProvider.$inject = ['$locationProvider', '$stateProvider', '$urlRouterProvider']

  angular
    .module 'blocks.router'
    .provider 'routerHelper', routerHelperProvider
