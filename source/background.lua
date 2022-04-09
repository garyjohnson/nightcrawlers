import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "global_vars"
import "bayer"
import "camera_utils"

local gfx <const> = playdate.graphics

class('Background').extends(Object)

function Background:init()
  Background.super.init(self)

  self.canvas = gfx.image.new(WIDTH, HEIGHT)

  self.step = 1
  self.startValue = 50
  self.endValue = 63
  self.startY = 0
  self.endY = HEIGHT/2.5

  self:generate()
end

function Background:draw(x, y, width, height)
  gfx.pushContext()

  gfx.setClipRect(cameraTransformRect(x, y, width, height))
  local drawOrigin = cameraTransformPoint(CENTER.x, CENTER.y)
  self.canvas:drawWithTransform(getCameraTransform(), drawOrigin.x, drawOrigin.y)

  gfx.clearClipRect()
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

  gfx.popContext()
end
