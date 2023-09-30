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
  for n=1, #listWorlds do
    local world = listWorlds[n]
    world:update(dt)
  end
end
--

function World:beginContact(_fixture, Contact)
  -- Vous pouvez gérer ce qui se passe lorsqu'il y a contact ici
  local fixture_a, fixture_b = Contact:getFixtures()
  local map = Core.MapManager.current
  local player = false
  local other = nil

  -- Event witch Player
  if fixture_a:getUserData() ~= nil and fixture_a:getUserData().name == "player" then
    player = fixture_a
    other = fixture_b
  elseif fixture_b:getUserData() ~= nil and  fixture_b:getUserData().name == "player" then
    player = fixture_b
    other = fixture_a
  end

  if player then
    Player.beginContact(_fixture, Contact, player, other, map)
    return true
  end
  --

  local navplayer = false
  -- Event witch Player
  if fixture_a:getUserData() ~= nil and fixture_a:getUserData().name == "NavPlayer" then
    navplayer = fixture_a
    other = fixture_b
  elseif fixture_b:getUserData() ~= nil and  fixture_b:getUserData().name == "NavPlayer" then
    navplayer = fixture_b
    other = fixture_a
  end
  if navplayer then
    NavPlayer.beginContact(_fixture, Contact, navplayer, other)
    return true
  end

end
--





return World