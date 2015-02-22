BtomModeView = require './btom-mode-view'
{CompositeDisposable} = require 'atom'

module.exports = BtomMode =
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
    console.log 'BtomMode was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
