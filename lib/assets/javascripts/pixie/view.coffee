#TODO Extract to separate lib

###*
A base view for our frontbone framework.
###

namespace "Pixie", (Pixie) ->
  class Pixie.View extends Backbone.View
    initialize: ->
      # Force jQuery Element
      @el = $(@el)

      # Set up HTML if template exists
      if @template?
        # TODO Generalize template base path
        @el.html $(JST["pixie/editor/tile/templates/#{@template}"]())

      # @settings and @editor now backbone special too
      @settings = @options.settings
      @editor = @options.editor

    include: (module) ->
      Object.extend this, module(this, this)
