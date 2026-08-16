PerspectiveSprite = {}
class("PerspectiveSprite").extends()

function PerspectiveSprite:init(name, __view, scale, X, Y, Z, FOV, minZ, hitRange, __viewIsSpritesheet, __singleState, __singleStateLoop)
	-- Default to N/A
	self.name = name or 'N/A'

	-- Default to zeros
	self.X, self.Y, self.Z = X or 0, Y or 0, Z or 0

	-- Default to 1
	self.scale = scale or 1

	-- Default to 20
	self.minZ = minZ or 20

	-- Default to 1000
	self.hitRange = hitRange or 1000

	-- Default to 60 deg
	self.FOV = FOV or 60

	-- Create and configure the sprite
	self.billboardSprite = NobleSprite(__view, __viewIsSpritesheet, __singleState, __singleStateLoop)
	self.billboardSprite:setVisible(false)

	-- Cache these values that don't change
    self.halfWidth = playdate.display.getWidth() / 2
    self.halfHeight = playdate.display.getHeight() / 2
end

function PerspectiveSprite:onCollect()
	print("Collected " .. self.name)
end

function PerspectiveSprite:onMiss()
	print("Missed " .. self.name)
end

function PerspectiveSprite:testCollection(X, Y, Z)
	if Z < self.minZ then
		-- Test if we collected them
		if math.abs(X) < self.hitRange then
			print('Collecting (' .. tostring(Z) .. ')')
			self:onCollect()
		else
			self:onMiss()
		end
		return true
	end

	return false
end

function PerspectiveSprite:updateLocation(eyeX, eyeY, eyeZ)
	-- Ignore when not visible
	if not self.billboardSprite:isVisible() then return end

	-- Prevent nil values
	eyeX, eyeY, eyeZ = eyeX or 0, eyeY or 0, eyeZ or 0

	-- Compute sprite location in camera coordinates
	local camX, camY, camZ = self.X + eyeX, self.Y + eyeZ, self.Z + eyeY

    -- Make invisible when we pass it (and avoid div by zero)
	if self:testCollection(camX, camY, camZ) then
		self.billboardSprite:setVisible(false)
		return
	end

	-- Perspective projection math
    local depthScale = self.FOV / camZ
    local screenX = self.halfWidth + (camX / camZ)
    local screenY = self.halfHeight + (camY / camZ)

    -- Update sprite transform attributes
    self.billboardSprite:moveTo(screenX, screenY)
    self.billboardSprite:setScale(depthScale * self.scale)
end

function PerspectiveSprite:add() self.billboardSprite:add(0, 0) end
function PerspectiveSprite:remove() self.billboardSprite:remove() end

function PerspectiveSprite:play() self.billboardSprite:play() end
function PerspectiveSprite:pause() self.billboardSprite:pause() end
function PerspectiveSprite:stop() self.billboardSprite:stop() end
