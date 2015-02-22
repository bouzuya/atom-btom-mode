{CompositeDisposable} = require 'atom'

module.exports = BtomMode =
  config:
    modes:
      type: 'array'
      default: []
      items:
        type: 'string'

  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @_initialize()

  deactivate: ->
    @subscriptions.dispose()
    @_removeAll()

  _initialize: ->
    modes = atom.config.get('btom-mode.modes')
    return if modes.length is 0

    # initialize commands
    atom.commands.add 'atom-workspace', modes.reduce (commands, i) =>
      commands["btom-mode:switch-#{i}"] = => @_switch i
      commands
    , {}

    @_switch modes[0]

  _switch: (mode) ->
    modes = atom.config.get('btom-mode.modes')
    return unless mode in modes
    @_removeAll()
    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.classList.add 'btom-mode-' + mode

  _removeAll: ->
    modes = atom.config.get('btom-mode.modes')
    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.classList.remove 'btom-mode-' + mode for mode in modes
