local Sfx = {}

Sfx.playlist = {}

function Sfx.newSource(pName, pFile, pVolume)
  local sound = love.audio.newSource("Sfx/"..pFile, "static")
  sound:setVolume(pVolume)
  Sfx[pName] = sound
end
--

function Sfx.load()
  Sfx.newSource("Jump", "Jump.wav", 0.3)
  Sfx.newSource("Coin", "Pickup_Coin.wav", 0.5)
  Sfx.newSource("PowerUp", "Powerup.wav", 0.6)
  Sfx.newSource("Hit", "Hit.wav", 0.6)
  Sfx.newSource("Hurt", "Hurt.wav", 0.6)
end
--

function Sfx.play(source)
  local new = source:clone()
  new:play()
end
--

return Sfx