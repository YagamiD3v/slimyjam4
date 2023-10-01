local SandBox = {}
--

local Gui = require('../SandBox/Gui')


MobMushroom = require("../Entity/MobMushroom")
MobBee = require("../Entity/MobBee")
Player = require("../Entity/Player")
Pop = require("../Entity/Pop")
Explosion = require("../Entity/Explosion")
Explosion:init()


function SandBox.newLevel(pLevel)
  local level = Game.levels[pLevel]
  level.maptiled = Core.TiledManager.importMapTiled(level.map_name)
  Core.MapManager:addNewMapTiled(level.maptiled)
end
--

function SandBox.setLevel(pLevel)
  --
  print("SandBox.setLevel(pLevel) : "..pLevel)
  --
  Game.levels.currentLevel = pLevel
  local level = Game.levels[Game.levels.currentLevel]
  Core.MapManager:setMap(level.maptiled)
  --
  Gui.load(level)
  --
  Player.load()
end
--

function SandBox.load()
  SandBox.newLevel("autumn")
  SandBox.newLevel("spring")
  SandBox.newLevel("summer")
  SandBox.newLevel("winter")
  
  --
  SandBox.setLevel("winter")

end
--

function SandBox.update(dt) 
  Core.MapManager.current:update(dt)
  Core.MapManager.current.world:update(dt)
  Gui.update(dt)
  --
  Pop:updateAll(dt)
  Explosion:update(dt)
  Player.update(dt)
end
--


function SandBox.draw()
  Core.MapManager.current.draw()
  Explosion:draw()
  Pop:drawAll()
  Player.draw()

  Gui.draw(dt)
end
--


function SandBox.keypressed(k)
  Player.keypressed(k)
end
--

function SandBox.mousepressed(x,y,button)
end

return SandBox