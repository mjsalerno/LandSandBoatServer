-----------------------------------
-- func: fafnir
-- desc: Summon a fightable Fafnir (no loot)
-- note:
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 5,
    parameters = ''
}

local mobID

commandObj.onTrigger = function(player)
    local x = 347.2237
    local y = -12.5101
    local z = -400.0551
    local rot = 255
    local zone = xi.zone.RALA_WATERWAYS
    if
        player:getZoneID() ~= zone then
        player:setPos(360.8445, -12.5101, -400.5133, 126, zone)
    end

    if mobID and GetMobByID(mobID) then
        return
    end

    local mob = GetZone(zone):insertDynamicEntity({
        objtype = xi.objType.MOB,
        name = 'Fafnir',
        x = x,
        y = y,
        z = z,
        rotation = rot,
        groupId = 5,
        groupZoneId = 154,
        onMobDeath = function(mob, playerArg, optParams)
            -- Do stuff
        end,
        onMobSpawn = function(mob)
            DespawnMob(mob:getID(), 300)
        end,
        releaseIdOnDisappear = true,
        mixins =
        {
            require('scripts/mixins/rage'),
            require('scripts/mixins/job_special'),
        },
        specialSpawnAnimation = true,
    })

    if not mob then
        return
    end

    -- Use the mob object as you normally would
    mob:setSpawn(x, y, z, rot)
    mob:setDropID(0) -- No loot!
    mob:setMobMod(xi.mobMod.NO_DROPS, 1)
    -- mob:spawn(10000, 5000)
    mob:spawn()
    mob:addStatusEffect(xi.effect.STUN, 69, 0, 3600)
    mob:setUnkillable(true)
    mobID = mob:getID()
end

return commandObj
