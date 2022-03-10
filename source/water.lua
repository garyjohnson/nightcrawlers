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

  self.startY = HEIGHT-self.height
  self.x = 0
  self.y = self.startY

  bayer.generateFillLUT()

  -- we draw the wave a little below the screen extent so that there
  -- are no gaps in the bottom from the sine wave
  self.canvas = gfx.image.new(WIDTH * 2, self.height + self.waveIntensity) 

  self.animator = gfx.animator.new(3000, 0, self.waveWidth, playdate.easingFunctions.inOutSine)
  self.animator.repeatCount = -1
end

function Water:draw()
  Water.super.draw(self)

  gfx.pushContext(self.canvas)
  gfx.clear(gfx.kColorClear)

  gfx.setPattern(bayer.getFill(47))

  gfx.fillRect(0, (self.waveIntensity * 2) + self.outlineStroke, WIDTH * 2, HEIGHT)

  for y = self.waveIntensity + self.outlineStroke - 1, self.waveIntensity * 3, 1 do
    gfx.drawSineWave(-self.animator:currentValue(), y, WIDTH * 2, y, self.waveIntensity, self.waveIntensity, self.waveWidth)
  end

  gfx.setColor(gfx.kColorWhite)
  for y = self.waveIntensity, self.waveIntensity + self.outlineStroke - 1, 1 do
    gfx.drawSineWave(-self.animator:currentValue(), y, WIDTH * 2, y, self.waveIntensity, self.waveIntensity, self.waveWidth)
  end
  

  gfx.popContext()

  self.canvas:draw(self.x, self.y)
end
