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

function Explosion:init(world, originX, originY, radius, angle, particleCount)
  Explosion.super.init(self)

  self.world = world
  self.particleCount = math.min(particleCount, 100)
  local particles = {}
  self.particles = particles

  for i = 1, self.particleCount + 1, 1 do
    local particle = {}
    local x = math.random(originX - radius, originX + radius)
    local y = math.random(originY - radius, originY + radius)
    local power = math.random(10, 25) * 8
    local particleAngle = angle + degToRad(math.random(-30, 90))
    local particleAngle = angle + degToRad(math.random(-30, 90))
    particle.x = x
    particle.y = y
    particle.logicalX = x
    particle.logicalY = y
    particle.angle = degToRad(math.random(-180, 0))
    particle.power = power
    particles[i] = particle
  end

  self.time = 0

  self:setBounds(0, 0, WIDTH, HEIGHT)
end

function Explosion:update()
  local time = self.time + deltaTime
  self.time = time

  for i = 1, #self.particles + 1, 1 do
    local particle = self.particles[i]

    if particle ~= nil then
      particle.logicalX = particle.x + (cos(particle.angle) * particle.power * time)
      particle.logicalY = particle.y + (sin(particle.angle) * particle.power * time + (GRAVITY_ACCELERATION * time * time)) -- / 2.0))

      if (particle.logicalX < 0 or particle.logicalX > WIDTH) and
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

  for i = 1, self.particleCount + 1, 1 do
    local particle = self.particles[i]

    if particle ~= nil then
      gfx.drawPixel(particle.logicalX, particle.logicalY)
    end
  end

  gfx.popContext()

  self:updateTransformedImage()
end
