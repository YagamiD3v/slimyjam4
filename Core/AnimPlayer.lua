local AnimPlayer = {debug=true}

function AnimPlayer.timerUpdate(self, dt)
  local anim = self[self.currentAnim]
  if self.timer.speed ~= anim.speed then
    self.timer.speed = anim.speed
  end
  --
  self.timer.current = self.timer.current + (self.timer.speed * dt)
  if self.timer.current >= self.timer.delai then
    local restant = self.timer.current - self.timer.delai
    self.timer.current = restant
    --
    return true
  else
    return false
  end
end
--

function AnimPlayer.setAnim(self, pAnimName)
  self.currentAnim = pAnimName
  self.currentFrame = 1
  self.timer.current = 0
  local anim = self[self.currentAnim]
  if anim.sfx then
    Core.Sfx.play(anim.sfx)
  end
end
--

function AnimPlayer.newAnim(pName, pFileName, pFrames, pSpeed, pSound, pLoop)
  local dirpath = "Assets/Tiled/sprite/Player/"
  local imgSource = love.graphics.newImage(dirpath..pFileName)
  local imgSourceW, imgSourceH = imgSource:getDimensions()
  local w = imgSourceW / pFrames
  local h = imgSourceH
  local ox = w / 2
  local oy = h / 2
  --
  local x = 0
  local y = 0
  --
  local sound = false
  if pSound then
    sound = pSound
  end
  --
  local loop = pLoop
  if loop == nil then
    loop = true
  end
  --
  local anim = {name=pName, imagedata=imgSource, nbFrames=pFrames, speed=pSpeed, w=w, h=h, ox=ox, oy=oy, sfx=sound, loop=loop}
  for n = 1, pFrames do
    table.insert(anim, {quad=love.graphics.newQuad(x,y,w,h,imgSourceW,imgSourceH)})
    --
    x=x+w
  end
  --
  AnimPlayer[pName] = anim
end
--

function AnimPlayer.load()
  AnimPlayer.newAnim("Idle", "player-idle.png", 4, 60)
  AnimPlayer.newAnim("Run", "player-run.png", 6, 60)
  AnimPlayer.newAnim("Jump", "player-jump.png", 2, 60, "Jump", false)
end
--

function AnimPlayer.update(self, dt)
  if self.timer.update(self, dt) then
    self.currentFrame = self.currentFrame + 1
    --
    local anim = self[self.currentAnim]
    if self.currentFrame > anim.nbFrames then
      if anim.loop == false then
        self.currentFrame = anim.nbFrames
      elseif anim.loop == true then
        self.currentFrame = 1
      end
    end
  end
end
--

function AnimPlayer.drawDebug(self)
  local t = ""
  t = "currentAnim : "..self.currentAnim.."\n"
  t = t.."currentFrame : "..self.currentFrame.."\n"
  love.graphics.print(t, 50, 50)
end
--
function AnimPlayer.draw(self, entity, Scale)
  local anim = self[self.currentAnim]
  local currentframe = self.currentFrame
  --
  local sx = Scale or 1
  local sy = Scale or 1
  local ox = anim.ox
  local oy = anim.oy
  local x = entity.x
  local y = entity.y

  --
  love.graphics.draw(anim.imagedata, anim[currentframe].quad, entity.x, entity.y, 0, sx*entity.direction.vx, sy, ox, oy)

  if AnimPlayer.debug then
    self:drawDebug()
    love.graphics.print(sx, 200, 50)
    love.graphics.print(sy, 200, 70)
    love.graphics.print(ox, 200, 90)
    love.graphics.print(oy, 200, 110)
  end
end
--

function AnimPlayer.getAnims()
  local anims = {currentAnim="Idle", currentFrame=1, update=AnimPlayer.update, setAnim=AnimPlayer.setAnim, drawDebug=AnimPlayer.drawDebug, draw=AnimPlayer.draw}
  anims.timer = {current=0, delai=10, speed=60, update=AnimPlayer.timerUpdate}
  --
  anims.Idle = AnimPlayer.Idle
  anims.Run = AnimPlayer.Run
  anims.Jump = AnimPlayer.Jump
  --
  return anims
end
--

return AnimPlayer