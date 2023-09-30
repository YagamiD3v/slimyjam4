local HouseWorld = {debug=false}

HouseWorld.World = Core.ClassWorld.new()

local background = love.graphics.newImage("Assets/HouseWorld/background_game.png")

NavPlayer = require("../Entity/NavPlayer")
Ground = require("../HouseWorld/Ground")
FlowerPot = require("../HouseWorld/FlowerPot")
MissionGui = require("../HouseWorld/MissionGui")

function HouseWorld.load()
  NavPlayer.load()
  Ground.load()
  FlowerPot.load()
  --
  MissionGui.load()
end
--

function HouseWorld.update(dt)
  NavPlayer.update(dt)
  Ground.update(dt)
  FlowerPot.update(dt)
  --
  HouseWorld.World:update(dt)
end
--

function HouseWorld.draw()

  love.graphics.draw(background)
  --
  Ground.draw()
  FlowerPot.draw()
  --
  NavPlayer.draw()

  --
  if not Game.tempo then
    MissionGui.draw()
  end

  if HouseWorld.debug then
    love.graphics.print("Scene HouseWorld",10,10)
  end
end
--

function HouseWorld.keypressed(k)
  NavPlayer.keypressed(k)
end
--

function HouseWorld.mousepressed(x,y,button)
end
--

return HouseWorld