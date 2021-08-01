require "global_vars"
require "math_utils"

Object = require "classic"
WeaponCharge = Object:extend()

function WeaponCharge:new()
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

function WeaponCharge:cancel()
  self.power = 0
end

function WeaponCharge:charge()
  self.power = math.min(self.power + self.chargeSpeed, self.maxPower)
end

function WeaponCharge:update(dt)
  self.farX = self.x + (self.power * self.direction * math.cos(self.angle))
  self.farY = self.y + (self.power * math.sin(self.angle))
  self.topFarX = self.x + (self.power * self.direction * math.cos(self.angle - degToRad(10)))
  self.topFarY = self.y + (self.power * math.sin(self.angle - degToRad(10)))
  self.bottomFarX = self.x + (self.power * self.direction * math.cos(self.angle + degToRad(10)))
  self.bottomFarY = self.y + (self.power * math.sin(self.angle + degToRad(10)))

  self.radius = distance(self.topFarX, self.topFarY, self.bottomFarX, self.bottomFarY) / 2 
end

function WeaponCharge:draw()
  if self.power == 0 then
    return
  end

  local jitter = 0
  if self.power == self.maxPower then
    jitter = (love.math.random() * 3) - 1.5
  end

  love.graphics.setColor(DARK_GREY)
  love.graphics.polygon(
    'fill',
    self.x + jitter,
    self.y + jitter,
    self.topFarX + jitter,
    self.topFarY + jitter,
    self.bottomFarX + jitter,
    self.bottomFarY + jitter
  )
  love.graphics.circle('fill', self.farX + jitter, self.farY + jitter, self.radius)
end
