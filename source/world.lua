import "CoreLibs/object"
import "CoreLibs/graphics"

import "global_vars"
import "entity"
import "terrain"
import "background"
import "person"
import "water"

local gfx <const> = playdate.graphics

class('World').extends(Entity)

function World:init()
  World.super.init(self)

  self.terrain = Terrain()
  self.person = Person(self)
  self.water = Water()

  self:addEntity(Background(), 1)
  self:addEntity(self.terrain, 2)
  self:addEntity(self.person, 3)
  self:addEntity(self.water, 4)
end

function World:update(dt)
  World.super.update(self, dt)
end

function World:onKeyReleased(key)
  World.super.onKeyReleased(self, key)

  if key == "r" then
    self.terrain:generate()
    self.person.y = 1
  end
end
