local TiledManager = {debug=false, db_layer=false}

local TileSheet = {}

function TiledManager.newMap(pfile)
  local map = {name=pfile}

  map.debugEvent = false

  map.listDropItems = {}
  map.listItems = {}
  map.listEvents = {}

  
  function map:update(dt)

    for i=#self.listItems, 1, -1 do 
      local item = self.listItems[i]
      if not item.visible then
        table.remove(self.listItems, i)
        goto continue -- simulate continue
      end

      if type(self.Animations[item.name]) == "table" then
        item.frameTimer = item.frameTimer + dt
        if item.frameTimer >= self.Animations[item.name][item.currentFrame].duration/1000 then
          item.currentFrame = item.currentFrame % #self.Animations[item.name] + 1
          item.frameTimer = 0
        end
      end

      ::continue::
    end


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
    end
    
    -- Affichage des items
    for _, item in pairs(map.listItems) do 
      --local item = map.listItems[i]
      if item.shapeType == "rectangle" and item.visible then
        if type(map.Animations[item.name]) == "table" then
          love.graphics.draw(
            map.TileSheet[map.Animations[item.name][item.currentFrame].tileid].imgdata,
            map.TileSheet[map.Animations[item.name][item.currentFrame].tileid].quad,
            item.x,
            item.y
          )
        else
          if (item.isDone) then
            love.graphics.print("done", item.x, item.y-10)
          end
          love.graphics.draw(map.TileSheet[item.gid].imgdata,  map.TileSheet[item.gid].quad, item.x, item.y)
        end
      end
    end

    --love.graphics.line(0,544,600,544)

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
  map.TileCollider = {}
  map.Animations = {}
  map.shapesTypes = {}
  
  for n=1, #mload.tilesets do
    local tilesetProps = mload.tilesets[n]
    local tileset = require("Assets/Tiled/".. tilesetProps.name )
    if tileset.properties.isCollider then
      for n=1, tileset.tilecount do
        local tileColliderID = tilesetProps.firstgid+(n-1)
        table.insert( map.shapesTypes, tileColliderID)
      end
    end
    
    -- Stock le nombre de quad avant d'en ajouter d'autres
    -- Cela servira d'offset pour déterminer les ids d'animation
    local nbQuad =  #map.TileSheet
    if tileset.image then
      local file = "Assets/Tiled/"..tileset.image
      local sheet = Core.ImageManager.newImageSheet( file, 16, 16)
      for n=1, #sheet do
        table.insert(map.TileSheet, sheet[n])
      end

      if type(tileset.tiles) == 'table' then
        for _, tile in ipairs(tileset.tiles) do
          if type(tile.objectGroup) == 'table' and type(tile.objectGroup.objects) == 'table' then
            for _,obj in ipairs(tile.objectGroup.objects) do
              if obj.properties['isCollider'] then
                map.TileCollider[tileset.name] = obj
              end
            end
          end
          if type(tile.animation) == 'table' then
            local t = { id = tile.id } 
            t.animation = {}
            for __, anim in ipairs(tile.animation) do
              anim.tileid = anim.tileid + nbQuad + 1
              table.insert(t.animation, anim)
            end
            map.Animations[tileset.name] = t.animation
          end
        end
      end
    end
  end
    
    

  -- Trie les layers entre layer/collisions/objects :
  local layers = {}
  map.colliderLayers = {}
  map.objects = {}
  for z=1, #mload.layers do
    local layer = mload.layers[z]

    if layer.properties.isCollider ~= nil and layer.properties.isCollider then
      table.insert(map.colliderLayers, layer)
      goto continue -- simulate continue
    end

    if layer.type == "tilelayer" then
      table.insert(layers, layer)
      goto continue -- simulate continue
    end
    
    if layer.type == "objectgroup" then
      for n=1, #layer.objects do
        local obj = layer.objects[n]
        obj.layerName = layer.name
        table.insert(map.objects, obj)
      end
      goto continue -- simulate continue
    end

    ::continue::
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

  -- Créer les items
  TiledManager.loadMapItems(map)

  -- Creer les Zones d'évents :
  TiledManager.loadMapEvents(map)


  -- return la Map
  return map
end
--

function TiledManager.loadMapItems(map)
  map.listItems = {}
  for _, object in pairs(map.objects) do
      if object.layerName == "Items" then
        if object.shape == "rectangle" then
          local item = {
            gid = object.gid,
            id = object.id,
            name = object.name,
            shapeType = "rectangle",
            x=object.x, y=object.y-16, -- Hack sur Y (avec un modèle Tiled il y a une sorte d'offset)
            w=object.width, h=object.height,
            visible = object.visible,
          }

          if object.properties['scorePoints'] ~= nil then
            item.scorePoints = object.properties['scorePoints'] or 0
          end
          if object.properties['color'] ~= nil then
            item.color = object.properties['color']
          end
          if object.properties['dependency'] ~= nil then
            item.dependency = object.properties['dependency']
          end
          if object.properties['isDone'] ~= nil then
            item.isDone = object.properties['isDone']
          end


          if object.properties['isAnimate'] then 
            item.currentFrame = 1
            item.frameTimer = 0
            item.frameDuration = map.Animations[item.name][item.currentFrame].duration/1000
          end
          
        
          local ox, oy = 0, 0
          if type(map.TileCollider[item.name]) == 'table' then
              local coinCollider = map.TileCollider[item.name]
              -- x,y is center of the shape
              ox, oy = coinCollider.width / 2, coinCollider.height/2
              item.body = love.physics.newBody(
                map.world, 
                item.x+coinCollider.x+ox, 
                item.y+coinCollider.y+oy, 
                "kinematic"
              )
              item.shape = love.physics.newRectangleShape(coinCollider.width, coinCollider.height)
          else
            -- x,y is center of the shape
            ox, oy = item.w / 2, item.h/2
            item.body = love.physics.newBody(map.world, item.x+ox, item.y+oy, "kinematic")
            item.shape = love.physics.newRectangleShape(object.width, object.height)
          end
          item.fixture = love.physics.newFixture(item.body, item.shape)
          item.fixture:setSensor(true) -- evite la collision "physique"
          item.fixture:setUserData(item)


          
          table.insert(map.listItems, item)
        end
      end -- eif
  end --efor
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
    if map.colliderLayers[z].type == "tilelayer" then
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
              block.shape = love.physics.newRectangleShape(16,16)
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
    
    if map.colliderLayers[z].type == "objectgroup" then
       local objects = map.colliderLayers[z].objects
       for _, object in pairs(objects) do
          if object.shape == "rectangle" then
            local block = {
              id = object.id,
              name = "ground",
              x=object.x, y=object.y,
              w=object.width, h=object.height,
              isCollider=true,
              isGround = object.properties['isGround'],
              friction = object.properties['friction']
            }
            
            -- x,y is center of the shape
            local ox, oy = block.w / 2, block.h/2
            block.body = love.physics.newBody(map.world, block.x+ox, block.y+oy, "static")
            block.shape = love.physics.newRectangleShape(object.width, object.height)
            block.fixture = love.physics.newFixture(block.body, block.shape)

            if block.isGround then
              block.fixture:setUserData(block)
              block.fixture:setFriction(block.friction)
              
              -- Créez un capteur pour détecter le sol 
              --[[block.sensorShape = love.physics.newRectangleShape(block.x+ox+1, block.y+oy, object.height, object.width-2)
              block.sensorFixture = love.physics.newFixture(block.body, block.sensorShape)
              block.sensorFixture:setSensor(true)]]
            end
            table.insert(map.listColliders, block)
          end
       end
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
