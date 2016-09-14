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

  $scope.receiveCableData = (data) ->
      uniq_id = "#{data['origin']}-#{data['origin_id']}"
      $scope.projects[uniq_id]['name'] = data['name']
      $scope.projects[uniq_id]['build_state'] = data['build_state']
      $scope.projects[uniq_id]['coverage'] = data['coverage'] || 0
      $scope.$apply()
  
  App.cable.subscriptions.create "ProjectChannel",
    received: $scope.receiveCableData
]