CrawlerScene = {}
class("CrawlerScene").extends(NobleScene)
local scene = CrawlerScene

local gfx <const> = playdate.graphics

-- Input management
import 'objects/PlayerController'

-- Special background sprites
import 'objects/backgrounds/InfinitePlane'
import 'objects/backgrounds/DistantHorizon'

-- Perspective sprites
import 'objects/managers/NPCManager'
import 'objects/managers/ObstacleManager'

-- Texture generation utility functions
import 'utilities/TexGen'

-- Player sprite
import 'objects/characters/CrawlerSprite'

function scene:setValues()
    -- Infinite ground/ceiling planes
    -- self.groundPlane = InfinitePlane('assets/images/Floors/ground1_32x32', 0, 140, 400, 100, 7, 7, 0.5, 0.95, 16, 9, true)
    -- self.groundPlane = InfinitePlane('assets/images/Floors/ground1_128x128', 0, 140, 400, 100, 7, 7, 0.5, 0.95, 16, 9, true)
    -- self.groundPlane = InfinitePlane('assets/images/Floors/ground2_32x32', 0, 140, 400, 100, 7, 7, 0.5, 0.95, 16, 9, true)
    -- self.groundPlane = InfinitePlane('assets/images/Floors/ground2_128x128', 0, 140, 400, 100, 7, 7, 0.5, 0.95, 16, 9, true)
    self.groundPlane = InfinitePlane('assets/images/Floors/ground3_32x32', 0, 140, 400, 100, 7, 7, 0.5, 0.95, 16, 9, true)
    -- self.groundPlane = InfinitePlane('assets/images/Floors/ground4_32x32', 0, 140, 400, 100, 7, 7, 0.5, 0.95, 16, 9, true)
    self.groundPlane:setImage(GENERATE_BEAM_GRID(32, 32, 16, 4))

    self.ceilingPlane = InfinitePlane('assets/images/Template/field', 0, 0, 400, 85, -7, -7, 0.5, 0.05, 16, -10, true)
    self.ceilingPlane:setImage(GENERATE_CHECKERBOARD(32, 32, 8, 8))

    -- Distant skyline
    self.horizon = DistantHorizon('assets/images/Template/sky', 70, 1)

    -- Main player sprite
    self.crawler = CrawlerSprite()

    -- Obstacle Sprites
    self.Obstacles = ObstacleManager(150, 1000, 1500)

    -- NPC Sprites
    self.NPCs = NPCManager(150, 1000, 1500)
    self.NPCs:add('Clown', 'assets/images/Testing/Person', 2.0, 0)
    self.NPCs:add('Clown2', 'assets/images/Testing/Person', 2.0, 2)
    self.NPCs:add('Clown3', 'assets/images/Testing/Person', 2.0, -15)
    self.NPCs:add('Clown4', 'assets/images/Testing/Person', 2.0, 0)
    self.NPCs:add('Clown5', 'assets/images/Testing/Person', 2.0, -30)

    -- Fake 3d camera properties
    self.angle = 0
    self.camX, self.camY = 0, 0
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
    self.crawler:add(200, 175)
end

function scene:start()
	scene.super.start(self)

    self.NPCs:start(self)
    self.Obstacles:start(self)
end

function scene:drawBackground()
    -- Clears the screen to white
	scene.super.drawBackground(self)

    -- Draw the distant horizon image
    self.horizon:draw(self.camX)

    -- Draw ground and then ceiling
    local c = math.cos(self.angle)
    local s = math.sin(self.angle)
    self.groundPlane:drawAngled(self.camX, self.camY, c, s)
    -- self.ceilingPlane:drawAngled(-self.camX, self.camY, c, s)
end

function scene:update()
	scene.super.update(self)

    -- Respond to input changes
    self.controller:update()

    -- Adjust animation
    self.crawler:adjustSpeed(self.controller.speed / self.controller.maxSpeed)

    -- Move
    local dx, dy = self.controller:computeMove(self.angle)
    self.camX += dx
    self.camY += dy

    -- Sync PSprites
    self.Obstacles:update(self)
    self.NPCs:update(self)

    -- Update all standard sprites
    gfx.sprite.update()
end

function scene:exit()
	scene.super.exit(self)
end
