import "CoreLibs/object"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

import "global_vars"
import "entity"
import "bayer"

class('Background').extends(Entity)

function Background:init()
  Background.super.init(self)

  self.canvas = gfx.image.new(WIDTH, HEIGHT)

  self.step = 1
  self.startValue = 50
  self.endValue = 63
  self.startY = 0
  self.endY = HEIGHT/2.5

  bayer.generateFillLUT()

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

  gfx.setPattern(bayer.getFill(self.startValue))
  gfx.fillRect(0, 0, WIDTH, 0 + self.startY)

  gfx.setPattern(bayer.getFill(self.endValue))
  gfx.fillRect(0, self.endY, WIDTH, HEIGHT - self.endY)

  for y = self.startY, heightRange, self.step do
    colorValue = self.startValue + (stepValue * (y/self.step))
    gfx.setPattern(bayer.getFill(math.floor(colorValue)))
    gfx.fillRect(0, y, WIDTH, y + self.step)
  end
end
