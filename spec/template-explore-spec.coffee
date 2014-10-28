{WorkspaceView} = require 'atom'
TemplateExplore = require '../lib/template-explore'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "TemplateExplore", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('template-explore')

  describe "when the template-explore:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.template-explore')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch atom.workspaceView.element, 'template-explore:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.template-explore')).toExist()
        atom.commands.dispatch atom.workspaceView.element, 'template-explore:toggle'
        expect(atom.workspaceView.find('.template-explore')).not.toExist()
