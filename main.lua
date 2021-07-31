require "global_vars"
require "terrain"
require "background"

function love.load()
  love.window.setMode(WIDTH, HEIGHT)

  terrain = Terrain()
  terrain:generate()

  background = Background()

  ditherShader = love.graphics.newShader("dither_shader.fs")
end

function love.update()
end

function love.keyreleased( key )
  if key == "r" then
    terrain:generate()
  end
end

function love.draw()
  love.graphics.setBlendMode('alpha')
  love.graphics.setColor(WHITE)

  love.graphics.setShader(ditherShader)

  love.graphics.draw(background.canvas)
  love.graphics.draw(terrain.canvas)

  love.graphics.setShader()
end

