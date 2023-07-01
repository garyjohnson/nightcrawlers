import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"

import "global_vars"
import "camera"
import "world"
import "lib/bayer"

local gfx <const> = playdate.graphics
local time = playdate.getCurrentTimeMilliseconds()
world = nil
camera = nil
deltaTime = 0

function load()
  bayer.generateFillLUT()
  camera = Camera()
  world = World()

  playdate.getSystemMenu():addMenuItem("Move camera", function() 
    camera:setEnableInput(true)
    world:setEnableInput(false)
    gfx.sprite.addDirtyRect(0, 0, WIDTH, HEIGHT)
  end)

  playdate.getSystemMenu():addMenuItem("Reset camera", function() 
    camera:setEnableInput(false)
    world:setEnableInput(true)
    camera:reset()
    gfx.sprite.addDirtyRect(0, 0, WIDTH, HEIGHT)
  end)
end

function endMoveCamera()
  camera:setEnableInput(false)
  playdate.wait(100)
  world:setEnableInput(true)
end

function playdate.update()
  camera:update()
  world:update()
  gfx.sprite.update()
  playdate.timer.updateTimers()

  deltaTime = (playdate.getCurrentTimeMilliseconds() - time) / 1000.0
  time = playdate.getCurrentTimeMilliseconds()
end

function playdate.deviceDidUnlock()
  gfx.sprite.addDirtyRect(0, 0, WIDTH, HEIGHT)
end

load()
