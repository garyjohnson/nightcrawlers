import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "entity"

local gfx <const> = playdate.graphics

class('ExplosionParticle').extends(Entity)

function ExplosionParticle:init(world, hitCallback, x, y, angle, direction, power, radius)
  ExplosionParticle.super.init(self)

  self.world = world
  self.hitCallback = hitCallback

  self.originX = x
  self.originY = y
  self.direction = direction
  self.angle = angle
  self.power = power * 8
  self.radius = radius
  self.time = 0
  self.halfLife = 1000

  self:setLogicalPos(x, y)
  self:setOriginalImage(self:generateImage())
end

function ExplosionParticle:update()
  self.time = self.time + deltaTime

  local logX = self.originX + (self.power * math.cos(self.angle) * self.time * self.direction)
  local logY = self.originY + (self.power * math.sin(self.angle) * self.time + (GRAVITY_ACCELERATION * self.time * self.time / 2.0))
  self:setLogicalPos(logX, logY)

  if self.time > self.halfLife then
    self.hitCallback(self)
  end
end

function ExplosionParticle:generateImage()
  local image = gfx.image.new(self.radius * 2, self.radius * 2)

  gfx.pushContext(image)
  gfx.setColor(gfx.kColorWhite)
  gfx.drawCircleAtPoint(self.radius, self.radius, self.radius)
  gfx.popContext()

  return image
end
