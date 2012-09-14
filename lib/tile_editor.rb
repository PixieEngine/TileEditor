require "tile_editor/version"

module TileEditor
  # Sneaky require for Rails engine environment
  if defined? ::Rails::Engine
    require "tile_editor/rails"
  elsif defined? ::Sprockets
    require "tile_editor/sprockets"
  end
end
