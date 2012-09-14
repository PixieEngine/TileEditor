require "tile_editor/version"

module TileEditor
  # Sneaky require for Rails engine environment
  if defined? ::Rails::Engine
    require "editor_base/rails"
  elsif defined? ::Sprockets
    require "editor_base/sprockets"
  end
end
