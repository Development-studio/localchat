-- LXL lua mod for localchat
-- https://github.com/

local json = require "json"

local DISTANCE = 100		-- local chat radius in blocks
local OP_TAG = "admin"  -- use in-game command /tag <player> add <OP_TAG>
local OP_PREFIX = "[§cA§r]"

local cnames = {
	["Steve"] = "§Hacker§r",
	["Mike"] = "§fCoolMiner§r"
}

local prefixes = {
	["Steve"] = "[§fOP§r]",
	["Mike"] = "[§fmember§r]"
}


function rawtext(content)
	return json.encode({rawtext = {{text = content}} })
end

function get_cname(plname)
	local pref = ""
	local cname = pl.name
	if(prefixes[pl.name] ~= nil) then
		pref = prefixes[pl.name]
	else
		if(pl.isOP(pl.name)) then
			pref = OP_PREFIX
		end
	end
	if(cnames[pl.name] ~= nil) then
		cname = cnames[pl.name]
	end
	return pref .. cname
end



mc.listen("onChat", function(name,text)

    if(text:sub(1,1) == "!")
    then
    	--global chat
		mc.runcmd("tellraw @a " .. rawtext("§6Ⓖ§r " .. get_cname(name) .. ": " .. text:sub(2)))
    else
		--local chat
		mc.runcmd(string.format("execute \"%s\" ~ ~ ~ tellraw @a[r=%i] %s", name, DISTANCE, rawtext("§3Ⓛ§r " .. get_cname(name) .. ": " .. text)))
		--send to ops (doesn't work if op is in different dimension)
		mc.runcmd(string.format("execute \"%s\" ~ ~ ~ tellraw @a[rm=%i,tag=%s] %s", name, DISTANCE + 1, OP_TAG, rawtext("§7Ⓛ <" .. get_cname(name) .. "> " .. text)))
	end
	
	return -1
end)
