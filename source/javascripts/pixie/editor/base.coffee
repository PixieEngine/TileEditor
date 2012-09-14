#= require pixie/editor/tile/templates/button_group

#TODO Extract to separate lib

# A Base editor module for backbone based editors
namespace "Pixie.Editor", (Editor) ->
  Button = (options={}) ->
    options.class ||= 'btn'
    jQuery "<button/>", options

  Editor.Base = (I, self) ->
    addHotkey: (hotkey, fn) ->
      # We need to bind hotkeys to document because non-input elements
      # can't detect key presses.
      $(document).bind 'keydown', hotkey, (event) ->
        # Only process hotkeys when this editor is "focused"
        if currentComponent == self
          event.preventDefault()
          fn()

          #TODO Be sure editors are scoped correctly so
          # that bubbling will work as expected.
          return false

    constructGroup: (groupName, action, actionButton) ->
      unless (buttonGroup = @$(".content .actions.top [data-group='#{groupName}']")).length
        buttonGroup = $(JST['pixie/editor/tile/templates/button_group']({group: groupName}))

      if action.primary
        buttonGroup.find('.dropdown-toggle').before actionButton

      listItem = $ "<li>"
      anchor = $ "<a>"
        href: '#'
        html: "#{action.name.capitalize()}<span class='hotkey'>#{action.hotkeys.first()}</span>"
      .on 'mousedown touchstart', ->
        action.perform(self)

        return false

      listItem.append(anchor)

      buttonGroup.find('.dropdown-menu').append listItem

      buttonGroup

    constructAction: (action) ->
      name = action.name
      titleText = name.capitalize()
      undoable = action.undoable

      perform = ->
        action.perform(self)

      if action.hotkeys
        # TODO: Auto-generate hotkey documentation for UI display
        ([].concat action.hotkeys).each (hotkey) ->
          self.addHotkey(hotkey, perform)

      if action.menu != false
        actionButton = Button
          text: name.capitalize()
          title: titleText
        .on "mousedown touchstart", ->
          perform() unless $(this).attr('disabled')

          return false

        if action.icon
          actionButton.append "<span class='icon static-#{action.icon}'></span>"

        actionButton

    addAction: (action) ->
      actionButton = self.constructAction(action)

      if action.menu != false
        if group = action.group
          self.constructGroup(group, action, actionButton).appendTo(@$(".content .actions.top"))
        else
          actionButton.appendTo(@$(".content .actions.top"))

    takeFocus: ->
      window.currentComponent = self
