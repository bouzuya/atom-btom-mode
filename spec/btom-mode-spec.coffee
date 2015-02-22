BtomMode = require '../lib/btom-mode'

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
        atom.config.set('btom-mode.modes', ['normal'])
        atom.workspace.open()
      waitsForPromise ->
        atom.packages.activatePackage('btom-mode')
      runs ->
        workspaceElement = atom.views.getView(atom.workspace)
        expect('btom-mode-normal' in workspaceElement.classList).toBe(true)

  describe 'default mode', ->
    it 'should be first mode', ->
      waitsForPromise ->
        atom.config.set('btom-mode.modes', ['first', 'second'])
        atom.workspace.open()
      waitsForPromise ->
        atom.packages.activatePackage('btom-mode')
      runs ->
        workspaceElement = atom.views.getView(atom.workspace)
        expect('btom-mode-first' in workspaceElement.classList).toBe(true)
        expect('btom-mode-second' in workspaceElement.classList).toBe(false)
