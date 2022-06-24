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

  self.logicalWidth = 8
  self.logicalHeight = 16
  self.name = "Gary"

  self.reticle = Reticle()
  self.reticle:setZIndex(self:getZIndex() + 90)
  self.reticle:add()

  self.weaponCharge = WeaponCharge()
  self.weaponCharge:setZIndex(self:getZIndex() + 100)
  self.weaponCharge:setLogicalPos(self.logicalX + (self.logicalWidth / 2), self.logicalY + 1)
  self.weaponCharge:add()


  self.movementSpeed = 25
  self.direction = 1

  self.reticleDistance = 30
  self.reticleSpeed = degToRad(50)
  self.reticleAngle = degToRad(0)
  self.reticleMinAngle = degToRad(-90)
  self.reticleMaxAngle = degToRad(90)

  self.crankMultiplier = 0.005

  self:resetMidairVars()

  self:setOriginalImage(self:generateImage())
  self:setCenter(0, 0)
  self:setLogicalPos(100, 1)
end

function Person:fall()
  print('falling!')
  self.midairState = 'falling'
  self.midairTime = 0
  self.midairAngle = degToRad(90)
  self.midairVelocity = 300
  self.midairOriginX = self.logicalX
  self.midairOriginY = self.logicalY
end

function Person:jump()
  print('jumping!')
  self.midairState = 'jumping'
  self.midairTime = 0
  self.midairAngle = degToRad(310)
  -- what is this in units? pixels per second?
  self.midairVelocity = 70
  self.logicalY = self.logicalY - 1
  self.midairOriginX = self.logicalX
  self.midairOriginY = self.logicalY
  -- need to kick off the ground
  -- or we'll be considered landed
end

function Person:resetMidairVars()
  print('not in midair anymore!')
  self.midairState = 'none'
  self.midairTime = 0
  self.midairAngle = degToRad(0)
  self.midairVelocity = 0
  self.midairOriginX = 0
  self.midairOriginY = 0
end

function Person:isJumping()
  return self.midairState == 'jumping'
end

function Person:isFalling()
  return self.midairState == 'falling'
end

function Person:isJumpingOrFalling()
  return self:isJumping() or self:isFalling()
end

function Person:processMidairMovement(dt)
  local isTouchingGround = self:isTouchingGround()

  if self:isJumpingOrFalling() then
    self.midairTime = self.midairTime + dt
  end

  if not(isTouchingGround) and not(self:isJumpingOrFalling()) then
    self:fall()
  end

  if not(isTouchingGround) then
    self.logicalX = self.midairOriginX + (self.midairVelocity * math.cos(self.midairAngle) * self.midairTime * self.direction)
    self.logicalY = self.midairOriginY + (self.midairVelocity * math.sin(self.midairAngle) * self.midairTime + (GRAVITY_ACCELERATION * self.midairTime * self.midairTime / 2.0))
  elseif self:isJumpingOrFalling() then
    self:resetMidairVars()
  end

  self:snapToGroundIfBelow()
end

function Person:setZIndex(zIndex)
  Person.super.setZIndex(self, zIndex)
  self.reticle:setZIndex(zIndex + 90)
  self.weaponCharge:setZIndex(zIndex + 100)
end

function Person:update()
  local dt = playdate.getElapsedTime()
  self:processMidairMovement(dt)
  self:processInput(dt)

  self:setLogicalPos(self.logicalX, self.logicalY)
  world.camera:panTo(self.logicalX, self.logicalY)

  self.reticle:setVisible(not(playdate.isCrankDocked()))
  if self.reticle:isVisible() then
    self.reticle.x = round(self.logicalX + (self.logicalWidth / 2) + (self.reticleDistance * self.direction * math.cos(self.reticleAngle)))
    self.reticle.y = round(self.logicalY + 1 + (self.reticleDistance * math.sin(self.reticleAngle)))
  end

  self.weaponCharge:setVisible(not(playdate.isCrankDocked()) or self.weaponCharge.power > 0)
  if self.weaponCharge:isVisible() then
    self.weaponCharge.direction = self.direction
    self.weaponCharge:setLogicalPos(self.logicalX + (self.logicalWidth / 2), self.logicalY + 1)
  end
end

function Person:generateImage()
  local image = gfx.image.new(self.logicalWidth, self.logicalHeight)
  gfx.pushContext(image)

  gfx.setColor(gfx.kColorWhite)
  gfx.fillRect(0, 0, self.logicalWidth, self.logicalHeight)
  gfx.setColor(gfx.kColorBlack)
  gfx.fillRect(1, 1, self.logicalWidth-2, self.logicalHeight-2)

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
    self.logicalX + (self.logicalWidth / 2) + (self.direction*self.logicalWidth/2),
    self.logicalY,
    self.reticleAngle,
    self.direction,
    self.weaponCharge.power
  )

  projectile:add()
end

function Person:canMove()
  return self.weaponCharge.power == 0 or not(self:isJumpingOrFalling())
end

function Person:move(dt)
  if not(self:canMove()) then
    print("move: can't move!")
    return
  end

  local desiredX = self.logicalX + (self.movementSpeed * dt * self.direction)

  local topY = self.world.terrain:findHighestYPoint(desiredX, self.logicalY, self.logicalWidth, self.logicalHeight)
  if topY == nil then
    topY = self.logicalY
  end

  local maxClimb = 6

  if ((topY-self.logicalHeight) - self.logicalY) < maxClimb then
    if not(self.world.terrain:isColliding(desiredX, topY-self.logicalHeight, self.logicalWidth, self.logicalHeight)) then
      self:setLogicalPos(desiredX, topY)
    else
      print("move:colliding at desired position!")
    end
  else
    print("move:above max climb!")
  end
end

function Person:processInput(dt, direction)
  if self:isJumpingOrFalling() then
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

  if playdate.buttonIsPressed(playdate.kButtonA) then
    self:jump()
  end

  if playdate.isCrankDocked() == false then
    local change, _ = playdate.getCrankChange()
    self.reticleAngle = self.reticleAngle + (change * self.crankMultiplier * self.direction)
    if self.reticleAngle < degToRad(-90) or self.reticleAngle > degToRad(90) then 
      self.direction = self.direction * -1
    end

    if playdate.buttonIsPressed(playdate.kButtonB) then
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

function Person:isTouchingGround()
  if self.logicalY + self.logicalHeight >= HEIGHT - 1 then
    return true
  end

  t = self.world.terrain:isColliding(self.logicalX, self.logicalY + self.logicalHeight, self.logicalWidth, 1)
  if not(t) then
    print("is not touching ground at " .. self.logicalY + self.logicalHeight)
  end
  return t
end

function Person:snapToGroundIfBelow()
  if self.logicalY + self.logicalHeight >= HEIGHT then
    print("snap to floor")
    self:setLogicalPos(self.logicalX, HEIGHT - self.logicalHeight - 1)
    return
  end

  if self.world.terrain:isColliding(self.logicalX, self.logicalY, self.logicalWidth, self.logicalHeight) then
    local yPosAbove = self.world.terrain:getEmptyYPosAbove(self.logicalX, self.logicalY + self.logicalHeight, self.logicalWidth)
    if yPosAbove == nil then
      print("yPosAbove nil, x:" .. self.logicalX .. " y:" .. self.logicalY .. " width:" .. self.logicalWidth .. " height:" .. self.logicalHeight)
      return
    end
    self:setLogicalPos(self.logicalX, yPosAbove - self.logicalHeight)
  end
end
