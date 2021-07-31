require "global_vars"

Object = require "classic"
Person = Object:extend()

function Person:new(terrain)
  self.terrain = terrain

  self.x = 100
  self.y = 1
  self.width = 8
  self.height = 16

  self.downwardVelocity = 0
  self.gravityAcceleration = 2
end

function Person:update()
  if not(self:isTouchingGround()) then
    self.downwardVelocity = self.downwardVelocity + self.gravityAcceleration
    self.y = self.y + self.downwardVelocity
  end

end

function Person:isTouchingGround()
  for x = self.x, (self.x+self.width) do
    r,g,b,a = self.terrain.imageData:getPixel(x, self.y+self.height+1)
    if r > 0 then
      return true
    end
  end

  return false
end

function Person:draw()
  love.graphics.setColor(WHITE)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(BLACK)
  love.graphics.rectangle('fill', self.x+1, self.y+1, self.width-2, self.height-2)
end
