#= require pixie/grid_gen

#= require ../command
#= require ../tools

#= require pixie/editor/tile/templates/screen

namespace "Pixie.Editor.Tile.Views", (Views) ->
  Tile = Pixie.Editor.Tile
  {Command, Models} = Tile

  UI = Pixie.UI

  class Views.Screen extends Views.Base
    className: "screen"

    template: "screen"

    initialize: ->
      super

      @selection = @settings.selection
      selectionView = new Views.ScreenSelection
        model: @selection
      @$(".canvas").append selectionView.el

      # Cache for views so they won't constantly be recreated
      @_layerViews = {}

      @collection.bind 'add', @appendLayer
      @collection.bind 'reset', @render

      @settings.bind 'change:tilesWide', @render
      @settings.bind 'change:tilesTall', @render
      @settings.bind 'change:tileWidth', @render
      @settings.bind 'change:tileHeight', @render

      @render()

    render: =>
      grid = Pixie.GridGen
        width: @settings.get "tileWidth"
        height: @settings.get "tileHeight"

      @$('.canvas').css
        height: @settings.pixelHeight()
        width: @settings.pixelWidth()
        backgroundImage: grid.backgroundImage()

      @$(".cursor").css
        width: @settings.get("tileWidth") - 1
        height: @settings.get("tileHeight") - 1

      @$(".canvas ul.layers").empty()

      @collection.each @appendLayer

    appendLayer: (layer) =>
      unless layerView = @_layerViews[layer.cid]
        layerView = @_layerViews[layer.cid] = new Views.ScreenLayer
          model: layer
          settings: @settings

      @$("ul.layers").append layerView.render().el

    instanceAtCursor: () =>
      layer = @settings.get "activeLayer"

      return layer.instanceAt(@cursorPosition.x, @cursorPosition.y)

    execute: (command) =>
      @currentCompoundCommand.push command

    localPosition: (event) =>
      {currentTarget} = event

      cursorWidth = @settings.get "tileWidth"
      cursorHeight = @settings.get "tileHeight"

      offset = $(currentTarget).offset()

      x: (event.pageX - offset.left).clamp(0, @settings.pixelWidth() - cursorWidth).snap(cursorWidth)
      y: (event.pageY - offset.top).clamp(0, @settings.pixelHeight() - cursorHeight).snap(cursorHeight)

    mousemove: (event) =>
      {x, y} = @cursorPosition = @localPosition(event)

      gridX = x / @settings.get "tileWidth"
      gridY = y / @settings.get 'tileHeight'

      @editor.$('.cursor_position').text "x: #{gridX} y: #{gridY}"

      unless _.isEqual(@cursorPosition, @previousCursorPosition)
        @entered(x, y)

        @$(".cursor").css
          left: x - 1
          top: y - 1

      @previousCursorPosition = @cursorPosition

    entered: (x, y) =>
      if @activeTool
        layer = @settings.get "activeLayer"
        entity = @settings.get "activeEntity"

        @activeTool.enter({x, y, layer, entity, @execute, @selection, @settings})

    actionStart: (event) =>
      event.preventDefault()

      # Reuse an empty existing compound command if present
      unless @currentCompoundCommand and @currentCompoundCommand.empty()
        @currentCompoundCommand = Command.CompoundCommand()

        @editor.execute @currentCompoundCommand

      if tool = Tile.tools[@settings.get("activeTool")]
        @activeTool = tool

        {x, y} = @localPosition(event)
        layer = @settings.get "activeLayer"
        entity = @settings.get "activeEntity"

        tool.start({x, y, layer, entity, @execute, @selection, @settings})
        tool.enter({x, y, layer, entity, @execute, @selection, @settings})

    actionEnd: (event) =>
      if @activeTool
        {x, y} = @localPosition(event)
        layer = @settings.get "activeLayer"
        entity = @settings.get "activeEntity"

        @activeTool.end()

      @activeTool = null

    events:
      "mousemove .canvas": "mousemove"
      "mousedown .canvas": "actionStart"
      "mouseup": "actionEnd"
