import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "entity"

local gfx <const> = playdate.graphics
local cos = math.cos
local sin = math.sin

class('ExplosionParticle').extends(Entity)

function generateImage()
  local image = gfx.image.new(2, 2)

  gfx.pushContext(image)
  gfx.setColor(gfx.kColorWhite)
  gfx.drawCircleAtPoint(1, 1, 1)
  gfx.popContext()

  return image
end

local img = generateImage()

function ExplosionParticle:init(world, hitCallback, x, y, angle, power)
  --print("angle: " .. angle)
  ExplosionParticle.super.init(self)

  self.world = world
  self.hitCallback = hitCallback

  self.originX = x
  self.originY = y
  self.angle = angle
  self.power = power * math.random(4, 10)
  self.time = 0
  self.halfLife = 4.0
  self.staleTime = 0--math.random(2, 10) / 100
  self.lastUpdate = nil

  self.cosAngleTimesPower = cos(angle) * self.power
  self.sinAngleTimesPower = sin(angle) * self.power

  self:setLogicalPos(x, y)
  self:setOriginalImage(img)
end

function ExplosionParticle:update()
  local time = self.time + deltaTime
  self.time = time

  local lastUpdate = self.lastUpdate
  if lastUpdate ~= nil and time - lastUpdate < self.staleTime then
    return
  end

  local power = self.power
  local angle = self.angle

  local logX = self.originX + (self.cosAngleTimesPower * time)
  local logY = self.originY + (self.sinAngleTimesPower * time + (GRAVITY_ACCELERATION * time * time)) -- / 2.0))
  self:setLogicalPos(logX, logY)

  if time > self.halfLife then
    self.hitCallback(self)
  end

  self.lastUpdate = time
end

function ExplosionParticle:generateImage()
  local image = gfx.image.new(1, 1)

  gfx.pushContext(image)
  gfx.setColor(gfx.kColorWhite)
  gfx.drawCircleAtPoint(1, 1, 0.5)
  gfx.popContext()

  return image
end
