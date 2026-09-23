-----------------------------------
-- func: ah
-- desc: opens the Auction House menu anywhere in the world
-----------------------------------
require('modules/module_utils')
local commandObj = {}

commandObj.cmdprops =
{
    permission = 1,
    parameters = ''
}

commandObj.onTrigger = function(player)
    player:sendMenu(1)
end

xi.module.registerCommand('moghouse', commandObj)
