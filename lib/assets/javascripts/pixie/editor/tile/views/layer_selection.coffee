#= require pixie/editor/jquery.live_edit

#= require pixie/editor/tile/templates/layer_selection

namespace "Pixie.Editor.Tile.Views", (Views) ->
  Models = Pixie.Editor.Tile.Models

  class Views.LayerSelection extends Pixie.View
    className: 'component layer_selection'

    template: "layer_selection"

    initialize: ->
      super

      @collection.on 'add', @appendLayer
      @collection.on 'reset', @render
      @collection.on 'remove', @render

      @el.liveEdit ".name",
        change: (element, value) =>
          cid = element.parent().data("cid")

          @collection.getByCid(cid).set name: value

      @$("ul").sortable
        axis: "y"
        distance: 10
        update: =>
          @reindex()

      @options.settings.bind "change:activeLayer", (settings) =>
        if layer = settings.get("activeLayer")
          @$("[data-cid=#{layer.cid}]").takeClass "active"

      # Cache for views so they won't constantly be recreated
      @_layerViews = {}

      @render()

    reindex: ->
      @$("ul li").each (i, li) =>
        cid = $(li).data("cid")
        debugger unless cid?
        @collection.getByCid(cid).set zIndex: i

        for name, view of @_layerViews
          view.delegateEvents()

    render: =>
      @$('ul').empty()

      @collection.each (layer) =>
        @appendLayer layer

    addLayer: =>
      newIndex = @collection.length + 1

      layer = new Models.Layer
        name: "Layer #{newIndex}"
        zIndex: newIndex

      @collection.add layer

    removeLayer: (e) =>
      if confirm 'Clicking OK will delete the layer and all entities on it'
        layerElement = @$('.layer.active')

        cid = layerElement.data("cid")

        layer = @collection.getByCid(cid)

        layer.objectInstances.reset()

        layer.destroy()

        # set a new active layer
        newActive = @collection.at(0)

        @options.settings.set
          activeLayer: newActive

        @reindex()

    appendLayer: (layer) =>
      unless layerView = @_layerViews[layer.cid]
        layerView = @_layerViews[layer.cid] = new Views.Layer
          model: layer
          settings: @options.settings

      @$('ul').append layerView.render().el

      @options.settings.set
        activeLayer: layer

    events:
      'click .add': 'addLayer'
      'click .remove': 'removeLayer'
