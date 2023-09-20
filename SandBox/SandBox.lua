local SandBox = {}

local maptiled = Core.TiledManager.importMapTiled("sand_box")
MapManager = Core.MapManager.newMapManager()
MapManager:addNewMapTiled(maptiled)
MapManager:setMap(maptiled)

Player = {}
Player.id = "player"
Player.isOnGround = true
Player.maxSpeed = 100
Player.x =  20
Player.y = 550
--Player.w, Player.h = 10, 10
Player.w, Player.h = 30, 30
Player.vy = 0
Player.vx = 0


function SandBox.load()
  -- force, gravity, positions x/y, etc :
  Player.body = love.physics.newBody(MapManager.current.world, Player.x, Player.y, "dynamic")
  -- mass defaut = 4
  --Player.body:setMass(3)
  Player.body:setInertia(math.huge) -- Empêche la rotation du joueur

  -- la forme de l objet et les collisions qui en decoulent :
  Player.shape = love.physics.newRectangleShape( Player.w, Player.h )

  -- on indique au monde de l'object quel body est attaché avec quelle fixture(s) :
--  Player.fixture = love.physics.newFixture(Player.body, Player.shape, 1)
  Player.fixture = love.physics.newFixture(Player.body, Player.shape, 0.1)
  Player.fixture:setFriction(.2) -- 0 verglas, 1 concrete
  Player.fixture:setUserData(Player)


end
--

function SandBox.update(dt) 
  MapManager.current:update(dt)
  MapManager.current.world:update(dt)
  Player.body:setAngle(0)

  Player.vx, Player.vy = Player.body:getLinearVelocity()

  -- move
  if love.keyboard.isDown("left") then
    if Player.vx > -Player.maxSpeed then
      Player.body:applyForce( -30, 0 )
    end
  elseif love.keyboard.isDown("right") then
    if Player.vx < Player.maxSpeed then
      Player.body:applyForce( 30, 0 )
    end
  end

  -- Si la touche de déplacement n'est pas enfoncée, arrêtez le deplacement
  if not (love.keyboard.isDown("right") or love.keyboard.isDown("left")) then
    local x, y = Player.body:getLinearVelocity()
    Player.body:setLinearVelocity(x/1.01, y)
  end



end
--


function SandBox.draw()
  MapManager.current.draw()
  love.graphics.setColor( 1,0,0 )
  love.graphics.print("isOnGround : " .. tostring(Player.isOnGround), 10,10)
  love.graphics.print("Velocity Y : " .. tostring(math.floor(Player.vy)), 10,30)
  love.graphics.setColor( 1,1,1 )
  -- les 4 points du rectangle
  local points = {Player.shape:getPoints()}
  for n=1, #points, 2 do
    points[n], points[n+1] = Player.body:getWorldPoint( points[n], points[n+1] )
  end
  love.graphics.polygon("fill", points)
end
--


function SandBox.keypressed(k)
  if k == "up" and Player.isOnGround then
    Player.body:applyLinearImpulse( 0, -15 )
    Player.isOnGround = false
  end
end
--


function SandBox.mousepressed(x,y,button)
end
--

return SandBox