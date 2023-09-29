local SandBox = {
  levels = {
    winter = {
      mission = "Collect the mushrooms and place them in the three flower pots.",
      map_name = "winter_map"
    },
    spring = {
      mission = "Collect the seeds and plant them in the three flower pots.",
      map_name = "spring_map",
    },
    summer = {
      mission = "Collect the water droplets and water the three flower pots.",
      map_name = "summer_map",
    },
    autumn = {
      mission = "Harvest the flowers from the three flower pots.",
      map_name = "autumn_map"
    }
  }
  
  
}

ENUM_DIRECTION = {
  TOP = 1,
  RIGHT = 2,
  BOTTOM = 3,
  LEFT = 4
}

MobMushroom = require("../Entity/MobMushroom")
MobBee = require("../Entity/MobBee")
Player = require("../Entity/Player")



MapManager = Core.MapManager.newMapManager()


local Gui = require('../Game/Gui')

function SandBox.load()
  local maptiled = Core.TiledManager.importMapTiled(SandBox.levels.winter.map_name)
  MapManager:addNewMapTiled(maptiled)
  MapManager:setMap(maptiled)

  Gui.load(SandBox.levels.winter)
  Player.load()

end
--

function SandBox.update(dt) 
  MapManager.current:update(dt)
  MapManager.current.world:update(dt)
  Gui.update(dt)
  --
  Player.update(dt)
end
--


function SandBox.draw()
  MapManager.current.draw()
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
--

return SandBox