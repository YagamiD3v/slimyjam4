local HouseWorld = {debug=false}

HouseWorld.World = Core.ClassWorld.new()

--local background = love.graphics.newImage("Assets/HouseWorld/background_game.png")
local bg={}
bg.winter = love.graphics.newImage("Assets/HouseWorld/winter.png")
bg.spring = love.graphics.newImage("Assets/HouseWorld/spring.png")
bg.summer = love.graphics.newImage("Assets/HouseWorld/summer.png")
bg.autumn = love.graphics.newImage("Assets/HouseWorld/autumn.png")

NavPlayer = require("../Entity/NavPlayer")
Ground = require("../HouseWorld/Ground")
FlowerPot = require("../HouseWorld/FlowerPot")
MissionGui = require("../HouseWorld/MissionGui")

local switchBox = {}

function HouseWorld.load()
  NavPlayer.load()
  Ground.load()
  FlowerPot.load()
  --
  MissionGui.load()
  --
  switchBox = {x=50, y=Screen.h-NavPlayer.h, w=NavPlayer.w, h=NavPlayer.h}
end
--

function HouseWorld.update(dt)
  NavPlayer.update(dt)
  Ground.update(dt)
  FlowerPot.update(dt)
  if Game.levels.house.status == "out" then
    if CheckCollision(NavPlayer.x,NavPlayer.y,NavPlayer.w,NavPlayer.h, switchBox.x,switchBox.y,switchBox.w,switchBox.h) then
      if Game.lstsaisons[ Game.currentSaison+1 ] then
        Game.setWorldScene(HouseWorld, Game.lstsaisons[ Game.currentSaison+1 ], false, "enter")
        Core.Sfx.play("PowerUp")
      else
        Core.Scene.setScene(EndGame, true)
      end
    end
  end
  --
  HouseWorld.World:update(dt)
end
--

function HouseWorld.draw()

  love.graphics.draw(bg[Game.levels.currentLevel])
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
    --love.graphics.rectangle("line", switchBox.x, switchBox.y, switchBox.w, switchBox.h)
    love.graphics.print("currentLevel : "..Game.levels.currentLevel, 10, 20)
  end
end
--

function HouseWorld.keypressed(k)
  NavPlayer.keypressed(k)
end
--

function HouseWorld.gamepadpressed(joystick, button)
  NavPlayer.gamepadpressed(joystick, button)
end
--

function HouseWorld.mousepressed(x,y,button)
end
--

return HouseWorld