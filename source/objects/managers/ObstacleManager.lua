import 'objects/managers/PSpriteManager'
import 'objects/PSprites/ObstacleSprite'

ObstacleManager = {}
class("ObstacleManager").extends(PSpriteManager)

-- Counts for static vs character obstacles in a phase
OBSTACLE_COUNT = {
    {  30,  5 },
    {  60, 10 },
    { 100, 50 }
}

-- Spacings (width and dist) for obstacles in a phase 
OBSTACLE_SPACING = {
    { 20, 50 },
    { 10, 25 },
    {  5, 10 }
}

function ObstacleManager:init(scaleX, widthScale, heightBase)
    ObstacleManager.super.init(self, scaleX, widthScale, heightBase)

    -- Make sure random generation is seeded
    math.randomseed(playdate.getSecondsSinceEpoch())
end

function ObstacleManager:onCollide(sprite)
    -- This just logs the event for debugging
    ObstacleManager.super.onCollide(self, sprite)

    -- TODO: Do other things here! (slow player, play sound, etc.)

    -- Remove from active list
    self:setComplete(sprite)
end

function ObstacleManager:checkSpawn(camX, camDist)
    -- Gather list of sprites that are ready to spawn
    local activateList = {}
    for i, sprite in ipairs(self.waiting) do
        if sprite.distance ~= nil and sprite.distance + camDist <= 0 then
            table.insert(activateList, i)
        end
    end

    -- Activate those sprites
    for i = #activateList, 1, -1 do
        self.waiting[i].X = camX + self.waiting[i].X
        self:setActive(i)
    end
end

function ObstacleManager:start(scene)
    self:makePhase(1)
end

function ObstacleManager:update(scene)
    -- Check for sprites ready to spawn (based on distance not time)
    if table.getSize(self.waiting) > 0 then
        self:checkSpawn(scene.camX, scene.camY)
    end

    -- Update locations of all updating sprites
    if scene ~= nil then
        self:updateLocations(scene.camX, scene.camY)
    end
end

function ObstacleManager:makePhase(which)
    -- Get the counts and spacing for this phase
    local count = OBSTACLE_COUNT[which]
    local spacing = OBSTACLE_SPACING[which]

    -- Loop over total count
    local total = count[1] + count[2]
    local span = total / count[2]

    print('Making phase ' .. which .. ':')

    local Y = math.random() * spacing[2]
    for i = 1, total, 1 do
        -- Get random spacing value that might be negative
        local X = math.random() * spacing[1] - spacing[1] / 2

        -- Make the sprite and add to 'waiting'
        local newSprite = ObstacleSprite(i % span == 0, which, 2.0, X * self.widthScale)
        self:add(newSprite)
        newSprite.distance = Y
        print('  ' .. tostring(i) .. ': ' .. newSprite.name .. ' at distance ' .. tostring(Y) .. ' and x offset ' .. tostring(X))

        -- Move forward
        Y += math.random() * spacing[2]
    end
end
