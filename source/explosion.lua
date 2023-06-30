import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "math_utils"
import "camera_utils"
import "entity"

class('Explosion').extends(Entity)

local gfx <const> = playdate.graphics
local cos = math.cos
local sin = math.sin

function Explosion:init(world, originX, originY, radius, angle, particleCount, onComplete)
  Explosion.super.init(self)

  self.world = world
  self.particleCount = math.min(particleCount, 300)
  self.onComplete = onComplete
  self.halfLife = 2.5
  local particles = {}

  for i = 1, self.particleCount + 1, 1 do
    local x = math.random(originX - radius, originX + radius)
    local y = math.random(originY - radius, originY + radius)
    local angle = 0
    local power = 0
    if i < self.particleCount / 3 then
      -- 1/3 random spray
      angle = math.random(-300, 0) / 100.0
      power = math.random(10, 25) * 6
    else
      -- 2/3 larger center column blast
      angle = math.random(-200, -100) / 100.0
      power = math.random(10, 25) * 12
    end

    local particle = {
      x = x,
      y = y,
      logicalX = x,
      logicalY = y,
      angle = angle,
      power = power
    }
    particles[i] = particle
  end

  self.particles = particles
  self.time = 0

  self:setBounds(0, 0, WIDTH, HEIGHT)
end

function Explosion:update()
  local time = self.time + deltaTime
  self.time = time

  if self.time > self.halfLife then
    self.onComplete(self)
    return
  end

  for i = 1, #self.particles + 1, 1 do
    local particle = self.particles[i]

    if particle ~= nil then
      particle.logicalX = particle.x + (cos(particle.angle) * particle.power * time)
      particle.logicalY = particle.y + (sin(particle.angle) * particle.power * time + (GRAVITY_ACCELERATION * time * time)) -- / 2.0))

      if (particle.logicalX < 0 or particle.logicalX > WIDTH) or
        (particle.logicalY < 0 or particle.logicalY > HEIGHT) then
        self.particles[i] = nil
      end
    end
  end

  gfx.sprite.addDirtyRect(0, 0, WIDTH, HEIGHT)
  self:markDirty()
end

function Explosion:draw(x, y, width, height)
  gfx.pushContext()
  gfx.setColor(gfx.kColorWhite)
  gfx.setClipRect( x, y, width, height )

  for i = 1, #self.particles + 1, 1 do
    local particle = self.particles[i]

    if particle ~= nil then
      gfx.drawPixel(cameraTransformPoint(particle.logicalX, particle.logicalY))
    end
  end

  gfx.popContext()
end
