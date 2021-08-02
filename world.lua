require "global_vars"
require "entity"
require "terrain"
require "background"
require "person"

World = Entity:extend()

function World:new()
  World.super.new(self)

  self.terrain = Terrain()
  self.person = Person(self)

  self:addEntity(Background(), 1)
  self:addEntity(self.terrain, 2)
  self:addEntity(self.person, 3)
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