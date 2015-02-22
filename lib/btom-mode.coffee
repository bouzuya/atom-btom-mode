{CompositeDisposable} = require 'atom'

module.exports = BtomMode =
  config:
    modes:
      type: 'array'
      default: []
      items:
        type: 'string'

  modes: []
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @modes = atom.config.get('btom-mode.modes')
    @initialize @modes

  deactivate: ->
    @subscriptions.dispose()
    @finalize @modes

  initialize: (modes) ->
    return if modes.length is 0
    @addCommands modes
    @switch modes[0]

  finalize: (modes) ->
    @removeClasses modes

  switch: (mode) ->
    return unless mode in @modes
    @removeClasses @modes
    @addClass mode

  removeClasses: (modes) ->
    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.classList.remove 'btom-mode-' + mode for mode in modes

  addClass: (mode) ->
    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.classList.add 'btom-mode-' + mode

  addCommands: (modes) ->
    atom.commands.add 'atom-workspace', modes.reduce (commands, i) =>
      commands["btom-mode:switch-#{i}"] = => @_switch i
      commands
    , {}
