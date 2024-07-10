
function generateUniqueId()
    return math.random(100000, 999999)
end

function onPlayerJoin()
    local playerId = generateUniqueId()
    setElementData(source, "playerId", playerId)
end
addEventHandler("onPlayerJoin", root, onPlayerJoin)


