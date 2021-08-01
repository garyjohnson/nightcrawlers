require "global_vars"
require "terrain"
require "background"
require "person"

function love.load()
  love.window.setMode(WIDTH, HEIGHT)
  love.window.setTitle("Rooty tooty run and shooty")

  terrain = Terrain()

  background = Background()
  person = Person(terrain)

  ditherShader = love.graphics.newShader("dither_shader.fs")
  shader = ditherShader
end

function love.update(dt)
  person:update(dt)
end

function love.keyreleased( key )
  if key == "r" then
    terrain:generate()
    person.y = 1
  end

  if key == "s" then
    if shader == nil then
      shader = ditherShader
    else
      shader = nil
    end
  end
end

function love.draw()
  love.graphics.setColor(WHITE)

  love.graphics.setShader(shader)

  love.graphics.draw(background.canvas)
  love.graphics.draw(terrain.canvas)

  person:draw()

  love.graphics.setShader()
end

