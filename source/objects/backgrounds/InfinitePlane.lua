class("InfinitePlane").extends()

local gfx <const> = playdate.graphics

-- Build with a source image, target rectangle, scale, pivot, depth, tilt and tile settings
function InfinitePlane:init(pngName, X, Y, W, H, scaleX, scaleY, cX, cY, Z, tilt, tiled)
    InfinitePlane.super.init()

    -- Load the underlying image
    self:setImage(gfx.image.new(pngName))

    -- Rendered Position, dimensions, scale
	self.rectX, self.rectY = X, Y
    self.rectW, self.rectH = W, H
    self.scaleX, self.scaleY = scaleX, scaleY

    -- Pivot point center
    self.centerX, self.centerY = cX, cY

    -- Depth and tilt
    self.Z = Z
    self.tilt = tilt

    -- Tiled or not
    self.tiled = tiled
end

function InfinitePlane:setImage(newImage)
    self.image = newImage
    if self.image ~= nil then
        self.srcW, self.srcH = self.image:getSize()
    end
end

function InfinitePlane:drawAngled(X, Y, angleCos, angleSin)
    -- Use the built-in Mode-7 method to draw with perspective projection
    self.image:drawSampled(
        self.rectX, self.rectY, self.rectW, self.rectH,
		self.centerX, self.centerY,
        angleCos / self.scaleX, angleSin / self.scaleY,
        -angleSin / self.scaleX, angleCos / self.scaleY,
        X / self.srcW, Y / self.srcH,
        self.Z, self.tilt, self.tiled
    )
end
