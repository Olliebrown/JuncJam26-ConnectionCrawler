CrawlerScene = {}
class("CrawlerScene").extends(NobleScene)
local scene = CrawlerScene

local gfx <const> = playdate.graphics

import 'Objects/PlayerController'
import 'Objects/InfinitePlane'
import 'Objects/DistantHorizon'
import 'Objects/PSprite'
import 'Utilities/TexGen'

function scene:setValues()
    -- Infinite ground/ceiling planes
    self.groundPlane = InfinitePlane('assets/images/field', 0, 140, 400, 100, 7, 7, 0.5, 0.95, 16, 9, true)
    self.groundPlane:setImage(generateBeamGrid(128, 128, 32, 4))

    self.ceilingPlane = InfinitePlane('assets/images/field', 0, 0, 400, 85, -7, -7, 0.5, 0.05, 16, -10, true)
    self.ceilingPlane:setImage(generateCheckerboard(32, 32, 8, 8))

    -- Distant skyline
    self.horizon = DistantHorizon('assets/images/sky', 70, 1)

    -- Main player sprite
    self.player = NobleSprite('assets/images/Player')
    self.player:setCenter(0.5, 0.0)

    -- NPC Sprites
    self.testSprite = PSprite('Clown', 'assets/images/person', 2.0, 0)

    -- Fake 3d camera properties
    self.angle = 0
    self.X, self.Y = 0, 0
end

function scene:init()
	scene.super.init(self)
	self:setValues()

    -- Make player controller and use as input handler
    self.controller = PlayerController()
	self.inputHandler = self.controller
end

function scene:enter()
	scene.super.enter(self)

    self.testSprite:add()
    self.testSprite:activate()

    self.player:add(200, 175)
end

function scene:start()
	scene.super.start(self)
end

function scene:drawBackground()
    -- Clears the screen to white
	scene.super.drawBackground(self)

    -- Draw the distant horizon image
    self.horizon:draw(self.X)

    -- Draw ground and then ceiling
    local c = math.cos(self.angle)
    local s = math.sin(self.angle)
    self.groundPlane:drawAngled(self.X, self.Y, c, s)
    self.ceilingPlane:drawAngled(-self.X, self.Y, c, s)
end

function scene:update()
	scene.super.update(self)

    -- Respond to input changes
    self.controller:update()

    -- Move
    local dx, dy = self.controller:computeMove(self.angle)
    self.X += dx
    self.Y += dy

    -- Sync NPCs and Perspective Sprites
    self.testSprite:updateLocation(-self.X * 150, self.Y, 1500)

    -- Update all standard sprites
    gfx.sprite.update()
end

function scene:exit()
	scene.super.exit(self)
end
