CrawlerSprite = {}
class("CrawlerSprite").extends(NobleSprite)

function CrawlerSprite:init()
	CrawlerSprite.super.init(self, "assets/images/Characters/CrawlerWobble", true)

	self.minDuration = 1
	self.maxDuration = 20

	-- Configure the sprite
	self:setUpdatesEnabled(true)
    self:setCenter(0.5, 0.0)
	self:setSize(115, 80)
    self:setZIndex(9999)

	-- Configure the animations
	if self.animation ~= nil then
		self.animation:addState("crawl", 1, 9)
		self.animation:addState("idle", 5, 5)
		self.animation["crawl"].frameDuration = 10

		-- Just a single frozen frame
		self.animation["idle"].loop = false
		self.animation:setState("idle")
	end
end

function CrawlerSprite:adjustSpeed(speed)
	if speed < 0.01 then
		self.animation:setState("idle")
	else
		self.animation["crawl"].frameDuration = math.lerp(self.maxDuration, self.minDuration, speed)
		self.animation:setState("crawl")
	end
end
