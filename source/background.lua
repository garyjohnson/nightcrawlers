import "CoreLibs/object"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

import "global_vars"
import "entity"

class('Background').extends(Entity)

function Background:init()
  Background.super.init(self)

  self.canvas = gfx.image.new(WIDTH, HEIGHT)

  self.step = 1
  self.startValue = 0.3
  self.endValue = 0
  self.startY = 0
  self.endY = HEIGHT/2.5

  self:generate()
end

function Background:draw()
  Background.super.draw(self)

  gfx.setColor(gfx.kColorWhite)
  self.canvas:draw(0,0)
end

function Background:generate()
  gfx.pushContext(self.canvas)
  gfx.clear(gfx.kColorWhite)

  local range = self.endValue - self.startValue
  local heightRange = self.endY - self.startY
  local stepValue = range / (heightRange / self.step)
  local colorValue = 0

  --gfx.setColor({ self.startValue, self.startValue, self.startValue })
  gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
  gfx.fillRect(0, 0, WIDTH, 0 + self.startY)

  --gfx.setColor({ self.endValue, self.endValue, self.endValue })
  gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
  gfx.fillRect(0, self.endY, WIDTH, HEIGHT - self.endY)

  for y = self.startY, heightRange, self.step do
    colorValue = self.startValue + (stepValue * (y/self.step))
    --gfx.setColor({ colorValue, colorValue, colorValue })
    gfx.setPattern({ 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55 })
    gfx.fillRect(0, y, WIDTH, y + self.step)
  end
end
