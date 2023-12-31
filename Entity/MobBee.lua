local MobBee = {debug=false}

function MobBee:new(obj, pMap)
    local mob = {update=MobBee.update, draw=MobBee.draw}

    mob.refMap = pMap
    mob.isAnimate = false
    mob.gid = obj.gid
    mob.id = obj.id
    mob.name = obj.name
    mob.shapeType = "rectangle"
    mob.x = obj.x + obj.width/2
    mob.y = obj.y
    mob.w = obj.width
    mob.h = obj.height
    mob.ox, mob.oy = 0, 0
    mob.visible = obj.visible
    
    mob.direction = obj.properties['direction']
    mob.scaleX = 1
    mob.vx, mob.vy = 20, 20
    mob.maxSpeed = 100
    mob.type="mob"

    if obj.properties['scorePoints'] ~= nil then
        mob.scorePoints = obj.properties['scorePoints'] or 0
    end

    if obj.properties['isAnimate'] then
        mob.isAnimate = true
        mob.Animations = mob.refMap.Animations[mob.name]
        mob.currentFrame = 1
        mob.frameTimer = 0
        mob.frameDuration = mob.refMap.Animations[mob.name][mob.currentFrame].duration/1000
    else 
        mob.currentFrame = 1
    end


    
    if type(mob.refMap.TileCollider[mob.name]) == 'table' then
        local mobCollider = mob.refMap.TileCollider[mob.name]
        -- x,y is center of the shape
        mob.ox, mob.oy = mobCollider.width / 2, mobCollider.height/2
        mob.body = love.physics.newBody(
            mob.refMap.world, 
            mob.x + mob.ox, 
            mob.y - mob.oy, 
            "kinematic"
        )

        mob.shape = love.physics.newRectangleShape(
            mobCollider.x, 
            mobCollider.y, 
            mobCollider.width, 
            mobCollider.height
        )
        
        mob.fixture = love.physics.newFixture(mob.body, mob.shape)
        --mob.fixture:setCategory(ENUM_CATEGORY.MOB)
        --mob.fixture:setMask(ENUM_CATEGORY.PLAYER, ENUM_CATEGORY.TRIGGER)
    else
        print("Le mob " .. mob.name .. "n'as pas de collider !")
    end

    mob.fixture:setUserData(mob)
      
    return mob
end

function MobBee.update(self, dt) -- self == mob:update(dt)
    local _x, _y = self.x, self.y
    
    if self.direction == ENUM_DIRECTION.TOP then
        self.y = self.y - self.vy * dt
    elseif self.direction == ENUM_DIRECTION.BOTTOM then
        self.y = self.y + self.vy * dt
    elseif self.direction == ENUM_DIRECTION.RIGHT then
        self.x = self.x + self.vx * dt
        self.scaleX = 1
    elseif self.direction == ENUM_DIRECTION.LEFT then
        self.x = self.x - self.vx * dt
        self.scaleX = -1
    end
    self.body:setPosition(self.x, self.y)

    if self.isAnimate then
        self.frameTimer = self.frameTimer + dt
        if self.frameTimer >= self.Animations[self.currentFrame].duration/1000 then
            self.currentFrame = self.currentFrame % #self.Animations + 1
            self.frameTimer = 0
        end
    end

    -- Collision avec trigger pour changer de direction
    for _, trig in pairs(self.refMap.listTriggers) do
        if CheckCollision(self.x, self.y, self.w, self.h, trig.x, trig.y, trig.w, trig.h ) then
            self.body:setPosition(_x, _y)
            self.direction = trig.direction
        end
    end
end

function MobBee.draw(self)

    if MobBee.debug then
        love.graphics.setColor(1,0,0)
        love.graphics.print("ID: " .. self.id, self.body:getX(), self.body:getY()-16)
        
        local points = {self.shape:getPoints()}
        for n=1, #points, 2 do
        points[n], points[n+1] = self.body:getWorldPoint( points[n], points[n+1] )
        end
        love.graphics.polygon("fill", points)
        love.graphics.setColor(1,1,1)
    end

    love.graphics.draw(
        
        self.refMap.TileSheet[self.Animations[self.currentFrame].tileid].imgdata,
        self.refMap.TileSheet[self.Animations[self.currentFrame].tileid].quad,
        self.body:getX(),
        self.body:getY(),
        0,
        self.scaleX,
        1,
        self.ox,
        self.oy
    )
end

return MobBee