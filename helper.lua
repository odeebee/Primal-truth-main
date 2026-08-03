function isMouseInRect(mouseX,mouseY,rectX,rectY,rectWidth,rectHeight)
    if mouseX >= rectX and mouseX <= rectX + rectWidth and mouseY >= rectY and mouseY < rectY + rectHeight then
        return true
    else
        return false
    end
end