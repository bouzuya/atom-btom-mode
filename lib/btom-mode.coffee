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
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    modes = atom.config.get('btom-mode.modes')
    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.classList.add 'btom-mode-' + mode for mode in modes

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()

    modes = atom.config.get('btom-mode.modes')
    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.classList.remove 'btom-mode-' + mode for mode in modes
