local Game = {debug=false}
Game.levels = {
  currentLevel = "winter",
  nextLevel = "winter",

  house = {
    status = "enter",
    mission = {
      winter={enter="Enter in the Pot".."\n".."Clean up this please...", out="Great Job !"},
      spring={enter="Plant Seed in the pot", out="Great Job !"},
      summer={enter="The pot need Water", out="Great Job !"},
      autumn={enter="Harvest the flowers", out="Great Job ! You have Finish All Levels !"},
    },
  },

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
--

ENUM_DIRECTION = {
  TOP = 1,
  RIGHT = 2,
  BOTTOM = 3,
  LEFT = 4
}
--

Game.WorldCurrent = nil
Game.WorldLast = nil

Game.fading = {0,0,0,0}
Game.fadeSens = 1

function Game.setWorldScene(pWorld, Saison, pEnterOut)
  Game.tempo = true
  Game.levels.house.status = pEnterOut or "enter"
  --
  Game.WorldLast = Game.WorldCurrent or HouseWorld
  Game.levels.nextLevel = Saison
  --
  if Game.levels.house.status == "enter" then 
    Game.fading = {0,0,0,0}
  else
    Game.fading = {0,0,0,0}
  end
  --
  Game.action = function(dt)
    Game.WorldCurrent = pWorld
    Game.tempo = false
    Game.levels.currentLevel = Game.levels.nextLevel
    if pWorld == SandBox then
      SandBox.setLevel(Saison)
    end
  end
end
--

function Game.fadingDraw(x,y)
  love.graphics.setColor(Game.fading)
  love.graphics.rectangle("fill", 0, 0, Screen.w, Screen.h)
  love.graphics.setColor(1,1,1,1)    
end
--

function Game.load()
  Game.tempo = false
  Game.action = function() end
  Game.animTimer = {
    current=0,
    delai=50,
    speed=60,
    update=function(self,dt)
      self.current = self.current + (self.speed * dt)
      if self.current >= self.delai and Game.fading[4] == 1 then
        self.current = 0
        Game.action()
      end

    end
  }
  --
  HouseWorld.load()
  SandBox.load()
  --
  Game.setWorldScene(HouseWorld, "winter")
end
--

function Game.update(dt)
  if Game.tempo then

    Game.animTimer:update(dt)

    -- alpha fading :
    Game.fading[4] = Game.fading[4] + (2 * Game.fadeSens * dt)
    if Game.fading[4] < 0 then Game.fading[4] = 0 end
    if Game.fading[4] > 1 then Game.fading[4] = 1 end

  else
    Game.WorldCurrent.update(dt)
  end
end
--

function Game.draw()

  if Game.tempo then
    Game.WorldLast.draw()
    Game.fadingDraw()
  else
    Game.WorldCurrent.draw()
  end

  --

  if Game.debug then
    love.graphics.print("Scene Game",10,10)
  end

end
--

function Game.keypressed(k)
  if not Game.tempo then
    Game.WorldCurrent.keypressed(k)
  end
end
--

function Game.mousepressed(x,y,button)
end
--

return Game