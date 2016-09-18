describe 'RootCtrl', ->
  scope = fullscreen = null

  beforeEach module('Appatite')

  beforeEach inject(($controller, $rootScope, Fullscreen) ->
    scope = $rootScope.$new()
    fullscreen = Fullscreen
    $controller('RootCtrl', { $scope: scope })
  )

  describe '$scope.goFullscreen', ->
    beforeEach ->
      spyOn fullscreen, 'all'
      spyOn fullscreen, 'cancel'

    it 'should enable fullscreen when off', ->
      spyOn(fullscreen, 'isEnabled').and.returnValue false
      scope.goFullscreen()
      expect(fullscreen.all).toHaveBeenCalled()
      expect(fullscreen.cancel).not.toHaveBeenCalled()

    it 'should disable fullscreen when on', ->
      spyOn(fullscreen, 'isEnabled').and.returnValue true
      scope.goFullscreen()
      expect(fullscreen.all).not.toHaveBeenCalled()
      expect(fullscreen.cancel).toHaveBeenCalled()