@app.controller 'AdminCtrl', ($scope, $http) ->
  $scope.users = {} 
  $scope.toggleAdmin = ($user_id) ->
    $http( { method: 'PATCH', url: "/users/#{$user_id}/toggle_admin.json" } ).then(
      successCallback = (response) ->
        $scope.users[$user_id] = response.data['is_admin']
      , failureCallback = (response) ->
        console.log response.data['error']
        $scope.users[$user_id] = !$scope.users[$user_id]
    )