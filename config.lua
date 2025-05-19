-- config.lua
Config = {}

-- [[ General Settings ]]
Config.PedModel = `a_m_m_farmer_01` -- Model for the contract giver ped
Config.AdminGroup = 'admin'        -- QBCore permission group needed for admin commands (e.g., 'admin', 'god')
Config.BlackMoneyItemName = "black_money" -- Item name for black money in the inventory system

-- [[ Contract Ped Locations ]]
Config.PedLocations = {
    vector3(1740.1201, 3329.0046, 41.2234),
    vector3(983.7450, -126.3322, 74.0012),
    vector3(1657.4205, 5.0647, 166.1179),
    vector3(-430.5353, 291.4746, 86.0624),
    vector3(-461.4174, 1080.1810, 323.8473),
    vector3(535.6957, -21.4712, 70.6294),
    vector3(-1576.4504, 143.9024, 58.4305),
    vector3(137.7020, -2200.7910, 4.6879),
}

-- [[ Contract Settings ]]
Config.ContractsPerLocation = 10 -- How many contracts total must be completed at a location before the ped moves
Config.PointsPenaltyDeath = 10   -- Points lost if the player dies (applied if > 0)
Config.PointsPenaltyFail = 20    -- Points lost if the player fails a contract (e.g., time runs out)
Config.PointsPenaltyCancelBase = 10  -- Penaliteti baze per anulim (do te dyfishohet)
Config.MaxCancelStreakForPenalty = 10 -- Opsionale: Limiti i streak per llogaritjen e penalitetit (p.sh. pas 5 anulimesh, penaliteti nuk rritet me tej)

-- [[ Contract Definitions (Tiered by Points) ]]
-- Keys represent the MINIMUM points required for this tier.
-- The script will select the highest tier the player qualifies for.
Config.ContractTiers = {
    [0] = { -- Tier 1: 0 - 4999 Points
        { id = 1, name = "Contract", required_items = {{ item = "weapon_pistol", count = 1 }, { item = "ammo-9", count = 20 }}, points_reward = 10, black_money_reward = { amount = 250, type = 'money' }, time_limit = 45 },
    },
    [5000] = { -- Tier 2: 5000 - 11999 Points
        { id = 101, name = "Contract", required_items = {{ item = "weapon_microsmg", count = 1 }, { item = "ammo-9", count = 60 }}, points_reward = 25, black_money_reward = { amount = 750, type = 'black_money' }, time_limit = 60 },
    },
    [12000] = { -- Tier 3: 12000 - 19999 Points
        { id = 201, name = "Contract", required_items = {{ item = "weapon_assaultrifle_mk2", count = 1 }, { item = "ammo-9", count = 100 }}, points_reward = 50, black_money_reward = { amount = 1500, type = 'black_money' }, time_limit = 75 },
    },
    [20000] = { -- Tier 4: 20000+ Points
        { id = 301, name = "Contract", required_items = {{ item = "weapon_advancedrifle", count = 1 }, { item = "weapon_heavypistol", count = 1 }, { item = "ammo-9", count = 150 }}, points_reward = 100, black_money_reward = { amount = 3000, type = 'black_money' }, time_limit = 90 },
    }
}


-- [[ Shop Settings ]]
Config.ShopRefreshIntervalMinutes = 60 -- How often shops refresh their stock (in minutes). Set to 0 or less to disable auto-refresh.

-- [[ Shop Definitions ]]
Config.Shops = {
    {
        id = 'barter_shop_1',
        label = 'Low Tier 5000+ Points',
        required_points = 5000,
        ped_model = `ig_manuel`,
        ped_coords = vector3(1104.5596, -2333.3298, 31.3931),
        ped_heading = 290.0,
        ped_scenario = 'WORLD_HUMAN_CLIPBOARD',
        potential_items = {
            { name = "lockpick", base_price = 500, currency = 'cash', chance = 75, min_stock = 5, max_stock = 20 },
            { name = "weapon_combatpistol", base_price = 1500, currency = 'cash', chance = 40, min_stock = 1, max_stock = 3 },
            { name = "bandage", base_price = 50, currency = 'cash', chance = 90, min_stock = 15, max_stock = 50 },
            { name = "radio", base_price = 250, currency = 'cash', chance = 60, min_stock = 2, max_stock = 10 }, -- Added item
        }
    },
    {
        id = 'barter_shop_2',
        label = 'Mid Tier 12000+ Points',
        required_points = 12000,
        ped_model = `g_m_y_lost_02`,
        ped_coords = vector3(1105.8434, -2330.1313, 31.3932),
        ped_heading = 165.0,
        ped_scenario = 'WORLD_HUMAN_SMOKING',
        potential_items = {
            { name = "bandage", base_price = 75, currency = 'cash', chance = 85, min_stock = 10, max_stock = 40 },
        }
    },
    {
        id = 'barter_shop_3',
        label = 'High Tier 20,000+ Points',
        required_points = 20000,
        ped_model = `g_m_m_chicold_01`,
        ped_coords = vector3(1110.3466, -2328.6667, 31.3931),
        ped_heading = 100.0,
        ped_scenario = 'WORLD_HUMAN_DRINKING',
        potential_items = {
            { name = "weapon_assaultrifle", base_price = 400000, currency = 'cash', chance = 5, min_stock = 1, max_stock = 1 },
            { name = "weapon_compactrifle", base_price = 300000, currency = 'cash', chance = 10, min_stock = 1, max_stock = 1 },
        }
    },
    {
        id = 'barter_shop_4',
        label = 'Attachments 20,000+ Points',
        required_points = 20000,
        ped_model = `mp_m_shopkeep_01`,
        ped_coords = vector3(1106.6497, -2326.3220, 31.3931),
        ped_heading = 165.0,
        ped_scenario = 'WORLD_HUMAN_HANG_OUT_STREET',
        potential_items = {
             { name = "weapon_pistol", base_price = 15000, currency = 'bank', chance = 40, min_stock = 1, max_stock = 3 }, 

             -- Add more attachments...
        }
    },
}


-- [[ Messages / Localization ]]
Config.Messages = {
    ['bartering_ped_label'] = 'Bartering Contractor',
    ['start_contract'] = 'Start New Contract',
    ['submit_items'] = 'Submit Items',
    ['cancel_contract'] = 'Cancel Active Contract',
    ['no_active_contract'] = 'You do not have an active contract.',
    ['already_active_contract'] = 'You already have an active contract.',
    ['no_contracts_available_for_tier'] = 'No suitable contracts available for your current point level. Check back later.',
    ['contract_accepted'] = 'Contract accepted: %s. You have %s minutes. Type /bartering for details.',
    ['required_items'] = 'Required Items:',
    ['not_enough_items'] = 'You do not have all the required items!',
    ['contract_success_points'] = 'Contract completed successfully! You earned %s points.',
    ['contract_success_money'] = 'Contract completed successfully! You earned %s points and %s.',
    ['contract_failed_time'] = 'Time\'s up! Contract failed. You lost %s points.',
    ['contract_failed_generic'] = 'Contract failed.',
    ['contract_cancelled_success'] = 'Your active contract was cancelled successfully. (Cancel Streak Reset)',
    ['contract_cancelled_penalty'] = 'Your active contract was cancelled. You lost %s points.',
    ['contract_cancelled_penalty_streak'] = 'Your active contract was cancelled. You lost %s points! (Cancel Streak: %s)',
    ['cannot_cancel_no_contract'] = 'You do not have an active contract to cancel.',
    ['points_lost_death'] = 'You lost %s bartering points due to death.',
    ['your_points'] = 'Your Bartering Points: %s',
    ['open_shop_target_label'] = 'Open (%s)',
    ['not_enough_points_shop'] = 'You do not have enough points (%s) to access this shop. %s required.',
    ['shop_title'] = 'Bartering Shop - %s',
    ['shop_item_description'] = 'Price: $%s',
    ['shop_purchase_success'] = 'You purchased 1x %s.',
    ['shop_purchase_failed_stock'] = 'Item is out of stock!',
    ['shop_purchase_failed_inventory'] = 'You don\'t have enough space in your inventory!',
    ['shop_purchase_failed_money_cash'] = 'You do not have enough cash!',
    ['shop_purchase_failed_money_bank'] = 'You do not have enough money in your bank!',
    ['shop_purchase_failed_generic'] = 'Purchase failed.',
    ['shop_empty'] = 'This shop is currently empty. Please check back later.',
    ['shop_refreshing'] = '[Bartering] Refreshing shop stock...',
    ['shop_refreshed'] = '[Bartering] Shop stock has been refreshed.',
    ['invalid_player'] = 'Player not found or is offline.',
    ['points_added'] = 'You added %s bartering points to player %s (ID: %s).',
    ['points_removed'] = 'You removed %s bartering points from player %s (ID: %s).',
    ['points_received'] = 'You received %s bartering points from an admin.',
    ['points_lost'] = '%s bartering points were removed by an admin.',
    ['invalid_amount'] = 'Invalid points amount.',
    ['no_permission'] = 'You do not have permission to use this command.',
    ['bartering_command_info_title'] = 'Bartering Contract Status',
    ['bartering_command_no_contract'] = 'You do not have an active bartering contract at the moment.',
    ['bartering_command_details'] = 'Contract: %s\nTime Remaining: %s:%s\nPoints Reward: %s\nRequired Items:',
    ['bartering_command_item_line'] = '- %sx %s',
    ['admin_menu_title'] = 'Bartering Admin',
    ['admin_select_player'] = 'Select Player',
    ['admin_player_actions_title'] = 'Actions for %s (%s)',
    ['admin_add_points'] = 'Add Points',
    ['admin_remove_points'] = 'Remove Points',
    ['admin_set_points'] = 'Set Points',
    ['admin_input_amount_add'] = 'Amount to Add',
    ['admin_input_amount_remove'] = 'Amount to Remove',
    ['admin_input_amount_set'] = 'Set Points To',
    ['admin_points_success'] = 'Points updated successfully for player %s (ID: %s).',
    ['admin_points_failed'] = 'Failed to update points for player %s (ID: %s).',
    ['points_set_admin'] = 'Your points have been set to %s by an admin.',
}