namespace "Pixie.Editor.Tile.Views", (Views) ->
  class Views.ScreenLayer extends Pixie.View
    className: "layer"

    tagName: "li"

    initialize: ->
      super

      @el.attr "data-cid", @model.cid

      @model.bind 'change', @render

      @objectInstances = @model.objectInstances
      @objectInstances.bind "add", @instanceAdded
      @objectInstances.bind "remove", @instanceRemoved
      @objectInstances.bind "reset", @resetInstances

      @resetInstances()

      @render()

    instanceAdded: (instance) =>
      screenInstance = new Views.ScreenInstance
        model: instance

      @el.append screenInstance.el

    instanceRemoved: (instance) =>
      @$(".instance[data-cid=#{instance.cid}]").remove()

    resetInstances: =>
      @$(".instance").remove()

      @objectInstances.each (instance) =>
        @instanceAdded(instance)

    render: =>
      @el.css
        zIndex: @model.get "zIndex"

      if @model.get 'visible'
        @el.css
          opacity: 1
      else
        @el.css
          opacity: 0

      return this
