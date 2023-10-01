local NavPlayer = {debug=false}

local decX = 0
local decY = -20

function NavPlayer.reload()
  NavPlayer.x =  350 + decX
  NavPlayer.y = 565 + decY
  NavPlayer.direction={vx=1, vy=1}
  NavPlayer.maxSpeed = 100
  NavPlayer.w, NavPlayer.h = 70, 80
  NavPlayer.isOnGround = true
  NavPlayer.name = "NavPlayer"
end
--

function NavPlayer.beginContact(_fixture, Contact, navplayer, other)
  if other:getUserData().name == "FlowerPot" then
    local nx, ny = Contact:getNormal()
    if ny == 1 then -- par dessus
      if Game.levels.house.status == "enter" then
        --
        Game.setWorldScene(SandBox, Game.levels.currentLevel, false, "enter")
        Core.Sfx.play("PowerUp")
        --
        NavPlayer.Anims:setAnim("Jump")
        NavPlayer.direction.vx = -1
        NavPlayer.y = NavPlayer.y - 1
        NavPlayer.body:setLinearVelocity( 0, 0)
        NavPlayer.body:applyLinearImpulse( -35, -15 )
      end
    end
  elseif other:getUserData().name == "NavGround" then
    NavPlayer.isOnGround = true    
  end
end
--

function NavPlayer.load()
  NavPlayer.Anims = Core.AnimPlayer.getAnims()
  --

  NavPlayer.reload()
  --

  -- force, gravity, positions x/y, etc :
  NavPlayer.body = love.physics.newBody(HouseWorld.World, NavPlayer.x, NavPlayer.y, "dynamic")

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

  NavPlayer.Anims:update(dt)

  NavPlayer.body:setAngle(0)

  NavPlayer.vx, NavPlayer.vy = NavPlayer.body:getLinearVelocity()

  -- move
  if love.keyboard.isDown("left") then
    if NavPlayer.vx > -NavPlayer.maxSpeed then
      NavPlayer.body:applyForce( -35, 0 )
      NavPlayer.direction.vx = -1
    end
  elseif love.keyboard.isDown("right") then
    if NavPlayer.vx < NavPlayer.maxSpeed then
      NavPlayer.body:applyForce( 35, 0 )
      NavPlayer.direction.vx = 1
    end
  end

  -- Si la touche de déplacement n'est pas enfoncée, arrêtez le deplacement
  if not (love.keyboard.isDown("right") or love.keyboard.isDown("left")) then
    local x, y = NavPlayer.body:getLinearVelocity()
    NavPlayer.body:setLinearVelocity(x/1.01, y)
  end

  NavPlayer.vx, NavPlayer.vy = NavPlayer.body:getLinearVelocity()
  NavPlayer.x, NavPlayer.y = NavPlayer.body:getPosition()
  NavPlayer.x = NavPlayer.x + decX
  NavPlayer.y = NavPlayer.y + decY

  if NavPlayer.isOnGround then
    if NavPlayer.Anims.currentAnim == "Jump" then
      NavPlayer.Anims:setAnim("Idle")
    elseif NavPlayer.Anims.currentAnim == "Idle" then
      if math.floor(NavPlayer.vx) ~= 0 then
        NavPlayer.Anims:setAnim("Run")
      end
    elseif NavPlayer.Anims.currentAnim == "Run" then
      if math.floor(NavPlayer.vx) == 0 then
        NavPlayer.Anims:setAnim("Idle")
      end
    end
  end

end
--

function NavPlayer.draw()

  if NavPlayer.debug then
    -- les 4 points du rectangle
    local points = {NavPlayer.shape:getPoints()}
    for n=1, #points, 2 do
      points[n], points[n+1] = NavPlayer.body:getWorldPoint( points[n], points[n+1] )
    end
    love.graphics.polygon("fill", points)
  end

  NavPlayer.Anims:draw(NavPlayer, 4)

end
--

function NavPlayer.keypressed(k)
  if k == "up" and NavPlayer.isOnGround then
    NavPlayer.body:applyLinearImpulse( 0, -15 )
    NavPlayer.isOnGround = false
    NavPlayer.Anims:setAnim("Jump")
  end
  if NavPlayer.debug then
    if k == "down" and NavPlayer.isOnGround then
      NavPlayer.Anims:setAnim("Hurt")
    end
  end
end
--

return NavPlayer