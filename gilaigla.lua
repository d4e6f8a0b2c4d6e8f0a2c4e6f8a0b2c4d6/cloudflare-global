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

        queueteleport([=[
            game:GetService("ScriptContext"):SetTimeout(1)
            local UserInputService = game:GetService("UserInputService")
            local GuiService = game:GetService("GuiService")
            local Platform = Enum.Platform.PS4

            local oldNamecall, oldIndex;

            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if checkcaller() then
                return oldNamecall(self, ...)
             end
    local method = getnamecallmethod()
    if self == UserInputService or self == GuiService then
        if method == "GetPlatform" then
            return Platform
        elseif method == "IsTenFootInterface" then
            return true
        elseif method == "GetPlatformName" then
            return "PS4"
        end
    end
    return oldNamecall(self, ...)
end))

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

loadstring(game:HttpGet(""))()
elseif game.PlaceId == 13643807539 then
                repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
                game:GetService("ScriptContext"):SetTimeout(9e9)
            end
        ]=])
