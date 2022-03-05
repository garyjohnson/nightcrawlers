import "CoreLibs/object"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

import "global_vars"
import "entity"

class('Reticle').extends(Entity)

function Reticle:init()
  Reticle.super.init(self)

  self.x = 0
  self.y = 0
  self.radius = 6
end

function Reticle:draw()
  Reticle.super.draw(self)

  gfx.setColor(gfx.kColorWhite)
  gfx.drawLine(self.x - self.radius, self.y, self.x + self.radius, self.y)
  gfx.drawLine(self.x, self.y - self.radius, self.x, self.y + self.radius)
  gfx.drawCircleAtPoint(self.x, self.y, self.radius-1)
end
