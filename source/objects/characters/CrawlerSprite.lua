CrawlerSprite = {}
class("CrawlerSprite").extends(NobleSprite)

function CrawlerSprite:init()
	CrawlerSprite.super.init(self, "assets/images/Characters/CrawlerWalkFull", true)

	self.minDuration = 1
	self.maxDuration = 20

	-- Configure the sprite
	self:setUpdatesEnabled(true)
    self:setCenter(0.5, 0.0)
	self:setSize(125, 80)
    self:setZIndex(9999)

	-- Configure the animations
	if self.animation ~= nil then
		-- Extract all animations
		self.animation:addState("forward", 1, 9)
		self.animation:addState("left", 10, 18)
		self.animation:addState("right", 19, 27)
		self.animation:addState("idle", 28, 28)

		-- Setup default frame duration
		self.animation["forward"].frameDuration = 10
		self.animation["left"].frameDuration = 10
		self.animation["right"].frameDuration = 10

		-- Make idle just a single frozen frame and start here
		self.animation["idle"].loop = false
		self.animation:setState("idle")
	end
end

function CrawlerSprite:adjustSpeed(speed, leftDown, rightDown)
	if speed < 0.01 then
		self.animation:setState("idle")
	else
		-- Determine direction state
		local newState = 'forward'
		if leftDown then
			newState = 'left'
		elseif rightDown then
			newState = 'right'
		end

		-- Update direction and speed
		self.animation[newState].frameDuration = math.lerp(self.maxDuration, self.minDuration, speed)
		self.animation:setState(newState)
	end
end
