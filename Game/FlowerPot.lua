local FlowerPot = {debug=false}

local lstFlowerPots = {}

local Happy = love.graphics.newImage("Assets/Game/FlowerPot_Happy.png")
local NoHappy = love.graphics.newImage("Assets/Game/FlowerPot_NoHappy.png")
local imgW, imgH = Happy:getDimensions()
local imgOx, imgOy = imgW/2, imgH/2


function FlowerPot.newGround(x)
  local y = Screen.h-imgOy
  --
  local new = {x=x, y=y, ox=imgOx, oy=imgOy, w=imgW, h=imgH}
  new.body = love.physics.newBody(Game.World, x, y, "static")
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
  lstFlowerPots = {}

  -- pot n°1
  FlowerPot.newGround(550)
end
--

function FlowerPot.update(dt)
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
  end
end
--

return FlowerPot