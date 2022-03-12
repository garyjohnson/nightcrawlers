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
end

function WeaponCharge:update()
  if self.power == 0 then
    self.topFarX = 0
    self.topFarY = 0
    self.bottomFarX = 0
    self.bottomFarY = 0
    self.endRadius = 0
    self.farX = 0
    self.farY = 0
    self.radiusWithJitter = 0

    self:setBounds(self.x - self.radius, self.y - self.radius, self.radius * 2, self.radius * 2)
    return
  end

  local jitter = 0
  if self.power == self.maxPower then
    jitter = (math.random() * 3) - 1.5
  end

  self.topFarX = self.radius + (self.power * self.direction * math.cos(self.angle - degToRad(10))) + jitter
  self.topFarY = self.radius + (self.power * math.sin(self.angle - degToRad(10))) + jitter
  self.bottomFarX = self.radius + (self.power * self.direction * math.cos(self.angle + degToRad(10))) + jitter
  self.bottomFarY = self.radius + (self.power * math.sin(self.angle + degToRad(10))) + jitter

  self.endRadius = distance(self.topFarX, self.topFarY, self.bottomFarX, self.bottomFarY) / 2
  self.farX = self.radius + (self.power * self.direction * math.cos(self.angle)) + jitter
  self.farY = self.radius + (self.power * math.sin(self.angle)) + jitter
  self.radiusWithJitter = self.radius + jitter
  self.radiusWithJitter = self.radius + jitter

  local minX = min(self.radiusWithJitter, self.topFarX, self.bottomFarX, self.farX, self.farX+self.endRadius)
  local maxX = max(self.radiusWithJitter, self.topFarX, self.bottomFarX, self.farX, self.farX+self.endRadius)
  local minY = min(self.radiusWithJitter, self.topFarY, self.bottomFarY, self.farY, self.farY+self.endRadius)
  local maxY = max(self.radiusWithJitter, self.topFarY, self.bottomFarY, self.farY, self.farY+self.endRadius)

  self:setBounds(self.x - self.radius, self.y - self.radius, maxX + 3, maxY + 3)
end

function WeaponCharge:draw(x, y, width, height)
  if self.power == 0 then
    return
  end

  gfx.pushContext()
  gfx.setClipRect( x, y, width, height )
  gfx.setColor(gfx.kColorWhite)

  gfx.fillPolygon(
    self.radiusWithJitter,
    self.radiusWithJitter,
    self.topFarX,
    self.topFarY,
    self.bottomFarX,
    self.bottomFarY
  )

  gfx.fillCircleAtPoint(self.farX, self.farY, self.endRadius)

  gfx.clearClipRect()
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

