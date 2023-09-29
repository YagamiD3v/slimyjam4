local SandBox = {}

ENUM_DIRECTION = {
  TOP = 1,
  RIGHT = 2,
  BOTTOM = 3,
  LEFT = 4
}

-- There can be up to 16 fixture categories represented as a number from 1 to 16
ENUM_CATEGORY = {
  PLAYER = 1,
  GROUND = 2,
  MOB = 5,
  TRIGGER = 6,
}

MobMushroom = require("../Entity/MobMushroom")
MobBee = require("../Entity/MobBee")
Player = require("../Entity/Player")

local maptiled = Core.TiledManager.importMapTiled("summer_map")
MapManager = Core.MapManager.newMapManager()
MapManager:addNewMapTiled(maptiled)
MapManager:setMap(maptiled)


function SandBox.load()
  Player.load()
end
--

function SandBox.update(dt) 
  MapManager.current:update(dt)
  MapManager.current.world:update(dt)
  --
  Player.update(dt)
end
--


function SandBox.draw()
  MapManager.current.draw()
  Player.draw()
end
--


function SandBox.keypressed(k)
  Player.keypressed(k)
end
--


function SandBox.mousepressed(x,y,button)
end
--

return SandBox