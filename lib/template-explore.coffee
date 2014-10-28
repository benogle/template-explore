TemplateExploreModel = require './template-explore-model'
TemplateExploreView = require './template-explore-view'

module.exports =
  activate: (state) ->
    @model = new TemplateExploreModel
    @panel = atom.workspace.addRightPanel item: @model

    atom.commands.add ".workspace", "template-explore:toggle", =>
      if @panel.isVisible()
        @panel.hide()
      else
        @panel.show()

  deactivate: ->

  serialize: ->
