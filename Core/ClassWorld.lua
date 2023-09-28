local World = { meter=32, canBodySleep=true}
World.__index = World
love.physics.setMeter(World.meter) -- la hauteur d'un mètre est de 32 pixels dans ce monde

local listWorlds = {}
local eventsList = {}

function World.new()
  local new = love.physics.newWorld(0, 9.81*World.meter, World.canBodySleep)
  new:setCallbacks(World.beginContact)
  --
  table.insert(listWorlds, new)
  --
  return new
end
--

function World:update(dt) -- met à jour le monde physique
  --MapManager.current.world:update(dt)
  for n=1, #listWorlds do
    local world = listWorlds[n]
    world:update(dt)
  end
end
--

function World:beginContact(_fixture, Contact)
  -- Vous pouvez gérer ce qui se passe lorsqu'il y a contact ici
  local fixture_a, fixture_b = Contact:getFixtures()
  local map = MapManager.current
  local player = false
  local other = nil
  local event = nil

  -- Event witch Player
  if fixture_a:getUserData() ~= nil and fixture_a:getUserData().name == "player" then
    player = fixture_a
    other = fixture_b
  elseif fixture_b:getUserData() ~= nil and  fixture_b:getUserData().name == "player" then
    player = fixture_b
    other = fixture_a
  end

  if player then
    -- On récupère "l'instance" du joueur
    local iPlayer = player:getUserData()

    if other:getUserData() ~= nil and other:getUserData().name == "ground" then
     
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

      --## GROUND ##
      local nx, ny = Contact:getNormal()
      if ny == -1 then
        iPlayer.isOnGround = true
      end
    end

    if other:getUserData() ~= nil and other:getUserData().name == "coin" then
      iPlayer.score = iPlayer.score + other:getUserData().scorePoints
      other:getUserData().visible = false
      other:getBody():destroy()
    end

    if other:getUserData() ~= nil and other:getUserData().name == "mushroom" then
      iPlayer.score = iPlayer.score + other:getUserData().scorePoints
      table.insert(iPlayer.inventory,other:getUserData())
      other:getUserData().visible = false
      other:getBody():destroy()
    end 

    if other:getUserData() ~= nil and other:getUserData().name == "droplet" then
      iPlayer.score = iPlayer.score + other:getUserData().scorePoints
      table.insert(iPlayer.inventory,other:getUserData())
      other:getUserData().visible = false
      other:getBody():destroy()
    end 

    if other:getUserData() ~= nil and other:getUserData().name == "pot" then
      if not other:getUserData().isDone then
        local dep = other:getUserData().dependency

        for i=#iPlayer.inventory, 1, -1 do
          local inv = iPlayer.inventory[i]
          if inv.id == dep.id then
            other:getUserData().isDone = true
            table.remove(iPlayer.inventory, i)
            break
          end
        end
      end

    end


    if other:getUserData() ~= nil and other:getUserData().type == "mob" then
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

end
--





return World