import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/utilities/where"
import "lib/event"

local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

class('Entity').extends(gfx.sprite)

function Entity:init(...)
  Entity.super.init(self, ...)
end
