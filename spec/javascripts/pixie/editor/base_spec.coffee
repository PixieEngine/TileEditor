describe "Pixie.Editor.Base", ->
  beforeEach ->
    @view = new Pixie.View
    @view.include(Pixie.Editor.Base)

  it "should be able to be mixed in", ->
    expect(@view.addAction).toBeDefined()
    expect(_.isFunction(@view.addAction)).toBeTruthy()

  describe "actions", ->
    it "should be able to be created", ->
      button = @view.constructButton
        name: 'save'

      expect(button).toHaveClass('btn')
      expect((button).attr('title')).toEqual('Save')
      expect(button).toHaveText('Save')

    it "should bind hotkeys", ->
      hotkeySpy = sinon.spy(@view, 'addHotkey')

      button = @view.constructButton
        name: 'delete'
        hotkeys: ['d', 'shift+d']

      # TODO test to make sure hotkey spy is called
      # with the hotkey strings
      expect(hotkeySpy).toHaveBeenCalledTwice()

    it "should not create a button for items not in the menu", ->
      button = @view.constructButton
        name: 'edit'
        menu: false

      expect(button).not.toBeDefined()

    it "should support adding icons", ->
      button = @view.constructButton
        name: 'hide'
        icon: 'eye'

      expect(button.find('.icon')).toExist()
