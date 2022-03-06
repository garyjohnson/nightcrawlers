import "CoreLibs/object"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

import "global_vars"
import "math_utils"
import "entity"

class('WeaponCharge').extends(Entity)

function WeaponCharge:init()
  WeaponCharge.super.init(self)

  self.x = 0
  self.y = 0
  self.direction = 1
  self.angle = 0
  self.power = 0
  self.maxPower = 40
  self.chargeSpeed = 1

  self.farX = 0
  self.farY = 0
  self.topFarX = 0
  self.topFarY = 0
  self.bottomFarX = 0
  self.bottomFarY = 0
  self.radius = 0
end

function WeaponCharge:update(dt)
  WeaponCharge.super.update(self, dt)

  self.farX = self.x + (self.power * self.direction * math.cos(self.angle))
  self.farY = self.y + (self.power * math.sin(self.angle))
  self.topFarX = self.x + (self.power * self.direction * math.cos(self.angle - degToRad(10)))
  self.topFarY = self.y + (self.power * math.sin(self.angle - degToRad(10)))
  self.bottomFarX = self.x + (self.power * self.direction * math.cos(self.angle + degToRad(10)))
  self.bottomFarY = self.y + (self.power * math.sin(self.angle + degToRad(10)))

  self.radius = distance(self.topFarX, self.topFarY, self.bottomFarX, self.bottomFarY) / 2 
end

function WeaponCharge:draw()
  WeaponCharge.super.draw(self)

  if self.power == 0 then
    return
  end

  local jitter = 0
  if self.power == self.maxPower then
    jitter = (math.random() * 3) - 1.5
  end

  gfx.setColor(gfx.kColorWhite)
  gfx.fillPolygon(
    self.x + jitter,
    self.y + jitter,
    self.topFarX + jitter,
    self.topFarY + jitter,
    self.bottomFarX + jitter,
    self.bottomFarY + jitter
  )
  gfx.fillCircleAtPoint(self.farX + jitter, self.farY + jitter, self.radius)
end

function WeaponCharge:cancel()
  self.power = 0
end

function WeaponCharge:charge()
  self.power = math.min(self.power + self.chargeSpeed, self.maxPower)
end

