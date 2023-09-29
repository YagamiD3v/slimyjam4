local Player = {debug=false}

function Player.reload()
  Player.isOnGround = true
  Player.maxSpeed = 100
  Player.x =  30
  Player.y = 550
  Player.w, Player.h = 26, 26
  Player.vy = 0
  Player.vx = 0
  Player.inventory = {}
end
--

function Player.beginContact(_fixture, Contact, player, other, map)
  local event = nil

  -- On récupère "l'instance" du joueur
  local iPlayer = player:getUserData()

  if other:getUserData() ~= nil then
    if other:getUserData().name == "ground" then
      --[[
        -- Récupère la position du "ground"
        local os_x1, os_y1, os_x2, os_y2 = other:getShape():computeAABB(
          other:getBody():getX(), 
          other:getBody():getY(),
          other:getBody():getAngle()
        )
        os_x1, os_y1, os_x2, os_y2 = applyFunc(math.ceil, os_x1, os_y1, os_x2, os_y2)
        --print( other:getUserData().id .. " position : " ..os_x1 .. "," .. os_y1)

        -- Récupère la position du player
        local p_x1, py_1, p_x2, p_y2 = player:getShape():computeAABB(
          player:getBody():getX(),
          player:getBody():getY(),
          player:getBody():getAngle()
        )
        p_x1, py_1, p_x2, p_y2 = applyFunc(math.ceil, p_x1, py_1, p_x2, p_y2)
        --print( player:getUserData().id .. " position : " .. p_x1 .. "," .. py_1 .. " w:" .. p_x2 .. " h:" .. p_y2) 


        -- Récupère les points de contacts
        local x1, y1, x2, y2 = Contact:getPositions()
        x1, y1, x2, y2 = applyFunc(math.ceil, x1, y1, x2, y2)
        --print("player touche ground (" .. tostring(x1) .. "," .. tostring(y1) .. ") (" ..tostring(x2) .. "," ..tostring(y2) .. ")")
        --print("Friction: " ..tostring(Contact:getFriction()))
      ]]
      --## GROUND ##
      local nx, ny = Contact:getNormal()
      if ny == -1 then
        iPlayer.isOnGround = true
      end
    end

    if other:getUserData().name == "coin" then
      iPlayer.score = iPlayer.score + other:getUserData().scorePoints
      other:getUserData().visible = false
      other:getBody():destroy()
    end

    if other:getUserData().name == "mushroom" or other:getUserData().name == "droplet" or other:getUserData().name == "seed" then
      iPlayer.score = iPlayer.score + other:getUserData().scorePoints
      table.insert(iPlayer.inventory,other:getUserData())
      other:getUserData().visible = false
      other:getBody():destroy()
    end 


    if other:getUserData().name == "pot" then
      local o = other:getUserData()
      if not o.isDone then
        if o.dependency ~= nil then -- le pot attend un item
          local dep = o.dependency
          for i=#iPlayer.inventory, 1, -1 do
            local inv = iPlayer.inventory[i]
            if inv.id == dep.id then
              o.isDone = true
              table.remove(iPlayer.inventory, i)
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
    end


    if other:getUserData().type == "mob" then
      local nx, ny = Contact:getNormal()
      if ny == -1 then
        iPlayer.body:setLinearVelocity( 0, -100 )
        iPlayer.score = iPlayer.score + other:getUserData().scorePoints
        -- Le joueur a touché l'ennemi par le haut
        for i=#map.listMobs, 1, -1 do
          local m = map.listMobs[i]
          if m.id == other:getUserData().id then
            table.remove(map.listMobs, i) 
            other:getUserData().visible = false
            other:getBody():destroy()
            break
          end
        end
      else 
        print("Le joueur est touché !")
      end

    end
  end



  for n=1, #map.listEvents do
    local lookMe = map.listEvents[n]
    if other == lookMe.fixture then
      event = lookMe
    end
  end
  --
  if event then
    if event.properties.isTeleport then
      table.insert(eventsList, function() Game:setMap(event.properties.toMap, event.properties.toSpawn) end )
    end
  end
end
--

function Player.findItemId(idItem, listItem)
  for _, item in ipairs(listItem) do
    if item.id == idItem then return item end
  end
end
--

function Player.load()
  Player.score = 0 
  Player.name = "player"
  --

  Player.reload()
  --

  -- force, gravity, positions x/y, etc :
  Player.body = love.physics.newBody(MapManager.current.world, Player.x, Player.y, "dynamic")

  -- mass defaut = 4
  Player.body:setFixedRotation(true)
  --Player.body:setInertia(math.huge) -- Empêche la rotation du joueur

  -- la forme de l objet et les collisions qui en decoulent :
  Player.shape = love.physics.newRectangleShape( Player.w, Player.h )

  -- on indique au monde de l'object quel body est attaché avec quelle fixture(s) :
  Player.fixture = love.physics.newFixture(Player.body, Player.shape, 0.14)
  --Player.fixture:setCategory(ENUM_CATEGORY.PLAYER)
  --Player.fixture:setCategory(ENUM_CATEGORY.MOB)
  Player.fixture:setFriction(.2) -- 0 verglas, 1 concrete (a cumuler avec la friction du sol)
  Player.fixture:setUserData(Player)
end
--

function Player.update(dt)
  Player.body:setAngle(0)

  Player.vx, Player.vy = Player.body:getLinearVelocity()

  -- move
  if love.keyboard.isDown("left") then
    if Player.vx > -Player.maxSpeed then
      Player.body:applyForce( -35, 0 )
    end
  elseif love.keyboard.isDown("right") then
    if Player.vx < Player.maxSpeed then
      Player.body:applyForce( 35, 0 )
    end
  end

  -- Si la touche de déplacement n'est pas enfoncée, arrêtez le deplacement
  if not (love.keyboard.isDown("right") or love.keyboard.isDown("left")) then
    local x, y = Player.body:getLinearVelocity()
    Player.body:setLinearVelocity(x/1.01, y)
  end
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
  end
  -- les 4 points du rectangle
  local points = {Player.shape:getPoints()}
  for n=1, #points, 2 do
    points[n], points[n+1] = Player.body:getWorldPoint( points[n], points[n+1] )
  end
  love.graphics.polygon("fill", points)
end
--

function Player.keypressed(k)
  if k == "up" and Player.isOnGround then
    Player.body:applyLinearImpulse( 0, -15 )
    Player.isOnGround = false
  end
end
--

return Player