queue_on_teleport([=[
            local UserInputService = game:GetService("UserInputService")
            local GuiService = game:GetService("GuiService")
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local Enum = Enum
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

                local __OldNamecall
                __OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                    local Method = getnamecallmethod()
                    local Traceback = debug.traceback()

                    if Traceback:match("PlayerGui") then
                        local SourceName = Traceback:gsub(string.format("Players.%s.PlayerGui.", game.Players.LocalPlayer.Name), "")
                        if SourceName:len() > 32 then
                            return task.wait(9e9)
                        end
                    end

                    if self == UserInputService or self == GuiService then
                        if Method == "GetPlatform" then
                            return Enum.Platform.XBoxOne
                        elseif Method == "IsTenFootInterface" then
                            return true
                        elseif Method == "GetPlatformName" then
                            return "XboxOne"
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
                oldIndex = hookmetamethod(game, "__index", newcclosure(function(tbl, idx)
                    if tostring(getcallingscript()) ~= "ControlModule" and tbl == UserInputService then
                        if idx == "TouchEnabled" then
                            return false
                        elseif idx == "MouseEnabled" then
                            return false
                        elseif idx == "KeyboardEnabled" then
                            return false
                        elseif idx == "GamepadEnabled" then
                            return true
                        elseif idx == "ControllerEnabled" then
                            return true
                        end
                    end

                    return oldIndex(tbl, idx)
                end))

            elseif game.PlaceId == 13643807539 then
                repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
                game:GetService("ScriptContext"):SetTimeout(9e9)
            end
        ]=])
