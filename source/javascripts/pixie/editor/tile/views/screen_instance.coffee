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

      properties = $ "<div>"
        class: 'properties_display'

      for key, value of @model.get('properties')
        properties.append $ "<p class='property'><span class='key'>#{key}</span>: <span class='value'>#{value}</span></p>"

      # sort properties so they match the properties editor
      if _.keys(@model.get('properties')).length
        @el.attr
          "data-original-title": properties.get(0).outerHTML
          "rel": "tooltip"

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

      # TODO move this up to a higher level
      # and only init the tooltips once all the
      # instances are rendered
      @el.tooltip
        placement: 'right'
        html: true
        delay:
          show: 500
          hide: 100

    render: =>
      @$('img:eq(0)').attr "src", @model.get "src"

      instanceProperties = @model.get "properties"
      @el.toggleClass "props", !_.isEmpty(instanceProperties)

      @el.css
        left: @model.get "x"
        top: @model.get "y"

      return this
