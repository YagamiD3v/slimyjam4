local ClassMap = {current=nil}

ClassMap.__index = ClassMap

local function newManagerMap(self)

  -- ### Functions MapManager ###

  function self:addNewMapTiled(MapTiled)
    if self:findMap(MapTiled) then 
      print("map non ajoute car existante")
      return false
    else
      --
      table.insert(self.listMaps, MapTiled)
      self[MapTiled.name] = self.listMaps[#self.listMaps]
      return true
    end
  end

  function self:findMap(GameMap)
    for n=1, #self.listMaps do
      local map = self.listMaps[n]
      if type(GameMap) == "table" then
        if map == GameMap then
          return map
        end
      elseif type(GameMap) == "string" then
        if map.name == GameMap then
          return map
        end
      end
    end
    return false
  end

  function self:setMap(GameMap)
    local map = self:findMap(GameMap)
    if map then
      self.current = map
      return true
    else
      print("tableMap not found.")
      return false
    end
  end

  function self:getPosition2D(map, x, y)
    local w = map.cellW
    local h = map.cellH
    --
    local col = math.floor(x/w) + 1
    local lig = math.floor(y/h) + 1
    --
    return col, lig
  end

  function self:getStartPoint(pName)
    local map = self.current
    --
    local cible = pName or "StartPoint"
    --
    for n=1,  #map.objects do
      local obj = map.objects[n]
      if obj.properties.isStartPoint then
        return obj.x, obj.y
      end
    end
    -- nothing ?
    return map.cellW, map.cellH
  end

  function self:getTeleportPoint(GameMap, pTeleport)
    --
    local cible = pTeleport or "StartPoint"
    local StartPoint = nil
    --
    for n=1,  #GameMap.objects do
      local obj = GameMap.objects[n]
      if obj.name == cible then
        return obj.x, obj.y
      elseif obj.properties.isStartPoint then
        StartPoint = obj
      end
    end
    --
    if StartPoint then
      return StartPoint.x, StartPoint.y
    end
    -- nothing ?
    return GameMap.cellW, GameMap.cellH
  end

  function self:draw()
    self.current.draw()
  end

end
--

function ClassMap.newMapManager()
  local map = {listMaps={}}
  setmetatable(map, ClassMap)
  --
  newManagerMap(map)
  --
  return map
end
--

return ClassMap