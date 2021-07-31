require "global_vars"
require "terrain"
require "background"
require "person"

function love.load()
  love.window.setMode(WIDTH, HEIGHT)

  terrain = Terrain()
  terrain:generate()

  background = Background()
  person = Person(terrain)

  ditherShader = love.graphics.newShader("dither_shader.fs")
end

function love.update()
  person:update()
end

function love.keyreleased( key )
  if key == "r" then
    terrain:generate()
  end
end

function love.draw()
  love.graphics.setColor(WHITE)

  love.graphics.setShader(ditherShader)

  love.graphics.draw(background.canvas)
  love.graphics.draw(terrain.canvas)

  person:draw()

  love.graphics.setShader()
end

