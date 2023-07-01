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
  self.direction = direction
  self.angle = angle
  self.power = power * 8
  self.radius = 3
  self.time = 0
  self.previousX = x
  self.previousY = y

  self:moveTo(x, y)
  self:setImage(self:generateImage())
end

function Projectile:update()
  self.time = self.time + deltaTime

  local logX = self.originX + (self.power * math.cos(self.angle) * self.time * self.direction)
  local logY = self.originY + (self.power * math.sin(self.angle) * self.time + (GRAVITY_ACCELERATION * self.time * self.time / 2.0))
  self.previousX = self.x
  self.previousY = self.y
  self:moveTo(logX, logY)

  if self.world.terrain:isColliding(self.x+1, self.y+1, (self.radius*2)-1, (self.radius*2)-1) then
    local angleOfApproach = angle(self.x, self.y, self.previousX, self.previousY)
    self.world.terrain:hit(self.x, self.y, angleOfApproach, self.direction, 25)
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
