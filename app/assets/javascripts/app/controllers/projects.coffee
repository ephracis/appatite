@app.controller 'ProjectsCtrl', ['$scope', '$http', ($scope, $http) ->
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
        console.log response.data['error']
        $scope.projects["#{$origin}-#{$id}"]['state'] = 'inactive'
    )

  $scope.deactivateProject = ($origin, $id, $api_url) ->
    $scope.projects["#{$origin}-#{$id}"]['state'] = 'deactivating'
    $http.patch(
      '/projects/0.json',
      {
        origin: $origin, origin_id: $id, api_url: $api_url,
        project: { active: false }
      }
    ).then(
      successCallback = (response) ->
        $scope.projects["#{$origin}-#{$id}"]['state'] = 'inactive'
      , failureCallback = (response) ->
        console.log response.data['error']
        $scope.projects["#{$origin}-#{$id}"]['state'] = 'active'
    )
  
  App.cable.subscriptions.create "ProjectChannel",
    received: (data) ->
      uniq_id = "#{data['origin']}-#{data['origin_id']}"
      $scope.projects[uniq_id]['name'] = data['name']
      $scope.projects[uniq_id]['build_state'] = data['build_state']
      $scope.projects[uniq_id]['coverage'] = data['coverage'] || 0
      $scope.$apply()
]