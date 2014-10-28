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

  numToWords: (value) ->
    convert =
      0: 'none'
      1: 'one'
      2: 'two'
      3: 'three'
      4: 'four'
      5: 'five'
    convert[value] ? value
