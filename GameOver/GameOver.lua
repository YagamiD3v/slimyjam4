local  GameOver = {debug=false}

local listButtons = {}

local currentBox = 0

local decH = 0

local font = love.graphics.newFont(22)

local drawSelect = true

local background = love.graphics.newImage("Assets/GameOver/GameOver.png")

local mouse = {x=Screen.ox, y=Screen.oy, w=1, h=1}
function mouse.AABB()
  for n=1, #listButtons do
    local button = listButtons[n]
    if CheckCollision( mouse.x, mouse.y, mouse.w, mouse.h,
      button.x, button.y, button.w, button.h) then
      currentBox = n
      return true
    end
  end
  return false
end
--

function mouse.getPosition()
  mouse.x, mouse.y = love.mouse.getPosition()
end
--

function mouse.update(dt)
  mouse.getPosition()
  mouse.AABB()
end
--

local timer = {current=0, delai=20}
function timer.update(dt)
  timer.current = timer.current + 60 * dt
  if timer.current >= timer.delai then
    timer.current = 0
    return true
  end
  return false
end
--

function GameOver.drawButton(self)
  love.graphics.setColor(0.827,0.827,0.827,0.25)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 30)
  love.graphics.setColor(1,1,1,1)
end
--

function GameOver.drawTextButton(self)
  love.graphics.draw(self.text.dataText, self.text.x, self.text.y, 0, 1, 1, self.text.ox, self.text.oy)
end
--

function GameOver.newText(button, pText)
  button.text = {}
  button.text.font = font
  button.text.string = pText
  button.text.dataText = love.graphics.newText(button.text.font, button.text.string)
  button.text.w = button.text.dataText:getWidth()
  button.text.h = button.text.dataText:getHeight()
  button.text.ox = button.text.w/2
  button.text.oy = button.text.h/2
  button.text.x = button.cx
  button.text.y = button.cy
end
--

local function draw(self)
  self:drawButton()
  self:drawTextButton()
end
--

function GameOver.newButton(posY, pText, pFunction)
  local y = posY
  --
  local w=Screen.w/3
  local h=Screen.h/10
  local x = Screen.ox - (w/2)
  --
  local ox = w/2
  local oy = h/2
  local cx = x + ox
  local cy = y + oy
  --
  local button = {x=x, y=y, w=w, h=h, ox=ox, oy=oy, cx=cx, cy=cy, drawButton=GameOver.drawButton, drawTextButton=GameOver.drawTextButton, draw=draw, action=pFunction}
  GameOver.newText(button, pText)
  --
  table.insert(listButtons, button)
  --
  currentBox = 1
  --
end
--

function GameOver.load()
  GameOver.newButton(Screen.oy + 140, "R E P L A Y", function() Core.Scene.setScene(Menu, true) end)
end
--

function GameOver.update(dt)
  if timer.update(dt) then
    drawSelect = not drawSelect
  end
  --
  mouse.update(dt)
end
--

function GameOver.draw()
  love.graphics.draw(background)
  --
  for n=1, #listButtons do
    local button = listButtons[n]
    --
    button:draw()
    --
    if currentBox == n then
      if drawSelect then
        love.graphics.setColor(0.15,0.8,0.1,1)
        love.graphics.rectangle("line", button.x, button.y, button.w, button.h, 30)
        love.graphics.setColor(1,1,1,1)
      end
    end
  end
  --
  if GameOver.debug then
    love.graphics.print("Scene GameOver",10,10)
  end
end
--

function GameOver.keypressed(k)
  if k == "w" or k == "up" then
    currentBox = currentBox - 1 
  elseif k == "s" or k == "down" then
    currentBox = currentBox + 1 
  end
  --
  if currentBox > #listButtons then
    currentBox = 1
  elseif currentBox < 1 then
    currentBox = #listButtons
  end
  --
  if k == "return" then
    if listButtons[currentBox] then
      listButtons[currentBox].action()
    end
  end

end
--

function GameOver.mousepressed(x,y,button)
  if button == 1 then
    if mouse.AABB() then
      if listButtons[currentBox] then
        listButtons[currentBox].action()
      end
    end
  end
end
--

return GameOver