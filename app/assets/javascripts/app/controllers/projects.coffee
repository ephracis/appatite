@app.controller 'ProjectsCtrl', ['$scope', '$http', '$timeout', ($scope, $http, $timeout) ->
  $scope.projects = {} 
  $scope.activateProject = ($origin, $id) ->
    $scope.projects["#{$origin}-#{$id}"] = 'activating'
    $http.post(
      '/projects.json',
      { project: { origin: $origin, origin_id: $id } }
    ).then(
      successCallback = (response) ->
        $scope.projects["#{$origin}-#{$id}"] = 'active'
      , failureCallback = (response) ->
        console.log response.data['error']
        $scope.projects["#{$origin}-#{$id}"] = 'inactive'
    )

  $scope.deactivateProject = ($origin, $id) ->
    $scope.projects["#{$origin}-#{$id}"] = 'deactivating'
    $http.patch(
      '/projects/0.json',
      {
        origin: $origin, origin_id: $id,
        project: { active: false }
      }
    ).then(
      successCallback = (response) ->
        $scope.projects["#{$origin}-#{$id}"] = 'inactive'
      , failureCallback = (response) ->
        console.log response.data['error']
        $scope.projects["#{$origin}-#{$id}"] = 'active'
    )
]