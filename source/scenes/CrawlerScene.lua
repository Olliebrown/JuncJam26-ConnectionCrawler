CrawlerScene = {}
class("CrawlerScene").extends(NobleScene)
local scene = CrawlerScene

local gfx <const> = playdate.graphics

import 'Objects/InfinitePlane'
import 'Objects/DistantHorizon'
import 'Utilities/TexGen'

function scene:setValues()
    -- Infinite ground planes
    self.groundPlane = InfinitePlane('assets/images/field', 0, 155, 400, 85, 7, 7, 0.5, 0.95, 16, 10, true)
    self.groundPlane:setImage(generateBeamGrid(128, 128, 32, 4))

    self.ceilingPlane = InfinitePlane('assets/images/field', 0, 0, 400, 85, -7, -7, 0.5, 0.05, 16, -10, true)
    self.ceilingPlane:setImage(generateCheckerboard(32, 32, 8, 8))

    self.horizon = DistantHorizon('assets/images/sky', 85, 1)
    self.truck = gfx.image.new('assets/images/Player')

    self.x = 260
    self.y = 314
    self.angle = 0 * (math.pi / 180)
    self.dangle = 0
    self.t = 0
    self.speed = 0
    self.maxspeed = 1.75
    self.accel = 0.02
    self.turnspeed = 0.01
    self.maxturn = 0.05
    self.turndamp = 0.8
    self.speedcoast = 0.95
    self.speedbrake = 0.75

    -- Track left and right D-pad state
    self.upDown = false
    self.downDown = false
    self.leftDown = false
    self.rightDown = false
end

function scene:init()
	scene.super.init(self)
	self:setValues()

	local crankTick = 0
	self.inputHandler = {
		upButtonDown = function() self.upDown = true end,
		downButtonDown = function() self.downDown = true end,
		upButtonUp = function() self.upDown = false end,
		downButtonUp = function() self.downDown = false end,

		leftButtonDown = function() self.leftDown = true end,
		rightButtonDown = function() self.rightDown = true end,
		leftButtonUp = function() self.leftDown = false end,
		rightButtonUp = function() self.rightDown = false end,

        cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
                -- Go fwd / down
			elseif (crankTick < -30) then
				crankTick = 0
                -- Go back / up
			end
		end,

        AButtonDown = function()
		end
	}
end

function scene:enter()
	scene.super.enter(self)
end

function scene:start()
	scene.super.start(self)
end

function scene:drawBackground()
	scene.super.drawBackground(self)

    -- Blank the screen0
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)
end

function scene:update()
	scene.super.update(self)

    -- Advance time
    self.t += 0.05

    -- Handle LR input
    if self.leftDown then
    	if self.dangle > -self.maxturn then self.dangle -= self.turnspeed end
    else
    	if self.dangle < 0 and not self.rightDown then
    		self.dangle *= self.turndamp
    	end
    end

    if self.rightDown then
    	if self.dangle < self.maxturn then self.dangle += self.turnspeed end
    else
    	if self.dangle > 0 and not self.leftDown then
    		self.dangle *= self.turndamp
    	end
    end

        -- Compute sine and cosine
    local c = math.cos(self.angle)
    local s = math.sin(self.angle)

    -- Update speed
    if self.upDown and self.speed < self.maxspeed then
        self.speed += self.accel
    elseif self.downDown then
        self.speed *= self.speedbrake
    else
        self.speed *= self.speedcoast
    end

    -- Move
    self.x += (self.dangle * self.speed / self.maxspeed) * 50
    self.y -= c * self.speed

    -- Draw the distant horizon image
    self.horizon:draw(self.x)

    -- Draw ground and then ceiling
    self.groundPlane:drawAngled(self.x, self.y, c, s)
    self.ceilingPlane:drawAngled(-self.x, self.y, c, s)

    -- Draw the truck
    local w, _ = self.truck:getSize()
    self.truck:draw(200 - w / 2, 175) -- + rumble/2)    
end

function scene:exit()
	scene.super.exit(self)
end
