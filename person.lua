require "global_vars"
require "reticle"
require "weapon_charge"
require "projectile"
require "math_utils"

Object = require "classic"
Person = Object:extend()

function Person:new(terrain)
  self.terrain = terrain
  self.reticle = Reticle()
  self.weaponCharge = WeaponCharge()
  self.projectiles = {}

  self.x = 100
  self.y = 1
  self.width = 8
  self.height = 16
  self.name = "Gary"

  self.downwardVelocity = 0

  self.movementSpeed = 25
  self.direction = 1

  self.reticleDistance = 30
  self.reticleSpeed = degToRad(50)
  self.reticleAngle = degToRad(0)
  self.reticleMinAngle = degToRad(-90)
  self.reticleMaxAngle = degToRad(90)
end

function Person:update(dt)
  self:processInput(dt)
  self:processGravity(dt)

  self.reticle.x = self.x + (self.width / 2) + (self.reticleDistance * self.direction * math.cos(self.reticleAngle))
  self.reticle.y = self.y + 1 + (self.reticleDistance * math.sin(self.reticleAngle))
  self.reticle:update(dt)

  self.weaponCharge.direction = self.direction
  self.weaponCharge.x = self.x + (self.width / 2)
  self.weaponCharge.y = self.y + 1
  self.weaponCharge:update(dt)

  for _, projectile in pairs(self.projectiles) do
    projectile:update(dt)
  end
end

function Person:draw()
  self.weaponCharge:draw()
  self.reticle:draw()

  love.graphics.setColor(WHITE)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(BLACK)
  love.graphics.rectangle('fill', self.x+1, self.y+1, self.width-2, self.height-2)

  love.graphics.setColor(WHITE)
  love.graphics.printf(self.name, self.x-20, self.y - 20, self.width+40, "center")

  for _, projectile in pairs(self.projectiles) do
    projectile:draw()
  end
end

function Person:fireProjectile()
  local projectile = Projectile(self.reticle.x, self.reticle.y, self.reticleAngle, self.direction, self.weaponCharge.power)
  table.insert(self.projectiles, projectile)
end

function Person:canMove()
  return self.weaponCharge.power == 0
end

function Person:processInput(dt)
  if not(self:isTouchingGround()) then
    return
  end

  if love.keyboard.isDown('left') then
    self.direction = -1

    if self:canMove() then
      self.x = self.x + (self.movementSpeed * dt * self.direction)
    end
  elseif love.keyboard.isDown('right') then
    self.direction = 1

    if self:canMove() then
      self.x = self.x + (self.movementSpeed * dt * self.direction)
    end
  end

  if love.keyboard.isDown('up') then
    self.reticleAngle = self.reticleAngle - (self.reticleSpeed * dt)
  elseif love.keyboard.isDown('down') then
    self.reticleAngle = self.reticleAngle + (self.reticleSpeed * dt)
  end

  if love.keyboard.isDown('space') then
    self.weaponCharge:charge()
  else
    if(self.weaponCharge.power > 0) then
      self:fireProjectile()
    end
    self.weaponCharge:cancel()
  end

  self.reticleAngle = clamp(self.reticleMinAngle, self.reticleAngle, self.reticleMaxAngle)
  self.weaponCharge.angle = self.reticleAngle

  self:snapToGroundIfBelow()
end

function Person:processGravity(dt)
  local groundPoint = self.terrain:findHighestYPoint(self.x, self.width)
  local footPoint = self.y + self.height
  if footPoint < groundPoint - 1 then
    self:fall(dt)
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

function Person:fall(dt)
  self.downwardVelocity = self.downwardVelocity + (GRAVITY_ACCELERATION * dt)
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
