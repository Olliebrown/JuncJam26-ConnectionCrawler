CustomNobleSprite = {}
class("CustomNobleSprite").extends(NobleSprite)

function CustomNobleSprite:init(__view, __viewIsSpritesheet, __singleState, __singleStateLoop)
    CustomNobleSprite.super.init(self, __view, __viewIsSpritesheet, __singleState, __singleStateLoop)
end

function CustomNobleSprite:draw()
    if (self.animation ~= nil) then
        local sX, sY = self:getScale()
        if sX ~= 1.0 or sY ~= 1.0 then
            self.animation:drawScaled(sX, sY)
        else
            self.animation:draw()
        end
		self:markDirty()
	end
end
