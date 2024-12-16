local audioManager = {}
local BASE_VOLUME = 0.1
local allSounds = {}
audioManager.BASE_VOLUME = 0.1
local globalVolume = 1

function audioManager.registerSound(sound)
    local scaledVolume = globalVolume * audioManager.BASE_VOLUME
    sound:setVolume(scaledVolume)
    table.insert(allSounds, sound)
end

function audioManager.setGlobalVolume(volume)
    globalVolume = volume
    local scaledVolume = globalVolume * audioManager.BASE_VOLUME
    for _, sound in ipairs(allSounds) do
        sound:setVolume(scaledVolume)
    end
end

return audioManager
