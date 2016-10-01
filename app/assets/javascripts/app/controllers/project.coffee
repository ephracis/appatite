@app.controller 'ProjectCtrl', ['$scope', '$http', '$log', ($scope, $http, $log) ->
  $scope.project = {}
  $scope.error = ''
  $scope.load = ($id) ->
    $http.get("/projects/#{$id}.json").then(
      successCallback = (response) ->
        $scope.project = response.data
        App.cable.subscriptions.create { channel: "ProjectChannel", id: $id },
          received: $scope.receiveCableData
      , failureCallback = (response) ->
        $log.error response.data['error']
        $scope.error = response.data['error']
    )

  $scope.isRefreshing = ->
    return false unless $scope.project['refreshed_at']
    refreshed_at = new Date($scope.project['refreshed_at'])
    timeout = 1000 * 60 * 60 # one hour in ms
    return ((new Date) - refreshed_at) < timeout

  $scope.receiveCableData = (data) ->
    $scope.project = data
    $scope.$apply()
]