require "global_vars"
require "reticle"
require "weapon_charge"
require "projectile"
require "math_utils"
require "entity"

Person = Entity:extend()

function Person:new(world)
  Person.super.new(self)

  self.world = world

  self.reticle = Reticle()
  self.weaponCharge = WeaponCharge()

  self:addEntity(self.weaponCharge, 1)
  self:addEntity(self.reticle, 2)

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
  Person.super.update(self, dt)

  self:processInput(dt)
  self:processGravity(dt)

  self.reticle.x = self.x + (self.width / 2) + (self.reticleDistance * self.direction * math.cos(self.reticleAngle))
  self.reticle.y = self.y + 1 + (self.reticleDistance * math.sin(self.reticleAngle))

  self.weaponCharge.direction = self.direction
  self.weaponCharge.x = self.x + (self.width / 2)
  self.weaponCharge.y = self.y + 1
end

function Person:draw()
  Person.super.draw(self)

  self.weaponCharge:draw()
  self.reticle:draw()

  love.graphics.setColor(WHITE)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
  love.graphics.setColor(BLACK)
  love.graphics.rectangle('fill', self.x+1, self.y+1, self.width-2, self.height-2)

  love.graphics.setColor(WHITE)
  love.graphics.printf(self.name, self.x-20, self.y - 20, self.width+40, "center")
end


function Person:fireProjectile()
  function handleProjectileHit(projectile)
    self:removeEntity(projectile)
  end

  local projectile = Projectile(
    self.world,
    handleProjectileHit,
    self.x + (self.width / 2) + (self.direction*self.width/2),
    self.y,
    self.reticleAngle,
    self.direction,
    self.weaponCharge.power
  )
  self:addEntity(projectile)
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
  if not(self:isTouchingGround()) then
    self:fall(dt)
  else
    self.downwardVelocity = 0
    self:snapToGroundIfBelow()
  end
end

function Person:isTouchingGround()
  if self.y + self.height >= HEIGHT - 1 then
    return true
  end

  return self.world.terrain:isColliding(self.x, self.y + self.height + 1, self.width, 1)
end

function Person:fall(dt)
  self.downwardVelocity = self.downwardVelocity + (GRAVITY_ACCELERATION * dt)
  self.y = self.y + self.downwardVelocity

  self:snapToGroundIfBelow()
end

function Person:snapToGroundIfBelow()
  if self.y + self.height > HEIGHT then
    self.y = HEIGHT - self.height - 1
  end

  if self.y == HEIGHT - self.height - 1 or self.world.terrain:isColliding(self.x, self.y + self.height, self.width, 1) then
    self.y = self.world.terrain:getEmptyYPosAbove(self.x, self.y + self.height, self.width) - self.height
  end
end
