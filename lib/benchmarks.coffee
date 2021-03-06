{registerElement} = require 'elmer'
{View} = require 'space-pen'

class BenchmarkModel
  shown: true
  text: 'test'

  updateText: ->
    @text = Math.random() * 999999

  toggle: ->
    @shown = !@shown

  filterText: (value) ->
    'OK!' + value



class BenchmarkView extends View
  @content: (model) ->
    @div class: 'benchmark-element', =>
      @h2 'Some Heading'
      @div =>
        @span 'Raw Text'
        @span outlet: 'normalText', model.text
      @div =>
        @span 'Filtered Text'
        @span outlet: 'filteredText', model.filterText model.text
      @div outlet: 'divToHide', '`tokenList` filter on class'

  initialize: (@model) ->

  updateText: ->
    @model.updateText()
    @normalText.text(@model.text)
    @normalText.text(@model.filterText @model.text)

  toggle: ->
    @model.toggle()
    if @model.shown
      @divToHide.addClass('should-hide')
    else
      @divToHide.removeClass('should-hide')



Template = require '../templates/benchmark-element.html'
BenchmarkElement = registerElement 'benchmark-element',
  modelConstructor: BenchmarkModel
  createdCallback: ->
    @appendChild(Template.clone())
    @rootTemplate = @querySelector('template')

  getModel: -> @model
  setModel: (@model) ->
    @rootTemplate.model = @model

  updateText: ->
    @model.updateText()

  toggle: ->
    @model.toggle()



BenchmarkNoModelElement = registerElement 'benchmark-element-no-model',
  createdCallback: ->
    content = Template.clone().querySelector('template').content
    node = document.importNode(content, true)
    @appendChild(node)



module.exports =
class Benchmarks
  @elementCreation: ->
    @elementCreationSpacePen()
    @elementCreationTemplateNoBinding()
    @elementCreationTemplate()

  @elementCreationSpacePen: ->
    name = 'Element creation benchmark: space-pen'
    root = atom.workspaceView

    console.time(name)

    for i in [0..1000]
      model = new BenchmarkModel()
      element = new BenchmarkView(model)
      root.append(element)
      element.remove()

    console.timeEnd(name)

  @elementCreationTemplateNoBinding: ->
    name = 'Element creation benchmark: template NO bindings'
    root = atom.views.getView(atom.workspace)

    console.time(name)

    for i in [0..1000]
      element = new BenchmarkNoModelElement()
      root.appendChild(element)
      root.removeChild(element)

    console.timeEnd(name)

  @elementCreationTemplate: ->
    name = 'Element creation benchmark: template bindings'
    root = atom.views.getView(atom.workspace)

    console.time(name)
    # console.profile(name)

    for i in [0..1000]
      model = new BenchmarkModel()
      element = atom.views.getView(model)
      root.appendChild(element)
      element.rootTemplate.setModelFn_()
      root.removeChild(element)

    # console.profileEnd(name)
    console.timeEnd(name)

  @setText: ->
    @setTextSpacePen()
    @setTextTemplate()
    @setTextTemplateSerial()

  @setTextSpacePen: ->
    name = 'Set text benchmark: space-pen'
    root = atom.workspaceView

    model = new BenchmarkModel()
    element = new BenchmarkView(model)
    root.append(element)

    console.time(name)
    for i in [0..1000]
      element.updateText()
    console.timeEnd(name)

    element.remove()

  @setTextTemplate: ->
    name = 'Set text benchmark: template bindings'
    root = atom.views.getView(atom.workspace)

    # Note: This is strictly not the same as the space pen test.
    # Object.observe batches them up, and will call the observe callback with
    # all changes.

    model = new BenchmarkModel()
    element = atom.views.getView(model)
    root.appendChild(element)
    element.rootTemplate.setModelFn_()

    n = 1000
    numChanges = 0
    Object.observe model, (changes) ->
      numChanges += changes.length
      endIt() if numChanges >= n

    endIt = ->
      console.timeEnd(name)
      root.removeChild(element)

    console.time(name)
    for i in [0..n]
      element.updateText()

  @setTextTemplateSerial: ->
    name = 'Set text benchmark: template bindings serial'
    root = atom.views.getView(atom.workspace)

    model = new BenchmarkModel()
    element = atom.views.getView(model)
    root.appendChild(element)
    element.rootTemplate.setModelFn_()

    n = 1000
    numChanges = 0
    Object.observe model, (changes) ->
      numChanges += changes.length
      endIt() if numChanges >= n
      next()

    next = ->
      element.updateText()

    endIt = ->
      console.timeEnd(name)
      root.removeChild(element)

    console.time(name)
    next()
