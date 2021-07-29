require "global_vars"
require "terrain"

function love.load()
  love.window.setMode(WIDTH, HEIGHT)

  terrain = Terrain()
  terrain:generate()

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
  love.graphics.setShader(ditherShader)
  love.graphics.setColor(TRUE_WHITE)
  love.graphics.draw(terrain.canvas)
end

