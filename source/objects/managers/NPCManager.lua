import 'objects/managers/PSpriteManager'
import 'objects/UI/CollectAlert'
import 'objects/UI/MissAlert'

NPCManager = {}
class("NPCManager").extends(PSpriteManager)

function NPCManager:init(scaleX, widthScale, heightBase)
    NPCManager.super.init(self, scaleX, widthScale, heightBase)
    self.spawnQueued = false

    -- Make sure random generation is seeded
    math.randomseed(playdate.getSecondsSinceEpoch())
end

function NPCManager:add(name, sprite, NPCIndex, scale, X)
    -- Add to waiting list (via parent) then decorate with NPCIndex
    NPCManager.super.add(self, name, sprite, scale, X)
    self.waiting[#self.waiting].NPCIndex = NPCIndex
end

function NPCManager:onCollide(sprite)
    -- This just logs the event for debugging
    NPCManager.super.onCollide(self, sprite)

    -- Show CollectAlert
    local alertSprite = CollectAlert()

    -- Show gratitude dialog
    local scene = Noble.currentScene()
    if scene ~= nil then
        scene:showDialog(sprite.NPCIndex or 4)
    end

    -- Remove from active list
    self:setComplete(sprite)
end

function NPCManager:onMiss(sprite, toLeft)
    -- This just logs the event for debugging
    NPCManager.super.onMiss(self, sprite, toLeft)

    -- TODO: Do other things here! (like warn use of the miss or subtract from score)
    local alertSprite = MissAlert(toLeft)

    -- Remove from active list
    self:setComplete(sprite)

    -- Add back to waiting list after 5 seconds (give them another chance)
    playdate.timer.new(5000, function ()
        print('Re-spawning ' .. sprite.name)

        -- Move from complete list back to active list
        local index = table.indexOfElement(self.complete, sprite)
        if index ~= nil and #(self.complete) >= index then
            sprite = table.remove(self.complete, index)
            table.insert(self.waiting, sprite)
        end
    end)
end

function NPCManager:waitAndSpawn(seconds)
    self.spawnQueued = true
    print('Queueing spawn')
    playdate.timer.new(seconds * 1000, function ()
        -- Activate the next sprite
        print('Spawning next!')
        self:setActive(1)
        self.spawnQueued = false
    end)
end

function NPCManager:start(scene)
end

function NPCManager:update(scene)
    -- Queue an activation if needed:
    -- > No spawn queued yet
    -- > No active sprites
    -- > Sprites are waiting
    if not self.spawnQueued and #(self.updating) < 1 and #(self.waiting) > 0 then
        self:waitAndSpawn(math.random(5, 7))
    end

    -- Update locations of all updating sprites
    if scene ~= nil then
        self:updateLocations(scene.camX, scene.camY)
    end
end
