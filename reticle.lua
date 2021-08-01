require "global_vars"

Object = require "classic"
Reticle = Object:extend()

function Reticle:new()
  self.x = 0
  self.y = 0
  self.radius = 6
end

function Reticle:update(dt)
end

function Reticle:draw()
  love.graphics.setColor(WHITE)
  love.graphics.line(self.x - self.radius, self.y, self.x + self.radius, self.y)
  love.graphics.line(self.x, self.y - self.radius, self.x, self.y + self.radius)
  love.graphics.circle("line", self.x, self.y, self.radius-1)
end
