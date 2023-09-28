local NavPlayer = {}

function NavPlayer.reload()
  NavPlayer.x =  350
  NavPlayer.y = 590
  NavPlayer.maxSpeed = 100
  NavPlayer.w, NavPlayer.h = 26*3, 26*3
  NavPlayer.isOnGround = true
  NavPlayer.name = "NavPlayer"
end
--

function NavPlayer.load()
  --

  NavPlayer.reload()
  --

  -- force, gravity, positions x/y, etc :
  NavPlayer.body = love.physics.newBody(Game.World, NavPlayer.x, NavPlayer.y, "dynamic")

  -- mass defaut = 4
  NavPlayer.body:setFixedRotation(true)
  --NavPlayer.body:setInertia(math.huge) -- Empêche la rotation du joueur

  -- la forme de l objet et les collisions qui en decoulent :
  NavPlayer.shape = love.physics.newRectangleShape( NavPlayer.w, NavPlayer.h )

  -- on indique au monde de l'object quel body est attaché avec quelle fixture(s) :
  NavPlayer.fixture = love.physics.newFixture(NavPlayer.body, NavPlayer.shape, 0.01)
  --NavPlayer.fixture:setCategory(ENUM_CATEGORY.PLAYER)
  --NavPlayer.fixture:setCategory(ENUM_CATEGORY.MOB)
  NavPlayer.fixture:setFriction(.2) -- 0 verglas, 1 concrete (a cumuler avec la friction du sol)
  NavPlayer.fixture:setUserData(NavPlayer)
end
--

function NavPlayer.update(dt)
  NavPlayer.body:setAngle(0)

  NavPlayer.vx, NavPlayer.vy = NavPlayer.body:getLinearVelocity()

  -- move
  if love.keyboard.isDown("left") then
    if NavPlayer.vx > -NavPlayer.maxSpeed then
      NavPlayer.body:applyForce( -35, 0 )
    end
  elseif love.keyboard.isDown("right") then
    if NavPlayer.vx < NavPlayer.maxSpeed then
      NavPlayer.body:applyForce( 35, 0 )
    end
  end

  -- Si la touche de déplacement n'est pas enfoncée, arrêtez le deplacement
  if not (love.keyboard.isDown("right") or love.keyboard.isDown("left")) then
    local x, y = NavPlayer.body:getLinearVelocity()
    NavPlayer.body:setLinearVelocity(x/1.01, y)
  end

  NavPlayer.vx, NavPlayer.vy = NavPlayer.body:getLinearVelocity()

  if math.floor(NavPlayer.vy) ~= 0 then
    NavPlayer.isOnGround = false
  else
    NavPlayer.isOnGround = true
  end
end
--

function NavPlayer.draw()
  -- les 4 points du rectangle
  local points = {NavPlayer.shape:getPoints()}
  for n=1, #points, 2 do
    points[n], points[n+1] = NavPlayer.body:getWorldPoint( points[n], points[n+1] )
  end
  love.graphics.polygon("fill", points)
end
--

function NavPlayer.keypressed(k)
  if k == "up" and NavPlayer.isOnGround then
    NavPlayer.body:applyLinearImpulse( 0, -15 )
    NavPlayer.isOnGround = false
  end
end
--

return NavPlayer