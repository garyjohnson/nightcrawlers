import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "global_vars"
import "reticle"
import "weapon_charge"
import "projectile"
import "math_utils"
import "entity"

local gfx <const> = playdate.graphics

class('Person').extends(Entity)

function Person:init(world)
  Person.super.init(self)

  self.world = world

  self.reticle = Reticle()
  self.reticle:setZIndex(self:getZIndex() + 90)
  self.reticle:add()

  self.weaponCharge = WeaponCharge()
  self.weaponCharge:setZIndex(self:getZIndex() + 100)
  self.weaponCharge:moveTo(self.x + (self.width / 2), self.y + 1)
  self.weaponCharge:add()

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

  self.crankMultiplier = 0.005

  self:setImage(self:generateImage())
  self:setCenter(0, 0)
  self:moveTo(100, 1)
end

function Person:setZIndex(zIndex)
  Person.super.setZIndex(self, zIndex)
  self.reticle:setZIndex(zIndex + 90)
  self.weaponCharge:setZIndex(zIndex + 100)
end

function Person:update()
  Person.super.update(self)

  local dt = playdate.getElapsedTime()
  self:processInput(dt)
  self:processGravity(dt)

  self:moveTo(self.x, self.y)

  self.reticle:setVisible(not(playdate.isCrankDocked()))
  if self.reticle:isVisible() then
    self.reticle.x = round(self.x + (self.width / 2) + (self.reticleDistance * self.direction * math.cos(self.reticleAngle)))
    self.reticle.y = round(self.y + 1 + (self.reticleDistance * math.sin(self.reticleAngle)))
  end

  self.weaponCharge:setVisible(not(playdate.isCrankDocked()) or self.weaponCharge.power == 0)
  if self.weaponCharge:isVisible() then
    self.weaponCharge.direction = self.direction
    self.weaponCharge:moveTo(self.x + (self.width / 2), self.y + 1)
  end
end

function Person:generateImage()
  local image = gfx.image.new(self.width, self.height)
  gfx.pushContext(image)

  gfx.setColor(gfx.kColorWhite)
  gfx.fillRect(0, 0, self.width, self.height)
  gfx.setColor(gfx.kColorBlack)
  gfx.fillRect(1, 1, self.width-2, self.height-2)

  --gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  --gfx.drawTextAligned(self.name, self.x + (self.width/2), self.y - 20, kTextAlignment.center)
  --gfx.setImageDrawMode(gfx.kDrawModeCopy)

  gfx.popContext()

  return image
end


function Person:fireProjectile()
  function handleProjectileHit(projectile)
    projectile:remove()
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

  projectile:add()
end

function Person:canMove()
  return self.weaponCharge.power == 0 or not(self:isTouchingGround())
end

function Person:move(dt)
  if not(self:canMove()) then
    print("move: can't move!")
    return
  end

  local desiredX = self.x + (self.movementSpeed * dt * self.direction)

  local topY = self.world.terrain:findHighestYPoint(desiredX, self.y, self.width, self.height)
  if topY == nil then
    topY = self.y
  end

  local maxClimb = 6

  if ((topY-self.height) - self.y) < maxClimb then
    if not(self.world.terrain:isColliding(desiredX, topY-self.height, self.width, self.height)) then
      self.x = desiredX
      self.y = topY
    else
      print("move:colliding at desired position!")
    end
  else
    print("move:above max climb!")
  end
end

function Person:fall(dt)
  self.downwardVelocity = self.downwardVelocity + (GRAVITY_ACCELERATION * dt)
  self.y = self.y + self.downwardVelocity

  self:snapToGroundIfBelow()
end

function Person:processInput(dt, direction)
  if not(self:isTouchingGround()) then
    return
  end

  self.reticle.hidden = playdate.isCrankDocked()
  self.reticle.hidden = playdate.isCrankDocked()

  if playdate.buttonIsPressed(playdate.kButtonLeft) then
    self.direction = -1
    self:move(dt)
  elseif playdate.buttonIsPressed(playdate.kButtonRight) then
    self.direction = 1
    self:move(dt)
  end

  --if playdate.buttonIsPressed(playdate.kButtonUp) then
  --  self.reticleAngle = self.reticleAngle - (self.reticleSpeed * dt)
  --elseif playdate.buttonIsPressed(playdate.kButtonDown) then
  --  self.reticleAngle = self.reticleAngle + (self.reticleSpeed * dt)
  --end
  
  if playdate.isCrankDocked() == false then
    local change, _ = playdate.getCrankChange()
    self.reticleAngle = self.reticleAngle + (change * self.crankMultiplier * self.direction)
    if self.reticleAngle < degToRad(-90) or self.reticleAngle > degToRad(90) then 
      self.direction = self.direction * -1
    end

    if playdate.buttonIsPressed(playdate.kButtonA) then
      self.weaponCharge:charge()
    else
      if(self.weaponCharge.power > 0) then
        self:fireProjectile()
        self.weaponCharge:cancel()
      end
    end
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

  t = self.world.terrain:isColliding(self.x, self.y + self.height, self.width, 1)
  if not(t) then
    print("is not touching ground at " .. self.y + self.height)
  end
  return t
end

function Person:snapToGroundIfBelow()
  if self.y + self.height >= HEIGHT then
    print("snap to floor")
    self.y = HEIGHT - self.height - 1
    return
  end

  if self.world.terrain:isColliding(self.x, self.y, self.width, self.height) then
    local yPosAbove = self.world.terrain:getEmptyYPosAbove(self.x, self.y + self.height, self.width)
    if yPosAbove == nil then
      print("yPosAbove nil, x:" .. self.x .. " y:" .. self.y .. " width:" .. self.width .. " height:" .. self.height)
      return
    end
    self.y = yPosAbove - self.height
  end
end
