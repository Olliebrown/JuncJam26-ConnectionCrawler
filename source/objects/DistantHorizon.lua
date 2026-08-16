class("DistantHorizon").extends()

local gfx <const> = playdate.graphics

-- Build with a source image
function DistantHorizon:init(pngName, Y, scale)
    DistantHorizon.super.init()
    self.Y = Y or 0
    self.scale = scale or 1
    self.srcW = 0

    self:setImage(gfx.image.new(pngName))
end

function DistantHorizon:setImage(newImage)
    self.image = newImage
    if self.image ~= nil then
        self.srcW, _ = self.image:getSize()
    end
end

function DistantHorizon:draw(x)
    -- Sanity check
    if self.image == nil then return end

    -- Draw horizon left half
	local horizX = (-self.srcW / 2.0) * x / self.srcW * 1.5
    while horizX < -self.srcW do
        horizX += self.srcW
    end
    while horizX > 0 do
        horizX -= self.srcW
    end

    self.image:drawScaled(horizX, self.Y, self.scale)

    -- If needed, draw right half
	if horizX < (-self.srcW / 3.0) then
		self.image:drawScaled(horizX + self.srcW, self.Y, self.scale)
	end
end
