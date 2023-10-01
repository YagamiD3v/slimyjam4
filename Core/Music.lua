local Music = {}

Music.playlist = {}

local currentPlay = "nothing"

function Music.newSource(pName, pFile, pVolume)
  local sound = {}
  sound.data = love.audio.newSource("Music/"..pFile, "stream")
  sound.data:setVolume(pVolume)
  sound.name = pName
  --
  Music[pName] = sound
end
--

function Music.load()
  Music.newSource("winter", "winter.mp3", 0.1)
  Music.newSource("summer", "summer.mp3", 0.1)
  Music.newSource("spring", "spring.mp3", 0.1)
  Music.newSource("autumn", "autumn.mp3", 0.1)
  --
end
--

function Music.play(pName)
  if currentPlay  == "nothing" then
    currentPlay = Music[pName]
  end
  currentPlay.data:stop()
  currentPlay = Music[pName]
  --
  currentPlay.data:play()
end
--

function Music.update(dt)
  if Game.levels.currentLevel ~= currentPlay.name or not currentPlay.data:isPlaying() then
    Music.play(Game.levels.currentLevel)
  end
end
--

return Music