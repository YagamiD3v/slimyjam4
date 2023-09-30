local MissionGui = {}

local box = {}

local function draw(self)
  love.graphics.setColor(0.827,0.827,0.827,0.25)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 30)
  --
  love.graphics.setColor(0,0,0,1)
  local currentMission = Game.levels.house.mission[Game.levels.currentLevel]
  local text = currentMission[Game.levels.house.status]
  love.graphics.printf(text, self.x, self.y+5, self.w, "center", 0, 1, 1)
  love.graphics.setColor(1,1,1,1)
end
--

function MissionGui.load()
  box = {x=10,y=10,w=200,h=40, draw=draw}
end
--


function MissionGui.update(dt)
end
--

function MissionGui.draw()
  box:draw()
end
--

return MissionGui