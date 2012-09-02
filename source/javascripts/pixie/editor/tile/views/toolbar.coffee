#= require pixie/editor/jquery.take_class
#= require pixie/editor/jquery.property_editor

#= require pixie/editor/tile/templates/toolbar

namespace "Pixie.Editor.Tile.Views", (Views) ->
  Models = Pixie.Editor.Tile.Models

  class Views.Toolbar extends Pixie.View
    className: "tools"

    tagName: "ul"

    template: "toolbar"

    initialize: ->
      super

      @render()

      @settings.bind "change:activeTool", (settings) =>
        activeTool = settings.get "activeTool"
        @$("[data-tool=#{activeTool}]").takeClass("active")

      @settings.set
        activeTool: "stamp"

    render: =>
      return this

    selectTool: ({currentTarget}) =>
      selectedTool = $(currentTarget)

      @editor.$el.css('cursor', Pixie.Editor.Tile.tools[selectedTool.data('tool')]?.cursor || "pointer")

      @settings.set
        activeTool: selectedTool.data "tool"

    events:
      "click .tool": "selectTool"
