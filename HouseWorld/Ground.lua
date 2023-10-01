local Ground = {debug=false}

local lstGround = {}

function Ground.newGround(x,y,w,h)
  local new = {}
  new.body = love.physics.newBody(HouseWorld.World, x, y, "static")
  new.shape = love.physics.newRectangleShape( w, h )
  new.fixture = love.physics.newFixture(new.body, new.shape, 0.14)
  new.fixture:setFriction(.2) -- 0 verglas, 1 concrete (a cumuler avec la friction du sol)
  new.fixture:setUserData(new)
  new.name = "NavGround"
  table.insert(lstGround, new)
end
--

function Ground.load()
  lstGround = {}

  -- ground
  Ground.newGround(Screen.cx, Screen.h+8, Screen.w, 16)

  -- walls
  Ground.newGround(Screen.x-8, Screen.cy, 16, Screen.h)
  Ground.newGround(Screen.w+8, Screen.cy, 16, Screen.h)
end
--

function Ground.update(dt)
end
--

function Ground.draw()
  if Ground.debug then
    for n=1, #lstGround do
      local ground = lstGround[n]
      -- les 4 points du rectangle
      local points = {ground.shape:getPoints()}
      for n=1, #points, 2 do
        points[n], points[n+1] = ground.body:getWorldPoint( points[n], points[n+1] )
      end
      love.graphics.polygon("fill", points)
    end
  end
end
--

return Ground