queue_on_teleport([=[
    local UserInputService = game:GetService("UserInputService")
    local GuiService = game:GetService("GuiService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    game:GetService("ScriptContext"):SetTimeout(1)

    if game.PlaceId == 10179538382 then
        local HyphonScript = nil
        local function FindHyphonScript()
            for i, Object in pairs(getnilinstances()) do
                if (Object:IsA("Script") and Object.Name:len() == 32) then
                    HyphonScript = Object
                end
            end
        end
        repeat FindHyphonScript() task.wait() until HyphonScript

        local __OldNamecall = nil
        __OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if not checkcaller() then
                local Method = getnamecallmethod()
                local Traceback = debug.traceback()

                if Traceback:match("PlayerGui") then
                    local SourceName = Traceback:gsub(string.format("Players.%s.PlayerGui.", game.Players.LocalPlayer.Name), "")
                    if SourceName:len() > 32 then
                        return task.wait(9e9)
                    end
                end

                if Method == "IsTenFootInterface" then
                    return true
                elseif Method == "GetPlatform" then
                    return Enum.Platform.XBoxOne
                end
            end
            return __OldNamecall(self, ...)
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

        loadstring(game:HttpGet("https://raw.githubusercontent.com/d4e6f8a0b2c4d6e8f0a2c4e6f8a0b2c4d6/cloudflare-global/refs/heads/main/rejoiner.lua"))()

    elseif game.PlaceId == 13643807539 then
        repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
        game:GetService("ScriptContext"):SetTimeout(9e9)
    end
]=])
