import 'objects/managers/PSpriteManager'

ObstacleManager = {}
class("ObstacleManager").extends(PSpriteManager)

function ObstacleManager:init(scaleX, widthScale, heightBase)
    ObstacleManager.super.init(self, scaleX, widthScale, heightBase)

    -- Make sure random generation is seeded
    math.randomseed(playdate.getSecondsSinceEpoch())
end
