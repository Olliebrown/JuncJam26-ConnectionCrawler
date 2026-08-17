MissAlert = {}
class("MissAlert").extends(NobleSprite)

function MissAlert:init(isLeft)
	MissAlert.super.init(self, "assets/images/UI/ArrowAlert")

	-- Configure the sprite
	self:setUpdatesEnabled(true)
    self:setCenter(0.5, 0.5)
	self:setSize(104, 79)
    self:setZIndex(10000)

	if isLeft then
		self:setRotation(-90)
	    self:add(90, 170)
	else
		self:setRotation(90)
	    self:add(320, 170)
	end

	-- Add automatically

	self.blinkTimer = playdate.timer.new(333, function()
		self:blink()
	end)
	self.blinkTimer.repeats = true

	playdate.timer.new(2000, function()
		self:finish()
	end)
end

function MissAlert:blink()
	self:setVisible(not self:isVisible())
end

function MissAlert:finish()
	self.blinkTimer:remove()
	self:setVisible(false)
	self:remove()

	if type(self.onCompleteCB) == "function" then
        self.onFinishedCB(self)
    end
end
