---@diagnostic disable: redundant-value
-----------------------------------
-- Experience Book custom in Lower Jeuno (zone 245)
-----------------------------------
require('modules/module_utils')
require('scripts/zones/Lower_Jeuno/Zone')
require('scripts/globals/npc_util')
require('scripts/globals/utils')
-----------------------------------
local m = Module:new('leveling_book')
local survival = require('scripts/globals/teleports/survival_guide_map')

local UNLOCK_WITH_SURVIVAL_GUIDE = true
local TP_TO_BOOKS_ONLY = false
local GIVE_WARP_SCROLL = true

local levelingPoints =
{
	{
		title = 'Valkurm Dunes (12-18)',
		x = 128.163,
		y = -7.320,
		z = 95.083,
		rot = 0,
		zone = 103
	}, -- Valkurm Dunes
	{
		title = "Qufim Island (19-22)",
		x = -54.956,
		y = -20.000,
		z = 63.757,
		rot = 0,
		zone = 126
	}, -- Qufim Pond
	{
		title = "Qufim Island (23-25)",
		x = -31.682,
		y = -20.026,
		z = 258.653,
		rot = 0,
		zone = 126
	}, -- Qufim Pugils
	{
		title = "Yuh. Jungle (26-28)",
		x = -224.635,
		y = -0.255,
		z = 503.703,
		rot = 0,
		zone = 123
	}, -- Yuhtunga Jungle
	{
		title = "Yhoator Jungle (29 - 32)",
		x = -278.584,
		y = 8.300,
		z = 140.543,
		rot = 0,
		zone = 124
	}, -- Yhoator Jungle
	{
		title = "Garlaige Citadel (33-36)",
		x = -341.194,
		y = -3.250,
		z = 340.712,
		rot = 0,
		zone = 200
	}, -- Garlaige Citadel
	{
		title = "Crawler's Nest (37-43)",
		x = 345.456,
		y = -32.374,
		z = -19.874,
		rot = 0,
		zone = 197
	}, -- Crawler's Nest
	{
		title = "Western Altepa Desert (44-50)",
		x = -140.079,
		y = -13.407,
		z = 19.703,
		rot = 0,
		zone = 125
	}, -- Western Altepa Desert
	{
		title = "Lab. of Onzozo (51-54)",
		x = -16.756,
		y = 0.000,
		z = -181.055,
		rot = 0,
		zone = 213
	}, -- Labyrinth of Onzozo
	{
		title = "Wajaom Woodlands (55-59)",
		x = -237.550,
		y = -15.855,
		z = 86.347,
		rot = 0,
		zone = 51
	}, -- Wajaom Woodlands
	{
		title = "Lab. of Onzozo (60-69)",
		x = -33.094,
		y = 4.770,
		z = 139.340,
		rot = 0,
		zone = 213
	}, -- Labyrinth of Onzozo
	{
		title = "Kuftal Tunnel (70-75)",
		x = 17.172,
		y = -10.547,
		z = 8.043,
		rot = 0,
		zone = 174
	}, -- Kuftal Tunnel
	{
		title = "Bhaflau Thickets (72-75)",
		x = -514.809,
		y = -12.156,
		z = -81.485,
		rot = 171,
		zone = 52
	}  -- Bhaflau Thickets (Tandjana Islet)
}

local npc = {}

-- We need just a tiny delay to let the previous menu context be cleared out
-- 'New pages' are actually just whole new menus!
local delaySendMenu = function(player, menu)
	player:timer(50, function(playerArg)
		playerArg:customMenu(menu)
	end)
end

local isUnlocked = function(playerArg, zone)
	if not UNLOCK_WITH_SURVIVAL_GUIDE
	then
		return true
	end

	local tableIndex = survival.zoneIdToGuideIdMap[zone]
	local guide      = survival.survivalGuides[tableIndex]
	return guide and playerArg:hasTeleport(xi.teleport.type.SURVIVAL, guide.groupIndex - 1, guide.group - 1)
end

local sendPlayer = function(playerArg, x, y, z, rot, zone)
	if not isUnlocked(playerArg, zone)
	then
		playerArg:printToPlayer("That zone is not unlocked yet.", xi.msg.channel.NS_SAY)
		return
	end
	local tableIndex = survival.zoneIdToGuideIdMap[zone]
	local guide      = survival.survivalGuides[tableIndex]

	npc[playerArg:getZoneID()]:injectActionPacket(playerArg:getID(), 4, 122, 0, 0, 0, 10, 1)
	--playerArg:independentAnimation(playerArg, 11, 4)

	playerArg:timer(4500, function(playerArg)
	--playerArg:timer(9350, function(playerArg)
		if TP_TO_BOOKS_ONLY
		then
			playerArg:setPos(guide.posX, guide.posY, guide.posZ, guide.posRot, guide.zoneId)
		else
			playerArg:setPos(x, y, z, rot, zone)
		end
	end)


	if GIVE_WARP_SCROLL
	then
		local hasWarpScroll = playerArg:hasItem(4181) or playerArg:hasItem(28540)
		-- check to see if our player has a warp scroll or warp ring, if not, give them a scroll.
		if not hasWarpScroll then
			-- npcUtil.giveItem(playerArg, xi.items.SCROLL_OF_INSTANT_WARP) -- scroll_of_instant_warp
			npcUtil.giveItem(playerArg, 4181) -- scroll_of_instant_warp
		end
	end
end

local createMenu
createMenu = function(player, pageNo)
	local menu = {
		title = 'Choose your destination',
		options = {},
	}

	local levelingPointLen = #levelingPoints

	local firstOptionIndex = ((pageNo - 1) * 3) + 1

	for i = firstOptionIndex, firstOptionIndex + 2, 1
	do
		local zone = levelingPoints[i]
		if not zone then break end
		local opt = {
			(isUnlocked(player, zone.zone) and '[o] ' or '[x] ') .. zone.title,
			function(playerArg)
				sendPlayer(playerArg, zone.x, zone.y, zone.z, zone.rot, zone.zone)
			end,
		}
		menu.options[#menu.options + 1] = opt
	end

	if pageNo * 3 < levelingPointLen
	then
		local opt = {
			'Next Page',
			function(playerArg)
				delaySendMenu(playerArg, createMenu(player, pageNo + 1))
			end,
		}
		menu.options[#menu.options + 1] = opt
	end

	if pageNo > 1
	then
		local opt = {
			'Previous Page',
			function(playerArg)
				delaySendMenu(playerArg, createMenu(player, pageNo - 1))
			end,
		}
		menu.options[#menu.options + 1] = opt
	end

	return menu
end

m:addOverride('xi.zones.RuLude_Gardens.Zone.onInitialize', function(zone)
	-- Call the zone's original function for onInitialize
	super(zone)

	-- Menu NPC Example
	npc_ = zone:insertDynamicEntity({
		objtype   = xi.objType.NPC,
		name      = 'Leveling Book',
		look      = 2290,
		x         = 54.5281,
		y         = 10.000,
		z         = -70.6328,
		rotation  = 243,
		widescan  = 1,
		onTrigger = function(player, npc)
			delaySendMenu(player, createMenu(player, 1))
		end,
	})
	npc[243]=npc_
end)

m:addOverride('xi.zones.Northern_San_dOria.Zone.onInitialize', function(zone)
	-- Call the zone's original function for onInitialize
	super(zone)

	-- Menu NPC Example
	npc_ = zone:insertDynamicEntity({
		objtype   = xi.objType.NPC,
		name      = 'Leveling Book',
		look      = 2290,
		x         = -173.8807,
		y         = 4.000,
		z         = 77.1292,
		rotation  = 2,
		widescan  = 1,
		onTrigger = function(player, npc)
			delaySendMenu(player, createMenu(player, 1))
		end,
	})
	npc[231]=npc_
end)

return m

