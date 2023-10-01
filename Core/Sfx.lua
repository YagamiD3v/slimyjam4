local Sfx = {}

Sfx.playlist = {}

function Sfx.newSource(pName, pFile, pVolume)
  local sound = love.audio.newSource("Sfx/"..pFile, "static")
  sound:setVolume(pVolume)
  Sfx[pName] = sound
end
--

function Sfx.load()
  Sfx.newSource("Jump", "Jump.wav", 0.4) -- Core.Sfx.Jump
  Sfx.newSource("Coin", "Pickup_Coin.wav", 0.4) -- Core.Sfx.Coin
  Sfx.newSource("PowerUp", "Powerup.wav", 0.6) -- etc
  Sfx.newSource("Hit", "Hit.wav", 0.5)
  Sfx.newSource("Hurt", "Hurt.wav", 0.6)
end
--

function Sfx.play(Name)
  local new = Sfx[Name]:clone()
  new:play()
  table.insert(Sfx.playlist, new)
end
--

function Sfx.update(dt)
  -- purge
  for n=#Sfx.playlist, 1, -1 do
    local sound = Sfx.playlist[n]
    if not sound:isPlaying() then
      table.remove(Sfx.playlist, n)
    end
  end
end
--

return Sfx