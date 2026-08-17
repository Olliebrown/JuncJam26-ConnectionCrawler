WelcomeScene = {}
class("WelcomeScene").extends(NobleScene)
local scene = WelcomeScene

local gfx <const> = playdate.graphics

function scene:setValues()
end

function scene:init()
	scene.super.init(self)
	self:setValues()
end

function scene:enter()
	scene.super.enter(self)
end

function scene:start()
	scene.super.start(self)
    self.NPCs:start(self)
end

function scene:drawBackground()
	scene.super.drawBackground(self)
end

function scene:update()
	scene.super.update(self)
end

function scene:exit()
	scene.super.exit(self)
end
