local SandBox = {
  levels = {
    currentLevel = "autumn",
    winter = {
      mission = "Collect the mushrooms and place them in the three flower pots.",
      map_name = "winter_map",
      maptiled=nil
    },
    spring = {
      mission = "Collect the seeds and plant them in the three flower pots.",
      map_name = "spring_map",
      maptiled=nil
    },
    summer = {
      mission = "Collect the water droplets and water the three flower pots.",
      map_name = "summer_map",
      maptiled=nil
    },
    autumn = {
      mission = "Harvest the flowers from the three flower pots.",
      map_name = "autumn_map",
      maptiled=nil
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

function SandBox.newLevel(pLevel)
  local level = SandBox.levels[pLevel]
  level.maptiled = Core.TiledManager.importMapTiled(level.map_name)
  MapManager:addNewMapTiled(level.maptiled)
end
--

function SandBox.loadLevel(pLevel)
  --
  SandBox.levels.currentLevel = pLevel
  local level = SandBox.levels[SandBox.levels.currentLevel]
  MapManager:setMap(level.maptiled)
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
  
  SandBox.loadLevel("autumn")
  SandBox.loadLevel("spring")
  SandBox.loadLevel("summer")
  SandBox.loadLevel("winter")
  SandBox.loadLevel("winter")
  SandBox.loadLevel("winter")
  SandBox.loadLevel("winter")

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