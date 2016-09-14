describe 'AdminCtrl', ->
  scope = http = null

  beforeEach module('Appatite')

  beforeEach inject(($controller, $rootScope, $httpBackend) ->
    scope = $rootScope.$new()
    http = $httpBackend
    $controller('AdminCtrl', { $scope: scope })
  )

  describe '$scope.users', ->
    it 'should default to empty hash', ->
      expect(scope.users).toEqual {}

  describe '$scope.toggleAdmin', ->
    it 'should update user to admin', ->
      http.expectPATCH('/users/1337/toggle_admin.json')
          .respond { is_admin: true }
      scope.toggleAdmin 1337
      http.flush()
      expect(scope.users[1337]).toEqual true

    it 'should update admin to user', ->
      http.expectPATCH('/users/1337/toggle_admin.json')
          .respond { is_admin: false }
      scope.toggleAdmin 1337
      http.flush()
      expect(scope.users[1337]).toEqual false

    it 'should revert on error', ->
      scope.users[1337] = true
      http.expectPATCH('/users/1337/toggle_admin.json')
          .respond 500, { error: 'Something went wrong' }
      scope.toggleAdmin 1337
      http.flush()
      expect(scope.users[1337]).toEqual false