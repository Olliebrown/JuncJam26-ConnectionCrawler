CollisionAlert = {}
class("CollisionAlert").extends(NobleSprite)

function CollisionAlert:init()
	CollisionAlert.super.init(self, "assets/images/UI/CollisionAlert", true)

	-- Configure the sprite
	self:setUpdatesEnabled(true)
    self:setCenter(0.0, 0.0)
	self:setSize(400, 240)
    self:setZIndex(10000)

	-- Add and play automatically
    self:add(0, 0)
    self:play()

	-- Configure the animations
	if self.animation ~= nil then
		self.animation:addState("main", 1, 3)
		self.animation:setState("main")

		-- Adjust the animation state
		self.animation["main"].frameDuration = 10
		self.animation["main"].loop = false
		self.animation["main"].onComplete = function ()
			-- Call any complete callback
			if type(self.onCompleteCB) == "function" then
				self.onCompleteCB()
			end

			-- Clean up the sprite
			self:stop()
			self:setVisible(false)
			self:remove()
		end
	end
end
