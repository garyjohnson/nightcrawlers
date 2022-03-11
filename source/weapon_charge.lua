import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "math_utils"
import "entity"

local gfx <const> = playdate.graphics

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
  self.endRadius = 0
  self.visible = false

  self.radius = 50
  self.width = self.radius * 2
  self.height = self.radius * 2
  self:setImage(gfx.image.new(self.width, self.height))
end

function WeaponCharge:setVisible(visible)
  self.visible = visible
end

function WeaponCharge:update()
  WeaponCharge.super.update(self)

  self.farX = self.radius + (self.power * self.direction * math.cos(self.angle))
  self.farY = self.radius + (self.power * math.sin(self.angle))
  self.topFarX = self.radius + (self.power * self.direction * math.cos(self.angle - degToRad(10)))
  self.topFarY = self.radius + (self.power * math.sin(self.angle - degToRad(10)))
  self.bottomFarX = self.radius + (self.power * self.direction * math.cos(self.angle + degToRad(10)))
  self.bottomFarY = self.radius + (self.power * math.sin(self.angle + degToRad(10)))

  self.endRadius = distance(self.topFarX, self.topFarY, self.bottomFarX, self.bottomFarY) / 2 

  if self:isVisible() then
    self:draw()
  end
end

function WeaponCharge:draw()
  if self.power == 0 then
    gfx.pushContext(self:getImage())
    gfx.clear(gfx.kColorClear)
    gfx.popContext()
    return
  end

  local jitter = 0
  if self.power == self.maxPower then
    jitter = (math.random() * 3) - 1.5
  end

  gfx.pushContext(self:getImage())

  gfx.clear(gfx.kColorClear)
  gfx.setColor(gfx.kColorWhite)
  gfx.fillPolygon(
    self.radius + jitter,
    self.radius + jitter,
    self.topFarX + jitter,
    self.topFarY + jitter,
    self.bottomFarX + jitter,
    self.bottomFarY + jitter
  )
  gfx.fillCircleAtPoint(self.farX + jitter, self.farY + jitter, self.endRadius)

  gfx.popContext()
end

function WeaponCharge:cancel()
  self.power = 0
end

function WeaponCharge:charge()
  self.power = math.min(self.power + self.chargeSpeed, self.maxPower)
end

