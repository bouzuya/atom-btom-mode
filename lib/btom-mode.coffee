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

  # public
  activate: ->
    configKey = 'btom-mode.modes'
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.onDidChange configKey, @change.bind @
    @initialize atom.config.get configKey

  # public
  deactivate: ->
    @subscriptions.dispose()
    @finalize @modes

  # private
  addClass: (mode) ->
    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.classList.add 'btom-mode-' + mode

  # private
  addCommands: (modes) ->
    atom.commands.add 'atom-workspace', modes.reduce (commands, i) =>
      commands["btom-mode:switch-#{i}"] = => @switch i
      commands
    , {}

  # private
  change: ({ newValue }) ->
    @finalize @modes
    @initialize newValue

  # private
  finalize: (modes) ->
    @removeClasses modes

  # private
  initialize: (modes) ->
    @modes = modes
    return if @modes.length is 0
    @addCommands @modes
    @switch @modes[0]

  # private
  removeClasses: (modes) ->
    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.classList.remove 'btom-mode-' + mode for mode in modes

  # private
  switch: (mode) ->
    return unless mode in @modes
    @removeClasses @modes
    @addClass mode
