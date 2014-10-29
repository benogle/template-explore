{registerElement} = require 'elmer'

Benchmarks = require './benchmarks'
Template = require '../templates/benchmark-runner.html'

module.exports =
BenchmarkRunnerElement = registerElement 'benchmark-runner',
  createdCallback: ->
    @appendChild(Template.clone())
    @classList.add 'tool-panel', 'panel-bottom', 'padded'

    @addEventListener 'click', (e) ->
      Benchmarks.elementCreation() if e.target.matches('.btn-element-creation')

    @addEventListener 'click', (e) ->
      Benchmarks.setText() if e.target.matches('.btn-set-text')
