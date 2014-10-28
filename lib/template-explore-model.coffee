module.exports =
class TemplateExploreModel
  buttonMessage: 'Clicked'
  buttonClicks: 0

  showTheThing: false

  things: [
    {name: 'one'}
    {name: 'two'}
    {name: 'three'}
    {name: 'four'}
  ]

  constructor: ->

  clicked: ->
    @buttonClicks++
