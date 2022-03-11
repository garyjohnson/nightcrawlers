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

  bayer.generateFillLUT()

  -- we draw the wave a little below the screen extent so that there
  -- are no gaps in the bottom from the sine wave
  self.animator = gfx.animator.new(3000, 0, self.waveWidth, playdate.easingFunctions.inOutSine)
  self.animator.repeatCount = -1

  self:setImage(gfx.image.new(WIDTH * 2, self.height + self.waveIntensity))
  self:setCenter(0, 0)
  self:moveTo(0, HEIGHT-self.height)
end

function Water:update()
  Water.super.update(self)

  self:draw()
end

function Water:draw()
  gfx.pushContext(self:getImage())
  gfx.clear(gfx.kColorClear)
  gfx.setPattern({
    0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, -- pattern, all black
    0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa  -- alpha mask, alternating transparent and solid (water transparency)
  })
  gfx.fillRect(-self.animator:currentValue(), (self.waveIntensity * 2) + self.outlineStroke, WIDTH * 2, HEIGHT)

  for y = self.waveIntensity + self.outlineStroke - 1, self.waveIntensity * 3, 1 do
    gfx.drawSineWave(-self.animator:currentValue(), y, WIDTH * 2, y, self.waveIntensity, self.waveIntensity, self.waveWidth)
  end

  gfx.setColor(gfx.kColorWhite)
  for y = self.waveIntensity, self.waveIntensity + self.outlineStroke - 1, 1 do
    gfx.drawSineWave(-self.animator:currentValue(), y, WIDTH * 2, y, self.waveIntensity, self.waveIntensity, self.waveWidth)
  end

  gfx.popContext()

  return image
end
