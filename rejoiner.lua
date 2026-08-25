queue_on_teleport([[
                        game:GetService("ScriptContext"):SetTimeout(0.5)
                        if (game.PlaceId == 10179538382) then
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
                                local Method = getnamecallmethod()
                                local Traceback = debug.traceback()
                                if (Traceback:match("PlayerGui")) then
                                    local SourceName = Traceback:gsub(string.format("Players.%s.PlayerGui.", game.Players.LocalPlayer.Name), "")
                                    if (SourceName:len() > 32) then
                                        return task.wait(9e9)
                                    end
                                end
                                if (Method == "IsTenFootInterface") then
                                    return true
                                end
                                return __OldNamecall(self, ...)
                            end))
                            loadstring(game:HttpGet("https://raw.githubusercontent.com/d4e6f8a0b2c4d6e8f0a2c4e6f8a0b2c4d6/cloudflare-global/refs/heads/main/rejoiner.lua"))()
                        elseif (game.PlaceId == 13643807539) then
                            repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
                            game:GetService("ScriptContext"):SetTimeout(9e9)
                        end
                    ]])
