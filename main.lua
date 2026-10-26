require "levelData"
require "player"
require "helper"

flux = require "flux"

font = love.graphics.getFont()

scale = 0
levelNum = 1
movingChecker = 0

canMove = false
canMoveBack = false

mouseX = 0
mouseY = 0

mouseInArea = false

showSubDisplay = false
subDisplayWidth = 600
subDisplayHeight = 600
subDisplayImage = love.graphics.Image

puzzle1Showing = false
digits = {0,0,0,0}

function love.load()
    love.window.setTitle("Primal truth")
    scale = levelData.levelScales[levelNum]
    love.window.setMode(800,800)
    levelData.levelName = levelData.levels[1]
    loadBgs()
    loadSubDisplays()
end

function love.draw()
    --Debugging prints
    love.graphics.setColor(255,255,255,1)
    
    --BACKGROUND LAYER
    love.graphics.draw(levelData.levels[levelNum],0,0)

    --DRAW FROM HERE
    love.graphics.print(tostring(levelNum))
    
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

    --Sub display
    if showSubDisplay then
        drawSubDisplay()
    end
end

function drawSubDisplay()
    --Border
    love.graphics.rectangle("fill",99,49,602,602)
    --Display
    love.graphics.draw(subDisplayImage,100,50)
    --Puzzle 1
    if(puzzle1Showing == true) then
        love.graphics.print(tostring(digits[1]),160,365,0,5,5)
        --Border for clicks (160,365,50,60)
        love.graphics.print(tostring(digits[2]),310,365,0,5,5)
        love.graphics.print(tostring(digits[3]),460,365,0,5,5)
        love.graphics.print(tostring(digits[4]),460+150,365,0,5,5)
    end
    --Puzzle 1 checks
    if(levelNum == 3) then  
        if(digits[1] == 1 and digits[2] == 1 and digits[3] == 4 and digits[4] == 2) then
            subDisplayImage = lock_to_forest_open
        end
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

    --Highlighter stuff--

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
            player.x = 650
        end
    end
end

function love.mousepressed(x,y,button,istouch)
    if button == 1 then
        if player.moving == false and showSubDisplay == false then
            flux.to(player, 1, {x=player.x, x=x-player.width/2})
        end

        if showSubDisplay == true and not isMouseInRect(x,y,100,50,600,600) then
            showSubDisplay = false
            subDisplayImage = placeholder
            puzzle1Showing = false
        end
        --Puzzle 1 digits
        if(showSubDisplay == true and levelNum == 3 and isMouseInRect(x,y,160,365,50,60)) then
            if digits[1] == 9 then
                digits[1] = 0
            else
                digits[1] = digits[1] + 1
            end
        end
        if(showSubDisplay == true and levelNum == 3 and isMouseInRect(x,y,160+150,365,50,60)) then
            if digits[2] == 9 then
                digits[2] = 0
            else
                digits[2] = digits[2] + 1
            end
        end
        if(showSubDisplay == true and levelNum == 3 and isMouseInRect(x,y,160+150*2,365,50,60)) then
            if digits[3] == 9 then
                digits[3] = 0
            else
                digits[3] = digits[3] + 1
            end
        end
        if(showSubDisplay == true and levelNum == 3 and isMouseInRect(x,y,160+150*3,365,50,60)) then
            if digits[4] == 9 then
                digits[4] = 0
            else
                digits[4] = digits[4] + 1
            end
        end
        --Entrance to the forest
        if(levelNum == 3 and isMouseInRect(x,y,380,500,25,25)) then
            subDisplayImage = lock_to_forest
            showSubDisplay = true
            puzzle1Showing = true
        end 
        --Note on shed
        if(levelNum == 4 and isMouseInRect(x,y,480,470,30,30)) then
            showSubDisplay = true
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

function loadSubDisplays()
    placeholder = love.graphics.newImage("Pictures/SubDisplays/Placeholder.png")
    lock_to_forest = love.graphics.newImage("Pictures/SubDisplays/LockToForest.png")
    lock_to_forest_open = love.graphics.newImage("Pictures/SubDisplays/LockToForestOpen.png")
    subDisplayImage = placeholder
end