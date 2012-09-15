namespace "Pixie.Editor.Tile.Models", (Models) ->
  LAYER_COLORS = [
    "#EB070E"
    "#F69508"
    "#FFDE49"
    "#388326"
    "#0246E3"
    "#563495"
    "#58C4F5"
    "#E5AC99"
    "#5B4635"
    "#FFFEE9"
    "#000000"
    "#FFFFFF"
    "#666666"
    "#DCDCDC"
  ]

  class Models.Layer extends Backbone.Model
    defaults:
      name: "Layer"
      visible: true
      zIndex: 0
      color: LAYER_COLORS[0]

    initialize: ->
      @instanceCache = {}
      @objectInstances = new Models.InstanceList

      @set
        color: LAYER_COLORS.wrap(@get 'zIndex')

    addObjectInstance: (instance) ->
      @objectInstances.add instance

      key = "#{instance.get 'x'}x#{instance.get 'y'}"
      @instanceCache[key] = instance

    instanceAt: (x, y) ->
      key = "#{x}x#{y}"

      return @instanceCache[key]

    removeObjectInstance: (instance) ->
      key = "#{instance.get 'x'}x#{instance.get 'y'}"

      if instance == @instanceCache[key]
        delete @instanceCache[key]

      @objectInstances.remove instance

    toJSON: ->
      name: @get "name"
      instances: @objectInstances.toJSON()
