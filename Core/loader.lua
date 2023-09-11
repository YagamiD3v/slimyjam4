
local Loader = {debug=false}
--
local dirpath = "Core/"
local filesTable = love.filesystem.getDirectoryItems(dirpath)

Core = {}

function Loader:load()
  -- For All
  require(dirpath.."Globals")

  -- Libs independante
  Core.Gamera = require(dirpath.."Gamera")

  -- Prio order require for work
  Core.Scene = require(dirpath.."SceneManager")

  -- Class dependantes
  Core.ImageManager = require(dirpath.."ImageManager")
  Core.TiledManager = require(dirpath.."TiledManager")
  Core.ClassAnim = require(dirpath.."ClassAnim")

  --
  for _, Module in pairs(Core) do
    if type(Module) == "table" then
      if Module.load then
        Module.load()
      end
    end
  end
end
--

Loader:load()

if Loader.debug then
  for k, v in pairs(Core) do
    print( "Core."..tostring(k) .. " : " .. tostring(v) )
  end
end
--