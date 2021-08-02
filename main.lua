require "global_vars"
require "world"

function love.load()
  love.window.setMode(WIDTH, HEIGHT)
  love.window.setTitle("Rooty tooty run and shooty")

  world = World()

  globalShader = love.graphics.newShader("dither_shader.fs")
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  love.graphics.setShader(globalShader)

  world:draw()

  love.graphics.setShader()
end

function love.keyreleased(key)
  if key == "s" then
    if globalShader == nil then
      globalShader = love.graphics.newShader("dither_shader.fs")
    else
      globalShader = nil
    end
  end

  world:onKeyReleased(key)
end

