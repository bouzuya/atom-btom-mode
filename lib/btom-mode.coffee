BtomModeView = require './btom-mode-view'
{CompositeDisposable} = require 'atom'

module.exports = BtomMode =
  config:
    modes:
      type: 'array'
      default: []
      items:
        type: 'string'

  active: false
  btomModeView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @btomModeView = new BtomModeView(state.btomModeViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @btomModeView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'btom-mode:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @btomModeView.destroy()

  serialize: ->
    btomModeViewState: @btomModeView.serialize()

  toggle: ->
    modes = atom.config.get('btom-mode.modes')
    workspaceElement = atom.views.getView atom.workspace
    if @active
      for mode in modes
        workspaceElement.classList.add 'btom-mode-' + mode
    else
      for mode in modes
        workspaceElement.classList.remove 'btom-mode-' + mode
    @active = !@active

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
