describe "Pixie.Editor.Base", ->
  beforeEach ->
    @view = new Pixie.View
    @view.include(Pixie.Editor.Base)

  it "should be able to be mixed in", ->
    expect(@view.addAction).toBeDefined()
    expect(_.isFunction(@view.addAction)).toBeTruthy()

  it "should create an action", ->
    button = @view._constructAction
      name: 'save'

    expect(button).toHaveClass('btn')
    expect((button).attr('title')).toEqual('Save')
    expect(button).toHaveText('Save')

  it "should bind hotkeys", ->
    hotkeySpy = sinon.spy(@view, 'addHotkey')

    button = @view._constructAction
      name: 'delete'
      hotkeys: ['d', 'shift+d']

    # TODO test to make sure hotkey spy is called
    # with the hotkey strings
    expect(hotkeySpy).toHaveBeenCalledTwice()

  it "should not create a button for items not in the menu", ->
    button = @view._constructAction
      name: 'edit'
      menu: false

    expect(button).not.toBeDefined()

  it "should support adding icons", ->
    button = @view._constructAction
      name: 'hide'
      icon: 'eye'

    expect(button.find('.icon')).toExist()
