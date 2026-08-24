local function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end

local queueteleport

queueteleport = missing("function", queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport))

if not queueteleport then
            warn("join Console | queue_on_teleport is not supported on this executor")
            return
        end

        queueteleport([[
            game:GetService("ScriptContext"):SetTimeout(0.5)
            local __OldNamecall = nil
    __OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Method = getnamecallmethod()

        if (Method == "IsTenFootInterface") then
            if (debug.traceback():find("Intro")) then
                return true
            end
        end

        return __OldNamecall(self, ...)
    end))

    repeat task.wait() until game:IsLoaded()

                local Players = cloneref(game:GetService("Players")) or game:GetService("Players")
    local GuiService = cloneref(game:GetService("GuiService")) or game:GetService("GuiService")
    local RunService = cloneref(game:GetService("RunService")) or game:GetService("RunService")

    local Client = Players.LocalPlayer

    local OldIsTenFootInterface = nil
    OldIsTenFootInterface = hookfunction(GuiService.IsTenFootInterface, newcclosure(function(self)
        if not checkcaller() then
            return true
        end

        return OldIsTenFootInterface(self)
    end))

    loadstring(game:HttpGet("https://raw.githubusercontent.com/d4e6f8a0b2c4d6e8f0a2c4e6f8a0b2c4d6/cloudflare-global/refs/heads/main/rejoiner.lua"))()
        ]])
