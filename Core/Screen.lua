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
end
--

function Screen.load()
  Screen.getDimensions()
end
--

function Screen.update(dt)
  Screen.getDimensions()
end
--