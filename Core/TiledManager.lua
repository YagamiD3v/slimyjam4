local TiledManager = {debug=true, db_layer=false}

local TileSheet = {}

function TiledManager.newMap(pfile)
  local map = {name=pfile}

  map.debugEvent = false

  map.listDropItems = {}

  map.listEvents = {}

  function map:update(dt)
  end

  function map.draw(pLayer)
    local lockz = false or pLayer
    for z=1, map.layers do
      if map[z].type == "tilelayer" then
        for l=1, map.ligs do
          for c=1, map.cols do
            local cell = map[lockz or z][l][c]
            if cell.id ~= 0 then
              if map.TileSheet[cell.id] == nil then
              end
              love.graphics.draw(map.TileSheet[cell.id].imgdata, map.TileSheet[cell.id].quad, cell.x, cell.y)
            end
          end
        end
      end
      -- Debug :
      if lockz then
        love.graphics.print(map[lockz].name, 10, 10)
      elseif TiledManager.debug then
        love.graphics.print("All Layers", 10, 10)
      end
      --
      if map.debugEvent then
        for n=1, #map.listEvents do
          local event = map.listEvents[n]
          love.graphics.setColor(1,0,0,0.05)
          if event.shapetype == "polygon" then
            love.graphics.polygon("line", event.polygon_points)
          else
            love.graphics.rectangle("line", event.x, event.y, event.width, event.height)
          end
          love.graphics.setColor(1,0,1,1)
          love.graphics.print(event.name, event.x, event.y)
        end
        love.graphics.setColor(1,1,1,1)
      end
      
    end
    --
    if TiledManager.debug then
      TiledManager.draw(map)
    end
  end
  
  return map
end
--

function TiledManager.importMapTiled(pfile)
  local mload = require("Assets/Tiled/"..pfile)
  local map = TiledManager.newMap(pfile)
  --
  map.world = Core.ClassWorld.new()
  --
  map.x=0
  map.y=0
  map.ligs = mload.height
  map.cols = mload.width
  map.cellW = mload.tilewidth
  map.cellH = mload.tileheight
  --
  map.w = map.cols * map.cellW
  map.h = map.ligs * map.cellH
  --
  function map.getDimensions()
    map.w = map.cols * map.cellW
    map.h = map.ligs * map.cellH
    return map.w, map.h
  end
  --


  -- Ajoute les SpriteSheet a la Map
  map.TileSheet = {}
  map.shapesTypes = {}

  for n=1, #mload.tilesets do
    local tileset = mload.tilesets[n]
    if tileset.properties.isCollider then
      for n=1, tileset.tilecount do
        local tileColliderID = tileset.firstgid+(n-1)
        table.insert( map.shapesTypes, tileColliderID)
      end
    end
    if  tileset.image then
      local file = "Assets/Tiled/"..tileset.image
      local sheet = Core.ImageManager.newImageSheet( file, 16, 16)
      for n=1, #sheet do
        table.insert(map.TileSheet, sheet[n])
      end
    end
  end

  -- Trie les layers entre layer/collisions/objects :
  local layers = {}
  map.colliderLayers = {}
  map.objects = {}
  for z=1, #mload.layers do
    local layer = mload.layers[z]
    if layer.type == "tilelayer" then
      if layer.properties.isCollider then
        table.insert(map.colliderLayers, layer)
      else
        table.insert(layers, layer)
      end
    elseif layer.type == "objectgroup" then
      for n=1, #layer.objects do
        local obj = layer.objects[n]
        obj.layerName = layer.name
        table.insert(map.objects, obj)
      end
    else
    end
  end
  map.layers = #layers


  -- Converti la Map en Tableau 2D sur different layers
  local x,y,w,h,ox,oy,cellID
  x=0
  y=0
  w=map.cellW
  h=map.cellH
  ox = w /2
  oy = h /2
  cellID=1
  for z=1, map.layers do
    map[z] = {name=layers[z].name, type=layers[z].type}
    if map[z].type == "tilelayer" then
      for l=1, map.ligs do
        map[z][l] = {}
        for c=1, map.cols do
          map[z][l][c] = {x=x, y=y ,w=w, h=h, ox=ox, oy=oy, id=layers[z].data[cellID]}
          --
          cellID = cellID + 1
          x=x+w
        end
        x=0
        y=y+h
      end
    end
    cellID = 1
    x=0
    y=0
  end
  --

  -- Creer les entités physics de collisions dans le World de la Map :
  TiledManager.loadMapColliders(map)

  -- Creer les Zones d'évents :
  TiledManager.loadMapEvents(map)


  -- return la Map
  return map
end
--

function TiledManager.loadMapColliders(map)
  map.listColliders = {}
  map.collidersMap = {}
  --
  local x,y,w,h,ox,oy,cellID
  x=0
  y=0
  w=map.cellW
  h=map.cellH
  ox=w/2
  oy=h/2
  cellID=1
  for z=1, #map.colliderLayers do
    map.collidersMap[z] = {}
    for l=1, map.ligs do
      map.collidersMap[z][l]={}
      for c=1, map.cols do
        local id = map.colliderLayers[z].data[cellID]
        map.collidersMap[z][l][c] = {x=x, y=y ,w=w, h=h, id=id, isCollider=false}
        local cell = map.collidersMap[z][l][c]
        --
        if id >= map.shapesTypes[1] and id <= map.shapesTypes[#map.shapesTypes] then -- 8305
          cell.isCollider = true
          local block = {x=x, y=y ,w=w, h=h, ox=ox, oy=oy, id=id, isCollider=true}
          block.body = love.physics.newBody(map.world, x+ox, y+oy, "static") -- x,y is center of Forme
          --
          local posx, posy = 0, 0
          --
          if id == map.shapesTypes[1] then -- rectangle
            block.shape = love.physics.newRectangleShape(w,h)
          elseif id == map.shapesTypes[2] then
            block.shape = love.physics.newPolygonShape( 
              posx-ox, posy-oy,
              posx+ox, posy+oy,
              posx-ox, posy+oy
            )
          elseif id == map.shapesTypes[3] then
            block.shape = love.physics.newPolygonShape(
              posx+ox, posy-oy,
              posx+ox, posy+oy,
              posx-ox, posy+oy
            )
          elseif id == map.shapesTypes[4] then
            block.shape = love.physics.newPolygonShape( 
              posx-ox, posy-oy,
              posx+ox, posy-oy,
              posx-ox, posy+oy
            )
          elseif id == map.shapesTypes[5] then
            block.shape = love.physics.newPolygonShape( 
              posx-ox, posy-oy,
              posx+ox, posy-oy,
              posx+ox, posy+oy
            )
          elseif id == map.shapesTypes[6] then
            block.shape = love.physics.newPolygonShape( 
              posx-ox, posy,
              posx+ox, posy,
              posx+ox, posy+oy,
              posx-ox, posy+oy
            )
          elseif id == map.shapesTypes[7] then
            block.shape = love.physics.newPolygonShape( 
              posx-ox, posy-oy,
              posx+ox, posy-oy,
              posx+ox, posy,
              posx-ox, posy
            )
          elseif id == map.shapesTypes[8] then
            block.shape = love.physics.newPolygonShape( 
              posx-ox, posy,
              posx, posy,
              posx, posy+oy,
              posx-ox, posy+oy
            )
          elseif id == map.shapesTypes[9] then
            block.shape = love.physics.newPolygonShape( 
              posx, posy-oy,
              posx+ox, posy-oy,
              posx+ox, posy,
              posx, posy
            )
          elseif id == map.shapesTypes[10] then
            block.shape = love.physics.newPolygonShape( 
              posx, posy,
              posx+ox, posy,
              posx+ox, posy+oy,
              posx, posy+oy
            )
          elseif id == map.shapesTypes[11] then
            block.shape = love.physics.newPolygonShape( 
              posx-ox, posy-oy,
              posx, posy-oy,
              posx, posy,
              posx-ox, posy
            )
          elseif id == map.shapesTypes[12] then
            block.shape = love.physics.newPolygonShape( 
              posx, posy-oy,
              posx+ox, posy-oy,
              posx+ox, posy+oy,
              posx, posy+oy
            )
          elseif id == map.shapesTypes[13] then
            block.shape = love.physics.newPolygonShape( 
              posx-ox, posy-oy,
              posx, posy-oy,
              posx, posy+oy,
              posx-ox, posy+oy
            )
          else
            block.shape = love.physics.newRectangleShape(2,2)
          end
          block.fixture = love.physics.newFixture(block.body, block.shape)
          table.insert(map.listColliders, block)
        end
        --
        cellID = cellID + 1
        x=x+w
      end
      x=0
      y=y+h
    end
  end
  cellID = 1
  x=0
  y=0
  --


  local function newMapLimit(centerX,centerY,w,h)
    local limit = {x=centerX, y=centerY ,w=w, h=h, ox=w/2, oy=h/2, isCollider=true}
    limit.body = love.physics.newBody(map.world, centerX, centerY, "static") -- x,y is center of Forme
    limit.shape = love.physics.newRectangleShape(w,h)
    limit.fixture = love.physics.newFixture(limit.body, limit.shape)
    --
    table.insert(map.listColliders, limit)
    return limit
  end

  -- contour map colliders Rectangle : x, y, w, h
  local blockLeft   = newMapLimit(map.x,   map.h/2,  1,  map.h)
  local blockRight  = newMapLimit(map.w, map.h/2,  -1,  map.h)

  local blockUp     = newMapLimit(map.w/2,   map.y,     map.w,   1)
  local blockDown   = newMapLimit(map.w/2,   map.h,     map.w,   1)
end
--

function TiledManager.loadMapEvents(map)
  -- kinematic colliders
  -- kinematic bodies do not react to forces and only collide with dynamic bodies.
  -- use fixture:setSensor(true) for disable collisions
  -- for detect enter need CallBack functiosn of World. (look ClassWorld.lua)

  for n=1, #map.objects do
    local event = map.objects[n]
    event.shapetype = event.shape
    event.shape = {}
    event.polygon_points = {}
    if event.shapetype == "polygon" then
      event.isZone=true
      event.list_points = {}
      for n=1, #event.polygon do
        local point = event.polygon[n]
        table.insert(event.list_points, point.x)
        table.insert(event.list_points, point.y)
      end
      event.body = love.physics.newBody(map.world, event.x, event.y, "kinematic") -- x,y is center of Forme
      event.shape = love.physics.newPolygonShape(event.list_points)
      event.fixture = love.physics.newFixture(event.body, event.shape)
    elseif event.shapetype == "polyline" then
      event.isZone=true
      event.width = math.max(event.polyline[1].x + event.polyline[2].x)
      event.height = math.max(event.polyline[1].y + event.polyline[2].y)
      if event.width == 0 then
        event.width = 2
      elseif event.height == 0 then
        event.height = 2
      end
      event.ox = event.width / 2
      event.oy = event.height / 2
      event.body = love.physics.newBody(map.world, event.x+event.ox, event.y+event.oy, "kinematic") -- x,y is center of Forme
      event.shape = love.physics.newRectangleShape(event.width, event.height)
      event.fixture = love.physics.newFixture(event.body, event.shape)
    elseif event.shapetype == "rectangle" then
      event.isZone=true
      event.ox = event.width / 2
      event.oy = event.height / 2
      event.body = love.physics.newBody(map.world, event.x+event.ox, event.y+event.oy, "kinematic") -- x,y is center of Forme
      event.shape = love.physics.newRectangleShape(event.width, event.height)
      event.fixture = love.physics.newFixture(event.body, event.shape)
    elseif event.shapetype == "point" then
      event.isZone=true
      event.ox = 5
      event.oy = 5
      event.body = love.physics.newBody(map.world, event.x, event.y-event.oy, "kinematic") -- x,y is center of Forme
      event.shape = love.physics.newRectangleShape(10, 10)
      event.fixture = love.physics.newFixture(event.body, event.shape)
    else
      event.isEvent=true
      --
      event.body = love.physics.newBody(map.world, event.x, event.y, "kinematic") -- x,y is center of Forme
      event.shape = love.physics.newRectangleShape(2,2)
      event.fixture = love.physics.newFixture(event.body, event.shape)
    end
    --
    event.fixture:setSensor(true)
    --
    table.insert(map.listEvents, event)
  end
end
--

function TiledManager.updateColliders(map, dt)
  for n=1, #map.listColliders do
    local block = map.listColliders[n]
    block.x, block.y = block.body:getPosition()
  end
end
--

function TiledManager.update(map, dt)
  if TiledManager.debug then
    TiledManager.updateColliders(map, dt)
  end
end
--

function TiledManager.draw(map)
  if TiledManager.debug then
    love.graphics.setColor(1,0,0,0.5)
    for n=1, #map.listColliders do
      local block = map.listColliders[n]
      local shapetype = block.shape:getType()
      if shapetype == "circle" then
        local x,y = block.shape:getPoint()
        love.graphics.circle("fill", x, y, block.shape:getRadius())
      elseif shapetype == "polygon" then
        local points = {block.shape:getPoints()}
        for n=1, #points, 2 do
          points[n], points[n+1] = block.body:getWorldPoint( points[n], points[n+1] )
        end
        love.graphics.polygon("fill", points)
      elseif shapetype == "edge" then
      elseif shapetype == "chain" then
      end
    end
    --
    love.graphics.setColor(1,1,1,1)
  end
end
--

function TiledManager.keypressed(key)
end
--

return TiledManager
