WelcomeScene = {}
class("WelcomeScene").extends(NobleScene)
local scene = WelcomeScene

-- NPC Gratitude Dialog (for testing)
import 'objects/UI/NPCGratitude'

local gfx <const> = playdate.graphics
local sound <const> = playdate.sound

function scene:setValues()
    -- Load images
	self.background = gfx.image.new("assets/images/UI/Title_Screen")
    self.startButtonUp = gfx.image.new("assets/images/UI/Start_Button")
    self.startButtonDown = gfx.image.new("assets/images/UI/Start_Button_Click")

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

    -- Background music with an infinite loop
    self.bgm = sound.fileplayer.new("assets/audio/CCMenuMusic-Gothamlicious")
    self.bgm:setLoopRange(11.636, 40.727)

    -- For texting
    self.gratitudeDialog = nil -- NPCGratitude(2)
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
        end
	}
end

function scene:enter()
	scene.super.enter(self)

    -- Setup the start button animation
	self.sequence = Sequence.new():from(250):to(self.startY, 1.5, Ease.outBounce):start()

    -- Play and loop forever
    self.bgm:play(0)
end

function scene:start()
	scene.super.start(self)

    -- For testing only
    if self.gratitudeDialog ~= nil then
        playdate.timer.new(1000, function ()
            self.gratitudeDialog:startFadeIn()
        end)
    end
end

function scene:drawBackground()
	scene.super.drawBackground(self)
    self.background:draw(0, 0)
    self.startButton:draw(self.startX, self.sequence:get() or self.startY)
end

function scene:update()
	scene.super.update(self)

    -- For testing only
    if self.gratitudeDialog ~= nil then
        self.gratitudeDialog:update()
    end

    if self.readyToStart and not self.startHeld then
        Noble.transition(CrawlerScene, nil, Noble.Transition.DipToBlack)
    end
end

function scene:exit()
	scene.super.exit(self)
    self.sequence = Sequence.new():from(self.startY):to(self.startYExit, 0.5, Ease.inSine):start()

    -- Fade out the audio
    self.bgm:setVolume(0.0, 0.0, 0.5, function()
        self.bgm:stop()
    end)
end
