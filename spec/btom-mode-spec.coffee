BtomMode = require '../lib/btom-mode'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'BtomMode', ->
  describe 'when atom.config is default', ->
    it 'should not have "btom-mode-normal" class', ->
      waitsForPromise ->
        atom.workspace.open()
      waitsForPromise ->
        atom.packages.activatePackage('btom-mode')
      runs ->
        workspaceElement = atom.views.getView(atom.workspace)
        expect('btom-mode-normal' in workspaceElement.classList).toBe(false)
        expect('btom-mode-insert' in workspaceElement.classList).toBe(false)

  describe 'when atom.config.get("btom-mode.modes") is not empty', ->
    it 'should have "btom-mode-normal" class', ->
      waitsForPromise ->
        atom.config.set('btom-mode.modes', ['normal', 'insert'])
        atom.workspace.open()
      waitsForPromise ->
        atom.packages.activatePackage('btom-mode')
      runs ->
        workspaceElement = atom.views.getView(atom.workspace)
        # expect(atom.config.get('btom-mode.modes')).toBe('')
        expect('btom-mode-normal' in workspaceElement.classList).toBe(true)
        expect('btom-mode-insert' in workspaceElement.classList).toBe(true)
