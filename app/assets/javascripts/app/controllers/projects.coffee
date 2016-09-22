@app.controller 'ProjectsCtrl', ['$scope', '$http', '$log', ($scope, $http, $log) ->
  $scope.projects = {}
  $scope.activateProject = ($origin, $id, $api_url) ->
    $scope.projects["#{$origin}-#{$id}"]['state'] = 'activating'
    $http.post(
      '/projects.json',
      { project: { origin: $origin, origin_id: $id, api_url: $api_url } }
    ).then(
      successCallback = (response) ->
        $scope.projects["#{$origin}-#{$id}"]['state'] = 'active'
      , failureCallback = (response) ->
        $log.error response.data['error']
        $scope.projects["#{$origin}-#{$id}"]['state'] = 'inactive'
    )

  $scope.deactivateProject = ($origin, $id, $api_url) ->
    $scope.projects["#{$origin}-#{$id}"]['state'] = 'deactivating'
    $http.delete(
      '/projects/0.json',
      { params: { origin: $origin, origin_id: $id, api_url: $api_url } }
    ).then(
      successCallback = (response) ->
        $scope.projects["#{$origin}-#{$id}"]['state'] = 'inactive'
      , failureCallback = (response) ->
        $log.error response.data['error']
        $scope.projects["#{$origin}-#{$id}"]['state'] = 'active'
    )
]