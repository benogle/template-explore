{registerElement} = require 'elmer'

TemplateExploreModel = require './template-explore-model'
Template = require '../templates/template-explore.html'

module.exports =
TemplateExploreElement = registerElement 'template-explore',
  modelConstructor: TemplateExploreModel
  createdCallback: ->
    @appendChild(Template.clone())
    @rootTemplate = @querySelector('template')
    @classList.add 'tool-panel', 'panel-right', 'padded'

    @addEventListener 'click', (e) =>
      @model.clicked() if e.target.matches('button')

  getModel: -> @model
  setModel: (@model) ->
    @rootTemplate.model = @model
