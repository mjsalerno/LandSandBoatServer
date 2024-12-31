require('scripts/enum/item')
require('scripts/globals/shop')

local commandObj = {}

commandObj.cmdprops =
{
    permission = 2,
    parameters = ''
}

-- Forward declarations (required)
local menu  = {}
local selecta = {}
local selectb = {}
local starter = {}
local medicine = {}
local mogpell = {}
local scrolls = {}
local keys = {}
local keysa = {}

local delaySendMenu = function(player)
    player:timer(50, function(playerArg)
        playerArg:customMenu(menu)
    end)
end

menu =
{
    title = 'What would you like?',
    options = {},
}

selecta =
{
    {
        'Nothing for now',
        function(player)
        end
    },
    {
        'Medicine',
         function(player)
            menu.options = xi.shop.general(player, medicine)
         end
    },
    {
        'Starter Items',
         function(player)
            menu.options = xi.shop.general(player, starter)
         end
    },
    {
        'Mog Pell',
         function(player)
            menu.options = xi.shop.general(player, mogpell)
         end
    },
    {
        'Scrolls',
         function(player)
            menu.options = xi.shop.general(player, scrolls)
         end
    },
    {
        'Next Page',
         function(player)
            menu.options = selectb
            delaySendMenu(player)
         end
    },
}
selectb =
{
    {
        'Keys Page1',
         function(player)
            menu.options = xi.shop.general(player, keys)
         end
    },
    {
        'Keys Page2',
         function(player)
            menu.options = xi.shop.general(player, keysa)
         end
    },
    {
        'Previous Page',
         function(player)
           menu.options = selecta
           delaySendMenu(player)
         end
    },
}
medicine =
    {
            4112,     300,   -- Potion
            4116,     600,   -- Hi-Potion
            4120,    1200,   -- X-Potion
            4128,     650,   -- Ether / Temporarily(?) removed by SE June 2021
            4132,    1300,   -- Hi-Ether
            4136,    3000,   -- Super Ether
            4145,   15000,   -- Elixir
            4148,     300,   -- Antidote
            4150,    1000,   -- Eye Drops
            4151,     700,   -- Echo Drops
            4156,     500,   -- Mulsum
            4164,     500,   -- Prism Powder
            4165,     500,   -- Silent Oil
            4166,     250,   -- Deodorizer
            4172,    1000,   -- Reraiser
            4153,     500,   -- Antacid
    }
starter =
    {
            xi.item.DESTRIER_BERET,     1,
            xi.item.CHOCOBO_SHIRT,      1,
            xi.item.MURREY_GRISAILLE,   1,
            xi.item.VANACLOCK,          1,
    }
mogpell =
    {
            xi.item.RAINBOW_MOG_PELL,   1,
            xi.item.OCHRE_MOG_PELL,     1,
            xi.item.RED_MOG_PELL,       1,
    }
scrolls =
    {
            4181,     500,   -- Instant Warp
            4182,     500,   -- Instant Reraise
            5428,     500,   -- Instant Retrace
            5988,     500,   -- Instant Protect
            5989,     500,   -- Instant Shell
            5990,     500,   -- Instant Stoneskin
            1550,     500,   -- Ark Pentasphere
    }
keys =
    {
            1024,    2500,   -- Ghelsba Chest Key
            1025,    2500,   -- Palborough Chest Key
            1026,    2500,   -- Giddeus Chest Key
            1027,    2500,   -- Ranperre Chest Key
            1028,    2500,   -- Dangruf Chest Key
            1029,    2500,   -- Horutoto Chest Key
            1030,    2500,   -- Ordelle Chest Key
            1031,    2500,   -- Gusgen Chest Key
            1032,    2500,   -- Shakhrami Chest Key
            1033,    2500,   -- Davoi Chest Key
            1034,    2500,   -- Beadeaux Chest Key
            1035,    2500,   -- Oztroja Chest Key
            1036,    2500,   -- Delkfutt Chest Key
            1037,    2500,   -- Fei'Yin Chest Key
            1038,    2500,   -- Zvahl Chest Key
            1039,    2500,   -- Eldieme Chest Key
            1040,    2500,   -- Nest Chest Key
            1041,    2500,   -- Garlaige Chest Key
            1043,    5000,   -- Beadeaux Coffer Key
    }
keysa =
    {
            1042,    5000,   -- Davoi Coffer Key
            1044,    5000,   -- Oztroja Coffer Key
            1045,    5000,   -- Nest Coffer Key
            1046,    5000,   -- Eldieme Coffer Key
            1047,    5000,   -- Garlaige Coffer Key
            1048,    5000,   -- Zvhal Coffer Key
            1049,    5000,   -- Uggalepih Coffer Key
            1050,    5000,   -- Den Coffer Key
            1051,    5000,   -- Kuftal Coffer Key
            1052,    5000,   -- Boyahda Coffer Key
            1053,    5000,   -- Cauldron Coffer Key
            1054,    5000,   -- Quicksand Coffer Key
            1055,    2500,   -- Grotto Chest Key
            1056,    2500,   -- Onzozo Chest Key
            1057,    5000,   -- Toraimarai Coffer Key
            1058,    5000,   -- Ru'Aun Coffer Key
            1059,    5000,   -- Grotto Coffer Key
            1060,    5000,   -- Ve'Lugannon Coffer Key
            1061,    2500,   -- Sacrarium Chest Key
            1062,    2500,   -- Oldton Chest Key
            1063,    5000,   -- Newton Coffer Key
            1064,    2500,   -- Pso'Xja Chest Key
    }
commandObj.onTrigger = function(player)
     menu.options = selecta
     delaySendMenu(player)
end
return commandObj