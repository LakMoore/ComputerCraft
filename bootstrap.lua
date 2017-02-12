--[[
turtle bootstrap

Original Source and all credit to: 
https://github.com/seriallos/computercraft/blob/master/bootstrap.lua

simple program to get a bunch of other programs simply

Usage:
  > pastebin get caMmH484 bootstrap
  > github get LakMoore/ComputerCraft/master/bootstrap.lua bootstrap
  > bootstrap
--]]

http_runs = {
  ["pastebin"] = {
    -- if you want to get something from pastebin use this
    -- Usage:
    -- ["3mkeUzby"] = "OreQuarry",
  },
  -- make sure to use the right URL for raw.github.com
  ["github"] = {
    -- grab the mover API
    ["LakMoore/ComputerCraft/master/LakMoore/move.lua"] = "move",

    -- a great quarry program
    -- http://www.computercraft.info/forums2/index.php?/topic/7675-advanced-mining-turtle-ore-quarry/
    ["LakMoore/ComputerCraft/master/advancedminingturtle.cc.lua"] = "OreQuarry",

    -- a quarry program I want to try
    -- unable to find original thread!?
    ["LakMoore/ComputerCraft/master/quarry.cc.lua"] = "quarry",

    -- looks like digtower does exactly what I want!!
    -- unable to find original thread!?
    ["LakMoore/ComputerCraft/master/digtower.cc.lua"] = "digtower",
    
  },
}

for service, list in pairs( http_runs ) do
  for id, program in pairs( list ) do
    print( "Downloading "..program.." from "..service )
    shell.run( service, "get", id, program )
  end
end

--shell.run( "boot2" )
