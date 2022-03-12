import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "math_utils"
import "entity"

local gfx <const> = playdate.graphics

class('WeaponCharge').extends(Entity)

function WeaponCharge:init()
  WeaponCharge.super.init(self)

  self.direction = 1
  self.angle = 0
  self.power = 0
  self.maxPower = 40
  self.chargeSpeed = 1
  self.radius = 50

  self:setBounds(0, 0, self.radius + self.maxPower, self.radius + self.maxPower)
end

function WeaponCharge:draw()
  if self.power == 0 then
    return
  end

  local jitter = 0
  if self.power == self.maxPower then
    jitter = (math.random() * 3) - 1.5
  end

  gfx.pushContext()
  gfx.setColor(gfx.kColorWhite)

  local x = 0
  local y = 0
  
  local topFarX = x + self.radius + (self.power * self.direction * math.cos(self.angle - degToRad(10)))
  local topFarY = y + self.radius + (self.power * math.sin(self.angle - degToRad(10)))
  local bottomFarX = x + self.radius + (self.power * self.direction * math.cos(self.angle + degToRad(10)))
  local bottomFarY = y + self.radius + (self.power * math.sin(self.angle + degToRad(10)))
  gfx.fillPolygon(
    x + self.radius + jitter,
    y + self.radius + jitter,
    topFarX + jitter,
    topFarY + jitter,
    bottomFarX + jitter,
    bottomFarY + jitter
  )

  local farX = x + self.radius + (self.power * self.direction * math.cos(self.angle))
  local farY = y + self.radius + (self.power * math.sin(self.angle))
  local endRadius = distance(topFarX, topFarY, bottomFarX, bottomFarY) / 2 
  gfx.fillCircleAtPoint(farX + jitter, farY + jitter, endRadius)

  gfx.popContext()
end

function WeaponCharge:cancel()
  self.power = 0
  self:markDirty()
end

function WeaponCharge:charge()
  self.power = math.min(self.power + self.chargeSpeed, self.maxPower)
  self:markDirty()
end

