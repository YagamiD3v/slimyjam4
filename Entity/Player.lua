local Player = {debug=false}

local decX = 0
local decY = -4

function Player.reload()
  Player.isOnGround = true
  Player.maxSpeed = 100
  Player.direction={vx=1, vy=1}
  Player.x =  30
  Player.y = 560
  Player.w, Player.h = 16, 22 -- 26
  Player.vy = 0
  Player.vx = 0

  Player.isDie = false
  Player.respawnDelay = 3
  Player.deathTime = 0

  Player.Anims:setAnim("Idle")

  -- force, gravity, positions x/y, etc :
  if Player.body then
    Player.body:destroy()
  end

  Player.body = love.physics.newBody(Core.MapManager.current.world, Player.x, Player.y, "dynamic")

  -- mass defaut = 4
  Player.body:setMass(4)
  Player.body:setFixedRotation(true)

  -- la forme de l objet et les collisions qui en decoulent :
  Player.shape = love.physics.newRectangleShape( Player.w, Player.h )

  -- on indique au monde de l'object quel body est attaché avec quelle fixture(s) :
  Player.fixture = love.physics.newFixture(Player.body, Player.shape, 0.26)
  Player.fixture:setFriction(.2) -- 0 verglas, 1 concrete (a cumuler avec la friction du sol)
  Player.fixture:setUserData(Player)
end
--

function Player.load()
  Player.score = Game.score
  Player.lives = Game.playerLife
  Player.name = "player"
  Player.inventory = {}
  --

  Player.Anims = Core.AnimPlayer.getAnims()

  Player.reload()
  --
end
--

function Player.lostLife()
  Player.lives = Player.lives - 1
  Player.deathTime = love.timer.getTime()
  Player.isDie = true
  Player.animDie = true
  Player.Anims:setAnim("Hurt")
  Player.body:setLinearVelocity( 0, -200 )
  Player.fixture:destroy()
end
--

function Player.powerUp()
  Player.lives = Player.lives + 1
  Core.Sfx.play("PowerUp")
end

function Player.changeLevelIfAllPotAreDone(listItem)
  for _, item in ipairs(listItem) do
    if item.name == "pot" and not item.isDone then 
      return false 
    end
  end

  -- All pots are done
  Game.setWorldScene(HouseWorld, Game.levels.currentLevel, false, "out")
end

function Player.findItemId(idItem, listItem)
  for _, item in ipairs(listItem) do
    if item.id == idItem then return item end
  end
end
--

function Player.beginContact(_fixture, Contact, player, other, map)
  local event = nil

  if other:getUserData() ~= nil then
    if other:getUserData().name == "ground" then
      --## GROUND ##
      local nx, ny = Contact:getNormal()
      if ny == -1 then
        Player.isOnGround = true
        if Player.Anims.currentAnim == "Jump" then
          Player.Anims:setAnim("Idle")
        end
      end
    end

    if other:getUserData().name == "coin" then
      Player.score = Player.score + other:getUserData().scorePoints
      other:getUserData().visible = false
      other:getBody():destroy()
      Core.Sfx.play("Coin")
      Pop:new(Player.x, Player.y - 30, other:getUserData().scorePoints)
    end

    if other:getUserData().name == "mushroom" or other:getUserData().name == "droplet" or other:getUserData().name == "seed" then
      if other:getUserData().particules then
        other:getUserData().particules = nil
      end
      --
      Player.score = Player.score + other:getUserData().scorePoints
      table.insert(Player.inventory,other:getUserData())
      other:getUserData().visible = false
      other:getBody():destroy()
      Core.Sfx.play("PowerUp")
      Pop:new(Player.x, Player.y - 30, other:getUserData().scorePoints)
    end 

    if other:getUserData().name == "powerup" then
      Player.score = Player.score + other:getUserData().scorePoints
      other:getUserData().visible = false
      other:getBody():destroy()
      Player.powerUp()
      Pop:new(Player.x, Player.y - 30, other:getUserData().scorePoints)
    end


    if other:getUserData().name == "pot" then
      local o = other:getUserData()
      if not o.isDone then
        if o.dependency ~= nil then -- le pot attend un item
          local dep = o.dependency
          for i=#Player.inventory, 1, -1 do
            local inv = Player.inventory[i]
            if inv.id == dep.id then
              o.isDone = true
              Pop:new(Player.x, Player.y - 30, 'Done!', 2)

              Core.Sfx.play("PowerUp")

              if other:getUserData().particules then
                other:getUserData().particules = nil
              end
              table.remove(Player.inventory, i)
              break
            end
          end

          -- On fait pousser avec l'item reçu
          if o.isDone then
            if o.obj0 ~= nil then 
              local obj = Player.findItemId(o.obj0.id, map.listItems)
              if (obj ~= nil) then
                if obj.name == "fertilizer" and obj.isGrowing then
                  obj.isGrowing = false
                else
                  obj.isGrowing = true
                end
              end 
            end
            if o.obj1 ~= nil then 
              local obj = Player.findItemId(o.obj1.id, map.listItems)
              if (obj ~= nil) then obj.isGrowing = not obj.isGrowing end 
            end
            if o.obj2 ~= nil then 
              local obj = Player.findItemId(o.obj2.id, map.listItems)
              if (obj ~= nil) then obj.isGrowing = not obj.isGrowing end  
            end
          end
        end

        if o.canHarvest then -- le pot peut être récolté (automne)
          o.isDone = true

          Core.Sfx.play("PowerUp")


          if other:getUserData().particules then
            other:getUserData().particules = nil
          end

          Pop:new(Player.x, Player.y - 30, 'Done!', 2)
          if o.obj0 ~= nil then
            local obj = Player.findItemId(o.obj0.id, map.listItems)
            if (obj ~= nil) then obj.isGrowing = false end
          end
          if o.obj1 ~= nil then 
            local obj = Player.findItemId(o.obj1.id, map.listItems)
            if (obj ~= nil) then obj.isGrowing = false end
          end
          if o.obj2 ~= nil then
            local obj = Player.findItemId(o.obj2.id, map.listItems)
            if (obj ~= nil) then obj.isGrowing = false end
          end
        end

      end

      Player.changeLevelIfAllPotAreDone(map.listItems)
    end


    if other:getUserData().type == "mob" then
      local nx, ny = Contact:getNormal()
      if ny == -1 then
        Player.body:setLinearVelocity( 0, -150 )
        Player.score = Player.score + other:getUserData().scorePoints
        Pop:new(Player.x, Player.y - 30, other:getUserData().scorePoints )
        -- Le joueur a touché l'ennemi par le haut
        for i=#map.listMobs, 1, -1 do
          local m = map.listMobs[i]
          if m.id == other:getUserData().id then
            table.remove(map.listMobs, i) 
            Explosion:new(other:getUserData().x-8, other:getUserData().y-16)
            other:getUserData().visible = false
            other:getBody():destroy()
            Core.Sfx.play("Hit")
            break
          end
        end
      else 
        Player.lostLife()
      end

    end

    if other:getUserData().name == "water" then
      Player.lostLife()
    end
  end

end
--


function Player.update(dt)
  Game.score = Player.score
  Game.playerLife = Player.lives

  if Player.isDie and love.timer.getTime() - Player.deathTime > Player.respawnDelay then
    if Player.lives == 0 then
      Core.Scene.setScene(Menu)
    else
      Game.fading.express() -- le fading quand le joueur est touché
      Player.reload()
    end
  end


  Player.Anims:update(dt)
  --

  Player.body:setAngle(0)

  Player.vx, Player.vy = Player.body:getLinearVelocity()

  if not Player.isDie then
    -- move
    if love.keyboard.isDown("left") then
      if Player.vx > -Player.maxSpeed then
        Player.body:applyForce( -35, 0 )
        Player.direction.vx = -1
        if Player.Anims.currentAnim ~= "Run" and Player.Anims.currentAnim ~= "Jump"  then
          Player.Anims:setAnim("Run")
        end
      end
    elseif love.keyboard.isDown("right") then
      if Player.vx < Player.maxSpeed then
        Player.body:applyForce( 35, 0 )
        Player.direction.vx = 1
        if Player.Anims.currentAnim ~= "Run" and Player.Anims.currentAnim ~= "Jump" then
          Player.Anims:setAnim("Run")
        end
      end
    else
      if Player.Anims.currentAnim == "Run" then
        Player.Anims:setAnim("Idle")
      end
    end

    -- Si la touche de déplacement n'est pas enfoncée, arrêtez le deplacement
    if not (love.keyboard.isDown("right") or love.keyboard.isDown("left")) then
      local x, y = Player.body:getLinearVelocity()
      Player.body:setLinearVelocity(x/1.01, y)
    end
  end


  Player.x, Player.y = Player.body:getPosition()
  Player.x = Player.x + decX
  Player.y = Player.y + decY


end
--

function Player.draw()

  if Player.debug then
    love.graphics.setColor( 1,0,0 )
    love.graphics.print("isOnGround : " .. tostring(Player.isOnGround), 10,10)
    love.graphics.print("Velocity Y : " .. tostring(math.floor(Player.vy)), 10,30)
    love.graphics.print("Mass (kg) : " .. tostring(Player.body:getMass()), 10,50)
    love.graphics.print("Score : " .. tostring(Player.score), 10,70)
    local inv=''
    for i, entry in ipairs(Player.inventory) do
      inv = inv .. "{id=" .. entry.id .. ", color='" .. tostring(entry.color) .. "'}"
      if i < #Player.inventory then
        inv = inv .. ","
      end
    end
    love.graphics.print("Inventory : " .. inv, 10,90)
    love.graphics.setColor( 1,1,1 )

    -- les 4 points du rectangle
    local points = {Player.shape:getPoints()}
    for n=1, #points, 2 do
      points[n], points[n+1] = Player.body:getWorldPoint( points[n], points[n+1] )
    end

    love.graphics.polygon("fill", points)

  end


  Player.Anims:draw(Player)

end
--

function Player.keypressed(k)
  if k == "up" and Player.isOnGround then
    Player.body:applyLinearImpulse( 0, -15 )
    Player.isOnGround = false
    Player.Anims:setAnim("Jump")
  end
  if Player.debug then
    if k == "delete" then
      Game.setWorldScene(HouseWorld, Game.levels.currentLevel, false, "out")
    end
  end
end
--

return Player