import 'objects/UI/TypewriterText'

NPCGratitude = {}
class("NPCGratitude").extends()

local gfx <const> = playdate.graphics
local sound <const> = playdate.sound

PORTRAIT_NAMES = {
    { path = 'assets/images/Portraits/Miner.png', Y = 0, fontPath = 'assets/fonts/Gondomania-3x',
        text = { 'YOU FOUND ME BUT', 'MORE FELL BELOW', 'DELVE DEEPER TO CONNECT' },
        audioPrefix = 'assets/audio/CCVoice-Miner1-' },
    { path = 'assets/images/Portraits/Lady.png', Y = -15, fontPath = 'assets/fonts/HotChase-3x',
        text = { 'HERE WE ARE', 'CONNECTED AGAIN', 'BUT YOU MUST GO DEEPER' },
        audioPrefix = 'assets/audio/CCVoice-Lady-' },
    { path = 'assets/images/Portraits/MinerK.png', Y = -25, fontPath = 'assets/fonts/KikiKaikai-3x',
        text = { 'WHAT HAVE WE FOUND BENEATH', 'ONLY EACH OTHER', 'AND DEEPER CONNECTION' },
        audioPrefix = 'assets/audio/CCVoice-Miner2-' },
    { path = 'assets/images/Portraits/FutureChicken.png', Y = -50, fontPath = 'assets/fonts/BubbleMemories-3x',
        text = { 'THANK YOU MARIO', 'BUT OUR PRINCESS', 'IS IN ANOTHER CASTLE' },
        audioPrefix = 'assets/audio/CCVoice-Chicken-' },
}

function NPCGratitude:init(whichPortrait, fadeDuration)
    -- Default value for fade duration (in ms)
    self.fadeDuration = (fadeDuration or 600)
    self.fadeOutCBSent = false

    -- Create sprites for the Gratitude UI
	self.background = gfx.image.new("assets/images/UI/Dialog_Background")
    self.portrait = gfx.image.new(PORTRAIT_NAMES[whichPortrait].path)
    self.portraitY = PORTRAIT_NAMES[whichPortrait].Y

    -- Start nil so it draws nothing
    self.fadeAnimator = nil
    self.slideIn = nil

    -- Create the typewriter object and text tracking variables
    self.typewriter = TypewriterText(gfx.font.new(PORTRAIT_NAMES[whichPortrait].fontPath), 3, 25, 165, 350, 55)
    self.currentText = 0
    self.textList = PORTRAIT_NAMES[whichPortrait].text
    self.advanceText = false

    -- Pre-load audio
    self.audioList = {}
    for i=1,#self.textList,1 do
        local newAudio = sound.sampleplayer.new(PORTRAIT_NAMES[whichPortrait].audioPrefix .. 'Text' .. i)
        if newAudio ~= nil then
            table.insert(self.audioList, newAudio)
        end
    end

    -- Setup the oncomplete callback
    self.typewriter.onCompleteCB = function ()
        -- Advance text after 1 second
        playdate.timer.new(1000, function ()
            self.advanceText = true
        end)
    end
end

function NPCGratitude:startFadeIn()
    -- Setup to fade in background
    self.fadeAnimator = gfx.animator.new(self.fadeDuration, 0, 1)

    -- Setup to slide in portrait
    self.slideIn = Sequence.new()
        :from(300)
        :sleep(self.fadeDuration / 2000) -- half the fade duration
        :to(0, 0.6, Ease.outBounce)
        :start()
end

function NPCGratitude:startFadeOut()
    -- Setup to fade out background
    self.fadeAnimator = gfx.animator.new(self.fadeDuration, 1, 0)

    -- Setup to slide out portrait
    self.slideOut = Sequence.new()
        :from(self.portraitY)
        :to(200, self.fadeDuration / 1000, Ease.inQuad)
        :start()
end

function NPCGratitude:checkForAdvancingText()
    -- Advance to the next text if we are ready
    if self.typewriter:isReady() and self.advanceText then
        self.currentText += 1
        if self.currentText <= #self.textList then
            self.typewriter:typeText(self.textList[self.currentText])
            if self.audioList ~= nil and self.currentText <= #self.audioList then
                self.audioList[self.currentText]:play(1)
            end
        else
            -- Fade out after 1 second
            playdate.timer.new(1000, function ()
                self:startFadeOut()
            end)
        end
        self.advanceText = false
    end
end

function NPCGratitude:update(AButtonDown)
    -- Track if the stencil gets set
    local stencilSet = false

    -- Start with portrait (sits behind dialog)
    if self.slideOut ~= nil then
        self.portrait:draw(0, (self.slideOut:get() or 0))
    elseif self.slideIn ~= nil then
        self.portrait:draw((self.slideIn:get() or 0), (self.portraitY or 0))

        -- Advance to next text when ready
        if self.slideIn:isDone() and self.currentText == 0 then
            self.advanceText = true
        end
    end

    -- Draw dialog background
    if self.fadeAnimator ~= nil then
        if not self.fadeAnimator:ended() or self.slideOut ~= nil then
            -- Apply a dither stencil based on the current animation value (0 to 1)
            gfx.setStencilPattern(self.fadeAnimator:currentValue(), gfx.image.kDitherTypeBayer8x8)
            stencilSet = true
            self.background:draw(0, 0)
        else
            -- Draw normally once the fade is complete (unless we are fading out)
            self.background:draw(0, 0)
        end
    end

    if self.typewriter ~= nil then
        -- Maybe advance to next text in list
        self:checkForAdvancingText()

        -- Draw the text
        self.typewriter:update()
    end

    -- Clear stencil so it won't affect later draw calls
    if stencilSet then
        gfx.clearStencil()
    end

    -- Send the fade-out callback once at the end of the fadeout
    if self.fadeAnimator ~= nil and self.slideOut ~= nil and self.fadeAnimator:ended() then
        if type(self.fadeOutCB) == 'function' and not self.fadeOutCBSent then
            self.fadeOutCBSent = true
            self.fadeOutCB()
        end
    end
end
