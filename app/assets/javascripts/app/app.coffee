@app = angular.module 'Appatite', ['FBAngular']

$(document).on 'turbolinks:load', ->
  angular.bootstrap document.body, ['Appatite']