-- [[ XRB-BARTERING - CLIENT SIDE SCRIPT ]]
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}

-- Ped-i i Kontratave
local contractPed = nil; local contractPedBlip = nil; local localCurrentContractPedLocationIndex = -1; local activeContract = nil
-- Ped-et e Dyqaneve
local shopPeds = {}

-- [[ FUNKSIONET E PED-EVE TE DYQANEVE ]]
local function spawnShopPeds() if not Config.Shops or #Config.Shops == 0 then return end; for i, shopData in ipairs(Config.Shops) do if shopData.id and shopData.ped_model and shopData.ped_coords then RequestModel(shopData.ped_model); local attempts = 0; while not HasModelLoaded(shopData.ped_model) and attempts < 50 do Wait(100); attempts = attempts + 1 end; if HasModelLoaded(shopData.ped_model) then local ped = CreatePed(4, shopData.ped_model, shopData.ped_coords.x, shopData.ped_coords.y, shopData.ped_coords.z - 1.0, shopData.ped_heading or 0.0, true, true); FreezeEntityPosition(ped, true); SetEntityInvincible(ped, true); SetBlockingOfNonTemporaryEvents(ped, true); if shopData.ped_scenario then TaskStartScenarioInPlace(ped, shopData.ped_scenario, 0, true) end; SetModelAsNoLongerNeeded(shopData.ped_model); shopPeds[shopData.id] = ped; exports.ox_target:addLocalEntity(ped, {{ name = ('open_shop_%s'):format(shopData.id), icon = 'fas fa-store', label = Config.Messages['open_shop_target_label']:format(shopData.label), distance = 1.5, onSelect = function() TriggerServerEvent('xrb-bartering:requestShopAccess', shopData.id) end }}) else print(('[xrb-Bartering] [ERROR] Shop ped model "%s" for shop "%s" failed to load!'):format(shopData.ped_model, shopData.id)) end else print(('[xrb-Bartering] [ERROR] Invalid config for shop at index %d'):format(i)) end end end

-- [[ FUNKSIONET E PED-IT TE KONTRATAVE ]]
local function spawnOrUpdateContractPed(locationIndex) local location = Config.PedLocations[locationIndex]; if not location then print(('[xrb-Bartering] [ERROR] Contract location index %s not found.'):format(locationIndex)); return end; if contractPed then exports.ox_target:removeLocalEntity(contractPed); if DoesEntityExist(contractPed) then DeleteEntity(contractPed) end; contractPed = nil end; if contractPedBlip and DoesBlipExist(contractPedBlip) then RemoveBlip(contractPedBlip); contractPedBlip = nil end; RequestModel(Config.PedModel); local attempts = 0; while not HasModelLoaded(Config.PedModel) and attempts < 50 do Wait(100); attempts = attempts + 1 end; if not HasModelLoaded(Config.PedModel) then print(('[xrb-Bartering] [CRITICAL ERROR] Contract ped model "%s" failed load!'):format(Config.PedModel)); return end; contractPed = CreatePed(4, Config.PedModel, location.x, location.y, location.z - 1.0, GetRandomFloatInRange(0.0, 360.0), true, true); FreezeEntityPosition(contractPed, true); SetEntityInvincible(contractPed, true); SetBlockingOfNonTemporaryEvents(contractPed, true); TaskStartScenarioInPlace(contractPed, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true); SetModelAsNoLongerNeeded(Config.PedModel); contractPedBlip = AddBlipForEntity(contractPed); SetBlipSprite(contractPedBlip, 1); SetBlipScale(contractPedBlip, 0.8); SetBlipColour(contractPedBlip, 5); SetBlipAsShortRange(contractPedBlip, true); BeginTextCommandSetBlipName("STRING"); AddTextComponentString(Config.Messages['bartering_ped_label']); EndTextCommandSetBlipName(contractPedBlip); exports.ox_target:addLocalEntity(contractPed, { { name = 'barter_start', icon = 'fas fa-handshake', label = Config.Messages['start_contract'], canInteract = function() return not activeContract end, onSelect = function() TriggerServerEvent('xrb-bartering:requestContract') end }, { name = 'barter_submit', icon = 'fas fa-box-open', label = Config.Messages['submit_items'], canInteract = function() return activeContract ~= nil end, onSelect = function() if activeContract then TriggerServerEvent('xrb-bartering:submitItems') else exports.ox_lib:notify({ title = 'Error', description = Config.Messages['no_active_contract'], type = 'error' }) end end }, { name = 'barter_cancel', icon = 'fas fa-ban', label = Config.Messages['cancel_contract'], canInteract = function() return activeContract ~= nil end, onSelect = function() if activeContract then TriggerServerEvent('xrb-bartering:requestCancelContract') else exports.ox_lib:notify({ title = 'Error', description = Config.Messages['no_active_contract'], type = 'error' }) end end } }); localCurrentContractPedLocationIndex = locationIndex end

-- [[ Initialize Script ]]
CreateThread(function() while QBCore == nil do TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end); Citizen.Wait(100) end; while not QBCore.Functions.GetPlayerData().citizenid do Citizen.Wait(100) end; PlayerData = QBCore.Functions.GetPlayerData(); Citizen.Wait(2500); TriggerServerEvent('xrb-bartering:requestInitialState'); spawnShopPeds(); end)

-- [[ Shop UI ]]
RegisterNetEvent('xrb-bartering:openOxLibShop', function(shopLabel, shopStockData, shopId) if not shopStockData or #shopStockData == 0 then exports.ox_lib:notify({ title = shopLabel, description = Config.Messages['shop_empty'], type = 'inform' }); return end; local shopOptions = {}; for i, itemData in ipairs(shopStockData) do if itemData and itemData.name and itemData.stock ~= nil and itemData.price ~= nil and itemData.currency then local itemLabel = exports.ox_inventory:Items(itemData.name)?.label or itemData.name; local currencyLabel = itemData.currency:upper(); table.insert(shopOptions, { title = string.format("%s (Sasia: %d)", itemLabel, itemData.stock), description = string.format(Config.Messages['shop_item_description'], itemData.price, currencyLabel), icon = 'fas fa-box', disabled = (itemData.stock <= 0), onSelect = function() if itemData.stock > 0 then TriggerServerEvent('xrb-bartering:purchaseShopItem', shopId, itemData.name, itemData.price, itemData.currency) else exports.ox_lib:notify({ title = 'Error', description = Config.Messages['shop_purchase_failed_stock'], type = 'error' }) end end }) end end; if #shopOptions > 0 then lib.registerContext({ id = ('barter_shop_%s'):format(shopId), title = Config.Messages['shop_title']:format(shopLabel), options = shopOptions }); lib.showContext(('barter_shop_%s'):format(shopId)) else exports.ox_lib:notify({ title = shopLabel, description = Config.Messages['shop_empty'], type = 'inform' }) end end)

-- [[ Admin Menu Logic ]]
local function openAdminAmountDialog(targetPlayerId, targetPlayerName, action) local title = ""; if action == 'add' then title = Config.Messages['admin_input_amount_add'] elseif action == 'remove' then title = Config.Messages['admin_input_amount_remove'] elseif action == 'set' then title = Config.Messages['admin_input_amount_set'] else return end; local amount = lib.inputDialog(title, { { type = 'number', label = 'Amount', placeholder = 'Enter amount', required = true, min = 0 } }); if not amount or not amount[1] then return end; local amountNum = tonumber(amount[1]); if not amountNum or amountNum < 0 then exports.ox_lib:notify({ title = 'Error', description = Config.Messages['invalid_amount'], type = 'error' }); return end; TriggerServerEvent('xrb-bartering:adminModifyPoints', targetPlayerId, action, amountNum) end
local function openAdminPlayerActionsMenu(targetPlayerId, targetPlayerName) local menuId = 'barter_admin_player_' .. targetPlayerId; local title = Config.Messages['admin_player_actions_title']:format(targetPlayerName, targetPlayerId); local options = { { title = Config.Messages['admin_add_points'], icon = 'fas fa-plus-circle', onSelect = function() openAdminAmountDialog(targetPlayerId, targetPlayerName, 'add') end }, { title = Config.Messages['admin_remove_points'], icon = 'fas fa-minus-circle', onSelect = function() openAdminAmountDialog(targetPlayerId, targetPlayerName, 'remove') end }, { title = Config.Messages['admin_set_points'], icon = 'fas fa-check-circle', onSelect = function() openAdminAmountDialog(targetPlayerId, targetPlayerName, 'set') end }, }; lib.registerContext({ id = menuId, title = title, options = options }); lib.showContext(menuId) end
RegisterNetEvent('xrb-bartering:openAdminMenu', function(players) if not players or #players == 0 then exports.ox_lib:notify({ title = 'Admin Menu', description = 'No players online.', type = 'inform' }); return end; local options = {}; for _, plyData in ipairs(players) do if plyData and plyData.source and plyData.name then table.insert(options, { title = string.format("%s (%s)", plyData.name, plyData.source), description = "Select actions for this player", icon = 'fas fa-user', onSelect = function() openAdminPlayerActionsMenu(plyData.source, plyData.name) end }) end end; table.sort(options, function(a,b) return a.title < b.title end); lib.registerContext({ id = 'barter_admin_main', title = Config.Messages['admin_menu_title'], options = options }); lib.showContext('barter_admin_main') end)

-- [[ Server Event Handlers ]]
RegisterNetEvent('xrb-bartering:updatePedLocation', function(newLocationIndex) if newLocationIndex and newLocationIndex ~= localCurrentContractPedLocationIndex then spawnOrUpdateContractPed(newLocationIndex) end end)
RegisterNetEvent('xrb-bartering:contractInfo', function(contractInfo) if contractInfo and contractInfo.contractId then activeContract = contractInfo else activeContract = nil end end)
RegisterNetEvent('xrb-bartering:contractSuccess', function() activeContract = nil end)
RegisterNetEvent('xrb-bartering:contractFailed', function() activeContract = nil end)
RegisterNetEvent('xrb-bartering:receiveInitialState', function(locationIndex) if locationIndex then if locationIndex ~= localCurrentContractPedLocationIndex then spawnOrUpdateContractPed(locationIndex) elseif not contractPed then spawnOrUpdateContractPed(locationIndex) end else print("[xrb-Bartering] [ERROR] Received invalid initial ped location index from server.") end end)


RegisterCommand('bartering', function()
    TriggerServerEvent('xrb-bartering:requestStatusCommand')
end, false)


RegisterNetEvent('xrb-bartering:showStatusMenu', function(statusData)
    if not statusData then return end 

    local options = {}
    local points = statusData.points or 0
    local contract = statusData.contract 

    -- Opsioni per Piket Aktuale
    table.insert(options, {
        title = "Current Points: " .. points, 
        description = "Your bartering points balance.",
        icon = 'fas fa-coins',
        disabled = true 
    })

    table.insert(options, { title = "----- Active Contract -----", description = "", disabled = true}) 

    -- Nese ka kontrate aktive
    if contract and contract.contractData then 
        local gameTimeSeconds = GetGameTimer() / 1000
        local remainingSeconds = math.max(0, math.floor(contract.endTime - gameTimeSeconds))
        local minutes = math.floor(remainingSeconds / 60)
        local seconds = remainingSeconds % 60
        local pointsReward = contract.contractData.points_reward or 'N/A' 

        table.insert(options, {
            title = "contracts: " .. (contract.contractData.name or "Unknown"),
            description = string.format("Time Left: %s:%02d", minutes, seconds),
            icon = 'fas fa-file-contract',
            disabled = true
        })

        -- Opsioni per Piket e Shperblimit
        table.insert(options, {
            title = "Rewards: " .. tostring(pointsReward) .. " Points",
            description = "Points to be earned upon completion.",
            icon = 'fas fa-star',
            disabled = true
        })

        -- Opsionet per Artikujt e Kerkuar
        if contract.contractData.required_items and #contract.contractData.required_items > 0 then
             table.insert(options, { title = "Searched Items:", description = "--------------------", disabled = true})
            for _, req in ipairs(contract.contractData.required_items) do
                local itemLabel = exports.ox_inventory:Items(req.item)?.label or req.item
                table.insert(options, {
                    title = string.format("- %sx %s", req.count, itemLabel),
                    description = "Required item for the contract.",
                    icon = 'fas fa-box',
                    disabled = true
                })
            end
        else
             table.insert(options, { title = "No specific items required..", icon = 'fas fa-check', disabled = true})
        end
    else
        -- Nese nuk ka kontrate aktive
        table.insert(options, {
            title = Config.Messages['bartering_command_no_contract'],
            icon = 'fas fa-times-circle',
            disabled = true
        })
    end

    -- Shfaq menune
    lib.registerContext({
        id = 'barter_status_menu',
        title = Config.Messages['bartering_command_info_title'],
        options = options,
        -- menu = 'default' -- Mund te ndryshosh stilin nese deshiron
    })
    lib.showContext('barter_status_menu')
end)



-- [[ Player Death ]]
RegisterNetEvent('QBCore:Client:OnPlayerDeath', function() if activeContract then TriggerServerEvent('xrb-bartering:server:playerDied') end end)

-- [[ Resource Stop Cleanup ]]
AddEventHandler('onResourceStop', function(resourceName) if resourceName == GetCurrentResourceName() then if contractPed then exports.ox_target:removeLocalEntity(contractPed); if DoesEntityExist(contractPed) then DeleteEntity(contractPed) end end; if contractPedBlip and DoesBlipExist(contractPedBlip) then RemoveBlip(contractPedBlip) end; contractPed, contractPedBlip = nil, nil; for shopId, ped in pairs(shopPeds) do if ped and DoesEntityExist(ped) then exports.ox_target:removeLocalEntity(ped); DeleteEntity(ped) end end; shopPeds = {}; activeContract = nil; end end)
