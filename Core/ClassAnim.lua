local ClassAnim = {debug = false}

ClassAnim.__index = ClassAnim

function ClassAnim:newAnim(pEntity, pName, pType, pCol, pLig, pStart, pEnd)
  local anim = Core.ImageManager.newAnim(pType, pCol, pLig, pStart, pEnd)
  anim.timer = Core.ClassTimer:new(false)
  anim.entity = pEntity
  --
  anim.isFinish = false
  anim.state = "isWaiting"
  --
  if not anim.entity.currentLayer then
    anim.entity.currentLayer = 1
  end
  --
  if not anim.entity.listAnim then
    anim.entity.listAnim = {}
  end
  table.insert(anim.entity.listAnim, pName)
  --
  if not anim.entity.nbAnims then
    anim.entity.nbAnims = 1
  else
    anim.entity.nbAnims = anim.entity .nbAnims + 1 
  end
  --
  setmetatable(anim, self)
  --
  return anim
end
--

function ClassAnim:setLoop(bool)
  self.timer:setLoop(bool)
end
--

function ClassAnim:setSpeed(speed)
  self.timer:setSpeed(speed)
end
--

function ClassAnim:setFrameSpeed(speed)
  self.timer:setSpeed(speed * 60) -- speed == nb frame / seconde
end
--

function ClassAnim:update(dt)
  if self.timer:update(dt) then
    self.frame = self.frame + 1
    if self.frame > self.nbframes then
      if self.timer.loop then
        self.frame = 1
      elseif not self.timer.loop then
        self.frame = 1
        self.isFinish = true
        self.state = "isDone"
        return true
      end
      self.isFinish = true
      self.state = "isLoop"
      return true
    end
  end
  self.isFinish = false
  self.state = "isWaiting"
  return false
end
--

function ClassAnim:draw()
  if self.debug then
    love.graphics.setColor(0,0,1,1)
    love.graphics.print(self.entity.anim.current, self.entity.x - 6, self.entity.y - self.oy)
    love.graphics.setColor(1,1,1,1)
  end

  -- anim with one file
  love.graphics.draw(self.imgdata, self[self.frame].quad, self.entity.x, self.entity.y, self.entity.rotate, self.entity.mirrorX, 1, self.ox, self.oy )

  if self.layers then
    -- anim with layers
    love.graphics.draw(self.layers[self.entity.currentLayer].imgdata, self.layers[self.currentLayer][self.frame].quad, self.entity.x, self.entity.y, self.entity.rotate, self.entity.mirrorX, 1, self.ox, self.oy )
    -- Draw with  outils/armes/etc ?
    if self.entity.isEquiped then
      love.graphics.draw(self.layers[self.outilsLayer].imgdata, self.layers[self.outilsLayer][self.frame].quad, self.entity.x, self.entity.y, self.entity.rotate, self.entity.mirrorX, 1, self.ox, self.oy )
    end
  end
end
--



return ClassAnim