import 'objects/PSprites/PerspectiveSprite'

PSprite = {}
class("PSprite").extends(PerspectiveSprite)

function PSprite:init(name, __view, scale, X, frames)
    PSprite.super.init(self, name, __view, scale, X, 70, 0, 15, 20, 1100, (frames or 1) > 1)
    if self.billboardSprite ~= nil then
        self.billboardSprite:setVisible(false)
        if (frames or 1) > 1 then
            self:initAnimation()
        end
    end
    self.distance = 0
end

function PSprite:initAnimation()
	-- Configure the sprite
	self.billboardSprite:setUpdatesEnabled(true)
    self.billboardSprite:setCenter(0.5, 0.0)
	self.billboardSprite:setSize(128, 128)
    self.billboardSprite:setZIndex(8000)

	-- Configure the animation
    self.billboardSprite.animation:addState("idle", 1, 4)
    self.billboardSprite.animation["idle"].frameDuration = 15
    self.billboardSprite.animation["idle"].loop = true
    self.billboardSprite.animation:setState("idle")
end

function PSprite:activate()
    -- Make visible and add to scene
    self.billboardSprite:setVisible(true)
    self.billboardSprite:add()
    self.billboardSprite:play()

    local scene = Noble.currentScene()
    if scene ~= nil then
        self.Z = -scene.camY + 100
    end
end

function PSprite:deactivate()
    -- Make invisible and remove from scene
    self.billboardSprite:setVisible(false)
    self.billboardSprite:stop()
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
        self.collectCallback()
    end
end

function PSprite:onMiss(toLeft)
    -- Run parent and de-activate sprite
    PSprite.super.onMiss(self)
    self:deactivate()

    -- Do miss logic here
    if type(self.missCallback) == "function" then
        self.missCallback(toLeft)
    end
end
