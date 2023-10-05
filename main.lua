-- little debug for quit game with esacpe press
local debug = false
-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
  require("lldebugger").start()
end
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local canvas


-- settings
love.graphics.setDefaultFilter( 'nearest', 'nearest' )
love.audio.setVolume(0.5)

-- requires Core modules
require("Core/loader")

-- Many Globals Scenes used (Intro/Menu/Game/etc.) :
Menu = require("Menu/Menu")
EndGame = require("EndGame/EndGame")
GameOver = require("GameOver/GameOver")
Game = require("Game/Game")
SandBox = require("SandBox/SandBox")
HouseWorld = require("HouseWorld/HouseWorld")

function love.load()
  Core.Scene.newScene(Game, "Game")
  Core.Scene.newScene(SandBox, "SandBox")
  Core.Scene.newScene(HouseWorld, "HouseWorld")
  Core.Scene.newScene(Menu, "Menu")
  Core.Scene.newScene(EndGame, "EndGame")
  Core.Scene.newScene(GameOver, "GameOver")
  --
  Core.Scene.setScene(Menu)
  --
  Core.Scene.loadScene()
  --
  canvas = love.graphics.newCanvas(Screen.w, Screen.h)
  --
--  love.window.setFullscreen(true)
  love.window.maximize()

  love.mouse.setVisible(false)
end
--

function love.update(dt)
  Screen.update(dt)
  --
  Core.Scene.update(dt)
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0, 0, 0, 0)
  love.graphics.setBlendMode("alpha")
  Core.Scene.draw()
  love.graphics.setCanvas()
end
--

function love.draw()
  love.graphics.draw(canvas,  Screen.offsetX / 2,  Screen.offsetY / 2, 0, Screen.sx, Screen.sy)
end
--

function love.keypressed(key)
  Core.Scene.keypressed(key)
end
--

function love.mousepressed(x,y,button)
  Core.Scene.mousepressed(x,y,button)
end
--

function love.gamepadpressed( joystick, button )
  Core.Scene.gamepadpressed( joystick, button )
end
--


function love.gamepadreleased( joystick, button )
  Core.Scene.gamepadreleased( joystick, button )
end
--