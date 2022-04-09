import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/animator"
import "CoreLibs/easing"
import "global_vars"
import "math_utils"
import "entity"
import "bayer"

local gfx <const> = playdate.graphics

class('Water').extends(Entity)

function Water:init()
  Water.super.init(self)

  self.height = 15
  self.outlineStroke = 1
  self.waveIntensity = 3
  self.waveWidth = 75

  -- we draw the wave a little below the screen extent so that there
  -- are no gaps in the bottom from the sine wave
  self.animator = gfx.animator.new(3000, 0, self.waveWidth, playdate.easingFunctions.inOutSine)
  self.animator.repeatCount = -1

  self:setOriginalImage(self:generateImage())
  self:setCenter(0, 0)
  self:setLogicalPos(0, HEIGHT-self.height)
end

function Water:update()
  local value = self.animator:currentValue()
  local evenValue = value - (value % 2)
  self:setLogicalPos(-evenValue, HEIGHT-self.height)
end

function Water:generateImage()
  local image = gfx.image.new(WIDTH * 2, self.height + self.waveIntensity)

  gfx.pushContext(image)
  gfx.clear(gfx.kColorClear)
  gfx.setPattern({
    0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, -- pattern, all black
    0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa  -- alpha mask, alternating transparent and solid (water transparency)
  })
  gfx.fillRect(0, (self.waveIntensity * 2) + self.outlineStroke, WIDTH * 2, HEIGHT)

  for y = self.waveIntensity + self.outlineStroke - 1, self.waveIntensity * 3, 1 do
    gfx.drawSineWave(0, y, WIDTH * 2, y, self.waveIntensity, self.waveIntensity, self.waveWidth)
  end

  gfx.setColor(gfx.kColorWhite)
  for y = self.waveIntensity, self.waveIntensity + self.outlineStroke - 1, 1 do
    gfx.drawSineWave(0, y, WIDTH * 2, y, self.waveIntensity, self.waveIntensity, self.waveWidth)
  end

  gfx.popContext()

  return image
end
