import "CoreLibs/object"
import "CoreLibs/graphics"
import "global_vars"
import "math_utils"
import "entity"
import "explosion_particle"

class('Explosion').extends(Entity)

function Explosion:init(world, originX, originY, particleCount)
  Explosion.super.init(self)

  self.world = world
  print("particleCount: " .. particleCount)
  self.particleCount = particleCount / 100

  for i = 0, particleCount, 1 do
    function handleProjectileHit(projectile)
      projectile:remove()
    end
    
    local direction = math.random(0,1) == 0 and -1 or 1

    local projectile = ExplosionParticle(
      world,
      handleProjectileHit,
      originX, 
      originY,
      math.random(-90, 90),
      direction,
      math.random(1, 40),
      1 --radius
    )

    projectile:add()
  end
end

