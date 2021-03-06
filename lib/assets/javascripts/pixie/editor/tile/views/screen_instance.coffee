namespace "Pixie.Editor.Tile.Views", (Views) ->
  Models = Pixie.Editor.Tile.Models

  class Views.ScreenInstance extends Views.Base
    className: "instance"

    initialize: ->
      super

      @el.append $ "<img>"

      @el.append $ "<div>",
        class: "propsIcon"

      colorLabel = $ "<div>"
        class: 'color_label'

      colorLabel.css
        backgroundColor: @model.get('color')

      @updateTooltip()

      @el.append colorLabel

      @el.attr "data-cid", @model.cid

      {width, height} = @model.get('sourceEntity').attributes

      @el.css
        width: width
        height: height

      @model.on 'change', @render
      @model.on 'change:properties', @updateTooltip

      @render()

    updateTooltip: =>
      properties = $ "<div>"
        class: 'properties_display'

      props = @model.get('properties')
      keys = _.keys(props)

      for key in keys.sort()
        value = props[key]

        properties.append $ "<p class='property'><span class='key'>#{key}</span>: <span class='value'>#{value}</span></p>"

      if keys.length
        @el.attr
          "data-original-title": properties.get(0).outerHTML
          "rel": "tooltip"

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

      @updateTooltip()

      return this
