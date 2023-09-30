local Game = {debug=false}
Game.levels = {
  currentLevel = "house",

  house = {
    mission = {
      winter="Clean up the pot",
      spring="Plant Seed in the pot",
      summer="The pot need Water",
      autumn="Harvest the flowers",
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

function Game.setWorldScene(pWorld, Saison)
  Game.WorldCurrent = pWorld
  if Saison ~= nil then
    Game.levels.currentLevel = Saison
    if Saison ~= "house" then
      SandBox.setLevel(Saison)
    end
  end
end
--

function Game.load()
  HouseWorld.load()
  SandBox.load()
  --
  Game.setWorldScene(HouseWorld)
end
--

function Game.update(dt)
  Game.WorldCurrent.update(dt)
end
--

function Game.draw()

  Game.WorldCurrent.draw()

  if Game.debug then
    love.graphics.print("Scene Game",10,10)
  end

end
--

function Game.keypressed(k)
  Game.WorldCurrent.keypressed(k)
end
--

function Game.mousepressed(x,y,button)
end
--

return Game