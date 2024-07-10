
local playerIdLabel = nil

function generateUniqueId()
    return math.random(100000, 999999)
end

function onPlayerJoin()
    local playerId = generateUniqueId()
    setElementData(source, "playerId", playerId)
end
addEventHandler("onPlayerJoin", root, onPlayerJoin)

function displayPlayerId()
    local screenWidth, screenHeight = guiGetScreenSize()
    local localPlayerId = getElementData(localPlayer, "playerId")

    if localPlayerId then
        dxDrawText("ID: " .. tostring(localPlayerId), 10, 10, screenWidth, screenHeight, tocolor(255, 255, 255, 255), 1.5, "default-bold")

        for _, player in ipairs(getElementsByType("player")) do
            local x, y, z = getElementPosition(player)
            local sx, sy = getScreenFromWorldPosition(x, y, z + 1, 0.06)
            if sx and sy then
                local playerId = getElementData(player, "playerId")
                if playerId then
                    dxDrawText(tostring(playerId), sx, sy, sx, sy, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
                end
            end
        end
    end
end
addEventHandler("onClientRender", root, displayPlayerId)

function updatePlayerIdLabel()
    if playerIdLabel then
        destroyElement(playerIdLabel)
    end

    --удалил
end
addEventHandler("onClientElementDataChange", root, function(dataName)
    if dataName == "playerId" and getElementType(source) == "player" then
        if source == localPlayer then
            updatePlayerIdLabel()
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    updatePlayerIdLabel()
end)


