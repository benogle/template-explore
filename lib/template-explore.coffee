TemplateExploreModel = require './template-explore-model'
TemplateExploreElement = require './template-explore-view'
BenchmarkRunnerElement = require './benchmark-runner-view'

module.exports =
  activate: (state) ->
    @model = new TemplateExploreModel
    @panel = atom.workspace.addRightPanel item: @model
    @runnerPanel = atom.workspace.addBottomPanel item: new BenchmarkRunnerElement

    atom.commands.add ".workspace", "template-explore:toggle", =>
      if @panel.isVisible()
        @panel.hide()
      else
        @panel.show()

  deactivate: ->

  serialize: ->
