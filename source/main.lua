import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"

import "global_vars"
import "world"
import "bayer"

local gfx <const> = playdate.graphics
local world = nil

function load()
  bayer.generateFillLUT()
  world = World()
end

function playdate.update()
  gfx.sprite.update()
  playdate.timer.updateTimers()
  playdate.resetElapsedTime()
end

load()
