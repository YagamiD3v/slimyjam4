local Controller = {debug=true, connected=false, gamepad = nil}

local joysticks = {}
local keyboard = {}

function Controller.getControllers(debug)
  joysticks = love.joystick.getJoysticks()
  if not Controller.gamepad and #joysticks >= 1 then
    Controller.gamepad = joysticks[1]
    Controller.connected = true
  elseif Controller.gamepad and #joysticks == 0 then
    Controller.gamepad = nil
    if Controller.connected then
      print("GamePad disconnect and no Controller.gamepad found.")
      Controller.connected = false
    end
  end
  --
  if debug then
    if Controller.gamepad then
      if Controller.gamepad:isGamepad() then
        print("Gamepad recognized : ".. Controller.gamepad:getName() .. " connected and used.")
      else
        print("Joystick not recognized as a Controller.gamepad : ".. Controller.gamepad:getName() .. " connected and used.")
      end
    else
      print("GamePad not found.")
    end
  end
end
--

-- ##############################
local listControls = {}
function Controller.newControls(pName, pKey, pJoy, debug)
  local scancode = love.keyboard.getScancodeFromKey( pKey )
  if scancode  and debug then
    print("The Key ["..pKey.."] is scancode ["..scancode.."].")
  end
  --
  local control = {
    name=pName,
    key=pKey,
    joykey=pJoy,
    isDown=false,
    isPressed=false,
    isReleased=false,
    isJoystick=false,
    isKeyboard=false
  }
  --
  listControls[pName] = control
end
-- ##############################

function Controller.isDown(pName)
  if listControls[pName] then
    local control = listControls[pName]
    local isDown = false
    if Controller.connected then
      isDown = love.keyboard.isDown(control.key) or Controller.gamepad:isGamepadDown(control.joykey)
    else
      isDown = love.keyboard.isDown(control.key)
    end
    --
    control.isDown = isDown
    --
    return isDown
  end
  --
  print("Controller.isDown("..tostring(pName)..") is not recognized")
  return false
end
--

function Controller.isKeyBoardPressed(pName, k)
  if listControls[pName] then
    local control = listControls[pName]
    local isPressed = false
    --
    isPressed = (control.key == k)
    --
    control.isPressed = isPressed
    --
    return isPressed
  end
  --
  print("Controller.isKeyBoardPressed("..tostring(pName)..") is not recognized")
  return false
end
--

function Controller.isGamePadPressed(pName, button)
  if listControls[pName] then
    local control = listControls[pName]
    local isPressed = false
    if Controller.connected then
      isPressed =  (control.joykey == button)
    end
    --
    control.isPressed = isPressed
    --
    return isPressed
  end
  --
  print("Controller.isGamePadBoardPressed("..tostring(pName)..") is not recognized")
  return false
end
--

function Controller.isKeyBoardReleased(pName, k)
  if listControls[pName] then
    local control = listControls[pName]
    local isReleased = false
    --
    isReleased =  (control.key == k)
    --
    control.isReleased = isReleased
    --
    return isReleased
  end
  --
  print("Controller.isKeyBoardReleased("..tostring(pName)..") is not recognized")
  return false
end
--

function Controller.isGamePadReleased(pName, button)
  if listControls[pName] then
    local control = listControls[pName]
    local isReleased = false
    if Controller.connected then
      isReleased = (control.joykey == button)
    end
    --
    control.isReleased = isReleased
    --
    return isReleased
  end
  --
  print("Controller.isGamePadReleased("..tostring(pName)..") is not recognized")
  return false
end
--

function Controller.load()
  Controller.getControllers("debug")


  -- Navigation :
  Controller.newControls("nav_up", "up", "dpup")
  Controller.newControls("nav_down", "down", "dpdown")
  Controller.newControls("nav_left", "left", "dpleft")
  Controller.newControls("nav_right", "right", "dpright")

  Controller.newControls("nav_valid", "return", "a")
  Controller.newControls("nav_back", "escape", "b")


  -- GamePlay
  Controller.newControls("up", "up", "dpup")
  Controller.newControls("left", "left", "dpleft")
  Controller.newControls("right", "right", "dpright")
  Controller.newControls("down", "down", "dpdown")

  Controller.newControls("jump", "space", "a")
  Controller.newControls("start", "pause", "start")
  Controller.newControls("select", "escape", "select")
end
--

function Controller.update(dt)
  Controller.getControllers()
end
--


function Controller.keypressed(k)
  for _, control in pairs (listControls) do
    local key = control.keyname
    if k == key then
      control.isPressed = true
      control.isKeyboard = true
    end
  end
end
--


function Controller.keyreleased(k)
  for _, control in pairs (listControls) do
    local key = control.joykey
    if k == key then
      control.isReleased = true
      control.isKeyboard = true
    end
  end
end
--

function Controller.gamepadpressed( joystick, button )
  if joystick == Controller.gamepad then
    for _, control in pairs (listControls) do
      local joykey = control.joykey
      if button == joykey then
        control.isPressed = true
        control.isJoystick = true
      end
    end
  end
end
--


function Controller.gamepadreleased( joystick, button )
  if joystick == Controller.gamepad then
    for _, control in pairs (listControls) do
      local joykey = control.joykey
      if not control.isReleased then
        if button == joykey then
          control.isReleased = true
          control.isJoystick = true
        end
      end
    end
  end
end
--

function Controller.draw()
  if Controller.debug then
    local text = ""
    for _, control in pairs (listControls) do
      if control.isDown then
        text = text .. " Control Name ["..control.name.."] is down with "
        --
        if control.isKeyboard then
          text = text .. "keyboard ["..control.key.."] "
        end
        --
        if control.isJoystick then
          text = text .. "joystick["..control.joykey.."]"
        end
        --
        text = text .. "\n"
      end
    end
    --
    love.graphics.print(text, 10, 10)
  end
end
--

return Controller

--[[

liste des buttons des Gamepads :

Source : https://love2d.org/wiki/GamepadButton


a
Bottom face button (A).

b
Right face button (B).

x
Left face button (X).

y
Top face button (Y).

back
Back button.

guide
Guide button.

start
Start button.

leftstick
Left stick click button.

rightstick
Right stick click button.

leftshoulder
Left bumper.

rightshoulder
Right bumper.

dpup
D-pad up.

dpdown
D-pad down.

dpleft
D-pad left.

dpright
D-pad right.


Available since LÖVE 12.0

misc1
Xbox Series X controller share button, PS5 controller mic button, and Switch Pro controller capture button.

paddle1
First paddle button.

paddle2
Second paddle button.

paddle3
Third paddle button.

paddle4
Fourth paddle button.

touchpad
Controller touchpad press.

--]]