TypewriterText = {}
class("TypewriterText").extends()

local gfx <const> = playdate.graphics

function TypewriterText:init(font, speed, X, Y, W, H)
    self.text = ''
    self.font = font
    self.speed = (speed or 4)

    self.X, self.Y = (X or 0), (Y or 0)
    self.W, self.H = (W or 400), (H or 240)

    self.displayedText = ''
    self.frameCounter = 0
    self.started = false
end

function TypewriterText:typeText(text)
    self.text = text
    self.displayedText = ''
    self.started = true
    self.frameCounter = 0
end

function TypewriterText:isReady()
    return self.text == '' or (#self.text > 0 and self:isDone())
end

function TypewriterText:isDone()
    return #self.displayedText >= #self.text
end

function TypewriterText:jumpToEnd()
    if not self:isDone() then
        -- Grab all but the LAST letter and skip to last frame
        self.displayedText = string.sub(self.text, 1, -2)
        self.frameCounter = self.speed
    end
end

function TypewriterText:update()
    -- Wait until started
    if not self.started then return end

    -- Remember things before mutation of the text
    local justFinished = false
    local previousLength = #self.displayedText

    -- Advance the typewriter logic
    if not self:isDone() then
        self.frameCounter += 1
        if self.frameCounter >= self.speed then
            -- Grab the substring up to the current character length
            self.displayedText = string.sub(self.text, 1, #self.displayedText + 1)
            justFinished = self:isDone()

            -- Reset frame counter
            self.frameCounter = 0
        end
    end

    -- Draw the text in a bounding box
    gfx.setFont(self.font)
    gfx.drawTextInRect(self.displayedText, self.X, self.Y, self.W, self.H)

    -- Trigger callback if provided passing last character added
    if type(self.onTextAdvance) == "function" and #self.displayedText > previousLength then
        self.onTextAdvance(string.sub(self.displayedText, -1))
    end

    -- Check for triggering the completed callback
    if justFinished and type(self.onCompleteCB) == "function" then
        self.onCompleteCB()
    end
end
