require "levelData"
require "player"

scale = 1.5
levelNum = 1

function love.load()
    love.window.setMode(800,800)
    levelData.levelName = levelData.levels[1]
    forest_entrance = love.graphics.newImage("Pictures/Levels/Forest_entrance.png")
    levelData.levels[1] = forest_entrance
    forest_1 = love.graphics.newImage("Pictures/Levels/Forest_1.png")
    levelData.levels[2] = forest_1
    player.y = levelData.levelFloor[1]/scale
end

function love.draw()
    love.graphics.draw(levelData.levels[levelNum],0,0)
    -- love.graphics.rectangle("fill",
    --                         player.x,
    --                         player.y,
    --                         player.width*scale,
    --                         player.height*scale)
end

function love.update()
    scale = scale - scale / 800
    --player.x = player.x + 1
end

function love.keypressed(key)
    if key == "space" then
        levelNum = levelNum + 1
    end
end