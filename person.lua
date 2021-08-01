require "global_vars"
require "reticle"

Object = require "classic"
Person = Object:extend()

function Person:new(terrain)
  self.terrain = terrain
  self.reticle = Reticle()

  self.x = 100
  self.y = 1
  self.width = 8
  self.height = 16
  self.name = "Gary"

  self.downwardVelocity = 0
  self.gravityAcceleration = 2
  self.movementSpeed = 0.5

  self.direction = 1
  self.reticleDistance = 30
  self.reticleAngle = 90
end

function Person:update()
  self:processInput()
  self:processGravity()

  self.reticle.x = self.x + (self.width / 2) + (self.reticleDistance * self.direction)
  self.reticle.y = self.y + 1
  self.reticle:update()
end

function Person:draw()
  love.graphics.setColor(WHITE)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(BLACK)
  love.graphics.rectangle('fill', self.x+1, self.y+1, self.width-2, self.height-2)

  love.graphics.setColor(WHITE)
  love.graphics.printf(self.name, self.x-20, self.y - 20, self.width+40, "center")

  self.reticle:draw()
end

function Person:processInput()
  if not(self:isTouchingGround()) then
    return
  end

  if love.keyboard.isDown('left') then
    self.direction = -1
    self.x = self.x + (self.movementSpeed * self.direction)
  elseif love.keyboard.isDown('right') then
    self.direction = 1
    self.x = self.x + (self.movementSpeed * self.direction)
  end


  self:snapToGroundIfBelow()
end

function Person:processGravity()
  local groundPoint = self.terrain:findHighestYPoint(self.x, self.width)
  local footPoint = self.y + self.height
  if footPoint < groundPoint - 1 then
    self:fall()
  elseif footPoint == groundPoint - 1 then
    self.downwardVelocity = 0
  else
    self:snapToGroundIfBelow()
  end
end

function Person:isTouchingGround()
  local groundPoint = self.terrain:findHighestYPoint(self.x, self.width)
  local footPoint = self.y + self.height
  return footPoint == groundPoint - 1
end

function Person:fall()
  self.downwardVelocity = self.downwardVelocity + self.gravityAcceleration
  self.y = self.y + self.downwardVelocity

  self:snapToGroundIfBelow()
end

function Person:snapToGroundIfBelow()
  local groundPoint = self.terrain:findHighestYPoint(self.x, self.width)
  local footPoint = self.y + self.height

  if footPoint > groundPoint - 1 then
    self.y = (groundPoint - 1) - self.height
  end
end
