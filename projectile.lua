require "global_vars"

Object = require "classic"
Projectile = Object:extend()

function Projectile:new(x, y, angle, direction, power)
  self.originX = x
  self.originY = y
  self.x = x
  self.y = y
  self.direction = direction
  self.angle = angle
  self.power = power * 8
  self.radius = 3
  self.time = 0
end

function Projectile:update(dt)
  self.time = self.time + dt

  self.x = self.originX + (self.power * math.cos(self.angle) * self.time * self.direction)
  self.y = self.originY + (self.power * math.sin(self.angle) * self.time + (GRAVITY_ACCELERATION * self.time * self.time / 2.0))
end

function Projectile:draw()
  love.graphics.setColor(WHITE)
  love.graphics.circle("line", self.x, self.y, self.radius)
end
