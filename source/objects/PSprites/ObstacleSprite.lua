import 'objects/PSprites/PSprite.lua'

ObstacleSprite = {}
class("ObstacleSprite").extends(PSprite)

-- Static obstacles
STATIC_SPRITE_NAMES = {
    { name='Small Rock', path='assets/images/Obstacles/Rock_Sm', frames=1, block=false },
    { name='Large Rock 1', path='assets/images/Obstacles/Rock_Lg1', frames=1, block=true },
    { name='Large Rock 2', path='assets/images/Obstacles/Rock_Lg2', frames=1, block=true },
    { name='Stalagtite', path='assets/images/Obstacles/Stlag', frames=1, block=true }
}

STATIC_SPRITE_FREQS = { 0.55, 0.7, 0.85 }

-- Character obstacles
CHARACTER_SPRITE_NAMES = {
    { name='Frog Bug', path='assets/images/Characters/FrogBugStatic', frames=1, freq={ 1.0, 0.67, 0.2 }, block=true },
    { name='Fire Muncher', path='assets/images/Characters/FireMuncherStatic', frames=1, freq={ 0.0, 0.33, 0.5 }, block=true },
    { name='Antennaed Slitherer', path='assets/images/Characters/AntennaedSlithererStatic', frames=1, freq={ 0.0, 0.0, 0.3 }, block=true }
}

CHARACTER_SPRITE_FREQS = {
    { 1.0, 1.0 },
    { 0.67, 1.0 },
    { 0.2, 0.7 }
}

function ObstacleSprite:init(isCharacter, phase, scale, X)
    local spriteObj = nil
    if isCharacter then
        spriteObj = self:pickSprite(CHARACTER_SPRITE_NAMES, CHARACTER_SPRITE_FREQS[phase or 1])
    else
        spriteObj = self:pickSprite(STATIC_SPRITE_NAMES, STATIC_SPRITE_FREQS)
    end

    if spriteObj ~= nil then
    	ObstacleSprite.super.init(self, spriteObj.name, spriteObj.path, scale, X, spriteObj.frames)
    end
end

function ObstacleSprite:pickSprite(list, freqs)
    -- Make random number between 0 and 1
    local rand = math.random()

    -- Search for the first value greater than random
    for i, freq in ipairs(freqs) do
        if freq > rand then
            return list[i]
        end
    end

    -- Return last one
    return list[#list]
end
