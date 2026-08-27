import "CoreLibs/graphics"
local gfx <const> = playdate.graphics

function GENERATE_CHECKERBOARD(w, h, cw, ch)
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

function GENERATE_BEAM_GRID(w, h, boxSize, lineWidth)
    local img = gfx.image.new(w, h)
    gfx.pushContext(img)

    local halfWidth = lineWidth / 2
    for y = 0, h - 1 do
        local boxH = y % boxSize
        for x = 0, w - 1 do
            local boxW = x % boxSize
            if boxH < halfWidth or boxW < halfWidth or
                boxSize - boxH < halfWidth or boxSize - boxW < halfWidth then
                gfx.setColor(gfx.kColorBlack)
            else
                gfx.setColor(gfx.kColorWhite)
            end
            gfx.drawPixel(x, y)
        end
    end

    gfx.popContext()
    return img
end