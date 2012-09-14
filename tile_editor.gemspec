# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tile_editor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Daniel X. Moore"]
  gem.email         = ["yahivin@gmail.com"]
  gem.description   = %q{Some kind of tile editor}
  gem.summary       = %q{Some kind of tile editor}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tile_editor"
  gem.require_paths = ["lib"]
  gem.version       = TileEditor::VERSION
end
