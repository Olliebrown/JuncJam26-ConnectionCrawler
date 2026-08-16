import "CoreLibs/graphics"
local gfx <const> = playdate.graphics

function generateCheckerboard(w, h, cw, ch)
    local img = gfx.image.new(w, h)
    gfx.pushContext(img)

    for y = 0, h - 1 do
        local yTile = math.floor(y / ch)
        for x = 0, w - 1 do
            local xTile = math.floor(x / cw)
            if yTile % 2 == xTile % 2 then
                gfx.setColor(gfx.kColorWhite)
            else
                gfx.setColor(gfx.kColorBlack)
            end
            gfx.drawPixel(x, y)
        end
    end

    gfx.popContext()
    return img
end
