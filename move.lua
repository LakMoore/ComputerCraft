--[[
Just some safe moving functions, as recommended by the tutorial, 
here: http://www.computercraft.info/forums2/index.php?/topic/15086-turtle-intermediate-3

Usage:
os.loadAPI(move)
then call move.Forward() in the code

]]


-- returns 1 if the move was successful
-- returns 0 if we were unable to move forward (due to bedrock)
-- returns -1 if path is blocked by something we dont WANT to mine
local function Forward()
  local waited = 0
  while not turtle.forward() do
      --# check if another CC component is in our way
      local periphType = peripheral.getType("front")
      if periphType == "turtle" then
        if waited > 3 then
            print("This Turtle isn't moving, we must be in a head-on collision")
            --# Take evasive action or go home!
            return -1
        end
        print("A Turtle is in my way, waiting for it to move")
        sleep(0.8)
        waited = waited + 1
      elseif periphType then
        print("Something ComputerCraft is in my way, and it cannot move out of my way")
        --# Go around or go home!
        return -1
      else
        --# check if a block was the cause
        if turtle.detect() then
          if not turtle.dig() then
            print("An unbreakable block has been encountered, bedrock is that you?")
            --# unable to proceed in this direction
            return 0
          elseif turtle.detect() then
            print("Sand/Gravel is falling!")
            sleep(0.8)
          else
            print("A block was in my way")
          end
        --# check if fuel was the cause
        elseif turtle.getFuelLevel() ~= "unlimited" and turtle.getFuelLevel() == 0 then
          print("I am out of fuel... HELP!")
          --# TODO: would be better to reserve enough fuel to get home
        elseif turtle.attack() then
          print("Get out of my way mob/player!")
        end
      end
  end

  --# if we finally get here then we were able to move forward 1 block... phew!
  return 1
end



