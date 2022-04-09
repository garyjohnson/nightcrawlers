import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"

import "global_vars"
import "world"
import "bayer"

local gfx <const> = playdate.graphics
world = nil

function load()
  bayer.generateFillLUT()
  world = World()
end

function playdate.update()
  world:update()
  gfx.sprite.update()
  playdate.timer.updateTimers()
  playdate.resetElapsedTime()
end

load()
