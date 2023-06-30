import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"

import "global_vars"
import "camera"
import "world"
import "bayer"

local gfx <const> = playdate.graphics
local time = playdate.getCurrentTimeMilliseconds()
world = nil
camera = nil
deltaTime = 0

function load()
  bayer.generateFillLUT()
  camera = Camera()
  world = World()
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
