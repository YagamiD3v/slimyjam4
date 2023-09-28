local Game = {debug=false}

function Game.load()
end
--

function Game.update(dt)
end
--

function Game.draw()
  if Game.debug then
    love.graphics.print("Scene Game",10,10)
  end
end
--

function Game.keypressed(k)
end
--

function Game.mousepressed(x,y,button)
end
--

return Game