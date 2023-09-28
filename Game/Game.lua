local Game = {debug=false}

Game.World = Core.ClassWorld.new()

local background = love.graphics.newImage("Assets/Game/background_game.png")

local Dialogue = {show=true, list={}}

NavPlayer = require("../Entity/NavPlayer")
Ground = require("../Game/Ground")

function Game.load()
  NavPlayer.load()
  Ground.load()
end
--

function Game.update(dt)
  NavPlayer.update(dt)
  Ground.update(dt)
  --
  Game.World:update(dt)
end
--

function Game.draw()

  love.graphics.draw(background)
  --
  Ground.draw()
  --
  NavPlayer.draw()

  if Game.debug then
    love.graphics.print("Scene Game",10,10)
  end
end
--

function Game.keypressed(k)
  NavPlayer.keypressed(k)
end
--

function Game.mousepressed(x,y,button)
end
--

return Game