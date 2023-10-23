-- Ajouter config pour steam/licence mysql
-- Corriger bug chat

------------------------
-- Variables and Init --
------------------------



-- From config

local ownerEmail = Config.email
local kickReason = Config.lang[Config.langInfo].kickVpn
local url = Config.webhooks

-- Misc related

local kickThreshold = 0.99 -- Anything equal to or higher than this value will be kicked. (0.99 Recommended as Lowest)
local flags = 'm'          -- Quickest and most accurate check. Checks IP blacklist.

-- Data variables

local payss
local ispss
local playerName
local playerIP
local def
local vpn = false
local risk 
local os 
local fraud 
local bot 
local abuse 
local tor 

-- Switchs var

local printFailed = true
local status
local statusTexte
local statusColor
----------
-- Code --
----------

-- Main : Event Handler and main function


---------------
-- Functions --
---------------

-- DOCUMENTATION :

-- SendError : Return the specified error to the client and close the connexion
-- connexion : Allow connexion to player
-- splitString : split and compare string
-- sendDiscord : send a discord query to the specified


function splitString(inputstr, sep)
    local t = {};
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

local function queryISP(isp_value, callback)
    -- MySQL.query('SELECT code FROM list_isp_auth WHERE code = @code', {['@code'] = isp_value}, callback)
    if Config.Isp then
        local row = MySQL.single.await('SELECT code FROM list_isp_auth WHERE code = ? LIMIT 1', {
            isp_value
        })
        if row then
            if row.code == isp_value then
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return true
    end
end

local function queryCountry(pays_value, callback)
    -- MySQL.query('SELECT code FROM list_pays_auth WHERE code = @code', {['@code'] = pays_value}, callback)
    if Config.Pays then
        local row = MySQL.single.await('SELECT code FROM list_pays_auth WHERE code = ? LIMIT 1', {
            pays_value
        })
        if row then
            if row.code == pays_value then
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return true
    end
end

local function queryIP(playerIP, callback)
    -- MySQL.query('SELECT IP FROM list_ip_auth WHERE IP = @code', {['@code'] = playerIP}, callback)
    if Config.Ip then
        local row = MySQL.single.await('SELECT IP FROM list_ip_auth WHERE IP = ? LIMIT 1', {
            playerIP
        })
        if row then
            if row.IP == playerIP then
                return true
            else
                return false
            end
        else
            return false
        end
    else
        return true
    end
end

local function checkBlacklistAndProceed(playerName, guid)
    if Config.Blacklist then
        if Config.debug then
            print(playerName)
        end
        print(guid)
        local result = MySQL.single.await('SELECT `guid`,`raison` FROM `list_guid_blacklist` WHERE `guid` = ? LIMIT 1',
            { guid })

        if result then
            return true
        else
            return false
        end
    else
        return false
    end
end



--------------
-- Commands --
--------------

RegisterCommand("add:ip", function(source, args, rawCommand)
    local ip = args[1]
    local name = GetPlayerName(source)

    MySQL.query('SELECT * FROM list_ip_auth WHERE IP = @code', { ['@code'] = ip }, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('security:client:chat', source, Config.lang[Config.langInfo].IpMessageErrorBdd)
        else
            MySQL.insert('INSERT INTO list_ip_auth (IP,who) VALUES (@code, @name)',
                { ['@code'] = ip, ['@name'] = name },
                function(affectedRows)
                    if Config.debug then
                        print(affectedRows)
                    end
                end)
        end
    end)
end, true)

RegisterCommand("add:blacklist", function(source, args, rawCommand)
    local guids = args[1]
    local name = GetPlayerName(source)
    local m = GetPlayerIdentifier(source)

    MySQL.query('SELECT * FROM list_guid_blacklist WHERE guid = @guid', { ['@guid'] = guid }, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('security:client:notify', source, Config.error[Config.langInfo].BlacklistMessageErrorBdd)
        else
            MySQL.insert('INSERT INTO list_guid_blacklist (guid,who,raison) VALUES (@guid, @who, @raison)',
                { ['@guid'] = args[1], ['@who'] = args[2], ['@raison'] = args[3] },
                function(affectedRows)
                    if Config.debug then
                        print(affectedRows)
                        -- if args[4] then
                        --     setKickReason('SECURITY CORE \n 🧊🧊🧊 - Joueur : ' .. tostring(name) .. ' \n Identifier: ' .. tostring(m) .. ' \n\n Raison: ' .. (tostring(args[3]) .. ' \n BAN / Kick)
                        -- end
                    end
                end)
        end
    end)
end, true)

-- RegisterCommand("get:player", function(source, args, rawCommand)
--     local commande = args[1]
--     local name = GetPlayerName(source)

--     MySQL.query('SELECT * FROM users WHERE identifier = @name or IP = @ip', { ['@name'] = commande, ['@ip'] = commande },
--         function(result)
--             if result[1] == nil then
--                 TriggerClientEvent('security:client:notify', source,
--                     Config.error[Config.langInfo].BlacklistMessageSendErrorBdd)
--             else
--                 TriggerClientEvent('security:client:chat', source,
--                     Config.lang[Config.langInfo].titlePlayerBlacklistMessage .. "" .. result[1].guid)
--                 Wait(5)
--                 TriggerClientEvent('security:client:chat', source,
--                     Config.lang[Config.langInfo].titlePlayerBlacklistMessage2 .. "" .. result[1].name)
--                 Wait(5)
--                 TriggerClientEvent('security:client:chat', source,
--                     Config.lang[Config.langInfo].titlePlayerBlacklistMessage3 .. "" .. result[1].IP)
--             end
--         end)
-- end, true)

RegisterCommand("add:pays", function(source, args, rawCommand)
    local pays = args[1]
    local name = GetPlayerName(source)
    MySQL.query('SELECT * FROM list_pays_auth WHERE code = @code', { ['@code'] = pays }, function(result)
        if result[1] ~= nil then
            TriggerClientEvent('security:client:chat', source, Config.lang[Config.langInfo].PaysMessageErrorBdd)
        else
            MySQL.insert('INSERT INTO list_pays_auth (code,who) VALUES (@code, @name)',
                { ['@code'] = pays, ['@name'] = name },
                function(affectedRows)
                    if Config.debug then
                        print(affectedRows)
                    end
                end)
        end
    end)
end, true)

RegisterCommand("add:isp", function(source, args, rawCommand)
    local name = GetPlayerName(source)

    -- Concaténer tous les arguments pour créer la chaîne 'isp'
    local isp = table.concat(args, " ")

    MySQL.query('SELECT * FROM list_isp_auth WHERE code = @code', { ['@code'] = isp }, function(result)
        if result[1] ~= nil then
            TriggerEvent('chat:addMessage',
                { color = { 255, 0, 0 }, multiline = false, args = { Config.lang[Config.langInfo].ispMessageErrorBdd } })
        else
            MySQL.insert('INSERT INTO list_isp_auth (code,who) VALUES (@code, @name)',
                { ['@code'] = isp, ['@name'] = name },
                function(affectedRows)
                    if Config.debug then
                        print(affectedRows)
                    end
                end)
        end
    end)
end, true)





if Config['activeSecurity'] == true then
    AddEventHandler('playerConnecting', function(playerNames, setKickReason, deferrals)
        if GetNumPlayerIndices() < GetConvarInt('sv_maxclients', 32) then
            def = deferrals
            playerName = playerNames
            deferrals.defer()
            playerIP = GetPlayerEP(source)
            guid = GetPlayerToken(source, 1)

            for k, v in ipairs(Config.AllowList) do
                print(v)
                if playerIP == v then
                    deferrals.done()
                    return
                end
            end

            if Config.identifier == "steam" then
                playerIdentifier = GetPlayerIdentifiers(source)[1]
            elseif Config.identifer == "licence" then
                playerIdentifier = GetPlayerIdentifiers(source)[2]
            end

            if string.match(playerIP, ":") then
                playerIP = splitString(playerIP, ":")[1]
            end

            if IsPlayerAceAllowed(source, "blockVPN.bypass") then
                deferrals.done()
                return
            else
                local probability = 0


                PerformHttpRequest(Config.apiUrl .. "" .. playerIP,
                    function(statusCode, response, headers)
                        if response.vpn and response.active_vpn or response.proxy then
                            vpn = true
                        else
                            PerformHttpRequest(Config.apiUrl .. "" .. playerIP,
                                function(errorCode, result, resultHeaders)
                                    print(json.encode(result))
                                    local json = json.decode(result)
                                   
                                    
                                    local isp_value = json.ISP
                                    local pays_value = json.country_code
                                    payss = json.country_code -- global pays
                                    isps = json.ISP -- global isp
                                    risk = tostring(json.risk_score)
                                    os = tostring(json.operating_system)
                                    fraud = tostring(json.fraud_score)
                                    bot = tostring(json.bot_status)
                                    abuse = tostring(json.recent_abuse)
                                    tor = tostring(json.active_tor)
                                    print(risk,os,fraud,bot,abuse,tor)


                                    if Config.debug then
                                        print(isp_value, pays_value)
                                    end
                                    local isp = queryISP(isp_value)
                                    local pays = queryCountry(pays_value)
                                    local IP = queryIP(playerIP)


                                    print(isp, pays, IP, vpn)

                                    if isp == true and pays == true and IP == true and vpn == false then
                                        local blacklist = checkBlacklistAndProceed(playerName, guid)

                                        if blacklist == true then
                                            local data = {
                                                ["type"] = "AdaptiveCard",
                                                ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                                                ["version"] = "1.5",
                                                ["body"] = {
                                                    {
                                                        ["type"] = "Image",
                                                        ["size"] = "Small",
                                                        ["url"] = "https://cdn-icons-png.flaticon.com/512/4067/4067568.png",
                                                        ["horizontalAlignment"] = "Center"
                                                    },
                                                    {
                                                        ["type"] = "TextBlock",
                                                        ["size"] = "ExtraLarge",
                                                        ["weight"] = "Bolder",
                                                        ["text"] = Config.lang[Config.langInfo].TitleDefer2,
                                                        ["color"] = "Default",
                                                        ["horizontalAlignment"] = "Center"
                                                    },
                                                    {
                                                        ["type"] = "TextBlock",
                                                        ["text"] = Config.lang[Config.langInfo].kickBlacklist,
                                                        ["wrap"] = true,
                                                        ["size"] = "Large",
                                                        ["weight"] = "Bolder",
                                                        ["color"] = "Attention",
                                                        ["horizontalAlignment"] = "Center"
                                                    },
                                                    {
                                                        ["type"] = "TextBlock",
                                                        ["text"] = Config.lang[Config.langInfo].infoSubtitle,
                                                        ["wrap"] = true,
                                                        ["color"] = "Good",
                                                        ["weight"] = "Bolder",
                                                        ["size"] = "Medium",
                                                        ["fontType"] = "Monospace",
                                                        ["style"] = "columnHeader",
                                                        ["isSubtle"] = true,
                                                        ["height"] = "stretch",
                                                        ["horizontalAlignment"] = "Center",
                                                        ["spacing"] = "ExtraLarge"
                                                    },
                                                    {
                                                        ["type"] = "ColumnSet",
                                                        ["height"] = "stretch",
                                                        ["minHeight"] = "5px",
                                                        ["bleed"] = true,
                                                        ["selectAction"] = {
                                                            ["type"] = "Action.OpenUrl"
                                                        },
                                                        ["columns"] = {
                                                            {
                                                                ["type"] = "Column",
                                                                ["width"] = "stretch",
                                                                ["items"] = {
                                                                    {
                                                                        ["type"] = "ActionSet",
                                                                        ["actions"] = {
                                                                            {
                                                                                ["type"] = "Action.OpenUrl",
                                                                                ["title"] = "Discord",
                                                                                ["url"] = Config.discordUrl,
                                                                                ["style"] = "positive",
                                                                                ["iconUrl"] = ""
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        },
                                                        ["horizontalAlignment"] = "Center"
                                                    }
                                                }
                                            }
                                            deferrals.presentCard(data)
                                        else
                                            Citizen.CreateThread(function()
                                                Citizen.Wait(5000)




                                                data = {
                                                    ["type"] = "AdaptiveCard",
                                                    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                                                    ["version"] = "1.5",
                                                    ["body"] = {
                                                        {
                                                            ["type"] = "TextBlock",
                                                            ["size"] = "ExtraLarge",
                                                            ["weight"] = "Bolder",
                                                            ["text"] = Config.lang[Config.langInfo].TitleDefer,
                                                            ["color"] = "Default",
                                                            ["horizontalAlignment"] = "Center"
                                                        },
                                                        {
                                                            ["type"] = "TextBlock",
                                                            ["text"] = Config.lang[Config.langInfo].MessageAttente,
                                                            ["wrap"] = true,
                                                            ["size"] = "Large",
                                                            ["weight"] = "Bolder",
                                                            ["color"] = "good",
                                                            ["horizontalAlignment"] = "Center"
                                                        },
                                                        {
                                                            ["type"] = "TextBlock",
                                                            ["text"] = Config.lang[Config.langInfo].infoSubtitle,
                                                            ["wrap"] = true,
                                                            ["color"] = "Good",
                                                            ["weight"] = "Bolder",
                                                            ["size"] = "Medium",
                                                            ["fontType"] = "Monospace",
                                                            ["style"] = "columnHeader",
                                                            ["isSubtle"] = true,
                                                            ["height"] = "stretch",
                                                            ["horizontalAlignment"] = "Center",
                                                            ["spacing"] = "ExtraLarge"
                                                        },
                                                        {

                                                            ["type"] = "TextBlock",
                                                            ["status"] = "Connexion en cours ...",
                                                            ["wrap"] = true,
                                                            ["size"] = "Large",
                                                            ["weight"] = "Bolder",
                                                            ["color"] = "Good",
                                                            ["horizontalAlignment"] = "Center"
                                                        },
                                                        {
                                                            ["type"] = "ColumnSet",
                                                            ["height"] = "stretch",
                                                            ["minHeight"] = "5px",
                                                            ["bleed"] = true,
                                                            ["selectAction"] = {
                                                                ["type"] = "Action.OpenUrl"
                                                            },
                                                            ["columns"] = {
                                                                {
                                                                    ["type"] = "Column",
                                                                    ["width"] = "stretch",
                                                                    ["items"] = {
                                                                        {
                                                                            ["type"] = "ActionSet",
                                                                            ["actions"] = {
                                                                                {
                                                                                    ["type"] = "Action.OpenUrl",
                                                                                    ["title"] = "Discord",
                                                                                    ["url"] = Config.discordUrl,
                                                                                    ["style"] = "positive",
                                                                                    ["iconUrl"] = ""
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }

                                                            },
                                                            ["horizontalAlignment"] = "Center"
                                                        }
                                                    }
                                                }




                                                deferrals.presentCard(data)
                                                Citizen.Wait(5000)
                                                connexion(playerName, playerIP, isp, pays)
                                                deferrals.done()
                                            end)
                                        end
                                    else
                                        local sendMessage

                                        if isp == false then
                                            sendMessage = Config.lang[Config.langInfo].deferalMessageisp
                                            local title = "ISP NON WHITELIST"
                                            sendError(title)
                                        end

                                        if pays == false then
                                            sendMessage = Config.lang[Config.langInfo].deferalMessagePays
                                            local title = "PAYS NON WHITELIST"
                                            sendError(title)
                                        end

                                        if IP == false then
                                            sendMessage = Config.lang[Config.langInfo].deferalMessageIp
                                            local title = "IP NON WHITELIST"
                                            sendError(title)
                                        end

                                        if vpn == true then
                                            sendMessage = Config.lang[Config.langInfo].kickVpn
                                            local title = "VPN BLOQUER"
                                            sendError(title)
                                        end

                                        
                                        local data = {
                                            ["type"] = "AdaptiveCard",
                                            ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                                            ["version"] = "1.5",
                                            ["body"] = {
                                                {
                                                    ["type"] = "TextBlock",
                                                    ["size"] = "ExtraLarge",
                                                    ["weight"] = "Bolder",
                                                    ["text"] = Config.lang[Config.langInfo].TitleDefer,
                                                    ["color"] = "Default",
                                                    ["horizontalAlignment"] = "Center"
                                                },
                                                {
                                                    ["type"] = "TextBlock",
                                                    ["text"] = sendMessage,
                                                    ["wrap"] = true,
                                                    ["size"] = "Large",
                                                    ["weight"] = "Bolder",
                                                    ["color"] = "Attention",
                                                    ["horizontalAlignment"] = "Center"
                                                },
                                                {
                                                    ["type"] = "TextBlock",
                                                    ["text"] = Config.lang[Config.langInfo].infoSubtitle,
                                                    ["wrap"] = true,
                                                    ["color"] = "Good",
                                                    ["weight"] = "Bolder",
                                                    ["size"] = "Medium",
                                                    ["fontType"] = "Monospace",
                                                    ["style"] = "columnHeader",
                                                    ["isSubtle"] = true,
                                                    ["height"] = "stretch",
                                                    ["horizontalAlignment"] = "Center",
                                                    ["spacing"] = "ExtraLarge"
                                                },
                                                {
                                                    ["type"] = "ColumnSet",
                                                    ["height"] = "stretch",
                                                    ["minHeight"] = "5px",
                                                    ["bleed"] = true,
                                                    ["selectAction"] = {
                                                        ["type"] = "Action.OpenUrl"
                                                    },
                                                    ["columns"] = {
                                                        {
                                                            ["type"] = "Column",
                                                            ["width"] = "stretch",
                                                            ["items"] = {
                                                                {
                                                                    ["type"] = "ActionSet",
                                                                    ["actions"] = {
                                                                        {
                                                                            ["type"] = "Action.OpenUrl",
                                                                            ["title"] = "Discord",
                                                                            ["url"] = "https://discord.gg/QABKF7e8",
                                                                            ["style"] = "positive",
                                                                            ["iconUrl"] = ""
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    },
                                                    ["horizontalAlignment"] = "Center"
                                                }
                                            }
                                        }
                                        deferrals.presentCard(data)
                                    end
                                end)
                        end
                    end)
            end
        end
    end)
end

function sendError(title)
    local username = Config['botUsername']
    local color = "15158332"
    local titles = title
    local content = Config.lang[Config.langInfo].ispDiscord ..

    " \n" ..
    Config.lang[Config.langInfo].ispName ..
    " :" ..
    isps ..
    " \n" ..
    Config.lang[Config.langInfo].paysName ..
    " :" ..
    payss ..
    " \n" ..
    "Risque score"..
    " :" ..
    risk ..
    " \n" ..
    "OS system"..
    " :" ..
    os ..
    " \n" ..
    "fraude score"..
    " :" ..
    fraud ..
    " \n" ..
    "Use Bot"..
    " :" ..
    bot ..
    " \n" ..
    "Ip avec des plaintes"..
    " :" ..
    abuse ..
    " \n" ..
    "Utilisation de TOR"..
    " :" ..
    tor ..
    " \n" ..
    
    Config.lang[Config.langInfo].ipName ..
    " :" .. playerIP .. " \n" .. Config.lang[Config.langInfo].playerName .. " : " .. playerName
    sendDiscord(url, username, color, titles, content)
end

function connexion(playerName, playerIP, isp, pays)
    local username = Config['botUsername']
    local color = "3066993"
    local title = Config.lang[Config.langInfo].connexionOk
    local content = Config.lang[Config.langInfo].connectDiscord ..
    " \n" ..
    Config.lang[Config.langInfo].ispName ..
    " :" ..
    isps ..
    " \n" ..
    Config.lang[Config.langInfo].paysName ..
    " :" ..
    payss ..
    " \n" ..
    "Risque score"..
    " :" ..
    risk ..
    " \n" ..
    "OS system"..
    " :" ..
    os ..
    " \n" ..
    "fraude score"..
    " :" ..
    fraud ..
    " \n" ..
    "Use Bot"..
    " :" ..
    bot ..
    " \n" ..
    "Ip avec des plaintes"..
    " :" ..
    abuse ..
    " \n" ..
    "Utilisation de TOR"..
    " :" ..
    tor ..
    " \n" ..
   
    Config.lang[Config.langInfo].ipName ..
    " :" .. playerIP .. " \n" .. Config.lang[Config.langInfo].playerName .. " : " .. playerName .. "  \n  Guid" .. guid
    sendDiscord(url, username, color, title, content)
end

function sendDiscord(url, usernames, color, title, content)
    PerformHttpRequest(url, function(err, text, headers) end, 'POST',
        json.encode({
            username = usernames,
            embeds = { {
                ["color"] = color,
                ["title"] = title,
                ["description"] = content,
                ["text"] = Config.discordfooter
            }
            },
            avatar_url = Config.avatarUrl,
            tts = false
        }), { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread(function()
    if (GetCurrentResourceName() == "security") then
        if Config.activeSecurity == true then
            print('┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬')
            if Config.Isp then
                print("Protection ISP :  🔰✅")
            else
                print("Protection ISP :  ⚠️❌")
            end

            if Config.Pays then
                print("Protection PAYS :  🔰✅")
            else
                print("Protection PAYS :  ⚠️❌")
            end

            if Config.Ip then
                print("Protection WHITELIST :  🔰✅")
            else
                print("Protection WHITELIST :  ⚠️❌")
            end

            if Config.Vpn then
                print("Protection VPN :  🔰✅")
            else
                print("Protection VPN :  ⚠️❌")
            end

            if Config.Blacklist then
                print("Protection BLACKLIST :  🔰✅")
            else
                print("Protection BLACKLIST :  ⚠️❌")
            end

            print("Langue du script :" .. Config.langInfo)
        else
            print("☢️ SYSTEME TOTALEMENT COUPER☢️")
        end

        print("┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴")
    end
end)
