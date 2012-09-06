namespace "Pixie.Editor.Tile.Views", (Views) ->
  class Views.Layer extends Pixie.View
    tagName: 'li'
    className: 'layer'

    initialize: ->
      super

      @el.attr "data-cid", @model.cid

      @model.bind 'change', @render

      @render()

    render: =>
      color = @model.get('color')
      backgroundColor = "background-color:#{color}"
      colorLabel = "<span class='color_label' style=#{backgroundColor}></span>"

      @el.html "#{colorLabel}<div class='name'>#{@model.get 'name'}</div> <eye />"

      if @model == @options.settings.get "activeLayer"
        @el.addClass "active"

      if @model.get 'visible'
        @el.fadeTo 'fast', 1
      else
        @el.fadeTo 'fast', 0.5

      return this

    activate: (e) ->
      return if $(e.target).is('eye')

      @options.settings.set
        activeLayer: @model

    toggleVisible: ->
      @model.set
        visible: !@model.get 'visible'

    events:
      click: "activate"
      "click eye": "toggleVisible"
