local Particules = {}

local function draw(self)
  for _, part in ipairs(self) do
    love.graphics.setColor(part.color)
    love.graphics.rectangle("fill", part.x, part.y, part.radius, part.radius)
  end
  love.graphics.setColor(1,1,1,1)
end
--
local function update(self, dt)
  for n=#self, 1, -1 do
    local part = self[n]
    --
    local gravity = 0.89 * dt * (part.speed * 2)
    part.x = part.x + (part.vx * part.speed * dt)
    part.y = part.y + (part.vy * part.speed * dt)
    part.y = part.y + gravity
    part.vy = part.vy + gravity
    --
    if part.y >= self.y then
      table.remove(self, n)
      self:generatePart()
    end
  end
end
--

local function generatePart(self)
  local color = {love.math.random(0.2,1), love.math.random(0.2,1), love.math.random(0.2,1), love.math.random(0.4,0.8)}
  local x = self.x + love.math.random(-5,5)
  local y = self.y - love.math.random(0.01, 3.0)
  local radius = love.math.random(2,5)
  local vecteur = {-1,1}
  local vx = vecteur[love.math.random(#vecteur)]
  local vy = 0 - (radius * 3)
  local speed = 60 / radius
  --
  local part = {x=x, y=y, color=color, radius=radius, vx=vx, vy=vy, speed=speed}
  table.insert(self, part)
end
--

function Particules.new(x, y)
  local new = {x=x, y=y, color=color, draw=draw, update=update, generatePart=generatePart}
  for n=1, 10 do
    new:generatePart()
  end
  return new
end
--

return Particules