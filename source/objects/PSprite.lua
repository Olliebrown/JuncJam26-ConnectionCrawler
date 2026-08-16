import 'objects/PerspectiveSprite'

PSprite = {}
class("PSprite").extends(PerspectiveSprite)

function PSprite:init(name, __view, scale, X)
    PSprite.super.init(self, name, __view, scale, X, 70, 0, 15, 20, 1100)
    if self.billboardSprite ~= nil then
        self.billboardSprite:setVisible(false)
    end
end

function PSprite:activate()
    self.billboardSprite:setVisible(true)

    local scene = Noble.currentScene()
    if scene ~= nil then
        self.Z = -scene.Y + 100
        print('Spawned at ' .. self.Z)
    else
        print('Scene is nil')
    end
end

function PSprite:onCollect()
    -- Run parent and de-activate sprite
    PSprite.super.onCollect(self)
    if self.billboardSprite ~= nil then
        self.billboardSprite:setVisible(false)
    end

    -- Do collection logic here
    if type(self.CollectCallback) == "function" then
        self.CollectCallback(self)
    end
end

function PSprite:onMiss()
    -- Run parent and de-activate sprite
    PSprite.super.onMiss(self)
    if self.billboardSprite ~= nil then
        self.billboardSprite:setVisible(false)
    end

    -- Do miss logic here
    if type(self.MissCallback) == "function" then
        self.MissCallback(self)
    end

    -- Wait 5 secs, then re-activate
    playdate.timer.new(5000, function ()
        print('Respawning ' .. self.name)
        self:activate()
    end)
end
