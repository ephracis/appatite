describe 'ProjectsCtrl', ->
  scope = http = deleteUrl = null

  beforeEach module('Appatite')

  beforeEach inject(($controller, $rootScope, $httpBackend) ->
    scope = $rootScope.$new()
    http = $httpBackend
    $controller('ProjectsCtrl', { $scope: scope })
    deleteUrl = '/projects/0.json?api_url=test-url&' +
                'origin=test-origin&origin_id=42'
  )

  describe '$scope.projects', ->
    it 'should default to empty hash', ->
      expect(scope.projects).toEqual {}

  describe '$scope.activateProject', ->
    beforeEach ->
      scope.projects = { 'test-origin-42': { state: 'inactive' } }

    it 'should mark project as active on success', ->
      http.expectPOST('/projects.json').respond()
      scope.activateProject 'test-origin', 42, 'test-url'
      http.flush()
      expect(scope.projects['test-origin-42']['state']).toEqual 'active'

    it 'should mark project as inactive on failure', ->
      http.expectPOST('/projects.json')
          .respond 500, { error: 'Something went wrong'}
      scope.activateProject 'test-origin', 42, 'test-url'
      http.flush()
      expect(scope.projects['test-origin-42']['state']).toEqual 'inactive'

  describe '$scope.deactivateProject', ->
    beforeEach ->
      scope.projects = { 'test-origin-42': { state: 'active' } }

    it 'should mark project as inactive on success', ->
      http.expectDELETE(deleteUrl).respond()
      scope.deactivateProject 'test-origin', 42, 'test-url'
      http.flush()
      expect(scope.projects['test-origin-42']['state']).toEqual 'inactive'

    it 'should mark project as active on failure', ->
      http.expectDELETE(deleteUrl)
          .respond 500, { error: 'Something went wrong' }
      scope.deactivateProject 'test-origin', 42, 'test-url'
      http.flush()
      expect(scope.projects['test-origin-42']['state']).toEqual 'active'