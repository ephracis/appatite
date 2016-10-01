describe 'ProjectCtrl', ->
  scope = http = null

  beforeEach module('Appatite')

  beforeEach inject(($controller, $rootScope, $httpBackend) ->
    scope = $rootScope.$new()
    http = $httpBackend
    $controller('ProjectCtrl', { $scope: scope })
  )

  describe '$scope.project', ->
    it 'should default to empty hash', ->
      expect(scope.project).toEqual {}

  describe '$scope.load', ->
    it 'should set error on failure', ->
      http.expectGET('/projects/42.json')
          .respond 500, { error: 'A test error'}
      scope.load 42
      http.flush()
      expect(scope.error).toEqual 'A test error'

    it 'update meta data on success', ->
      spyOn(App.cable.subscriptions, 'create')
      http.expectGET('/projects/42.json')
          .respond { name: 'test/repo' }
      scope.load 42
      http.flush()
      expect(App.cable.subscriptions.create).toHaveBeenCalled()
      expect(scope.project['name']).toEqual 'test/repo'

  describe '$scope.isRefreshing', ->
    it 'should return false when refresh_at is null', ->
      scope.project['refreshed_at'] = null
      expect(scope.isRefreshing()).toEqual false

    it 'should return false when refresh_at is two hours ago', ->
      date = new Date(new Date().getTime() - (2 * 60 * 60 * 1000))
      scope.project['refreshed_at'] = date
      expect(scope.isRefreshing()).toEqual false

    it 'should return false when refresh_at is two minutes ago', ->
      date = new Date(new Date().getTime() - (2 * 60 * 1000))
      scope.project['refreshed_at'] = date
      expect(scope.isRefreshing()).toEqual true

  describe '$scope.receiveCableData', ->
    it 'should update project meta data', ->
      scope.receiveCableData {
        origin: 'test-origin',
        origin_id: 42,
        name: 'new-name',
        build_state: 'running',
        coverage: 1.23
      }
      expect(scope.project['name']).toEqual 'new-name'
      expect(scope.project['build_state']).toEqual 'running'
      expect(scope.project['coverage']).toEqual 1.23

    it 'should set coverage to undefined by default', ->
      scope.receiveCableData {
        origin: 'test-origin',
        origin_id: 42
      }
      expect(scope.project['coverage']).toEqual undefined