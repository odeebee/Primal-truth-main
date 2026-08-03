require "levelData"
require "player"
require "helper"

flux = require "flux"

scale = 0
levelNum = 1
movingChecker = 0

canMove = false
canMoveBack = false

mouseX = 0
mouseY = 0

mouseInArea = false

function love.load()
    love.window.setTitle("Primal truth")
    scale = levelData.levelScales[levelNum]
    love.window.setMode(800,800)
    levelData.levelName = levelData.levels[1]
    loadBgs()
end

function love.draw()
    --Debugging prints
    love.graphics.setColor(255,255,255,1)
    
    --BACKGROUND LAYER
    love.graphics.draw(levelData.levels[levelNum],0,0)

    --DRAW FROM HERE
    love.graphics.print(tostring(love.mouse.getPosition()))
    local x,y = love.mouse.getPosition()

    love.graphics.rectangle("fill",
                            player.x,
                            player.y,
                            player.width*scale,
                            player.height*scale)

    --Draws level highlighters

    --How to read level highlighters
    --[Level][Highlighter][x / y / w / l / opacity / mouse]
    for i=1,#levelData.levelHighlighters[levelNum] do 
        love.graphics.setColor(255,255,255,levelData.levelHighlighters[levelNum][i][5])
        love.graphics.rectangle("fill",levelData.levelHighlighters[levelNum][i][1]
                                    ,levelData.levelHighlighters[levelNum][i][2]
                                    ,levelData.levelHighlighters[levelNum][i][3]
                                    ,levelData.levelHighlighters[levelNum][i][4])
        love.graphics.setColor(255,255,255,1)
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

    --Checks if mouse is in highlighter areas
    local x,y = love.mouse.getPosition()
    for k=1,#levelData.levelHighlighters[levelNum] do
        if(isMouseInRect(x,y,levelData.levelHighlighters[levelNum][k][1],levelData.levelHighlighters[levelNum][k][2],levelData.levelHighlighters[levelNum][k][3],levelData.levelHighlighters[levelNum][k][4])) then
            levelData.levelHighlighters[levelNum][k][6] = true
        else
            levelData.levelHighlighters[levelNum][k][6] = false
        end
    end

    --Adjusts opacity for highliters 
    for i=1,#levelData.levelHighlighters[levelNum] do
        local mOver = levelData.levelHighlighters[levelNum][i][6]
        local currOp = levelData.levelHighlighters[levelNum][i][5]
        if levelData.levelHighlighters[levelNum][i][6] == true then
            if levelData.levelHighlighters[levelNum][i][5] < 0.2 then
                levelData.levelHighlighters[levelNum][i][5] = levelData.levelHighlighters[levelNum][i][5] + 0.01
            end
        else
            if levelData.levelHighlighters[levelNum][i][5] > 0 then
                levelData.levelHighlighters[levelNum][i][5] = levelData.levelHighlighters[levelNum][i][5] - 0.01
            end
        end
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