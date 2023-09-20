local World = { meter=32, canBodySleep=true}
World.__index = World
love.physics.setMeter(World.meter) -- la hauteur d'un mètre est 16px dans ce monde

local listWorlds = {}
local eventsList = {}

function World.new()
  local new = love.physics.newWorld(0, 9.81*World.meter, World.canBodySleep)
  new:setCallbacks(World.beginContact, World.endContact)
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
  for n=1, #eventsList do
    if eventsList[n] ~= nil then
      eventsList[n]()
    end
    table.remove(eventsList, n)
  end
end
--

function World:beginContact(_fixture, Contact)
  -- Vous pouvez gérer ce qui se passe lorsqu'il y a contact ici
  --print("beginContact")
  local fixture_a, fixture_b = Contact:getFixtures()
  local map = MapManager.current
  local player = false
  local other = nil
  local event = nil

  --print("SELF : " .. self:getUserData())

  -- Event witch Player
  if fixture_a:getUserData() ~= nil and fixture_a:getUserData().id == "player" then
    player = fixture_a
    other = fixture_b
  elseif fixture_b:getUserData() ~= nil and  fixture_b:getUserData().id == "player" then
    player = fixture_b
    other = fixture_a
  end

  if player then
    -- On récupère "l'instance" du joueur
    local iPlayer = player:getUserData()

    -- Vérifiez si le rectangle touche le sol
    --[[if other:isSensor() then
      iPlayer.isOnGround = true
    end]]

    if other:getUserData() ~= nil and other:getUserData().id == "ground" then

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
      if p_y2 >= os_y1 and p_x1 < os_x2 and p_x2 > os_x1 then -- path fixed double jump
        Player.isOnGround = true
        Player.vy = 0
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

  --other:

end
--

function World:endContact(_fixture, Contact)
  --print("endContact")
  --[[local fixture_a, fixture_b = Contact:getFixtures()
    -- Event witch Player
    if fixture_a:getUserData() ~= nil and fixture_a:getUserData() == "player" then
      player = fixture_a
      other = fixture_b
    elseif fixture_b:getUserData() ~= nil and  fixture_b:getUserData().id == "player" then
      player = fixture_b
      other = fixture_a
    end

    if player then
      -- On récupère "l'instance" du joueur
      local iPlayer = player:getUserData()
  
      -- Vérifiez si le rectangle touche le sol
      if other:isSensor() then
        iPlayer.isOnGround = false
      end
    end
    ]]
end
--

return World