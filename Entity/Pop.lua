local Pop = {
    debug=false,
    listePopScore = {}
}

function Pop:new(x, y, text, delay)
    local p = {update=Pop.update, draw=Pop.draw}
    local width = love.graphics.getFont():getWidth(tostring(text))
    
    p.x = x - width/2
    p.y = y
    p.vy = -20
    p.delay = delay or 1 -- seconde
    p.timeElapsed = 0
    p.text = text
    p.destroy = false
   
    table.insert(self.listePopScore, p)

end

function Pop.update(self, dt) -- self == mob:update(dt)
    self.y = self.y + self.vy * dt
    self.timeElapsed = self.timeElapsed + dt
    if self.timeElapsed >= self.delay then
        self.destroy = true
    end
end

function Pop.draw(self)
    local alpha = 1 - (self.timeElapsed / self.delay)
    love.graphics.setColor(1, 0, 0, alpha) 
    love.graphics.print(self.text, self.x, self.y)
    love.graphics.setColor(1, 1, 1, 1)
end

function Pop:updateAll(dt)
    for i=#self.listePopScore, 1, -1 do
        p = self.listePopScore[i]
        if p.destroy then
            table.remove(Pop.listePopScore, i)
        else
            p:update(dt)
        end
    end
end

function Pop:drawAll(dt)
    for i=#self.listePopScore, 1, -1 do
        p = self.listePopScore[i]
        p:draw()
    end
end

return Pop