import "CoreLibs/object"
import "CoreLibs/graphics"

import "global_vars"
import "world"

local gfx <const> = playdate.graphics

function load()
  world = World()
end

function playdate.update()
  local dt = playdate.getElapsedTime()
  world:update(dt)
  world:draw()
end

load()
