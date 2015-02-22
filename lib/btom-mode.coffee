BtomModeView = require './btom-mode-view'
{CompositeDisposable} = require 'atom'

module.exports = BtomMode =
  config:
    modes:
      type: 'array'
      default: []
      items:
        type: 'string'

  btomModeView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @btomModeView = new BtomModeView(state.btomModeViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @btomModeView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    modes = atom.config.get('btom-mode.modes')
    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.classList.add 'btom-mode-' + mode for mode in modes

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @btomModeView.destroy()

    modes = atom.config.get('btom-mode.modes')
    workspaceElement = atom.views.getView atom.workspace
    workspaceElement.classList.remove 'btom-mode-' + mode for mode in modes

  serialize: ->
    btomModeViewState: @btomModeView.serialize()
