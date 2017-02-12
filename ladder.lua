--[[
Ladder hole digging program found here: http://pastebin.com/YgAui7aC
Forum thread: http://www.computercraft.info/forums2/index.php?/topic/6686-haj523s-turtle-programs/

TODO:
Current version works nicely but needs to return if it runs out of wall blocks
]]

local tArgs = { ... }

--Check for Valid Args
if (#tArgs < 1) or (#tArgs > 2) then
	print("Usage: ladder <depth> <up?>")
	print("    Make sure that you provide enough fuel to go up and down <depth> + 1")
	print("    Max Depth 64")
	print("    Slot 1: Fuel")
	print("    Slot 2: Wall Blocks")
	print("    Slot 3: Ladder Blocks")
	return
end

local depth=tonumber(tArgs[1])
local dir=0

--Check Depth
if depth>64 then
	depth=64
elseif depth<1 then
	return
end

if (#tArgs > 1) then
	dir=tonumber(tArgs[2])
	if (dir >= 1) then
		dir=1
	else
		dir=-1
	end
end

local function refuel(slot)
	local fuelLevel = turtle.getFuelLevel()
	if fuelLevel == "unlimited" or fuelLevel > 0 then
		return
	end
	
	local function tryRefuel()
		if turtle.getItemCount(1) > 0 then
			turtle.select(1)
			if turtle.refuel(1) then
				return true
			end
		end
		return false
	end
	
	if not tryRefuel() then
		print( "Add more fuel to continue." )
		while not tryRefuel() do
			sleep(5)
		end
		print( "Resuming..." )
		turtle.select(slot)
	end
end

local function checkBlock(slot,first,last,block)
	while turtle.getItemCount(slot) == 0 do
		slot = slot + 1
		if slot > last then
			print("Missing: " .. block)
			print("Slots: " .. first .. "-" .. last)
			local line=""
			repeat
				print("Enter 'Y' to continue: ")
				line = io.read()
			until string.lower(line) ~= "y"
			print("Resuming...")
			slot = first --Reset slot to first
		end
	end
	return slot
end

local function checkStorage()
	if turtle.getItemCount(16) > 0 then
		print("Clean inventory...")
		while turtle.getItemCount(16) > 0 do
			sleep(5)
		end
		print( "Resuming..." )
	end
end

--slot  - current slot of blocks (returned)
--inv   - start of inventory slots
--first - start of blocks slots
--last  - end of blocks slots
--block - block name
--dir   - place direction
local function tryBlock(slot,inv,first,last,block,dir)
	slot=checkBlock(slot,first,last,block)
	turtle.select(slot)
	if (dir == 0) then
		turtle.place()
	elseif (dir > 0) then
		turtle.placeUp()
	else
		turtle.placeDown()
	end
	turtle.select(inv)
	return checkBlock(slot,first,last,block)
end

local function tryDig()
	while turtle.detect() do
		if turtle.dig() then
			checkStorage()
			sleep(0.5)
		else
			return false
		end
	end
	return true
end

local function tryDigDown()
	if turtle.digDown() then
		checkStorage()
		return true
	end
	return false
end

local function tryDigUp()
	while turtle.detectUp() do
		if turtle.digUp() then
			checkStorage()
			sleep(0.5)
		else
			return false
		end
	end	
	return true
end

local function tryUp(slot)
	refuel(slot)
	while not turtle.up() do
		if turtle.detectUp() then
			if not tryDigUp() then
				return false
			end
		elseif turtle.attackUp() then
			checkStorage()
		else
			sleep( 0.5 )
		end
	end
	return true
end

local function tryDown(slot)
	refuel(slot)
	while not turtle.down() do
		if turtle.detectDown() then
			if not tryDigDown() then
				return false
			end
		elseif turtle.attackDown() then
			checkStorage()
		else
			sleep( 0.5 )
		end
	end
	return true
end

local function tryForward(slot)
	refuel(slot)
	while not turtle.forward() do
		if turtle.detect() then
			if not tryDig() then
				return false
			end
		elseif turtle.attack() then
			checkStorage()
		else
			sleep(0.5)
		end
	end
	return true
end

local i=depth

while i > 0 do
	if (dir < 0) then
		tryDigDown()
		tryDown()
	else
		tryDigUp()
		tryUp()
	end
	tryDig()
	tryBlock(2,4,2,2,"Wall",0)
	i=i-1
end

i=depth
turtle.turnRight()
turtle.turnRight()
tryDig()
tryForward()
turtle.turnRight()
turtle.turnRight()

while i > 0 do
	tryBlock(3,4,3,3,"Ladder",0)
	if (dir > 0) then
		tryDigDown()
		tryDown()
	else
		tryDigUp()
		tryUp()
	end
	i=i-1
end
