local factions = {
    ["city_mayor"] = {
        name = "Мэрия города",
        members = {},
        leader = nil
    }
}

-- Функция для получения данных фракции ----------------------------------------------------
function getFactionData(player)
    local factionId = getElementData(player, "faction")
    if factionId and factions[factionId] then
        local members = {}
        for member, _ in pairs(factions[factionId].members) do
            table.insert(members, {id = getElementData(member, "playerId"), name = getPlayerName(member)})
        end
        local isLeader = (factions[factionId].leader == player)
        triggerClientEvent(player, "receiveFactionData", player, members, isLeader)
    end
end

-- Обработка запроса данных фракции ---------------------------------------------------------
addEvent("requestFactionData", true)
addEventHandler("requestFactionData", root, function()
    getFactionData(client)
end)

-- Команда для добавления игрока во фракцию или удаления из фракции -------------------------
addCommandHandler("set_player_faction",
    function(player, command, playerId, factionId)
        local targetPlayer = getPlayerFromId(tonumber(playerId))
        if targetPlayer then
            if factionId then
                if factions[factionId] then
                    factions[factionId].members[targetPlayer] = true
                    setElementData(targetPlayer, "faction", factionId)
                    outputChatBox("Игрок добавлен во фракцию " .. factions[factionId].name, player)
                else
                    outputChatBox("Фракция с ID " .. factionId .. " не найдена.", player)
                end
            else
                local currentFactionId = getElementData(targetPlayer, "faction")
                if currentFactionId then
                    factions[currentFactionId].members[targetPlayer] = nil
                    setElementData(targetPlayer, "faction", nil)
                    outputChatBox("Игрок удален из фракции " .. factions[currentFactionId].name, player)
                else
                    outputChatBox("Игрок не состоит в фракции.", player)
                end
            end
        else
            outputChatBox("Игрок с ID " .. playerId .. " не найден.", player)
        end
    end
)

-- Команда для назначения лидера фракции ---------------------------------------------------
addCommandHandler("set_player_faction_leader",
    function(player, command, playerId, factionId)
        local targetPlayer = getPlayerFromId(tonumber(playerId))
        if targetPlayer and factionId and factions[factionId] then
            factions[factionId].leader = targetPlayer
            factions[factionId].members[targetPlayer] = true
            setElementData(targetPlayer, "faction", factionId)
            outputChatBox("Игрок назначен лидером фракции " .. factions[factionId].name, player)
        else
            outputChatBox("Некорректный ID игрока или фракции.", player)
        end
    end
)

-- Обработка увольнения игрока из фракции --------------------------------------------------
addEvent("fireFactionMember", true)
addEventHandler("fireFactionMember", root, function(playerId)
    local player = client
    local targetPlayer = getPlayerFromId(playerId)
    local factionId = getElementData(player, "faction")
    if targetPlayer and factionId and factions[factionId] then
        if factions[factionId].leader == player then
            factions[factionId].members[targetPlayer] = nil
            setElementData(targetPlayer, "faction", nil)
            outputChatBox("Вы уволили игрока из фракции.", player)
            outputChatBox("Вы были уволены из фракции " .. factions[factionId].name, targetPlayer)
            getFactionData(player)
        else
            outputChatBox("Вы не являетесь лидером фракции.", player)
        end
    else
        outputChatBox("Игрок не найден или неверный ID фракции.", player)
    end
end)

-- Обработка приглашения игрока во фракцию --------------------------------------------------
addEvent("inviteFactionMember", true)
addEventHandler("inviteFactionMember", root, function(playerId)
    local player = client
    local targetPlayer = getPlayerFromId(playerId)
    local factionId = getElementData(player, "faction")
    if targetPlayer and factionId and factions[factionId] then
        if factions[factionId].leader == player then
            triggerClientEvent(targetPlayer, "showInvite", targetPlayer, getPlayerName(player), factions[factionId].name)
            outputChatBox("Приглашение отправлено игроку.", player)
        else
            outputChatBox("Вы не являетесь лидером фракции.", player)
        end
    else
        outputChatBox("Игрок не найден или неверный ID фракции.", player)
    end
end)

-- Обработка принятия приглашения во фракцию ------------------------------------------------
addEvent("acceptFactionInvite", true)
addEventHandler("acceptFactionInvite", root, function()
    local player = client
    local inviter = source
    local factionId = getElementData(inviter, "faction")
    if factionId and factions[factionId] then
        factions[factionId].members[player] = true
        setElementData(player, "faction", factionId)
        outputChatBox("Вы вступили во фракцию " .. factions[factionId].name, player)
        outputChatBox("Игрок вступил во фракцию.", inviter)
        getFactionData(inviter)
    else
        outputChatBox("Ошибка приглашения. Фракция не найдена.", player)
    end
end)

-- Функция для получения игрока по ID -------------------------------------------------------
function getPlayerFromId(id)
    for _, player in ipairs(getElementsByType("player")) do
        if getElementData(player, "playerId") == id then
            return player
        end
    end
    return nil
end