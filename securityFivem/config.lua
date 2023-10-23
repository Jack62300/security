Config = {}

-- Choose the language of the script, "fr" and "en" only supported for this release.
-- If you want to add your language, please refer to line 65

Config.langInfo = "fr"

-- Activate the debug print in console
Config.debug = true

Config.maintenance = false

--------------
-- Security --
--------------

-- Configure the desired level of security to enable: True otherwise set: false
-- If you want to disable everything, prefer config.activeSecurity

Config.Isp = false                  -- Indicate if the script must use our ISP (internet service provider) security
Config.Ip = false                    -- Indicate if the script must use our IP (Whitelist) security
Config.Pays = true                  -- Indicate if the script must use our country check security
Config.Vpn = true                   -- Indicate if the script must use our VPN check security
Config.Blacklist = true             -- Indicate if the script must use our device ban security (This system use unique IDs of a machine to ban all the player accounts)

-- If false : Deactivate all the security options listed before
Config.activeSecurity = true

Config.AllowList = {
}

Config.activeInfo = true
-----------
-- API's -- 
-----------

-- Url API to test VPN (You need to register with a valid email)
Config.apiUrl = "https://ipqualityscore.com/api/json/ip/LiF8gwLtnKlTmCScRnDLbS6SJhftIWtL/" 

-- Email to connect the API's (Must be the one you registered with)
Config.email = ""


-- Url API to test the ISP & Country Code (We recommand to keep this one)
Config.apiUrl2 = "http://ip-api.com/json/" 

---------------------
-- Discord related --
---------------------

-- Discord url to display for the player if he has an error
Config.discordUrl =  "https://discord.gg/aEMkkSjx"

-- Title of the discord bot (Footer)
Config.discordfooter = "https://discord.gg/aEMkkSjx"

-- Name of the discord Bot
Config.botUsername = "Sécurity Jack"

-- Discord WebHook to receive logs of the security script
Config.webhooks = "https://discord.com/api/webhooks/1162162793982734418/vBFdkob0K7SjkHbkGhUhLRN69eZgNnUsMmxdLwnakX_P6L8iTOnHhyUr3U8v-Yo0WYiP"

-- Profile Picture of the bot 
Config.avatarUrl = "https://cdn.discordapp.com/attachments/798550610840256602/1156925692437606490/NF.png?ex=653a5703&is=6527e203&hm=9efdacee3f58946fe91e1bef9ece0a94caec6e725c3b9dc95b7d6a3395792578&"

---------------
-- Languages --
---------------

-- Config your language if needeed
Config.lang = {
    fr = { 
        -- Discord webhooks
        isp = "Tentative de connexion ISP BLOQUÉE", 
        pays = "Tentative de connexion PAYS BLOQUÉE", 
        whitelist = "Connexion non autorisé : NON WHITELISTÉ",
        vpn = "Connexion VPN bloquée ", 
        connexionOk = "Connexion réussie - VPN / ISP / PAYS",
        ispName = "FAI",
        paysName = " Code pays",
        ipName = " Ip Joueur",
        playerName = " Nom du Joueur",
        ipDiscord = "L'ip suivante n'est pas valide ou non whitelistée. Voici les informations reçues",
        ispDiscord = " L'isp suivante n'est pas valide ou non whitelistée. Voici les informations reçues",
        paysDiscord = " Pays suivant non whitelisté ou non valide. Voici les informations reçues",
        connectDiscord = " Connection autorisée. Voici les informations reçues ",
        vpnDiscord = " Connexion via VPN detectée. Voici les informations reçues ",
        vpnProba = "Probalitité d'utilisation de VPN ",

        -- Message lors des commandes
        titlePlayerBlacklistMessage = " Joueur Guid Unique ",
        titlePlayerBlacklistMessage2 = " Nom du joueur ",
        titlePlayerBlacklistMessage3 = " Ip du Joueur ",
        BlacklistMessageSendErrorBdd = " Aucun Joueur trouvé",

        TitleDefer = "Bienvenue sur le serveur de Intensity RP",
        TitleDefer2 = "Compte blacklisté du serveur",
        
        -- Pendant la connexion 
        kickVpn = "[SECURITY] Nous avons détecté que vous utilisez un VPN ou un proxy. Si vous pensez qu\'il s\'agit d\'une erreur, veuillez contacter l\'équipe administrative.",
        MessageAttente = "Merci de patienter, nous sécurisons la connexion",
        deferalMessageIp = "Vous devez être whitelisté sur notre serveur pour vous connecter",
        deferalMessageisp = "Votre fournisseur d'accès n'est pas validé sur notre serveur",
        deferalMessagePays = "Votre pays n'est pas validé sur notre serveur",
        kickBlacklist = "Vous avez été blacklist sur notre serveur, si vous penser que cela est une erreur, merci de nous contacter sur discord ",
        infoSubtitle = "C'est mesure sont la pour la protection du serveur, il ne servent à rien d'autre."
    },

    en = {
        -- Discord webhooks
        isp = "ISP BLOCKED connection attempt", 
        pays = "BLOCKED COUNTRY login attempt", 
        whitelist = "Unauthorized connection: NOT WHITELISTED",
        vpn = "VPN connection blocked", 
        connexionOk = "Connection successful - VPN/ISP/COUNTRY",
        ispName = "ISP",
        paysName = " Country Code",
        ipName = " Player IP",
        playerName = " Player Name",
        ipDiscord = "The following ip is invalid or not whitelisted. Here is the information received",
        ispDiscord = " The following isp is not valid or not whitelisted. Here is the information received",
        paysDiscord = " This country is not whitelisted or invalid. Here is the information received",
        connectDiscord = " Connection authorized. Here is the information received",
        vpnDiscord = " Connection via VPN detected. Here is the information received",
        vpnProba = "Probability of using VPN ",

        -- Message after a chat command
        titlePlayerBlacklistMessage = " Unique Player GUID ",
        titlePlayerBlacklistMessage2 = " Player name ",
        titlePlayerBlacklistMessage3 = " Player Ip ",
        BlacklistMessageSendErrorBdd = " No player found",
         
        -- While connecting 
        kickVpn = "[SECURITY] We have detected that you are using a VPN or proxy. If you believe this is an error, please contact the admin team.",
        MessageAttente = "Please wait, we are securing the connection",
        deferalMessageIp = "You must be whitelisted on our server to connect",
        deferalMessageisp = "Your ISP is not validated on our server",
        deferalMessagePays = "Your country is not validated on our server",
        kickBlacklist = "Vous avez été blacklist sur notre serveur, si vous penser que cela est une erreur, merci de nous contacter sur discord ",
        infoSubtitle = "C'est mesure sont la pour la protection du serveur, il ne servent à rien d'autre."
    },
}

Config.error =  {
    fr = {
        isp = "Votre founisseur d'accès n'est pas autorisé sur notre serveur",
        pays = "Votre pays n'est pas autorisé sur notre serveur",
        ip = "Votre ip n'est pas whitelisté merci de passer via discord",
        ispMessageErrorBdd = "ISP déja présent en base de données",
        PaysMessageErrorBdd = "ISP déja présent en base de données",
        IpMessageErrorBdd = "IP déja présente en base de données",
        BlacklistMessageErrorBdd = "Guid déja en base de donnée",
        BlacklistMessageSendErrorBdd = " Aucun Joueur trouver",
    },

    en = {
        isp = "Your ISP is not authorized on our server",
        pays = "Your country is not allowed on our server",
        ip = "Your ip is not whitelisted please use discord",
        ispMessageErrorBdd = "ISP already present in database",
        PaysMessageErrorBdd = "ISP already present in the database",
        IpMessageErrorBdd = "IP already present in database",
        BlacklistMessageErrorBdd = "Guid already in database",
        BlacklistMessageSendErrorBdd = " No Player found",
    } 
}