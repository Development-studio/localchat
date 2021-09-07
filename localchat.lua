-- LXL lua mod for localchat
-- https://github.com/Development-studio/localchat

-- local json = require "json"

local DISTANCE = 100		-- local chat radius in blocks
local OP_PREFIX = "[§cA§r]"

local cnames = {
	["Steve"] = "§Hacker§r",
	["Mike"] = "§fCoolMiner§r"
}

local prefixes = {
	["Steve"] = "[§fOP§r]",
	["Mike"] = "[§fmember§r]"
}

-- Cname
function GetCname(pl)
	local pref = ""
	local name = pl.name
	local cname = name

	if(prefixes[name] ~= nil) then
		pref = prefixes[name]
	else
		if pl:isOP() then
			pref = OP_PREFIX
		end
	end

	if(cnames[name] ~= nil) then
		cname = cnames[name]
	end
	
	return pref .. cname
end

-- Local Broadcast
function Square(a)
	return a*a
end

function CheckDistance(from,to)
	local pos1 = from.pos
	local pos2 = to.pos
	return Square(pos2.x-pos1.x) + Square(pos2.y-pos1.y) + Square(pos2.z-pos1.z) <= DISTANCE
end

function LocalBroadcast(from,text)
	local players = mc.getOnlinePlayers()
	for i, pl in ipairs(players) do
		if pl:isOP() or CheckDistance(from,pl) then
			pl:tell("§7Ⓛ <" .. GetCname(from) .. "> " .. text)
		end
	end
end

-- Main
mc.listen("onChat", function(player,text)

    if(text:sub(1,1) == "!") then
    	--global chat
		mc.broadcast("§6Ⓖ§r <" .. GetCname(player) .. "> " .. text:sub(2))
    else
		--local chat
		LocalBroadcast(player,text)
	end
	
	return false
end)