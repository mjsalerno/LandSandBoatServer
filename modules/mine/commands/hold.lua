---------------------------------------------------------------------------------------------------
--func: !hold <t>
---------------------------------------------------------------------------------------------------

---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 2,
    parameters = "s"
}

commandObj.onTrigger = function (player, target)

    if (target == nil) then
        player:printToPlayer("You must enter a valid target name.")
        player:printToPlayer( "!hold <player>" )

        return
    end

    local targ = GetPlayerByName(target)
    if (targ ~= nil) then
		if (targ:getStatusEffect(28)) then
			targ:addStatusEffect(28, 9999, 9999, 0)
		else
			targ:addStatusEffect(28, 9999, 9999, 999999)
		end
	end
end

return commandObj