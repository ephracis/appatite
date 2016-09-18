@app.controller 'RootCtrl', ['$scope', 'Fullscreen', ($scope, $fullscreen) ->
  $scope.goFullscreen = ->
    if $fullscreen.isEnabled()
      $fullscreen.cancel()
    else
      $fullscreen.all()
]