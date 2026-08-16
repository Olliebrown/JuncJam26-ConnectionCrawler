import 'objects/PSprite'

PSpriteManager = {}
class("PSpriteManager").extends()

function PSpriteManager:init(scaleX, heightBase)
    -- Initialize scales and offsets
    self.scaleX = scaleX or 150
    self.heightBase = heightBase or 1500

    -- Lists to hold sprites in different states
    -- (kind of like a sprite pool)
    self.waiting = {}
    self.updating = {}
    self.complete = {}
end

function PSpriteManager:add(name, sprite, scale, X)
    table.insert(self.waiting, PSprite(name, sprite, scale or 1.0, X or 0))
end

function PSpriteManager:setActive(index)
    index = index or 1
    if table.getSize(self.waiting >= index) then
        local sprite = table.remove(self.waiting, index)
        table.insert(self.updating, sprite)
    end
end

function PSpriteManager:setComplete(index)
    index = index or 1
    if table.getSize(self.updating >= index) then
        local sprite = table.remove(self.updating, index)
        table.insert(self.complete, sprite)
    end
end

function PSpriteManager:updateLocations(camX, camY)
    for _, sprite in ipairs(self.updating) do
        sprite:updateLocation(-camX * self.scaleX, camY, self.heightBase)
    end
end
