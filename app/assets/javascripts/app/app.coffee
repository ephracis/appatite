@app = angular.module 'Appatite', []

$(document).on 'turbolinks:load', ->
  angular.bootstrap document.body, ['Appatite']