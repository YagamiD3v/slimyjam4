local Gui = { debug=false, level = {}, score=0 }

function Gui.load(lvl)
   Gui.level = lvl
   Gui.lives = 0
end

function Gui.update(dt)
    Gui.score = Player.score
    Gui.lives = Player.lives
end
--

function Gui.draw()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", 0, 0, 800, 16)
    love.graphics.setColor(1,1,1)

    love.graphics.print("Mission: " ..   Gui.level.mission, 8, 1)
    love.graphics.print("Lives: " ..   Gui.lives, 600, 1)
    love.graphics.print("Score: " ..  Gui.score, 700, 1)
end
--

return Gui