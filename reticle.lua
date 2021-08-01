require "global_vars"
require "entity"

Reticle = Entity:extend()

function Reticle:new()
  Reticle.super.new(self)

  self.x = 0
  self.y = 0
  self.radius = 6
end

function Reticle:draw()
  Reticle.super.draw(self)

  love.graphics.setColor(WHITE)
  love.graphics.line(self.x - self.radius, self.y, self.x + self.radius, self.y)
  love.graphics.line(self.x, self.y - self.radius, self.x, self.y + self.radius)
  love.graphics.circle("line", self.x, self.y, self.radius-1)
end
