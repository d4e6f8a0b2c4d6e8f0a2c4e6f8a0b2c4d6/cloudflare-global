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
            local LOBBY_PLACE = 10179538382
            local PC_PLACE = 13643807539
            local CONSOLE_PLACE = 15124180230

            game:GetService("ScriptContext"):SetTimeout(0.5)

            local function cref(inst)
                if cloneref then
                    return cloneref(inst)
                end
                return inst
            end

            local function protect(fn)
                if newcclosure then
                    return newcclosure(fn)
                end
                return fn
            end

            if game.PlaceId == LOBBY_PLACE then
                pcall(function()
                    local q = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
                    if q then
                        q([[
                            if game.PlaceId == 15124180230 or game.PlaceId == 13643807539 then
                                repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
                                game:GetService("ScriptContext"):SetTimeout(9e9)
                            end
                        ]])
                    end
                end)

                local GuiService = cref(game:GetService("GuiService"))
                local UserInputService = cref(game:GetService("UserInputService"))
                local TeleportService = cref(game:GetService("TeleportService"))

                local oldNamecall
                oldNamecall = hookmetamethod(game, "__namecall", protect(function(self, ...)
                    local method = getnamecallmethod()
                    local a1, a2, a3, a4, a5, a6 = ...

                    local ok, traceback = pcall(debug.traceback)
                    if ok and traceback and traceback:match("PlayerGui") then
                        local lp = game:GetService("Players").LocalPlayer
                        if lp then
                            local sourceName = traceback:gsub(string.format("Players.%s.PlayerGui.", lp.Name), "")
                            if sourceName:len() > 32 then
                                return task.wait(9e9)
                            end
                        end
                    end

                    if method == "IsTenFootInterface" then
                        return true
                    elseif method == "GetPlatform" then
                        return Enum.Platform.XBoxOne
                    elseif method == "GetPlatformName" then
                        return "XBoxOne"
                    elseif (method == "Teleport" or method == "TeleportToPlaceInstance" or method == "TeleportAsync") and a1 == 13643807539 then
                        return oldNamecall(self, 15124180230, a2, a3, a4, a5, a6)
                    end

                    return oldNamecall(self, ...)
                end))

                pcall(function()
                    hookfunction(GuiService.IsTenFootInterface, protect(function()
                        return true
                    end))
                end)

                pcall(function()
                    hookfunction(UserInputService.GetPlatform, protect(function()
                        return Enum.Platform.XBoxOne
                    end))
                end)

                pcall(function()
                    local oldTeleport
                    oldTeleport = hookfunction(TeleportService.Teleport, protect(function(self, placeId, ...)
                        if placeId == 13643807539 then
                            placeId = 15124180230
                        end
                        return oldTeleport(self, placeId, ...)
                    end))
                end)

                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/d4e6f8a0b2c4d6e8f0a2c4e6f8a0b2c4d6/cloudflare-global/refs/heads/main/rejoiner.lua"))()
                end)
            elseif game.PlaceId == PC_PLACE then
                repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
                game:GetService("ScriptContext"):SetTimeout(9e9)
            end
        ]=])
