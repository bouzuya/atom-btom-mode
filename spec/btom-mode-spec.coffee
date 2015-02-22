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

  describe 'commands', ->
    it 'should register each modes', ->
      waitsForPromise ->
        atom.config.set('btom-mode.modes', ['mode1', 'mode2'])
        atom.workspace.open()
      waitsForPromise ->
        atom.packages.activatePackage('btom-mode')
      runs ->
        workspaceElement = atom.views.getView(atom.workspace)
        commands = atom.commands.findCommands(target: workspaceElement)
        commandNames = commands.map (i) -> i.name
        expect('btom-mode:switch-mode1' in commandNames).toBe(true)
        expect('btom-mode:switch-mode2' in commandNames).toBe(true)
