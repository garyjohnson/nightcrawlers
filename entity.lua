Object = require "classic"
Entity = Object:extend()

function Entity:new()
  self.entities = {}
end

function Entity:update(dt)
  self:eachChild(function(entity)
    entity:update(dt)
  end)
end

function Entity:draw()
  self:eachChild(function(entity)
    entity:draw()
  end)
end

function Entity:onKeyReleased(key)
  self:eachChild(function(entity)
    entity:onKeyReleased(key)
  end)
end

function Entity:eachChild(func)
  for _, entity in pairs(self.entities) do
    func(entity[2])
  end
end

function Entity:addEntity(entity, zIndex)
  zIndex = zIndex or 0
  table.insert(self.entities, {zIndex, entity})
  table.sort(self.entities, function(a,b) return a[1] < b[1] end)
end

function Entity:removeEntity(entity)
  for i = #self.entities, 1, -1 do
    if self.entities[i][2] == entity then
      table.remove(self.entities, i)
      break
    end
  end
end
