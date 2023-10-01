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

Game.tempo = false
Game.fastTempo = false

Game.fading = {0,0,0,0}
Game.fading.sens = 1
Game.fading.speed = 2
Game.fading.noir=false
Game.fading.blanc=false
Game.fading.timer = {current=0, delai=15, speed=60}

Game.score = 0
Game.playerLife = 3

function Game.setWorldScene(pWorld, Saison, FadeInOut, pEnterOut)
  Game.tempo = true
  Game.levels.house.status = pEnterOut or "enter"
  --
  Game.WorldLast = Game.WorldCurrent or HouseWorld
  Game.WorldCurrent = pWorld
  --
  Game.levels.nextLevel = Saison
  --
  Game.fading.reset(FadeInOut)
  --
  Game.switchLevelFading = function(dt)
    if Game.levels.currentLevel ~= Game.levels.nextLevel then
      Game.levels.currentLevel = Game.levels.nextLevel
      if pWorld == SandBox then
        SandBox.setLevel(Game.levels.nextLevel)
      end
    end
  end
end
--

function Game.fading.express()
  Game.fading.reset(false, 180)
  Game.fastTempo = true
end
--

function Game.fading.reset(FadeInOut, pSpeed)

  Game.fading.timer.current = 0

  Game.fading.timer.speed = pSpeed or 60

  if pSpeed then
    Game.fading.speed = 4
  else
    Game.fading.speed = 2
  end

  if not FadeInOut then
    Game.fading.color = {0,0,0,0}
    Game.fading.sens = 1
    Game.fading.noir=false
    Game.fading.blanc=false
  else
    Game.fading.color = {0,0,0,1}
    Game.fading.sens = -1
    Game.fading.noir=true
    Game.fading.blanc=false
  end

end
--

function Game.fading.timer.update(dt)
  local t = Game.fading.timer
  --
  t.current = t.current + (t.speed * dt)
  if t.current >= t.delai then
    return true
  end
  return false
end
--

function Game.fading.alphaUpdate(dt)
  -- alpha fading :
  Game.fading.color[4] = Game.fading.color[4] + (Game.fading.speed * Game.fading.sens * dt)
  if Game.fading.color[4] < 0 then Game.fading.color[4] = 0 end
  if Game.fading.color[4] > 1 then Game.fading.color[4] = 1 end
end
--

function Game.fading.update(dt)
  --[[
      start to : 
      Game.fading = {0,0,0,0}
      Game.fadeSens = 1
      ]]--

  if not Game.fading.noir then
    Game.fading.alphaUpdate(dt)
    if Game.fading.color[4] == 1 then
      Game.fading.noir = true
      Game.fading.sens = -Game.fading.sens
    end
  end

  if Game.fading.noir then

    if Game.tempo then
      Game.switchLevelFading()
    end

    if Game.fading.timer.update(dt) then
      Game.fading.alphaUpdate(dt)

      if not Game.fading.blanc then
        if Game.fading.color[4] == 0 then
          Game.fading.blanc = true
        end
      end

      if Game.fading.blanc and Game.fading.noir then
        Game.tempo = false
        Game.fastTempo = false
      end

    end
  end

end
--

function Game.fading.draw()
  if Game.fading.noir or Game.fastTempo then
    Game.WorldCurrent.draw()
  elseif Game.tempo then
    Game.WorldLast.draw()
  end

  love.graphics.setColor(Game.fading.color)
  love.graphics.rectangle("fill", 0, 0, Screen.w, Screen.h)
  love.graphics.setColor(1,1,1,1)  
end
--

function Game.load()
  Game.tempo = false
  Game.fastTempo = false
  Game.score = 0
  Game.playerLife = 3
  Game.switchLevelFading = function() end
  --
  HouseWorld.load()
  SandBox.load()
  --
  Game.setWorldScene(HouseWorld, "winter", "SkipBlack")
end
--

function Game.update(dt)
  if Game.tempo then
    Game.fading.update(dt)
  else
    if Game.fastTempo then
      Game.fading.update(dt)
    end
    Game.WorldCurrent.update(dt)
  end
end
--

function Game.draw()

  if Game.tempo then
    Game.fading.draw()
  else
    Game.WorldCurrent.draw()
    if Game.fastTempo then
      Game.fading.draw()
    end
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