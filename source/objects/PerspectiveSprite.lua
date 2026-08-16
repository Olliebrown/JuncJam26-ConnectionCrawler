PerspectiveSprite = {}
class("PerspectiveSprite").extends()

function PerspectiveSprite:init(X, Y, Z, __view, __viewIsSpritesheet, __singleState, __singleStateLoop)
	self.billboardSprite = NobleSprite(__view, __viewIsSpritesheet, __singleState, __singleStateLoop)
	self.X, self.Y, self.Z = X, Y, Z

	-- Cache these values that don't change
    self.screenWidth = playdate.display.getWidth()
    self.screenHeight = playdate.display.getHeight()
end

function PerspectiveSprite:updateLocation(dX, dY, dZ)
	-- Prevent nil values
	dX = dX or 0
	dY = dY or 0
	dZ = dZ or 0

	-- Move sprite
	self.X += dX
	self.Y += dY
	self.Z += dZ

    -- Prevent Z from hitting 0 or negative values to avoid division errors
    if self.Z < 0.01 then self.Z = 0.01 end

	-- Perspective projection math
    local scale = 2.0 / self.z  -- Adjust '2.0' as your field-of-view / zoom factor
    local screenX = self.screenWidth / 2 + (self.X / self.Z)
    local screenY = self.screenHeight / 2 + (self.Y / self.Z)

    -- Update sprite transform attributes
    self.billboardSprite:moveTo(screenX, screenY)
    self.billboardSprite:setScale(scale)
end
