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
    -- Make visible and add to scene
    self.billboardSprite:setVisible(true)
    self.billboardSprite:add()

    local scene = Noble.currentScene()
    if scene ~= nil then
        self.Z = -scene.Y + 100
    end
end


function PSprite:deactivate()
    -- Make invisible and remove from scene
    self.billboardSprite:setVisible(false)
    self.billboardSprite:remove()
end

function PSprite:onCollect()
    -- Run parent and de-activate sprite
    PSprite.super.onCollect(self)
    if self.billboardSprite ~= nil then
        self:deactivate()
    end

    -- Do collection logic here
    if type(self.collectCallback) == "function" then
        self.collectCallback(self)
    end
end

function PSprite:onMiss()
    -- Run parent and de-activate sprite
    PSprite.super.onMiss(self)
    self:deactivate()

    -- Do miss logic here
    if type(self.missCallback) == "function" then
        self.missCallback(self)
    end
end
