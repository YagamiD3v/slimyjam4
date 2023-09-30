local Scene = {debug=false,current=""}

Scene.listScene = {}

local currentScene = nil

function Scene.newScene(pSceneTable, pSceneName)
  if type(pSceneTable) == "table" and type(pSceneName) == "string" then
    table.insert(Scene.listScene, {table=pSceneTable, name=pSceneName})
  else
    print("newScene introuvable")
    love.event.quit()
  end
end
--

function Scene.setScene(pScene, pLoad)
  local get = false
  for k, scene in ipairs(Scene.listScene) do
    if scene.table == pScene then
      currentScene = pScene
      Scene.current = scene.name
      if pLoad then
        if currentScene.load then
          currentScene.load()
        end
      end
      return true
    end
  end
  -- else
  print("setScene introuvable")
  love.event.quit()
end
--

function Scene.loadScene()
  Screen.load()
  if currentScene.load then
    currentScene.load()
  end
end
--

function Scene.update(dt)
  if currentScene.update then
    currentScene.update(dt)
  end
  if Core.Sfx.update then
    Core.Sfx.update(dt)
  end
end
--

function Scene.draw()
  if currentScene.draw then
    currentScene.draw()
  end
  if Scene.debug then
    love.graphics.print("Scene : "..Scene.current,350,10)
  end
end
--

function Scene.keypressed(key)
  if currentScene.keypressed then
    currentScene.keypressed(key)
  end
end
--

function Scene.mousepressed(x,y,button)
  if currentScene.mousepressed then
    currentScene.mousepressed(x,y,button)
  end
end
--

return Scene
