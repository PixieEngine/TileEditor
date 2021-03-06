namespace "Pixie.Editor.Tile.Views", (Views) ->
  class Views.Entity extends Views.Base
    tagName: 'img'
    className: 'entity'

    initialize: ->
      super

      # Add cid
      @el.attr
        "data-cid": @model.cid
        "data-uuid": @model.get("uuid")

      @model.bind 'change:sprite', @render

      @render()

    render: =>
      @el.attr "src", @model.src()

      if @model == @options.settings.get "activeEntity"
        @el.addClass "active"

      return this
