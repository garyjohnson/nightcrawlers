import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "entity"

local gfx <const> = playdate.graphics

class('Projectile').extends(Entity)

function Projectile:init(world, hitCallback, x, y, angle, direction, power)
  Projectile.super.init(self)

  self.world = world
  self.hitCallback = hitCallback

  self.originX = x
  self.originY = y
  self.x = x
  self.y = y
  self.direction = direction
  self.angle = angle
  self.power = power * 8
  self.radius = 3
  self.time = 0

  self:setOriginalImage(self:generateImage())
end

function Projectile:update()
  local dt = playdate.getElapsedTime()
  self.time = self.time + dt

  self.x = self.originX + (self.power * math.cos(self.angle) * self.time * self.direction)
  self.y = self.originY + (self.power * math.sin(self.angle) * self.time + (GRAVITY_ACCELERATION * self.time * self.time / 2.0))
  self:setLogicalPos(self.x, self.y)

  if self.world.terrain:isColliding(self.x+1, self.y+1, (self.radius*2)-1, (self.radius*2)-1) then
    self.world.terrain:hit(self.x, self.y, 25)
    self.hitCallback(self)
  end
end

function Projectile:generateImage()
  local image = gfx.image.new(self.radius * 2, self.radius * 2)

  gfx.pushContext(image)
  gfx.setColor(gfx.kColorWhite)
  gfx.drawCircleAtPoint(self.radius, self.radius, self.radius)
  gfx.popContext()

  return image
end

function Projectile:collidesWithTerrain(terrain)
  local groundPoint = terrain:findHighestYPoint(self.x - self.radius, self.radius * 2)
  return self.y >= groundPoint
end
