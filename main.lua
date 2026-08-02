require "levelData"
require "player"

flux = require "flux"

scale = 0
levelNum = 1
movingChecker = 0

canMove = false
canMoveBack = false

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
    love.graphics.print(tostring(#levelData.levelHighlighters[1]),0,25)
    

    love.graphics.rectangle("fill",
                            player.x,
                            player.y,
                            player.width*scale,
                            player.height*scale)

    --How to read level highlighters
    --[Level][Highlighter][x / y / w / l / opacity]
    --#levelData.levelHighlighters[1] Gives us ammount of highlighters in level

        for i=1,#levelData.levelHighlighters[levelNum] do 
            love.graphics.setColor(255,255,255,levelData.levelHighlighters[levelNum][i][5])
            love.graphics.rectangle("fill",levelData.levelHighlighters[levelNum][i][1]
                                        ,levelData.levelHighlighters[levelNum][i][2]
                                        ,levelData.levelHighlighters[levelNum][i][3]
                                        ,levelData.levelHighlighters[levelNum][i][4])
            love.graphics.setColor(255,255,255)
        end


    
end

function love.update(deltatime)
    --Checks for player movement
    if(movingChecker ~= player.x) then
        player.moving = true
    else
        player.moving = false
    end
    movingChecker = player.x

    --Checks for position for level movement
    if(player.x > 600 and levelNum ~= #(levelData.levels)) then
        canMove = true
    else
        canMove = false
    end

    if(player.x < 100 and levelNum > 1) then
        canMoveBack = true
    else
        canMoveBack = false
    end

    --Updates flux clock
    flux.update(deltatime)
end

function love.keypressed(key)
    if key == "space" then
        if canMove == true then
            levelNum = levelNum + 1
            player.x = 0
        end
        
        if canMoveBack == true then
            levelNum = levelNum - 1
            player.x = 0
        end
    end
end

function love.mousepressed(x,y,button,istouch)
    if button == 1 then
        if player.moving == false then
            flux.to(player, 1, {x=player.x, x=x-player.width/2})
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