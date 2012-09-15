
namespace "Pixie.Editor.Tile", (Tile) ->
  Tile.actions =
    undo:
      group: 'undo'
      hotkeys: ["ctrl+z", "meta+z"]
      perform: (editor) ->
        editor.undo()
      primary: true

    redo:
      group: 'undo'
      hotkeys: ["ctrl+y", "meta+y"]
      perform: (editor) ->
        editor.redo()

    stamp:
      hotkeys: "1 p"
      menu: false
      perform: (editor) ->
        editor.settings.set
          activeTool: 'stamp'

    eraser:
      hotkeys: "2 e"
      menu: false
      perform: (editor) ->
        editor.settings.set
          activeTool: 'eraser'

    fill:
      hotkeys: "3 f"
      menu: false
      perform: (editor) ->
        editor.settings.set
          activeTool: 'fill'

    selection:
      hotkeys: "4 m"
      menu: false
      perform: (editor) ->
        editor.settings.set
          activeTool: 'selection'

    pointer:
      hotkeys: "5 v"
      menu: false
      perform: (editor) ->
        editor.settings.set
          activeTool: 'pointer'
