CustomNobleSprite = {}
class("CustomNobleSprite").extends(NobleSprite)

function CustomNobleSprite:init(__view, __viewIsSpritesheet, __singleState, __singleStateLoop)
    CustomNobleSprite.super.init(self, __view, __viewIsSpritesheet, __singleState, __singleStateLoop)
end

function CustomNobleSprite:draw()
    if (self.animation ~= nil) then
        self.animation:draw()
		self:markDirty()
	end
end
