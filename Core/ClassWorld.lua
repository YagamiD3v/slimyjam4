local World = {meter=16}
World.__index = World

love.physics.setMeter(World.meter) -- la hauteur d'un mètre est 16px dans ce monde

local listWorlds = {}

local eventsList = {}

function World.new()
  local new = love.physics.newWorld(0, 0, true) -- pas de gravité dans ce monde
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
  for n=1, #eventsList do
    if eventsList[n] ~= nil then
      eventsList[n]()
    end
    table.remove(eventsList, n)
  end
end
--

function World:beginContact(_fixture, contact)
  -- Vous pouvez gérer ce qui se passe lorsqu'il y a contact ici
  --print("beginContact")
  local fixture_a, fixture_b = contact:getFixtures()
  local map = MapManager.current
  local player = false
  local other = nil
  local event = nil

  -- Event witch Player
  if fixture_a == Player.fixture or fixture_b == Player.fixture then
    if fixture_a == Player.fixture then
      player = fixture_a
      other = fixture_b
    else
      player = fixture_b
      other = fixture_a
    end
  end
  if player then
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

return World