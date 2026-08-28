queue_on_teleport([=[
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
]=])
