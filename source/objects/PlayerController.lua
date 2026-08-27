PlayerController = {}
class("PlayerController").extends()

function PlayerController:init()
    -- Time
    self.t = 0

    -- Angles
    self.angle = 0 * (math.pi / 180)
    self.dangle = 0

    -- Speed & acceleration limits
    self.speed = 0
    self.maxSpeed = 1.75
    self.accel = 0.02

    -- Turning
    self.turnSpeed = 0.01
    self.maxTurn = 0.05
    self.turnDamp = 0.8

    -- Speed smoothing
    self.speedCoast = 0.95
    self.speedBrake = 0.75

    -- Tracking input state
    self.upDown = false
    self.downDown = false
    self.leftDown = false
    self.rightDown = false
    self.ADown = false
    self.BDown = false
    self.crankTick = 0

    -- D-Pad up/down
    self.upButtonDown = function() self.upDown = true end
    self.downButtonDown = function() self.downDown = true end
    self.upButtonUp = function() self.upDown = false end
    self.downButtonUp = function() self.downDown = false end

    -- D-Pad left/right
    self.leftButtonDown = function() self.leftDown = true end
    self.rightButtonDown = function() self.rightDown = true end
    self.leftButtonUp = function() self.leftDown = false end
    self.rightButtonUp = function() self.rightDown = false end

    -- A/B buttons
    self.AButtonDown = function() self.ADown = true end
    self.BButtonDown = function() self.BDown = true end
    self.AButtonUp = function() self.ADown = false end
    self.BButtonUp = function() self.BDown = false end

    -- Crank
    self.cranked = function(change, acceleratedChange)
        self.crankTick += change
        if (self.crankTick > 30) then
            self.crankTick = 0
            -- Go fwd / down
        elseif (self.crankTick < -30) then
            self.crankTick = 0
            -- Go back / up
        end
    end
end

function PlayerController:update()
    -- Advance time
    self.t += 0.05

    -- Handle LR input
    if self.leftDown then
    	if self.dangle > -self.maxTurn then self.dangle -= self.turnSpeed end
    else
    	if self.dangle < 0 and not self.rightDown then
    		self.dangle *= self.turnDamp
    	end
    end

    if self.rightDown then
    	if self.dangle < self.maxTurn then self.dangle += self.turnSpeed end
    else
    	if self.dangle > 0 and not self.leftDown then
    		self.dangle *= self.turnDamp
    	end
    end

    -- Update speed
    if self.upDown and self.speed < self.maxSpeed then
        self.speed += self.accel
    elseif self.downDown then
        self.speed *= self.speedBrake
    else
        self.speed *= self.speedCoast
    end
end

function PlayerController:computeMove(angle)
    local dX = (self.dangle * self.speed / self.maxSpeed) * 50
    local dY = -math.cos(angle) * self.speed

    return dX, dY
end
