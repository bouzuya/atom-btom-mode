BtomMode = require '../lib/btom-mode'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'BtomMode', ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('btom-mode')

  describe 'modes', ->
    modes = null

    beforeEach ->
      modes = ['normal', 'insert']

    describe 'when atom.config is default', ->
      it 'should not have "btom-mode-normal" class', ->
        atom.commands.dispatch workspaceElement, 'btom-mode:toggle'
        waitsForPromise ->
          activationPromise
        runs ->
          expect('btom-mode-normal' in workspaceElement.classList).toBe(false)
          expect('btom-mode-insert' in workspaceElement.classList).toBe(false)

    describe 'when atom.config.get("btom-mode.modes") is not empty', ->
      beforeEach ->
        atom.config.set('btom-mode.modes', modes)

      it 'should have "btom-mode-normal" class', ->
        expect('btom-mode-normal' in workspaceElement.classList).toBe(false)
        expect('btom-mode-insert' in workspaceElement.classList).toBe(false)
        atom.commands.dispatch workspaceElement, 'btom-mode:toggle'
        waitsForPromise ->
          activationPromise
        runs ->
          expect('btom-mode-normal' in workspaceElement.classList).toBe(true)
          expect('btom-mode-insert' in workspaceElement.classList).toBe(true)

      it 'should be able to toggle classes', ->
        expect('btom-mode-normal' in workspaceElement.classList).toBe(false)
        expect('btom-mode-insert' in workspaceElement.classList).toBe(false)
        atom.commands.dispatch workspaceElement, 'btom-mode:toggle'
        waitsForPromise ->
          activationPromise
        runs ->
          expect('btom-mode-normal' in workspaceElement.classList).toBe(false)
          expect('btom-mode-insert' in workspaceElement.classList).toBe(false)
          atom.commands.dispatch workspaceElement, 'btom-mode:toggle'
          expect('btom-mode-normal' in workspaceElement.classList).toBe(true)
          expect('btom-mode-insert' in workspaceElement.classList).toBe(true)


  describe 'when the btom-mode:toggle event is triggered', ->
    it 'hides and shows the modal panel', ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.btom-mode')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'btom-mode:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.btom-mode')).toExist()

        btomModeElement = workspaceElement.querySelector('.btom-mode')
        expect(btomModeElement).toExist()

        btomModePanel = atom.workspace.panelForItem(btomModeElement)
        expect(btomModePanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'btom-mode:toggle'
        expect(btomModePanel.isVisible()).toBe false

    it 'hides and shows the view', ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.btom-mode')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'btom-mode:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        btomModeElement = workspaceElement.querySelector('.btom-mode')
        expect(btomModeElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'btom-mode:toggle'
        expect(btomModeElement).not.toBeVisible()
