import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "entity"

local gfx <const> = playdate.graphics

class('Reticle').extends(Entity)

function Reticle:init()
  Reticle.super.init(self)

  self.x = 0
  self.y = 0
  self.radius = 7

  self:setImage(self:generateImage())
end

function Reticle:update()
  self:moveTo(self.x, self.y)
end

function Reticle:generateImage()
  local image = gfx.image.new(self.radius * 2, self.radius * 2)

  gfx.pushContext(image)
  gfx.setColor(gfx.kColorWhite)
  gfx.drawLine(0, self.radius, self.radius * 2, self.radius)
  gfx.drawLine(self.radius, 0, self.radius, self.radius * 2)
  gfx.drawCircleAtPoint(self.radius, self.radius, self.radius-1.5)
  gfx.popContext()

  return image
end
