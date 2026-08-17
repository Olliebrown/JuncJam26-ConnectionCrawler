WelcomeScene = {}
class("WelcomeScene").extends(NobleScene)
local scene = WelcomeScene

local gfx <const> = playdate.graphics

function scene:setValues()
    -- Load images
	self.background = Graphics.image.new("assets/images/UI/Title_Screen")
    self.startButtonUp = Graphics.image.new("assets/images/UI/Start_Button")
    self.startButtonDown = Graphics.image.new("assets/images/UI/Start_Button_Click")

    -- Button starts up
    self.startButton = self.startButtonUp

    -- Anchor to bottom left
    self.startX, self.startY = self.startButton:getSize()
    self.startX = 400 - self.startX - 5
    self.startY = 250 - self.startY - 15
    self.startYExit = 250

    -- Storing the button state and animation
    self.readyToStart = false
    self.startHeld = false
    self.sequence = nil
end

function scene:init()
	scene.super.init(self)
	self:setValues()

    self.inputHandler = {
		AButtonDown = function()
            self.startButton = self.startButtonDown
            self.readyToStart = true
			self.startHeld = true
		end,
        AButtonUp = function()
            self.startButton = self.startButtonUp
            self.startHeld = false
        end,0
	}

end

function scene:enter()
	scene.super.enter(self)

    -- Back to no scaling
    playdate.display.setScale(1)

	self.sequence = Sequence.new():from(250):to(self.startY, 1.5, Ease.outBounce):start()
end

function scene:start()
	scene.super.start(self)
end

function scene:drawBackground()
	scene.super.drawBackground(self)
    self.background:draw(0, 0)
    self.startButton:draw(self.startX, self.sequence:get() or self.startY)
end

function scene:update()
	scene.super.update(self)

    if self.readyToStart and not self.startHeld then
        Noble.transition(CrawlerScene, nil, Noble.Transition.DipToBlack)
    end
end

function scene:exit()
	scene.super.exit(self)
    self.sequence = Sequence.new():from(self.startY):to(self.startYExit, 0.5, Ease.inSine):start()
end
