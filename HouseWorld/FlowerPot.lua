local FlowerPot = {debug=false}

local lstFlowerPots = {}

local Happy = love.graphics.newImage("Assets/HouseWorld/FlowerPot_Happy.png")
local NoHappy = love.graphics.newImage("Assets/HouseWorld/FlowerPot_NoHappy.png")
local imgW, imgH = Happy:getDimensions()
local imgOx, imgOy = imgW/2, imgH/2

local font = love.graphics.newFont(28)

local listText = {}

local completed = {}

local nextSaison = {}

local MissionText = {}

local function generateText(pText)
  local text = {}
  text.data = love.graphics.newText(font, pText)
  text.w, text.h = text.data:getDimensions()
  text.ox, text.oy = text.w/2, text.h/2
  text.xDef, text.yDef = 0, 0
  text.x, text.y = 0, 0
  text.radian = 0

  function text.update(dt)
    text.radian = text.radian + 30 * dt % math.rad(360)
    text.y = text.yDef + (math.sin(text.radian) * 2)
    --
    if text == nextSaison then
      if Game.lstsaisons[Game.currentSaison+1] then
        text.data:set("Go to "..Game.lstsaisons[Game.currentSaison+1].."\n".."\n"..">>        <<")
      else
        text.data:set("Congrats Go Here !".."\n".."\n"..">>        <<")
      end
    end
    if text.particules then
      text.particules:update(dt)
    end
    --
  end

  table.insert(listText, text)

  return text
end
--


function FlowerPot.newGround(x)
  local y = Screen.h-imgOy
  --
  local new = {x=x, y=y, ox=imgOx, oy=imgOy, w=imgW, h=imgH}
  new.body = love.physics.newBody(HouseWorld.World, x, y, "static")
  new.shape = love.physics.newRectangleShape( imgW, imgH )
  new.fixture = love.physics.newFixture(new.body, new.shape, 0.14)
  new.fixture:setFriction(.2) -- 0 verglas, 1 concrete (a cumuler avec la friction du sol)
  new.fixture:setUserData(new)
  new.name = "FlowerPot"
  --
  new.image = NoHappy
  --
  table.insert(lstFlowerPots, new)
end
--

function FlowerPot.load()

  completed = generateText("! Succes !")
  nextSaison = generateText("Go to ".."\n".."\n"..">>        <<")
  MissionText = generateText("     Enter To".."\n".."The Flower Pot")

  nextSaison.particules = Core.Particules.new(80, Screen.h)
  MissionText.particules = Core.Particules.new(550, Screen.h-imgH)

  lstFlowerPots = {}

  -- pot n°1
  FlowerPot.newGround(550)
end
--

function FlowerPot.update(dt)
  for _, text in ipairs (listText) do
    text.update(dt)
  end
  --
  for n=1, #lstFlowerPots do
    local pot = lstFlowerPots[n]
    if Game.levels.house.status == "enter" then
      pot.image = NoHappy
    else
      pot.image = Happy
    end
  end
  --
end
--

function FlowerPot.draw()
  for n=1, #lstFlowerPots do
    local pot = lstFlowerPots[n]
    --
    if FlowerPot.debug then
      -- les 4 points du rectangle
      local points = {pot.shape:getPoints()}
      for n=1, #points, 2 do
        points[n], points[n+1] = pot.body:getWorldPoint( points[n], points[n+1] )
      end
      love.graphics.polygon("line", points)
    end
    --
    love.graphics.draw(pot.image, pot.x, pot.y, 0, 1, 1, pot.ox, pot.oy)
    if pot.image == Happy then
      love.graphics.draw(completed.data, pot.x, (pot.y-(pot.h*1.5)) + completed.y, 0, 1, 1, completed.ox, completed.oy)
      love.graphics.draw(nextSaison.data, nextSaison.ox, (Screen.h - NavPlayer.h) + nextSaison.y, 0, 1, 1, nextSaison.ox, nextSaison.oy)
      --
      nextSaison.particules:draw()
    else
      love.graphics.draw(MissionText.data, pot.x, (pot.y-(pot.h*1.5)) + MissionText.y, 0, 1, 1, MissionText.ox, MissionText.oy)
      MissionText.particules:draw()
    end
  end
end
--

return FlowerPot