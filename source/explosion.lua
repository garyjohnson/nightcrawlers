import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "math_utils"
import "entity"
import "explosion_particle"

class('Explosion').extends(Entity)

function Explosion:init(world, originX, originY, radius, angle, particleCount)
  Explosion.super.init(self)

  self.world = world
  print("particleCount: " .. particleCount)
  self.particleCount = math.min(particleCount, 50)
  print("real particleCount: " .. self.particleCount)
  self.remainingParticles = 0

  playdate.graphics.sprite.setAlwaysRedraw(true)
  print("setAlwaysRedraw=true")

  for i = 1, self.particleCount + 1, 1 do
    function handleParticleHit(particle)
      particle:remove()
      self.remainingParticles -= 1

      if self.remainingParticles == 0 then
        print("setAlwaysRedraw=false")
        playdate.graphics.sprite.setAlwaysRedraw(false)
      end
    end
    
    local particle = ExplosionParticle(
      world,
      handleParticleHit,
      math.random(originX - radius, originX + radius),
      math.random(originY - radius, originY + radius),
      angle + degToRad(math.random(-30, 30)),
      math.random(10, 25)
    )

    self.remainingParticles += 1
    particle:add()
  end
end

