Screen = {}

function Screen.getDimensions()
  Screen.x=0
  Screen.y=0
  --
  Screen.w, Screen.h = love.graphics.getDimensions()
  --
  Screen.ox=Screen.w/2
  Screen.oy=Screen.h/2
  --
  Screen.cx = Screen.ox
  Screen.cy = Screen.oy
  --
  Screen.sx = 1
  Screen.sy = 1
end
--

function Screen.getScale()
  local w, h = love.graphics.getDimensions() -- 1920 / 1080
  
  local sx = w / Screen.w
  local sy = h / Screen.h
  
  Screen.sx = math.min(sx, sy)
  Screen.sy = math.min(sx, sy)
  --
  Screen.offsetX = w - (Screen.w * Screen.sx)
  Screen.offsetY = h - (Screen.h * Screen.sy)
  --
--  print(Screen.sx)
--  print(Screen.sy)
--  ---
--  love.event.quit()
end
--

function Screen.load()
  Screen.getDimensions()
end
--

function Screen.update(dt)
  Screen.getScale()
end
--