-- little debug for quit game with esacpe press
local debug = false
-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
  require("lldebugger").start()
end
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")


-- settings
love.graphics.setDefaultFilter( 'nearest', 'nearest' )

-- requires Core modules
require("Core/loader")

-- Many Globals Scenes used (Intro/Menu/Game/etc.) :
Game = require("Game/Game")
SandBox = require("SandBox/SandBox")
Menu = require("Menu/Menu")

function love.load()
  Core.Scene.newScene(Game, "Game")
  Core.Scene.newScene(SandBox, "SandBox")
  Core.Scene.newScene(Menu, "Menu")
--  Core.Scene.setScene(Menu)
  Core.Scene.setScene(Game)
  --
  Core.Scene.loadScene()
end
--

function love.update(dt)
  Core.Scene.update(dt)
end
--

function love.draw()
  Core.Scene.draw()
end
--

function love.keypressed(key)
  Core.Scene.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
--

function love.mousepressed(x,y,button)
  Core.Scene.mousepressed(x,y,button)
end