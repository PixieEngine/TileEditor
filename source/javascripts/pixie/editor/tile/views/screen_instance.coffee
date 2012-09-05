namespace "Pixie.Editor.Tile.Views", (Views) ->
  Models = Pixie.Editor.Tile.Models

  class Views.ScreenInstance extends Pixie.View
    className: "instance"

    initialize: ->
      super

      @el.append $ "<img>"

      @el.append $ "<img>",
        class: "propsIcon"
        src: '/images/pixie/editor/tile/table.png'

      colorLabel = $ "<div>"
        class: 'color_label'

      colorLabel.css
        backgroundColor: @model.get('color')

      @el.append colorLabel

      @el.attr "data-cid", @model.cid

      {width, height} = @model.get('sourceEntity').attributes

      @el.css
        width: width
        height: height

      @model.bind 'change', @render

      @render()

    render: =>
      @$('img:eq(0)').attr "src", @model.get "src"

      instanceProperties = @model.get "properties"
      @el.toggleClass "props", !_.isEmpty(instanceProperties)

      @el.css
        left: @model.get "x"
        top: @model.get "y"

      return this
