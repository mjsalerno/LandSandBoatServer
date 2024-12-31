---------------------------------------------------------------------------------------------------
-- func: zap
-- desc: expresses GM anger on cursor target
---------------------------------------------------------------------------------------------------

---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 3,
    parameters = ""
}

commandObj.onTrigger = function (player)
    local victim = player:getCursorTarget()

    if not victim then
        player:printToPlayer("Must target a player with cursor! ")
        return
    end

    if not victim:isPC() then
        player:printToPlayer("Only works on players, not NPCs and not Monsters. ")
        return
    end

    -- Begin Wrath of the Gods Animation
    victim:injectActionPacket(player:getID(), 5, 207, 0, 0, 0, 0, 0)
    victim:injectActionPacket(player:getID(), 5, 270, 0, 0, 0, 0, 0)
    -- End Wrath of the Gods Animation
end

return commandObj