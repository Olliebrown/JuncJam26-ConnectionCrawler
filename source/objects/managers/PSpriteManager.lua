import 'objects/PSprites/PSprite'

PSpriteManager = {}
class("PSpriteManager").extends()

function PSpriteManager:init(scaleX, widthScale, heightBase)
    -- Initialize scales and offsets
    self.scaleX = scaleX or 150
    self.widthScale = widthScale or 1000
    self.heightBase = heightBase or 1500

    -- Lists to hold sprites in different states
    -- (kind of like a sprite pool)
    self.waiting = {}
    self.updating = {}
    self.complete = {}
end

function PSpriteManager:add(name, sprite, scale, X)
    table.insert(self.waiting, PSprite(name, sprite, scale or 1.0, (X or 0) * self.widthScale))
end

-- Override in child for custom logic when colliding with PSprite
function PSpriteManager:onCollide(sprite)
    print('Collided with active PSprite ' .. sprite.name)
end

-- Override in child for custom logic when PSprite is missed
function PSpriteManager:onMiss(sprite)
    print('Missed active PSprite ' .. sprite.name)
end

-- Move the indicated sprite (or the first one) from waiting to updating
function PSpriteManager:setActive(index)
    index = index or 1
    if table.getSize(self.waiting) >= index then
        -- Move from waiting list to updating list
        local sprite = table.remove(self.waiting, index)
        table.insert(self.updating, sprite)

        -- Set callbacks
        sprite.collectCallback = function()
            self:onCollide(sprite)
        end

        sprite.missCallback = function ()
            self:onMiss(sprite)
        end

        -- Activate
        sprite:activate()
    end
end

-- Move the given sprite from updating to completed
function PSpriteManager:setComplete(sprite)
    -- lookup index
    local index = table.indexOfElement(self.updating, sprite)

    if index ~= nil and table.getSize(self.updating) >= index then
        -- Move from updating list to complete list
        sprite = table.remove(self.updating, index)
        table.insert(self.complete, sprite)

        -- Unset callbacks and deactivate
        sprite.collectCallback = nil
        sprite.missCallback = nil
        sprite:deactivate()
    end
end

-- Update the location of all sprites in the updating list
function PSpriteManager:updateLocations(camX, camY)
    for _, sprite in ipairs(self.updating) do
        sprite:updateLocation(-camX * self.scaleX, camY, self.heightBase)
    end
end
