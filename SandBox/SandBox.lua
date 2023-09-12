local SandBox = {}

local maptiled = Core.TiledManager.importMapTiled("sand_box")
MapManager = Core.MapManager.newMapManager()
MapManager:addNewMapTiled(maptiled)
MapManager:setMap(maptiled)

Player = {}

function SandBox.load()
  -- force, gravity, positions x/y, etc :
  Player.body = love.physics.newBody(MapManager.current.world, 400, 300, "dynamic")

  -- la forme de l objet et les collisions qui en decoulent :
  Player.shape = love.physics.newRectangleShape( 32, 32 )

  -- on indique au monde de l'object quel body est attaché avec quelle fixture(s) :
  Player.fixture = love.physics.newFixture(Player.body, Player.shape)

  -- mass defaut = 4
  --Player.body:setMass(50)
  Player.body:setAngle(math.rad(47))
end
--


function SandBox.update(dt)
  MapManager.current:update(dt)
  MapManager.current.world:update(dt)

  -- move
  if love.keyboard.isDown("left") then
    Player.body:applyForce( -600, 0 )
  elseif love.keyboard.isDown("right") then
    Player.body:applyForce( 600, 0 )
  end
  if love.keyboard.isDown("up") then
    Player.body:applyLinearImpulse( 0, -50 )
  elseif love.keyboard.isDown("down") then
    Player.body:applyForce( 0, 50 )
  end
end
--


function SandBox.draw()
  MapManager.current.draw()

  -- les 4 points du rectangle
  local points = {Player.shape:getPoints()}
  for n=1, #points, 2 do
    points[n], points[n+1] = Player.body:getWorldPoint( points[n], points[n+1] )
  end
  love.graphics.polygon("fill", points)
end
--


function SandBox.keypressed(k)
end
--


function SandBox.mousepressed(x,y,button)
end
--

return SandBox