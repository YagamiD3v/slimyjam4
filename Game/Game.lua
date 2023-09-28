local Game = {debug=false}

Game.World = Core.ClassWorld.new()

local background = love.graphics.newImage("Assets/Game/background_game.png")

local Dialogue = {show=true, list={}}

NavPlayer = require("../Entity/NavPlayer")
Ground = require("../Game/Ground")
FlowerPot = require("../Game/FlowerPot")

function Game.load()
  NavPlayer.load()
  Ground.load()
  FlowerPot.load()
end
--

function Game.update(dt)
  NavPlayer.update(dt)
  Ground.update(dt)
  FlowerPot.update(dt)
  --
  Game.World:update(dt)
end
--

function Game.draw()

  love.graphics.draw(background)
  --
  Ground.draw()
  FlowerPot.draw()
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