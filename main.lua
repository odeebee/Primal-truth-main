require "levelData"
require "player"

flux = require "flux"

scale = 0
levelNum = 1
movingChecker = 0

function love.load()
    love.window.setTitle("Primal truth")
    scale = levelData.levelScales[levelNum]
    love.window.setMode(800,800)
    levelData.levelName = levelData.levels[1]
    loadBgs()
end

function love.draw()
    love.graphics.draw(levelData.levels[levelNum],0,0)

    love.graphics.print(player.x-player.width/2)

    love.graphics.rectangle("fill",
                            player.x,
                            player.y,
                            player.width*scale,
                            player.height*scale)
end

function love.update(deltatime)
    --Checks for player movement
    if(movingChecker ~= player.x) then
        player.moving = true
    else
        player.moving = false
    end
    movingChecker = player.x

    --Updates flux clock
    flux.update(deltatime)
end

function love.keypressed(key)
    if key == "space" then
        levelNum = levelNum + 1
    end
end

function love.mousepressed(x,y,button,istouch)
    if button == 1 then
        if player.moving == false then
            flux.to(player, 10, {x=player.x, x=x-player.width/2})
        end
    end
end

function loadBgs()
    forest_entrance = love.graphics.newImage("Pictures/Levels/Forest_entrance.png")
    levelData.levels[1] = forest_entrance

    forest_wall = love.graphics.newImage("Pictures/Levels/Forest_Wall.png")
    levelData.levels[2] = forest_wall

    forest_gate = love.graphics.newImage("Pictures/Levels/Forest_Gate.png")
    levelData.levels[3] = forest_gate

    forest_shed = love.graphics.newImage("Pictures/Levels/Forest_Shed.png")
    levelData.levels[4] = forest_shed

end