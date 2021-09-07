-- LXL lua mod for localchat
-- https://github.com/Development-studio/localchat
-- version = 0.3.1

Cconfig = data.openConfig('.\\plugins\\localchat\\config.json', 'json', '{}')

if Cconfig:get('DISTANCE') == nil then
    Cconfig:set('DISTANCE', 100)
    Cconfig:set('OP_PREFIX', "[§cA§r]")
    Cconfig:set('cnames', {["Steve"] = "§r§cAlex§r§r", ["Alex"] = "§rSteve§r"})
    Cconfig:set('prefixes', {["Steve"] = "§cViP", ["Alex"] = "§cTester"})
end

DISTANCE = Cconfig:get('DISTANCE')
OP_PREFIX = Cconfig:get('OP_PREFIX')
Cnames = Cconfig:get('cnames')
Prefixes = Cconfig:get('prefixes')

function Reload()
    Cconfig:reload()
    DISTANCE = Cconfig:get('DISTANCE')
    OP_PREFIX = Cconfig:get('OP_PREFIX')
    Cnames = Cconfig:get('cnames')
    Prefixes = Cconfig:get('prefixes')
end

-- Cname
function GetCname(pl)
    local pref = ""
    -- local newpref = "§2[§r"..pref.."§2]§r "
	local name = pl.name
    local cname = name

    if (Prefixes[name] ~= nil) then
        pref = "§2[§r"..Prefixes[name].."§2]§r "
        --pref = Prefixes[name]
    else
        if pl:isOP() then pref = OP_PREFIX end
    end

    if (Cnames[name] ~= nil) then cname = Cnames[name] end

    return pref .. cname
end

-- Local Broadcast
function Square(a) return a * a end

function CheckDistance(from, to)
    local pos1 = from.pos
    local pos2 = to.pos
    return Square(pos2.x - pos1.x) + Square(pos2.y - pos1.y) + Square(pos2.z - pos1.z) <= DISTANCE
end

function LocalBroadcast(from, text)
    local players = mc.getOnlinePlayers()
    for i, pl in ipairs(players) do if pl:isOP() or CheckDistance(from, pl) then pl:tell("§7Ⓛ §7" .. GetCname(from) .. "§7: " .. text) end end
end

-- Main
mc.listen("onChat", function(player, text)

    if (text:sub(1, 1) == "!") then
        -- global chat
        mc.broadcast("§6Ⓖ§r " .. GetCname(player) .. "§r: " .. text:sub(2))
    else
        -- local chat
        LocalBroadcast(player, text)
    end

    return false
end)

mc.regConsoleCmd("chatreload", "chatreload", function(pl)
    Reload()
    colorLog("green", "Chatreload")

end)

print('[\27[92mCRON\27[0m] \27[93mlocalchat loaded\27[0m')
