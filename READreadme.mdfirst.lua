--[[Yatta's Crazy GUI – 1.0 Archival Edition—By no means, may you use this version to gain profit or any other.
The Creator, "" doesn't want to keep talking about this version. Since the creator had something, he is planning to redo / recode YCGui entirely.
If you are reading this creator (thou name will not be sent due to the owner possibly not liking this), thank you for taking the situation greatly.
Please do not harass the owner, nor inflict harm opon thee.
THIS IS NOT SKIDDED, THIS IS A CODE ARCHIVE]]
local r = "/raw"
--1
loadstring(game:HttpGet("https://pastefy.app/8Nl7Zxd3" .. r))()
--2
loadstring(game:HttpGet("https://raw.githubusercontent.com/EaglerMan2022/Yattas-Crazy-Gui-REUPLOAD/refs/heads/main/YCG2.lua"))()
--3 
loadstring(game:HttpGet("https://pastefy.app/qRNHkuVb" .. r))()
print("Init, read README.md in the GitHub resp. Link copied.")
setclipboard("https://github.com/shann-git-lol/Yatta-s-Crazy-GUI-Archival-Edition-1.0/blob/main/README.md")





















--[[ Yatta's Crazy GUI – 1.0 Archival Edition—By no means, may you use this version to gain profit or any other.
The Creator, "" doesn't want to keep talking about this version. Since the creator had something, he is planning to redo / recode YCGui entirely.
If you are reading this creator (thou name will not be sent due to the owner possibly not liking this), thank you for taking the situation greatly.
Please do not harass the owner, nor inflict harm opon thee.



THIS IS NOT SKIDDED, THIS IS A CODE ARCHIVE


local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser       = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local pGui   = player:WaitForChild("PlayerGui")

local FULL_PLACE_ID       = 16552821455
local RESTRICTED_PLACE_ID = 16116270224
local currentPlaceId = game.PlaceId
local IS_RESTRICTED = (currentPlaceId == RESTRICTED_PLACE_ID)
local IS_FULL       = (currentPlaceId == FULL_PLACE_ID)

-- FIX: disconnect all connections from a previous load before re-running
if _G.TwistedDodgerLoaded then
    local og = pGui:FindFirstChild("TwistedDodger_Ultimate")
    if og then og:Destroy() end
    if _G.YattaConnections then
        for _, conn in ipairs(_G.YattaConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    _G.TwistedDodgerLoaded = false
end
_G.TwistedDodgerLoaded = true
_G.YattaConnections = {} -- fresh connection list for this load

local oldVis = workspace.Terrain:FindFirstChild("Super Pro")
if oldVis then oldVis:Destroy() end
local VisualFolder = Instance.new("Folder", workspace.Terrain)
VisualFolder.Name  = "Super Pro"

local SCRIPT_BILLBOARD_TAG = "YattaGUI_Billboard"
local SCRIPT_OWNER_NAMES  = {"ForcedAPI","ForToBeTold","ForwadedAPI"}
local SCRIPT_TESTER_NAMES = {"manigaws_67","ForAPIMod","4ugustttt0"}
-- FIX: weak-key table so destroyed Player objects don't prevent GC
local playerBillboards = setmetatable({}, {__mode = "k"})

local function IsOurBillboard(obj)
    if not obj then return false end
    local cur = obj
    while cur do
        if cur:IsA("BillboardGui") and
           cur:GetAttribute(SCRIPT_BILLBOARD_TAG) then return true end
        cur = cur.Parent
    end
    return false
end

local function CreatePlayerBillboard(targetPlayer)
    if playerBillboards[targetPlayer] then
        local existing = playerBillboards[targetPlayer]
        if existing and existing.Parent then return end
        pcall(function() existing:Destroy() end)
        playerBillboards[targetPlayer] = nil
    end
    local name = targetPlayer.Name
    local isOwner, isTester = false, false
    for _, n in ipairs(SCRIPT_OWNER_NAMES)  do
        if n == name then isOwner = true; break end
    end
    for _, n in ipairs(SCRIPT_TESTER_NAMES) do
        if n == name then isTester = true; break end
    end
    if not isOwner and not isTester then return end
    local labelText  = isOwner and "Script Owner" or "Script Tester"
    local labelColor = isOwner and
        Color3.fromRGB(255,212,48) or Color3.fromRGB(85,190,255)
    local function AttachBillboard(char)
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if playerBillboards[targetPlayer] then
            pcall(function() playerBillboards[targetPlayer]:Destroy() end)
            playerBillboards[targetPlayer] = nil
        end
        local bb = Instance.new("BillboardGui")
        bb.Name = "YattaLabel_"..name
        bb.Size = UDim2.new(0,120,0,36)
        bb.StudsOffset = Vector3.new(0,5.5,0)
        bb.AlwaysOnTop = true; bb.MaxDistance = 200
        bb.ResetOnSpawn = false; bb.LightInfluence = 0
        bb:SetAttribute(SCRIPT_BILLBOARD_TAG, true)
        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1,0,1,0)
        bg.BackgroundColor3 = Color3.fromRGB(10,10,18)
        bg.BackgroundTransparency = 0.25; bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0,8)
        local accentLine = Instance.new("Frame", bg)
        accentLine.Size = UDim2.new(1,0,0,3)
        accentLine.BackgroundColor3 = labelColor
        accentLine.BorderSizePixel = 0
        Instance.new("UICorner", accentLine).CornerRadius = UDim.new(0,8)
        local lbl = Instance.new("TextLabel", bg)
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 1; lbl.Text = labelText
        lbl.TextColor3 = labelColor; lbl.Font = Enum.Font.FredokaOne
        lbl.TextSize = 16
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center; lbl.ZIndex = 2
        local stroke = Instance.new("UIStroke", lbl)
        stroke.Color = Color3.fromRGB(0,0,0)
        stroke.Thickness = 1.5; stroke.Transparency = 0
        bb.Parent = hrp
        playerBillboards[targetPlayer] = bb
    end
    AttachBillboard(targetPlayer.Character)
    targetPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5); AttachBillboard(char)
    end)
end

local function ScanForSpecialPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then CreatePlayerBillboard(plr) end
    end
end
-- FIX: track connections so they can be disconnected on reload
table.insert(_G.YattaConnections,
    Players.PlayerAdded:Connect(function(plr)
        if plr ~= player then CreatePlayerBillboard(plr) end
    end)
)
table.insert(_G.YattaConnections,
    Players.PlayerRemoving:Connect(function(plr)
        if playerBillboards[plr] then
            pcall(function() playerBillboards[plr]:Destroy() end)
            playerBillboards[plr] = nil
        end
    end)
)
task.spawn(ScanForSpecialPlayers)

local function PlaySound(assetId)
    local snd = Instance.new("Sound")
    snd.SoundId = "rbxassetid://"..tostring(assetId)
    snd.Volume = 1; snd.RollOffMaxDistance = 0
    snd.Parent = game:GetService("SoundService")
    snd:Play(); game:GetService("Debris"):AddItem(snd, 3)
end
local SOUND_CLICK    = 552900451
local SOUND_ERROR    = 134189051248016
local SOUND_MINIMIZE = 121531878137469

-- FLY STATE
local FlyState = {
    flying     = false,
    speed      = 50,
    accel      = 0.12,
    lv         = nil,
    av         = nil,
    attachment = nil,
}

local camera = workspace.CurrentCamera

local function FlyToggle()
    local char = player.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChildWhichIsA("Humanoid")
    if not root or not hum then return end
    FlyState.flying = not FlyState.flying
    if FlyState.flying then
        FlyState.attachment = Instance.new("Attachment", root)
        FlyState.lv = Instance.new("LinearVelocity", root)
        FlyState.lv.MaxForce = 9e10
        FlyState.lv.VelocityConstraintMode =
            Enum.VelocityConstraintMode.Vector
        FlyState.lv.VectorVelocity = Vector3.zero
        FlyState.lv.Attachment0 = FlyState.attachment
        FlyState.av = Instance.new("AngularVelocity", root)
        FlyState.av.MaxTorque = 9e10
        FlyState.av.AngularVelocity = Vector3.zero
        FlyState.av.Attachment0 = FlyState.attachment
        hum.PlatformStand = true
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    else
        if FlyState.lv then FlyState.lv:Destroy() end
        if FlyState.av then FlyState.av:Destroy() end
        if FlyState.attachment then FlyState.attachment:Destroy() end
        FlyState.lv = nil; FlyState.av = nil; FlyState.attachment = nil
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- FIX: store RenderStepped connection so it is disconnected on reload
table.insert(_G.YattaConnections,
    RunService.RenderStepped:Connect(function()
        if not FlyState.flying then return end
        local char = player.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildWhichIsA("Humanoid")
        if not root or not FlyState.lv then return end
        local drive, strafe = 0, 0
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then drive =  1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then drive = -1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then strafe = -1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then strafe =  1 end
        if UserInputService.TouchEnabled and hum and
           hum.MoveDirection.Magnitude > 0 then
            local lm = camera.CFrame:VectorToObjectSpace(hum.MoveDirection)
            strafe = lm.X; drive = -lm.Z
        end
        local targetDir = (camera.CFrame.LookVector * drive) +
                          (camera.CFrame.RightVector * strafe)
        local targetVel = targetDir.Magnitude > 0 and
            targetDir.Unit * FlyState.speed or Vector3.zero
        FlyState.lv.VectorVelocity =
            FlyState.lv.VectorVelocity:Lerp(targetVel, FlyState.accel)
        local camRot = camera.CFrame - camera.CFrame.Position
        root.CFrame = CFrame.new(root.Position) * camRot
    end)
)

local S = {
    AUTO_ENABLED=false, ANTI_AFK=false, PICKING_UP=false,
    FIRE_STOP=true, PICKUP_ENABLED=true, SAFE_TP=true,
    AUTO_USE_ITEMS=false, INSTANT_SKILLCHECK=false,
    AUTO_VOTE=false, AUTO_BUY=false, DRAIN_HUNT=false,
    EGGSON_MODE=false, DRAG_LOCKED=false, IS_MINIMIZED=false,
    ANTI_LAG=false, stopFireActive=false,
    lastItemUse=0, lastHealUse=0, antiAfkTimer=30,
    PICKUP_START_TIME=0, lastVoteTime=0, lastBuyTime=0,
    drainHuntLastTP=0, lastTeleport=0, lastIconTeleport=0,
    lastPanicTeleport=0, lastFarmTeleport=0, activeTween=nil,
    skillcheckOrigCB=nil, FarmBall=nil, VacuumPlatform=nil,
    lastDecodingUse=0, lastBuyInteract=0, lastFarmBaseTP=0,
    lastBoughtItem=nil, pipeFixedGens={},
    eggsonStopLoopActive=false, eggsonLastStopFire=0,
    lastBaseTP=0, eggsonCompletionWaitStart={},
    eggsonStopSpamActive=false, eggsonStopSpamGen=nil,
    invisWallFixed=false, isSprinting=false,
    sprintLoopActive=false, spinLoopActive=false,
    spinLoopConnection=nil, lastStaminaCheck=0,
    SpinPlatform=nil, antiLagConnection=nil,
    boughtThisSession={}, spinOrbitTween=nil,
    -- Rendering
    RENDERING_DISABLED=false, MAX_HEAL=false, HEAL_SLOT_COUNT=1, EXTRA_TOGGLES={},
}

-- Per-monster DETECTOR_RADIUS overrides
local MONSTER_RADIUS = {
    DandyMonster=85, DyleMonster=85, SproutMonster=85,
    ScrapsMonster=45, GoobMonster=45, RazzleDazzleMonster=85,
    RodgerMonster=85,
}

local C = {
    ITEM_USE_COOLDOWN=0.1, HEAL_COOLDOWN=0,
    ITEM_PICKUP_DURATION=10, DETECTOR_RADIUS=35,
    TELEPORT_MODE="instant", CONFIG_FILE_NAME="Example",
    VOTE_SPAM_INTERVAL=0.5, BUY_COOLDOWN=0.8,
    BUY_INTERACT_COOLDOWN=0.1, DRAIN_HUNT_DELAY=1,
    DEFAULT_RANGE=25, TENDRIL_DODGE_RANGE=12,
    GEN_TENDRIL_SAFE=18, GRAB_DODGE_RANGE=40,
    TELEPORT_HEIGHT=4, FARM_BALL_RADIUS=15,
    ICON_LOOP_DELAY=0.1, PANIC_COOLDOWN=1,
    FARM_LOOP_DELAY=0.1, teleportCooldown=0.1,
    TARGET_FOLDER="CurrentRoom", MODEL_NAME="FakeElevator",
    BASE_NAME="Base", INDICATOR_NAME="GeneratedIndicator",
    DECODING_USE_DELAY=1.0, BASE_TP_COOLDOWN=2.0,
    BASE_TP_LOOP_CD=0.2, EGGSON_COMPLETION_WAIT=0.8,
    STAMINA_STOP_THRESHOLD=70, STAMINA_START_THRESHOLD=71,
    SPIN_STEP_WAIT=0.07, SPIN_ORBIT_RADIUS=8,
    SPIN_ORBIT_STEP=0.045, SPIN_MOVE_SPEED=1,
    SPIN_TWEEN_DURATION=0.07,
    -- New: radius for monster check near a gen during active decode
    GEN_ACTIVE_MONSTER_RADIUS=20,
    -- New: radius for monster check near pickup items
    ITEM_MONSTER_RADIUS=15,
}

local SPECIAL_MONSTERS = {
    DandyMonster={Range=50}, DyleMonster={Range=55},
    SproutMonster={Range=40}, ScrapsMonster={Range=35},
    GoobMonster={Range=35}, RazzleDazzleMonster={Range=40},
    RodgerMonster={Range=30},
}
local FARM_IGNORE = {
    "RazzleDazzleMonster","ConnieMonster","RodgerMonster",
    "BlottMonster","SquirmMonster",
}
local GRAB_NAMES  = {"MonsterScrapsGrab","MonsterGigiGrab","MonsterGoobGrab"}
local THREAT_LIST = {
    "DyleMonster","DandyMonster","BlottMonster",
    "RodgerMonster","RazzleDazzleMonster","ConnieMonster","GlistenMonster",
}
local HEAL_CARDS = {Heal2=true, Heal=true}
local GEN_HALF_RESTRICTED = {JumperCable=true, Valve=true}

local BUY_PRIORITY = {
    {name="Bandage",tier=1},{name="HealthKit",tier=1},
    {name="JumperCable",tier=2},{name="Valve",tier=2},
    {name="PopBottle",tier=2},{name="Pop",tier=2},
    {name="Instructions",tier=2},{name="SmokeBomb",tier=2},
}
local CARD_PRIORITY = {
    DyleFloor=1, Heal2=2, Heal=2, Elevator=2, Elevator2=2,
    FrostShield=2, Glowlight=2, AbilityCooldown=2,
    AbilityCooldown2=2, DandyDiscount=2, PipingTape=2,
    PollenShield=2, Stamina=2, Stamina2=2, Machine=2,
    Blackout=2, RandomItem=3, RandomItem2=3,
}

local ITEM_CONFIG = {
    {name="Bonbon",              trigger="always"},
    {name="Chocolate",           trigger="always"},
    {name="ChocolateBox",        trigger="always"},
    {name="EjectButton",         trigger="always"},
    {name="ExtractionSpeedCandy",trigger="always"},
    {name="Gumball",             trigger="always"},
    {name="Jawbreaker",          trigger="always"},
    {name="JumperCable",         trigger="decoding"},
    {name="Pop",                 trigger="always"},
    {name="PopBottle",           trigger="always"},
    {name="SkillCheckCandy",     trigger="always"},
    {name="SpeedCandy",          trigger="always"},
    {name="StaminaCandy",        trigger="always"},
    {name="Valve",               trigger="decoding"},
    {name="Stopwatch",           trigger="decoding"},
    {name="Instructions",        trigger="decoding"},
    {name="StealthCandy",        trigger="always"},
    {name="ProteinBar",          trigger="always"},
    {name="AirHorn",             trigger="always"},
    {name="SmokeBomb",           trigger="Seen"},
    {name="Bandage",             trigger="heal"},
    {name="HealthKit",           trigger="heal"},
}

local PICKUP_CFG = {
    {name="Bandage",              blacklisted=false},
    {name="HealthKit",            blacklisted=false},
    {name="Tape",                 blacklisted=false},
    {name="ResearchCapsule",      blacklisted=false},
    {name="JumperCable",          blacklisted=false},
    {name="Bonbon",               blacklisted=false},
    {name="Chocolate",            blacklisted=false},
    {name="ChocolateBox",         blacklisted=false},
    {name="EjectButton",          blacklisted=false},
    {name="ExtractionSpeedCandy", blacklisted=false},
    {name="Gumball",              blacklisted=false},
    {name="Jawbreaker",           blacklisted=false},
    {name="Pop",                  blacklisted=true},
    {name="PopBottle",            blacklisted=true},
    {name="SkillCheckCandy",      blacklisted=false},
    {name="SpeedCandy",           blacklisted=false},
    {name="StaminaCandy",         blacklisted=false},
    {name="Valve",                blacklisted=false},
    {name="Stopwatch",            blacklisted=false},
    {name="Instructions",         blacklisted=false},
    {name="StealthCandy",         blacklisted=false},
    {name="ProteinBar",           blacklisted=false},
    {name="DandyEasterEggs",      blacklisted=false},
    {name="ChristmasCookie",      blacklisted=false},
    {name="AirHorn",              blacklisted=false},
    {name="SmokeBomb",            blacklisted=false},
}

local BUY_BLACKLIST = {
    {name="Bandage",              blacklisted=false},
    {name="HealthKit",            blacklisted=false},
    {name="JumperCable",          blacklisted=false},
    {name="Valve",                blacklisted=false},
    {name="PopBottle",            blacklisted=true},
    {name="Pop",                  blacklisted=true},
    {name="Instructions",         blacklisted=true},
    {name="SmokeBomb",            blacklisted=false},
    {name="Bonbon",               blacklisted=false},
    {name="Chocolate",            blacklisted=false},
    {name="ChocolateBox",         blacklisted=false},
    {name="EjectButton",          blacklisted=true},
    {name="ExtractionSpeedCandy", blacklisted=false},
    {name="Gumball",              blacklisted=false},
    {name="Jawbreaker",           blacklisted=false},
    {name="SkillCheckCandy",      blacklisted=false},
    {name="SpeedCandy",           blacklisted=false},
    {name="StaminaCandy",         blacklisted=false},
    {name="Stopwatch",            blacklisted=true},
    {name="StealthCandy",         blacklisted=false},
    {name="ProteinBar",           blacklisted=false},
    {name="AirHorn",              blacklisted=false},
}

local TRIGGER_OPTIONS = {
    "decoding","Seen","always","heal","stamina","disabled"
}

local DodgeBalls, TendrilBalls, GrabBalls     = {}, {}, {}
local TwistedLabels, MachineLabels, SMTLabels = {}, {}, {}

-- FIX: all ESP highlight tables use weak keys so destroyed Instances are GC'd
local ESPHighlights = {
    players    = setmetatable({}, {__mode = "k"}),
    tendrils   = setmetatable({}, {__mode = "k"}),
    blothands  = setmetatable({}, {__mode = "k"}),
    items      = setmetatable({}, {__mode = "k"}),
    monsters   = setmetatable({}, {__mode = "k"}),
    generators = setmetatable({}, {__mode = "k"}),
}
local ESP_ENABLED = {
    players=false,tendrils=false,blothands=false,
    items=false,monsters=false,generators=false,
}

local Theme = {
    Font=Enum.Font.FredokaOne,
    BG_TOP=Color3.fromRGB(20,20,32), BG_BOT=Color3.fromRGB(8,8,14),
    ACCENT=Color3.fromRGB(85,190,255), WHITE=Color3.fromRGB(255,255,255),
    LGRAY=Color3.fromRGB(175,175,192), MGRAY=Color3.fromRGB(105,105,122),
    GREEN=Color3.fromRGB(68,245,145), RED=Color3.fromRGB(255,70,70),
    YELLOW=Color3.fromRGB(255,212,48), PURPLE=Color3.fromRGB(182,68,255),
    ORANGE=Color3.fromRGB(255,155,48), BLUE=Color3.fromRGB(68,170,255),
    PINK=Color3.fromRGB(255,78,178), TOG_OFF=Color3.fromRGB(44,44,62),
    TOG_ON=Color3.fromRGB(38,192,98), TOG_KNOB=Color3.fromRGB(228,228,240),
    FRAME_BG=Color3.fromRGB(85,190,255),
    CHECK_BG=Color3.fromRGB(38,38,50),
    CHECK_BORDER=Color3.fromRGB(0,0,0),
}

local FONT_OPTIONS = {
    Enum.Font.FredokaOne,Enum.Font.GothamBold,Enum.Font.Gotham,
    Enum.Font.Oswald,Enum.Font.RobotoMono,Enum.Font.Code,
}
local FONT_NAMES = {
    "FredokaOne","GothamBold","Gotham","Oswald","RobotoMono","Code"
}
local IDX = {font=1}

local SUBTITLE_WORDS = {
    "So good","Unbeatable","Cracked out","Super Pro and Good bludd",
    "Skill issue HAHEHAHE","Touch grass blud","Key-Free, Free-Key",
    "Alpha wolf sigma boy","*Fake cries and becomes sigma*",
    "Son im crine ✌️😢","I'm gonna eat candy hold on",
    "try out Boxten Gender GUI!","Try out Riddance Hub!",
    "Try out Glisten's St-... Glisten's Club!","Have you eaten yet?",
}
local subtitleIdx = 1

-- SCRIPTS TAB DATA
local SCRIPTS_DATA = {
    {
        textName = "Boxten Gender GUI",
        code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/bookworming/bookshelf/refs/heads/main/shelf%203/boxten%20sex%20gui.lua"))()]]--[[,
    --[[},
    {
        textName = "Riddance Hub!",
        code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/bookworming/bookshelf/refs/heads/main/shelf%203/glisten's%20strip%20club.lua"))()]]--[[,
    --[[},
    {
        textName = "Glisten's Club!",
        code = [[getgenv().element_load_delay = 0.1 -- seconds
loadstring(game:HttpGet("https://raw.githubusercontent.com/riddance-club/script/refs/heads/main/loader.lua"))()]]--[[,
    --[[},
    {
        textName = "Infinite Yield!",
        code = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()]]--[[,
    --[[},
}

local function GetConfigFile() return C.CONFIG_FILE_NAME..".json" end

local function BuildConfigTable()
    local it, pk, bbl, mr = {}, {}, {}, {}
    for _,cfg in ipairs(ITEM_CONFIG)   do it[cfg.name]  = cfg.trigger    end
    for _,cfg in ipairs(PICKUP_CFG)    do pk[cfg.name]  = cfg.blacklisted end
    for _,cfg in ipairs(BUY_BLACKLIST) do bbl[cfg.name] = cfg.blacklisted end
    for k,v in pairs(MONSTER_RADIUS)   do mr[k] = v end
    return {
        autoFarm=S.AUTO_ENABLED, antiAfk=S.ANTI_AFK,
        fireStop=S.FIRE_STOP, pickupToggle=S.PICKUP_ENABLED,
        safeTp=S.SAFE_TP, autoUseItems=S.AUTO_USE_ITEMS,
        instantSkillcheck=S.INSTANT_SKILLCHECK,
        autoVote=S.AUTO_VOTE, autoBuy=S.AUTO_BUY,
        eggsonMode=S.EGGSON_MODE,
        teleportMode=C.TELEPORT_MODE, fontIdx=IDX.font,
        itemTriggers=it, pickupBlacklist=pk, buyBlacklist=bbl,
        spinOrbitRadius=C.SPIN_ORBIT_RADIUS,
        monsterRadius=mr, flySpeed=FlyState.speed,
        maxHeal=S.MAX_HEAL, healSlotCount=S.HEAL_SLOT_COUNT,
        extraToggles=S.EXTRA_TOGGLES or {},
    }
end

local function SaveConfig()
    if writefile then
        pcall(function()
            writefile(GetConfigFile(),
                HttpService:JSONEncode(BuildConfigTable()))
        end)
    end
end

local function LoadConfig()
    if not readfile then return nil end
    local ok,d = pcall(function()
        return HttpService:JSONDecode(readfile(GetConfigFile()))
    end)
    if not ok or type(d)~="table" then return nil end
    S.AUTO_ENABLED       = d.autoFarm          or false
    S.ANTI_AFK           = d.antiAfk           or false
    S.FIRE_STOP          = d.fireStop ~=nil and d.fireStop or true
    S.PICKUP_ENABLED     = d.pickupToggle~=nil and d.pickupToggle or true
    S.SAFE_TP            = d.safeTp ~=nil and d.safeTp or true
    S.AUTO_USE_ITEMS     = d.autoUseItems       or false
    S.INSTANT_SKILLCHECK = d.instantSkillcheck  or false
    S.AUTO_VOTE          = d.autoVote           or false
    S.AUTO_BUY           = d.autoBuy            or false
    S.EGGSON_MODE        = d.eggsonMode         or false
    C.TELEPORT_MODE      = d.teleportMode       or "instant"
    IDX.font             = d.fontIdx            or 1
    Theme.Font = FONT_OPTIONS[IDX.font]
    if d.spinOrbitRadius then C.SPIN_ORBIT_RADIUS=d.spinOrbitRadius end
    if d.flySpeed then FlyState.speed=d.flySpeed end
    if d.maxHeal~=nil then S.MAX_HEAL=d.maxHeal end
    if d.healSlotCount then S.HEAL_SLOT_COUNT=d.healSlotCount end
    if type(d.extraToggles)=="table" then S.EXTRA_TOGGLES=d.extraToggles end
    if type(d.monsterRadius)=="table" then
        for k,v in pairs(d.monsterRadius) do
            if MONSTER_RADIUS[k] then MONSTER_RADIUS[k]=v end
        end
    end
    if type(d.itemTriggers)=="table" then
        for _,cfg in ipairs(ITEM_CONFIG) do
            if d.itemTriggers[cfg.name] then
                cfg.trigger=d.itemTriggers[cfg.name]
            end
        end
    end
    if type(d.pickupBlacklist)=="table" then
        for _,cfg in ipairs(PICKUP_CFG) do
            if d.pickupBlacklist[cfg.name]~=nil then
                cfg.blacklisted=d.pickupBlacklist[cfg.name]
            end
        end
    end
    if type(d.buyBlacklist)=="table" then
        for _,cfg in ipairs(BUY_BLACKLIST) do
            if d.buyBlacklist[cfg.name]~=nil then
                cfg.blacklisted=d.buyBlacklist[cfg.name]
            end
        end
    end
    return d
end
LoadConfig()

local function TeleportTo(hrp, cf)
    if C.TELEPORT_MODE=="instant" then
        hrp.CFrame = cf
    elseif C.TELEPORT_MODE=="fast" then
        if S.activeTween then S.activeTween:Cancel() end
        S.activeTween = TweenService:Create(hrp,
            TweenInfo.new(0.15,Enum.EasingStyle.Linear),{CFrame=cf})
        S.activeTween:Play()
    else
        if S.activeTween then S.activeTween:Cancel() end
        local dur = math.clamp(
            (hrp.Position-cf.Position).Magnitude/60,0.3,2.5)
        S.activeTween = TweenService:Create(hrp,
            TweenInfo.new(dur,Enum.EasingStyle.Quad,
                          Enum.EasingDirection.Out),{CFrame=cf})
        S.activeTween:Play()
    end
end

local function GetInvStats()
    local res={isFull=false,healingCount=0,slotData={},noSlots=false}
    local igp = workspace:FindFirstChild("InGamePlayers")
    local pm  = igp and igp:FindFirstChild(player.Name)
    local inv = pm  and pm:FindFirstChild("Inventory")
    if not inv then res.noSlots=true; return res end
    local total,occ = 0,0
    for i=1,4 do
        local slot = inv:FindFirstChild("Slot"..i)
        if slot and slot:IsA("StringValue") then
            total+=1
            local cv=(slot.Value=="" or slot.Value=="None") and "None" or slot.Value
            res.slotData[i]=cv
            if cv~="None" then
                occ+=1
                if cv=="HealthKit" or cv=="Bandage" then
                    res.healingCount+=1
                end
            end
        end
    end
    if total==0 then res.noSlots=true end
    res.isFull = total>0 and occ==total
    return res
end

local function GetEnabledPickup()
    local t={}
    for _,cfg in ipairs(PICKUP_CFG) do
        if not cfg.blacklisted then t[#t+1]=cfg.name end
    end
    return t
end

local function GetSurvivalPoints()
    local info=workspace:FindFirstChild("Info"); if not info then return 0 end
    local ps=info:FindFirstChild("PlayerStats"); if not ps then return 0 end
    local folder=ps:FindFirstChild(player.Name); if not folder then return 0 end
    local sp=folder:FindFirstChild("SurvivalPoints")
    return (sp and sp:IsA("NumberValue") and sp.Value) or 0
end

local function GetTapeCount()
    local info=workspace:FindFirstChild("Info"); if not info then return 0 end
    local ps=info:FindFirstChild("PlayerStats"); if not ps then return 0 end
    local folder=ps:FindFirstChild(player.Name); if not folder then return 0 end
    local tp=folder:FindFirstChild("Tapes") or
              folder:FindFirstChild("SurvivalPoints")
    return (tp and tp:IsA("NumberValue") and tp.Value) or 0
end

local function HasItemInInventory(itemName)
    local igp=workspace:FindFirstChild("InGamePlayers")
    local pm=igp and igp:FindFirstChild(player.Name)
    local inv=pm and pm:FindFirstChild("Inventory")
    if not inv then return false end
    for i=1,4 do
        local slot=inv:FindFirstChild("Slot"..i)
        if slot and slot:IsA("StringValue") and
           slot.Value==itemName then return true end
    end
    return false
end

local function IsPlayerEggson()
    local info=workspace:FindFirstChild("Info"); if not info then return false end
    local pc=info:FindFirstChild("PickedCharacters"); if not pc then return false end
    local sv=pc:FindFirstChild(player.Name)
    return sv and sv:IsA("StringValue") and sv.Value=="Eggson"
end

local function GetEggsonGenPlayerNumberValue(gen)
    local pc=gen:FindFirstChild("PlayerCompletion")
    if pc then
        local entry=pc:FindFirstChild(player.Name)
        if entry and entry:IsA("NumberValue") then return entry end
    end
    return nil
end

local function EggsonGenHasPlayerNumberValue(gen)
    local nv=GetEggsonGenPlayerNumberValue(gen)
    return nv~=nil and nv.Value>=8
end

local function GetCurrentRoomGenerators()
    local result={}
    local currentRoom=workspace:FindFirstChild("CurrentRoom")
    if not currentRoom then return result end
    for _,roomModel in ipairs(currentRoom:GetChildren()) do
        if not roomModel:IsA("Model") then continue end
        local gensFolder=roomModel:FindFirstChild("Generators")
        if not gensFolder then continue end
        for _,gen in ipairs(gensFolder:GetChildren()) do
            if gen.Name~="Generator" or not gen:IsA("Model") then continue end
            result[#result+1]={gen=gen,roomModel=roomModel,gensFolder=gensFolder}
        end
    end
    return result
end

local function FireStopGenCurrentRoom(gen)
    local currentRoom=workspace:FindFirstChild("CurrentRoom")
    if currentRoom then
        for _,roomModel in ipairs(currentRoom:GetChildren()) do
            if not roomModel:IsA("Model") then continue end
            local gensFolder=roomModel:FindFirstChild("Generators")
            if not gensFolder then continue end
            for _,g in ipairs(gensFolder:GetChildren()) do
                if g==gen then
                    local st=g:FindFirstChild("Stats")
                    if st then
                        local si=st:FindFirstChild("StopInteracting")
                        if si then
                            pcall(function() si:FireServer("Stop") end)
                        end
                    end
                    return
                end
            end
        end
    end
    local s=gen:FindFirstChild("Stats")
    if s then
        local r=s:FindFirstChild("StopInteracting")
        if r then pcall(function() r:FireServer("Stop") end) end
    end
end

local function CleanName(n)
    if n=="SproutTendril" then return "Tendril" end
    return n:gsub("Monster",""):gsub("Sprout",""):gsub("Tendril","")
            :gsub("Model",""):gsub("Grab","")
end

local function CreateBall(radius, color, target)
    local b=Instance.new("Part",VisualFolder)
    b.Shape=Enum.PartType.Ball
    b.Size=Vector3.new(radius*2,radius*2,radius*2)
    b.Material=Enum.Material.ForceField
    b.Anchored=true; b.CanCollide=false; b.CastShadow=false
    b.Color=color or Color3.fromRGB(0,255,255)
    if target then
        local existingHL=target:FindFirstChildWhichIsA("Highlight")
        if not existingHL then
            local hl=Instance.new("Highlight",target)
            hl.FillColor=b.Color
            hl.OutlineColor=Color3.new(1,1,1)
        end
    end
    return b
end

-- ===== MONSTER NEAR POSITION CHECK =====
-- Returns true if any non-ignored monster is within `radius` studs of `pos`
local function IsMonsterNearPosition(pos, radius)
    for _,obj in ipairs(workspace:GetDescendants()) do
        if not obj:IsA("Model") then continue end
        if not (obj.Name:find("Monster") or SPECIAL_MONSTERS[obj.Name]) then continue end
        if table.find(FARM_IGNORE, obj.Name) then continue end
        if table.find(GRAB_NAMES, obj.Name) then continue end
        local prim = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
        if prim and (pos - prim.Position).Magnitude <= radius then
            return true
        end
    end
    return false
end

-- ===== GEN MONSTER SAFETY CHECK =====
-- Returns true if a monster (not ignored) is within GEN_ACTIVE_MONSTER_RADIUS of gen
local function IsMonsterNearGen(gen)
    local gp = gen:GetPivot().Position
    return IsMonsterNearPosition(gp, C.GEN_ACTIVE_MONSTER_RADIUS)
end

local function GetAvailableItems()
    local items,inv,ep={},GetInvStats(),GetEnabledPickup()
    local healTypes={"Bandage","HealthKit"}
    for _,folder in ipairs(workspace:GetDescendants()) do
        if folder.Name=="Items" and folder:IsA("Folder") then
            for _,item in ipairs(folder:GetChildren()) do
                if table.find(ep,item.Name) then
                    if inv.healingCount>=2 and
                       table.find(healTypes,item.Name) then continue end
                    if inv.isFull and item.Name~="Tape" and
                       item.Name~="ResearchCapsule" then continue end
                    -- NEW: skip items that have a monster within 15 studs
                    local handle = item:IsA("BasePart") and item or
                        item:FindFirstChildWhichIsA("BasePart", true)
                    if handle and IsMonsterNearPosition(handle.Position, C.ITEM_MONSTER_RADIUS) then
                        continue
                    end
                    items[#items+1]=item
                end
            end
        end
    end
    return items
end

local function MakeVacuumPad(pos)
    if S.VacuumPlatform then S.VacuumPlatform:Destroy() end
    local p=Instance.new("Part")
    p.Name="VacuumSafetyPad"; p.Size=Vector3.new(10,1,10)
    p.CFrame=CFrame.new(pos.X,pos.Y-5.5,pos.Z)
    p.Anchored=true; p.CanCollide=true; p.Transparency=1; p.Parent=workspace
    S.VacuumPlatform=p
end

local function InBaseBounds(base,pos)
    if not base then return false end
    local lp=base.CFrame:PointToObjectSpace(pos)
    return math.abs(lp.X)<=(base.Size.X/2-1.2) and
           math.abs(lp.Z)<=(base.Size.Z/2-1.2)
end

-- Cache base to avoid scanning every frame
local _baseCacheObj  = nil
local _baseCacheTime = 0
local BASE_CACHE_TTL = 2.0

local function FindBase()
    local now = tick()
    if _baseCacheObj and _baseCacheObj.Parent and (now - _baseCacheTime) < BASE_CACHE_TTL then
        return _baseCacheObj
    end
    _baseCacheObj = nil
    local folder=workspace:FindFirstChild(C.TARGET_FOLDER) or workspace
    for _,d in ipairs(folder:GetDescendants()) do
        if d:IsA("Model") and d.Name==C.MODEL_NAME then
            for _,it in ipairs(d:GetDescendants()) do
                if it.Name=="NoClip_Collider" or
                   it.Name=="NoClip_Colliders" then it:Destroy() end
            end
            local base=d:FindFirstChild(C.BASE_NAME)
            if base and base:IsA("BasePart") then
                if not base:FindFirstChild(C.INDICATOR_NAME) then
                    local ind=Instance.new("Part",base)
                    ind.Name=C.INDICATOR_NAME
                    ind.Size=base.Size+Vector3.new(0.1,0.5,0.1)
                    ind.CFrame=base.CFrame*CFrame.new(0,0.1,0)
                    ind.Anchored=true; ind.CanCollide=true
                    ind.Material=Enum.Material.Neon
                    ind.Color=Color3.fromRGB(0,255,100)
                    ind.Transparency=0.5
                end
                _baseCacheObj = base
                _baseCacheTime = now
                return base
            end
        end
    end
    return nil
end

local function FindPanicBase()
    local elevs=workspace:FindFirstChild("Elevators"); if not elevs then return nil end
    local elev=elevs:FindFirstChild("Elevator"); if not elev then return nil end
    local b=elev:FindFirstChild("Base")
    if b and b:IsA("BasePart") then return b end
    return nil
end

local function GetDecodingValue()
    local igp=workspace:FindFirstChild("InGamePlayers")
    local cig=igp and igp:FindFirstChild(player.Name)
    return cig and cig:FindFirstChild("Decoding")
end

local function GetActiveGen()
    local dv=GetDecodingValue(); if not dv then return nil end
    local g=dv.Value
    if not g or not g:IsA("Model") or g.Name~="Generator" then return nil end
    return g
end

local TENDRIL_LIKE = {
    "SproutTendril","BlotHand","BlotHand_L","BlotHand_R"
}

local function IsGenSafe(gen)
    local gp=gen:GetPivot().Position
    -- Check tendrils near gen
    for _,obj in ipairs(workspace:GetDescendants()) do
        if table.find(TENDRIL_LIKE,obj.Name) and obj:IsA("Model") then
            local tp=obj.PrimaryPart or
                      obj:FindFirstChildWhichIsA("BasePart",true)
            if tp then
                local diff=tp.Position-gp
                if Vector2.new(diff.X,diff.Z).Magnitude<=C.GEN_TENDRIL_SAFE and
                   math.abs(diff.Y)<=30 then return false end
            end
        end
    end
    -- Check monsters near gen (using per-monster radius)
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent:IsA("Model") and
           not Players:GetPlayerFromCharacter(obj.Parent) then
            if table.find(FARM_IGNORE,obj.Parent.Name) then continue end
            local mr=obj.Parent.PrimaryPart or
                      obj.Parent:FindFirstChild("HumanoidRootPart")
            if mr then
                local radius = MONSTER_RADIUS[obj.Parent.Name] or C.DETECTOR_RADIUS
                local dist = (gp-mr.Position).Magnitude
                if dist <= radius then
                    local base=FindBase()
                    if base and (base.Position-mr.Position).Magnitude <= radius then
                        continue
                    end
                    return false
                end
            end
        end
    end
    return true
end

local function GetGenThreats(gp)
    local mc,tc,bc=0,0,0
    for _,obj in ipairs(workspace:GetDescendants()) do
        if not obj:IsA("Model") then continue end
        if table.find(TENDRIL_LIKE,obj.Name) then
            local tp=obj.PrimaryPart or
                      obj:FindFirstChildWhichIsA("BasePart",true)
            if tp then
                local diff=tp.Position-gp
                if Vector2.new(diff.X,diff.Z).Magnitude<=C.GEN_TENDRIL_SAFE and
                   math.abs(diff.Y)<=30 then
                    if obj.Name=="SproutTendril" then tc+=1 else bc+=1 end
                end
            end
        elseif obj.Name:find("Monster") or SPECIAL_MONSTERS[obj.Name] then
            local mr2=obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
            if mr2 then
                local radius=MONSTER_RADIUS[obj.Name] or C.DETECTOR_RADIUS
                if (gp-mr2.Position).Magnitude<=radius then
                    local base=FindBase()
                    if base and (base.Position-mr2.Position).Magnitude<=radius then
                        continue
                    end
                    if not table.find(FARM_IGNORE,obj.Name) then mc+=1 end
                end
            end
        end
    end
    return mc,tc,bc
end

local function FireStopGen(gen)
    local s=gen:FindFirstChild("Stats")
    if s then
        local r=s:FindFirstChild("StopInteracting")
        if r then r:FireServer("Stop") end
    end
end

local function StartStopFireLoop()
    if S.stopFireActive or not S.FIRE_STOP then return end
    S.stopFireActive=true
    task.spawn(function()
        while true do
            local cg=GetActiveGen()
            if not cg then S.stopFireActive=false; return end
            local _,tc,bc=GetGenThreats(cg:GetPivot().Position)
            local icon=pGui:FindFirstChild("MonsterIcon",true)
            if (tc+bc)==0 and not(icon and icon.ImageTransparency==0) then
                S.stopFireActive=false; return
            end
            FireStopGen(cg); task.wait(0.1)
        end
    end)
end

local function ApplyInstantSkillcheck(state)
    local ok,hi=pcall(function()
        return ReplicatedStorage.Events.SkillcheckUpdate
    end)
    if not ok or not hi then return end
    if state then
        if getcallbackvalue then
            local ok2,orig=pcall(function()
                return getcallbackvalue(hi,"OnClientInvoke")
            end)
            if ok2 and orig then S.skillcheckOrigCB=orig end
        end
        hi.OnClientInvoke=function()
            task.spawn(function()
                pcall(function()
                    local gui=pGui:WaitForChild("ScreenGui")
                    local menu=gui.Menu
                    menu.SkillCheckFrame.Visible=false
                    menu.Calibrate.Visible=false
                    gui.Correct:Play(); gui.GoldAreaHit:Play()
                    menu.SkillCheckMessage.Text="Great Job!"
                    menu.SkillCheckMessage.UIGradient.Enabled=false
                    menu.SkillCheckMessage.UIGradientWin.Enabled=true
                    menu.SkillCheckMessage.Visible=true
                    menu.SkillCheckMessage.TextTransparency=0
                    task.wait(1)
                    TweenService:Create(menu.SkillCheckMessage,
                        TweenInfo.new(1),
                        {TextTransparency=1,TextStrokeTransparency=1}):Play()
                end)
            end)
            return "supercomplete"
        end
    else
        if S.skillcheckOrigCB then
            hi.OnClientInvoke=S.skillcheckOrigCB; S.skillcheckOrigCB=nil
        else hi.OnClientInvoke=nil end
    end
end

local function FireItemSlot(slotObj)
    local char=player.Character; if not char or not slotObj then return end
    pcall(function()
        ReplicatedStorage.Events.ItemEvent:InvokeServer(char,slotObj)
    end)
end

local function SlotWithItem(name)
    local char=player.Character
    local inv=char and char:FindFirstChild("Inventory")
    if not inv then return nil end
    for i=1,4 do
        local slot=inv:FindFirstChild("Slot"..i)
        if slot and slot:IsA("StringValue") and
           slot.Value==name then return slot end
    end
    return nil
end

local function GetCurrentStamina()
    local igp=workspace:FindFirstChild("InGamePlayers")
    local pm=igp and igp:FindFirstChild(player.Name)
    local st=pm and pm:FindFirstChild("Stats")
    local cs=st and st:FindFirstChild("CurrentStamina")
    if cs and cs:IsA("NumberValue") then return cs.Value end
    return math.huge
end

local function IsFloorActive()
    local info=workspace:FindFirstChild("Info")
    local fa=info and info:FindFirstChild("FloorActive")
    return fa and fa:IsA("BoolValue") and fa.Value==true
end

local function IsDandyStoreOpen()
    local info=workspace:FindFirstChild("Info")
    local ds=info and info:FindFirstChild("DandyStoreOpen")
    return ds and ds:IsA("BoolValue") and ds.Value==true
end

local function IsCardVoting()
    local info=workspace:FindFirstChild("Info")
    local cv=info and info:FindFirstChild("CardVoting")
    return cv and cv:IsA("BoolValue") and cv.Value==true
end

local function FireSprint(state)
    pcall(function()
        ReplicatedStorage.Events.SprintEvent:FireServer(state)
    end)
    S.isSprinting=state
end

local function StopSprintLoop() S.sprintLoopActive=false end

local function StartSprintLoop()
    if S.sprintLoopActive then return end
    S.sprintLoopActive=true
    task.spawn(function()
        while S.sprintLoopActive do
            task.wait(0.25)
            local activeGen=GetActiveGen()
            local floorActive=IsFloorActive()
            local shouldBeActive=(activeGen~=nil) or (not floorActive)
            if not shouldBeActive then
                if S.isSprinting then
                    pcall(function() FireSprint(false) end)
                end
                S.sprintLoopActive=false; return
            end
            local stamina=GetCurrentStamina()
            if stamina<=C.STAMINA_STOP_THRESHOLD then
                if S.isSprinting then
                    pcall(function() FireSprint(false) end)
                end
            elseif stamina>C.STAMINA_START_THRESHOLD then
                if not S.isSprinting then
                    pcall(function() FireSprint(true) end)
                end
            end
        end
        if S.isSprinting then
            pcall(function() FireSprint(false) end)
        end
    end)
end

local function GetFloorActiveValue()
    local info=workspace:FindFirstChild("Info")
    if not info then return nil end
    return info:FindFirstChild("FloorActive")
end

local function ShouldSpin()
    local faVal=GetFloorActiveValue()
    if faVal==nil then return false end
    if faVal:IsA("BoolValue") then return faVal.Value==false end
    return false
end

local function DestroySpinPlatform()
    if S.SpinPlatform then
        pcall(function() S.SpinPlatform:Destroy() end)
        S.SpinPlatform=nil
    end
end

local function GetOrCreateSpinPlatform()
    if S.SpinPlatform and S.SpinPlatform.Parent then
        return S.SpinPlatform
    end
    local p=Instance.new("Part")
    p.Name="SpinWalkPlatform"; p.Size=Vector3.new(6,1,6)
    p.Anchored=true; p.CanCollide=false; p.CastShadow=false
    p.Material=Enum.Material.Neon
    p.Color=Color3.fromRGB(85,190,255); p.Transparency=0.3
    p.Parent=workspace; S.SpinPlatform=p; return p
end

local function StopSpinLoop()
    S.spinLoopActive=false
    if S.spinOrbitTween then
        pcall(function() S.spinOrbitTween:Cancel() end)
        S.spinOrbitTween=nil
    end
    S.spinLoopConnection=nil; DestroySpinPlatform()
end

local function StartSpinLoop()
    if S.spinLoopActive then return end
    S.spinLoopActive=true
    task.spawn(function()
        local orbitAngle=0; local orbitCenter=nil
        while S.spinLoopActive do
            local activeGen=GetActiveGen()
            local dandyStore=IsDandyStoreOpen()
            local cardVoting=IsCardVoting()
            local spinOk=ShouldSpin()
            if not spinOk or activeGen or dandyStore or cardVoting then
                S.spinLoopActive=false
                if S.spinOrbitTween then
                    pcall(function() S.spinOrbitTween:Cancel() end)
                    S.spinOrbitTween=nil
                end
                DestroySpinPlatform(); return
            end
            local char=player.Character
            local hrp=char and char.PrimaryPart
            if not hrp then task.wait(C.SPIN_STEP_WAIT); continue end
            if not orbitCenter then orbitCenter=hrp.Position end
            orbitAngle=orbitAngle+C.SPIN_ORBIT_STEP
            if orbitAngle>=2*math.pi then
                orbitAngle=orbitAngle-2*math.pi
            end
            local radius=C.SPIN_ORBIT_RADIUS
            local targetX=orbitCenter.X+math.cos(orbitAngle)*radius
            local targetZ=orbitCenter.Z+math.sin(orbitAngle)*radius
            local targetY=hrp.Position.Y
            local targetPos=Vector3.new(targetX,targetY,targetZ)
            local flatDir=Vector3.new(
                targetPos.X-hrp.Position.X,0,targetPos.Z-hrp.Position.Z)
            local lookCF=CFrame.lookAt(targetPos,
                targetPos+(flatDir.Magnitude>0.01 and
                    flatDir.Unit or Vector3.new(0,0,1)))
            if S.spinOrbitTween then
                pcall(function() S.spinOrbitTween:Cancel() end)
                S.spinOrbitTween=nil
            end
            local tw=TweenService:Create(hrp,
                TweenInfo.new(C.SPIN_TWEEN_DURATION,
                    Enum.EasingStyle.Linear,Enum.EasingDirection.Out),
                {CFrame=lookCF})
            S.spinOrbitTween=tw; tw:Play()
            local plat=GetOrCreateSpinPlatform()
            plat.CFrame=CFrame.new(targetX,targetY-1,targetZ)
            task.wait(C.SPIN_STEP_WAIT)
        end
        if S.spinOrbitTween then
            pcall(function() S.spinOrbitTween:Cancel() end)
            S.spinOrbitTween=nil
        end
        DestroySpinPlatform()
    end)
end

local function DoAutoVote()
    if tick()-S.lastVoteTime<C.VOTE_SPAM_INTERVAL then return end
    local info=workspace:FindFirstChild("Info"); if not info then return end
    local cvBool=info:FindFirstChild("CardVoting")
    if not cvBool or not cvBool:IsA("BoolValue") or
       not cvBool.Value then return end
    local cvFolder=info:FindFirstChild("CardVote"); if not cvFolder then return end
    local cards={}
    for _,child in ipairs(cvFolder:GetChildren()) do
        if not Players:FindFirstChild(child.Name) then
            cards[#cards+1]=child
        end
    end
    if #cards==0 then return end
    local char=player.Character
    local hum=char and char:FindFirstChildWhichIsA("Humanoid")
    local igp=workspace:FindFirstChild("InGamePlayers")
    local pm=igp and igp:FindFirstChild(player.Name)
    local st=pm and pm:FindFirstChild("Stats")
    local maxHp=(st and st:FindFirstChild("Health") and st.Health.Value) or 3
    local curHp=(hum and hum.Health) or maxHp
    local isFull=(curHp>=maxHp)
    local best,bestTier=nil,999
    for _,card in ipairs(cards) do
        local tier=CARD_PRIORITY[card.Name] or 4
        if HEAL_CARDS[card.Name] and isFull then tier=5 end
        if tier<bestTier then bestTier=tier; best=card end
    end
    if not best then return end
    local votesFolder=best:FindFirstChild("Votes")
    if votesFolder then
        local alreadyVoted=votesFolder:FindFirstChild(player.Name)
        if alreadyVoted then return end
    end
    local myVote=cvFolder:FindFirstChild(player.Name)
    if myVote then
        if myVote.Value==best.Name or
           (myVote:IsA("StringValue") and myVote.Value==best.Name) then
            return
        end
        return
    end
    S.lastVoteTime=tick()
    pcall(function()
        ReplicatedStorage.Events.CardVoteEvent:FireServer(best)
    end)
end

local _lastStoreWasOpen=false
local function DoAutoBuy(hrp)
    if tick()-S.lastBuyTime<C.BUY_COOLDOWN then return end
    local info=workspace:FindFirstChild("Info"); if not info then return end
    local storeOpen=info:FindFirstChild("DandyStoreOpen")
    if not storeOpen or not storeOpen:IsA("BoolValue") or
       not storeOpen.Value then
        if _lastStoreWasOpen then
            S.boughtThisSession={}; _lastStoreWasOpen=false
        end
        return
    end
    _lastStoreWasOpen=true
    local elevs=workspace:FindFirstChild("Elevators"); if not elevs then return end
    local elev=elevs:FindFirstChild("Elevator"); if not elev then return end
    local openTrap=elev:FindFirstChild("OpenTrapDoors")
    if not openTrap or not openTrap:IsA("BoolValue") or
       not openTrap.Value then return end
    local dandyStore=elev:FindFirstChild("DandyStore"); if not dandyStore then return end
    local inv=GetInvStats(); if inv.isFull then return end
    local survivalPoints=GetSurvivalPoints()
    local bestItem,bestTier,bestModel,bestSlotFolder,bestSlotKey=nil,1000,nil,nil,nil
    for i=1,3 do
        local slotFolder=dandyStore:FindFirstChild("Slot"..i)
        if not slotFolder then continue end
        for _,child in ipairs(slotFolder:GetChildren()) do
            if not (child:IsA("Model") or child:IsA("BasePart")) then continue end
            local itemName=child.Name
            local slotKey="Slot"..i.."_"..itemName
            if S.boughtThisSession[slotKey] then continue end
            local costVal=child:FindFirstChild("Cost")
            if not costVal then
                costVal=slotFolder:FindFirstChild("Cost")
            end
            local itemCost=(costVal and costVal:IsA("NumberValue") and
                            costVal.Value) or math.huge
            if survivalPoints<itemCost then continue end
            if HasItemInInventory(itemName) then continue end
            local isHeal=(itemName=="Bandage" or itemName=="HealthKit")
            if not isHeal and inv.isFull then continue end
            if isHeal and inv.healingCount>=2 then continue end
            local isBlacklisted2=false
            for _,bbl in ipairs(BUY_BLACKLIST) do
                if bbl.name==itemName and bbl.blacklisted then
                    isBlacklisted2=true; break
                end
            end
            if isBlacklisted2 then continue end
            local tier=999
            for _,bp in ipairs(BUY_PRIORITY) do
                if bp.name==itemName then tier=bp.tier; break end
            end
            if tier<bestTier then
                bestTier=tier; bestItem=itemName; bestModel=child
                bestSlotFolder=slotFolder; bestSlotKey=slotKey
            end
        end
    end
    if not bestModel or not bestItem then return end
    local targetPart=bestModel:IsA("BasePart") and bestModel or
        bestModel:FindFirstChildWhichIsA("BasePart",true)
    if not targetPart then return end
    S.lastBuyTime=tick()
    TeleportTo(hrp,targetPart.CFrame*CFrame.new(0,3,0)); task.wait(0.2)
    if tick()-S.lastBuyInteract<C.BUY_INTERACT_COOLDOWN then return end
    S.lastBuyInteract=tick(); S.lastBoughtItem=bestItem
    if bestSlotKey then S.boughtThisSession[bestSlotKey]=true end
    for _,p in ipairs(bestSlotFolder:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            p.HoldDuration=0
            if fireproximityprompt then
                pcall(function() fireproximityprompt(p) end)
            end
        end
    end
    for _,p in ipairs(bestModel:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            p.HoldDuration=0
            if fireproximityprompt then
                pcall(function() fireproximityprompt(p) end)
            end
        end
    end
end

local function FindSafeMonster(hrp)
    local best,bestDist=nil,math.huge
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and
           (obj.Name:find("Monster") or SPECIAL_MONSTERS[obj.Name]) then
            if table.find(THREAT_LIST,obj.Name) then continue end
            local prim=obj.PrimaryPart or
                        obj:FindFirstChild("HumanoidRootPart")
            if prim then
                local d=(hrp.Position-prim.Position).Magnitude
                if d<=80 and d<bestDist then
                    bestDist=d; best=prim
                end
            end
        end
    end
    return best
end

local function FixAllGeneratorPipes()
    local function FixGens(gensFolder)
        if not gensFolder then return end
        for _,genModel in ipairs(gensFolder:GetChildren()) do
            if genModel.Name~="Generator" or
               not genModel:IsA("Model") then continue end
            for _,desc in ipairs(genModel:GetDescendants()) do
                if desc:IsA("BasePart") then
                    local n=desc.Name
                    if n=="InvisBlock" or n:lower():find("invisblock") then
                        pcall(function() desc:Destroy() end); continue
                    end
                    if n=="Pipe" and desc.CanCollide then
                        pcall(function() desc.CanCollide=false end)
                    end
                elseif desc:IsA("MeshPart") and desc.Name=="Pipe" then
                    if desc.CanCollide then
                        pcall(function() desc.CanCollide=false end)
                    end
                end
            end
        end
    end
    local gensFolder=workspace:FindFirstChild("Generators")
    FixGens(gensFolder)
    local currentRoom=workspace:FindFirstChild("CurrentRoom")
    if currentRoom then
        for _,roomModel in ipairs(currentRoom:GetChildren()) do
            if roomModel:IsA("Model") then
                FixGens(roomModel:FindFirstChild("Generators"))
            end
        end
    end
end

local function RemoveInvisWall()
    if S.invisWallFixed then return end
    local elevs=workspace:FindFirstChild("Elevators"); if not elevs then return end
    local elev=elevs:FindFirstChild("Elevator"); if not elev then return end
    local iwd=elev:FindFirstChild("InvisWall")
    if iwd and iwd:IsA("BasePart") then
        pcall(function() iwd:Destroy() end); S.invisWallFixed=true; return
    end
    local iwf=elev:FindFirstChild("Inviswall")
    if iwf then
        local iw=iwf:FindFirstChild("InvisWall")
        if iw and iw:IsA("BasePart") then
            pcall(function() iw:Destroy() end); S.invisWallFixed=true; return
        end
        pcall(function() iwf:Destroy() end); S.invisWallFixed=true; return
    end
    S.invisWallFixed=true
end

local function FindGenTeleportPosition(gen)
    local tpFolder=gen:FindFirstChild("TeleportPositions")
    if tpFolder then
        local tp=tpFolder:FindFirstChild("TeleportPosition")
        if tp and tp:IsA("BasePart") then return tp end
        local tread=tpFolder:FindFirstChild("TreadmillTeleportPosition")
        if tread and tread:IsA("BasePart") then return tread end
    end
    local tp=gen:FindFirstChild("TeleportPosition",true)
    if tp and tp:IsA("BasePart") then return tp end
    local tread=gen:FindFirstChild("TreadmillTeleportPosition",true)
    if tread and tread:IsA("BasePart") then return tread end
    return nil
end

local function FindGenPipePart(gen)
    for _,desc in ipairs(gen:GetDescendants()) do
        if (desc:IsA("BasePart") or desc:IsA("MeshPart")) and
           desc.Name=="Pipe" then return desc end
    end
    return nil
end

local function GetGenTeleportCFrame(gen)
    local activeGen=GetActiveGen()
    if activeGen and activeGen==gen then
        local pipe=FindGenPipePart(gen)
        if pipe then return pipe.CFrame end
    end
    local tpPart=FindGenTeleportPosition(gen)
    if tpPart then return tpPart.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0) end
    local prim=gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart",true)
    if prim then return prim.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0) end
    return nil
end

-- FIX: weak-key table so destroyed BaseParts don't prevent GC
local antiLagMaterialCache = setmetatable({}, {__mode = "k"})

local function IsOurObject(obj)
    if not obj then return false end
    local cur=obj
    while cur and cur~=game do
        if cur:IsA("BillboardGui") and
           cur:GetAttribute(SCRIPT_BILLBOARD_TAG) then return true end
        cur=cur.Parent
    end
    return false
end

local function ApplyAntiLagToInstance(obj)
    if not S.ANTI_LAG then return end
    if not obj or not obj.Parent then return end
    if obj:IsDescendantOf(pGui) then return end
    if obj:IsDescendantOf(VisualFolder) then return end
    if IsOurObject(obj) then return end
    if obj:IsA("BasePart") or obj:IsA("UnionOperation") or
       obj:IsA("MeshPart") then
        if obj.Material~=Enum.Material.SmoothPlastic then
            if not antiLagMaterialCache[obj] then
                antiLagMaterialCache[obj]=obj.Material
            end
            pcall(function() obj.Material=Enum.Material.SmoothPlastic end)
        end
    end
end

local function ApplyAntiLagToWorkspace()
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsDescendantOf(pGui) then continue end
        if obj:IsDescendantOf(VisualFolder) then continue end
        if IsOurObject(obj) then continue end
        pcall(function() ApplyAntiLagToInstance(obj) end)
    end
end

local function RestoreAntiLag()
    for obj,mat in pairs(antiLagMaterialCache) do
        if obj and obj.Parent then
            pcall(function() obj.Material=mat end)
        end
    end
    -- FIX: reset to a fresh weak table rather than leaving stale entries
    antiLagMaterialCache = setmetatable({}, {__mode = "k"})
end

local function StartAntiLag()
    if S.antiLagConnection then return end
    task.spawn(ApplyAntiLagToWorkspace)
    S.antiLagConnection=workspace.DescendantAdded:Connect(function(obj)
        if not S.ANTI_LAG then return end
        if obj:IsDescendantOf(pGui) then return end
        if obj:IsDescendantOf(VisualFolder) then return end
        if IsOurObject(obj) then return end
        task.defer(function()
            pcall(function() ApplyAntiLagToInstance(obj) end)
        end)
    end)
end

local function StopAntiLag()
    if S.antiLagConnection then
        S.antiLagConnection:Disconnect(); S.antiLagConnection=nil
    end
    RestoreAntiLag()
end

local function GetOrAddHighlight(obj,tbl,fillColor,outlineColor,fillTrans,outlineTrans)
    if not obj or not obj.Parent then return end
    local existing=tbl[obj]
    if existing and existing.Parent then
        existing.FillColor=fillColor or Color3.fromRGB(255,0,0)
        existing.OutlineColor=outlineColor or Color3.fromRGB(255,255,255)
        if fillTrans then existing.FillTransparency=fillTrans end
        if outlineTrans then existing.OutlineTransparency=outlineTrans end
        return existing
    end
    if existing then pcall(function() existing:Destroy() end) end
    local existingHL=obj:FindFirstChildWhichIsA("Highlight")
    if existingHL and not tbl[obj] then tbl[obj]=existingHL; return existingHL end
    local hl=Instance.new("Highlight")
    hl.FillColor=fillColor or Color3.fromRGB(255,0,0)
    hl.OutlineColor=outlineColor or Color3.fromRGB(255,255,255)
    hl.FillTransparency=fillTrans or 0.5
    hl.OutlineTransparency=outlineTrans or 0
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=obj
    tbl[obj]=hl; return hl
end

local function RemoveHighlight(obj,tbl)
    local hl=tbl[obj]
    if hl then pcall(function() hl:Destroy() end); tbl[obj]=nil end
end

local function CleanupESPTable(tbl)
    for obj,hl in pairs(tbl) do
        if not obj or not obj.Parent or
           not obj:IsDescendantOf(workspace) then
            pcall(function() hl:Destroy() end); tbl[obj]=nil
        end
    end
end

-- Throttled ESP update: only scan every N frames
local _espFrameCounter = 0
local ESP_UPDATE_INTERVAL = 10 -- update ESP every 10 render frames

local function UpdateAllESP()
    _espFrameCounter += 1
    if _espFrameCounter < ESP_UPDATE_INTERVAL then return end
    _espFrameCounter = 0

    CleanupESPTable(ESPHighlights.players)
    CleanupESPTable(ESPHighlights.tendrils)
    CleanupESPTable(ESPHighlights.blothands)
    CleanupESPTable(ESPHighlights.items)
    CleanupESPTable(ESPHighlights.monsters)
    CleanupESPTable(ESPHighlights.generators)

    if ESP_ENABLED.players then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr==player then continue end
            local char=plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                GetOrAddHighlight(char,ESPHighlights.players,
                    Color3.fromRGB(0,200,255),
                    Color3.fromRGB(255,255,255),0.5,0)
            end
        end
    else
        for obj,hl in pairs(ESPHighlights.players) do
            pcall(function() hl:Destroy() end)
            ESPHighlights.players[obj]=nil
        end
    end

    for _,obj in ipairs(workspace:GetDescendants()) do
        if not obj:IsA("Model") then continue end
        if obj.Name=="SproutTendril" then
            if ESP_ENABLED.tendrils then
                GetOrAddHighlight(obj,ESPHighlights.tendrils,
                    Color3.fromRGB(255,0,0),Color3.fromRGB(255,255,255),0.4,0)
            else RemoveHighlight(obj,ESPHighlights.tendrils) end
        elseif obj.Name=="BlotHand" or obj.Name=="BlotHand_L" or
               obj.Name=="BlotHand_R" then
            if ESP_ENABLED.blothands then
                GetOrAddHighlight(obj,ESPHighlights.blothands,
                    Color3.fromRGB(255,0,0),Color3.fromRGB(255,255,255),0.4,0)
            else RemoveHighlight(obj,ESPHighlights.blothands) end
        elseif (obj.Name:find("Monster") or SPECIAL_MONSTERS[obj.Name]) and
               not table.find(GRAB_NAMES,obj.Name) then
            if ESP_ENABLED.monsters then
                local fillC=SPECIAL_MONSTERS[obj.Name] and
                    Color3.fromRGB(150,0,0) or Color3.fromRGB(255,0,0)
                GetOrAddHighlight(obj,ESPHighlights.monsters,fillC,
                    Color3.fromRGB(255,255,255),0.4,0)
            else RemoveHighlight(obj,ESPHighlights.monsters) end
        elseif obj.Name=="Generator" then
            if ESP_ENABLED.generators then
                local st=obj:FindFirstChild("Stats")
                local completed=st and st:FindFirstChild("Completed") and
                    st.Completed.Value==true
                local fillC=completed and
                    Color3.fromRGB(0,255,80) or Color3.fromRGB(0,180,255)
                GetOrAddHighlight(obj,ESPHighlights.generators,fillC,
                    Color3.fromRGB(255,255,255),0.45,0)
            else RemoveHighlight(obj,ESPHighlights.generators) end
        end
    end

    if ESP_ENABLED.items then
        local currentRoom=workspace:FindFirstChild("CurrentRoom")
        if currentRoom then
            for _,roomModel in ipairs(currentRoom:GetChildren()) do
                if not roomModel:IsA("Model") then continue end
                local itemsFolder=roomModel:FindFirstChild("Items")
                if not itemsFolder then continue end
                for _,item in ipairs(itemsFolder:GetChildren()) do
                    if not item:IsA("Model") and
                       not item:IsA("BasePart") then continue end
                    local isHeal=item.Name=="Bandage" or item.Name=="HealthKit"
                    local fillC=isHeal and
                        Color3.fromRGB(255,140,0) or Color3.fromRGB(170,0,255)
                    GetOrAddHighlight(item,ESPHighlights.items,fillC,
                        Color3.fromRGB(255,255,255),0.4,0)
                end
            end
        end
        for _,folder in ipairs(workspace:GetDescendants()) do
            if folder.Name=="Items" and folder:IsA("Folder") then
                for _,item in ipairs(folder:GetChildren()) do
                    if not item:IsA("Model") and
                       not item:IsA("BasePart") then continue end
                    local isHeal=item.Name=="Bandage" or item.Name=="HealthKit"
                    local fillC=isHeal and
                        Color3.fromRGB(255,140,0) or Color3.fromRGB(170,0,255)
                    GetOrAddHighlight(item,ESPHighlights.items,fillC,
                        Color3.fromRGB(255,255,255),0.4,0)
                end
            end
        end
    else
        for obj,hl in pairs(ESPHighlights.items) do
            pcall(function() hl:Destroy() end)
            ESPHighlights.items[obj]=nil
        end
    end
end

 
_G.YattaP1 = {
    Players=Players, RunService=RunService, TweenService=TweenService,
    UserInputService=UserInputService, HttpService=HttpService,
    ReplicatedStorage=ReplicatedStorage, VirtualUser=VirtualUser,
    player=player, pGui=pGui, camera=camera,
    FULL_PLACE_ID=FULL_PLACE_ID, RESTRICTED_PLACE_ID=RESTRICTED_PLACE_ID,
    currentPlaceId=currentPlaceId, IS_RESTRICTED=IS_RESTRICTED,
    IS_FULL=IS_FULL, VisualFolder=VisualFolder,
    SCRIPT_BILLBOARD_TAG=SCRIPT_BILLBOARD_TAG,
    PlaySound=PlaySound, SOUND_CLICK=SOUND_CLICK,
    SOUND_ERROR=SOUND_ERROR, SOUND_MINIMIZE=SOUND_MINIMIZE,
    FlyState=FlyState, FlyToggle=FlyToggle,
    S=S, C=C, MONSTER_RADIUS=MONSTER_RADIUS,
    SPECIAL_MONSTERS=SPECIAL_MONSTERS, FARM_IGNORE=FARM_IGNORE,
    GRAB_NAMES=GRAB_NAMES, THREAT_LIST=THREAT_LIST,
    HEAL_CARDS=HEAL_CARDS, GEN_HALF_RESTRICTED=GEN_HALF_RESTRICTED,
    BUY_PRIORITY=BUY_PRIORITY, CARD_PRIORITY=CARD_PRIORITY,
    ITEM_CONFIG=ITEM_CONFIG, PICKUP_CFG=PICKUP_CFG,
    BUY_BLACKLIST=BUY_BLACKLIST, TRIGGER_OPTIONS=TRIGGER_OPTIONS,
    SCRIPTS_DATA=SCRIPTS_DATA,
    DodgeBalls=DodgeBalls, TendrilBalls=TendrilBalls, GrabBalls=GrabBalls,
    TwistedLabels=TwistedLabels, MachineLabels=MachineLabels,
    SMTLabels=SMTLabels, ESPHighlights=ESPHighlights,
    ESP_ENABLED=ESP_ENABLED, Theme=Theme,
    FONT_OPTIONS=FONT_OPTIONS, FONT_NAMES=FONT_NAMES, IDX=IDX,
    SUBTITLE_WORDS=SUBTITLE_WORDS, subtitleIdx=subtitleIdx,
    playerBillboards=playerBillboards,
    TeleportTo=TeleportTo, GetInvStats=GetInvStats,
    GetEnabledPickup=GetEnabledPickup, GetSurvivalPoints=GetSurvivalPoints,
    GetTapeCount=GetTapeCount, HasItemInInventory=HasItemInInventory,
    IsPlayerEggson=IsPlayerEggson,
    GetEggsonGenPlayerNumberValue=GetEggsonGenPlayerNumberValue,
    EggsonGenHasPlayerNumberValue=EggsonGenHasPlayerNumberValue,
    GetCurrentRoomGenerators=GetCurrentRoomGenerators,
    FireStopGenCurrentRoom=FireStopGenCurrentRoom,
    CleanName=CleanName, CreateBall=CreateBall,
    GetAvailableItems=GetAvailableItems, MakeVacuumPad=MakeVacuumPad,
    InBaseBounds=InBaseBounds, FindBase=FindBase, FindPanicBase=FindPanicBase,
    GetDecodingValue=GetDecodingValue, GetActiveGen=GetActiveGen,
    TENDRIL_LIKE=TENDRIL_LIKE, IsGenSafe=IsGenSafe,
    GetGenThreats=GetGenThreats, FireStopGen=FireStopGen,
    StartStopFireLoop=StartStopFireLoop,
    ApplyInstantSkillcheck=ApplyInstantSkillcheck,
    FireItemSlot=FireItemSlot, SlotWithItem=SlotWithItem,
    GetCurrentStamina=GetCurrentStamina, IsFloorActive=IsFloorActive,
    IsDandyStoreOpen=IsDandyStoreOpen, IsCardVoting=IsCardVoting,
    FireSprint=FireSprint, StopSprintLoop=StopSprintLoop,
    StartSprintLoop=StartSprintLoop, GetFloorActiveValue=GetFloorActiveValue,
    ShouldSpin=ShouldSpin, StopSpinLoop=StopSpinLoop,
    StartSpinLoop=StartSpinLoop, DoAutoVote=DoAutoVote,
    DoAutoBuy=DoAutoBuy, FindSafeMonster=FindSafeMonster,
    FixAllGeneratorPipes=FixAllGeneratorPipes,
    RemoveInvisWall=RemoveInvisWall,
    FindGenTeleportPosition=FindGenTeleportPosition,
    FindGenPipePart=FindGenPipePart,
    GetGenTeleportCFrame=GetGenTeleportCFrame,
    StartAntiLag=StartAntiLag, StopAntiLag=StopAntiLag,
    UpdateAllESP=UpdateAllESP, SaveConfig=SaveConfig,
    LoadConfig=LoadConfig, BuildConfigTable=BuildConfigTable,
    GetConfigFile=GetConfigFile,
    -- New exports
    IsMonsterNearPosition=IsMonsterNearPosition,
    IsMonsterNearGen=IsMonsterNearGen,
}





--------------------------


local P = _G.YattaP1
assert(P, "Run Part 1 first!")

local Players           = P.Players
local TweenService      = P.TweenService
local UserInputService  = P.UserInputService
local player            = P.player
local pGui              = P.pGui
local IS_RESTRICTED     = P.IS_RESTRICTED
local Theme             = P.Theme
local S                 = P.S
local C                 = P.C
local MONSTER_RADIUS    = P.MONSTER_RADIUS
local ITEM_CONFIG       = P.ITEM_CONFIG
local PICKUP_CFG        = P.PICKUP_CFG
local BUY_BLACKLIST     = P.BUY_BLACKLIST
local TRIGGER_OPTIONS   = P.TRIGGER_OPTIONS
local SCRIPTS_DATA      = P.SCRIPTS_DATA
local SPECIAL_MONSTERS  = P.SPECIAL_MONSTERS
local FONT_OPTIONS      = P.FONT_OPTIONS
local FONT_NAMES        = P.FONT_NAMES
local IDX               = P.IDX
local SUBTITLE_WORDS    = P.SUBTITLE_WORDS
local FlyState          = P.FlyState
local PlaySound         = P.PlaySound
local SOUND_CLICK       = P.SOUND_CLICK
local SOUND_ERROR       = P.SOUND_ERROR
local SOUND_MINIMIZE    = P.SOUND_MINIMIZE
local ApplyInstantSkillcheck = P.ApplyInstantSkillcheck
local StartAntiLag      = P.StartAntiLag
local StopAntiLag       = P.StopAntiLag
local ESP_ENABLED       = P.ESP_ENABLED
local ESPHighlights     = P.ESPHighlights
local FlyToggle         = P.FlyToggle

-- ===== RESPONSIVE SIZING =====
local Camera = workspace.CurrentCamera
local function GetScreenSize()
    local vp = Camera.ViewportSize
    return vp.X, vp.Y
end
local SW, SH = GetScreenSize()
local function CalcScale()
    local w, h = GetScreenSize()
    return math.clamp(math.min(w/1366, h/768) * 1.18, 0.48, 1.0)
end
local SCALE = CalcScale()
local function Px(n) return math.max(1, math.floor(n * SCALE + 0.5)) end

-- Memory-safe viewport connection stored for cleanup
local _viewportConn = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    SW, SH = GetScreenSize(); SCALE = CalcScale()
end)

-- ===== FONT =====
local RBXFONT = Enum.Font.FredokaOne

-- ===== DIMENSIONS =====
local TOTAL_W   = Px(320)
local TAB_W     = Px(72)
local CONT_W    = TOTAL_W - TAB_W
local TOTAL_H   = Px(530)
local TITLE_H   = Px(70)
local TOG_W     = Px(50)
local TOG_H     = Px(26)
local FONT_SZ   = Px(14)
local HDR_SZ    = Px(15)
local SM_SZ     = Px(11)
local TAB_BTN_H = Px(64)

-- ===== COLORS =====
local COL_BG_MAIN    = Color3.fromRGB(38, 38, 38)
local COL_BG_LIST    = Color3.fromRGB(28, 28, 28)
local COL_BG_CONTENT = Color3.fromRGB(52, 52, 52)
local COL_BG_ITEM    = Color3.fromRGB(45, 45, 45)
local COL_BORDER     = Color3.fromRGB(0, 0, 0)
local COL_TEXT_WHITE = Color3.fromRGB(255, 255, 255)
local COL_TEXT_LIGHT = Color3.fromRGB(210, 210, 210)
local COL_TEXT_MID   = Color3.fromRGB(130, 130, 130)
local COL_TEXT_DIM   = Color3.fromRGB(90, 90, 90)
local COL_GREEN      = Color3.fromRGB(68, 200, 90)
local COL_RED        = Color3.fromRGB(200, 50, 50)
local COL_YELLOW     = Color3.fromRGB(230, 180, 30)
local COL_ORANGE     = Color3.fromRGB(220, 130, 40)
local COL_BLUE       = Color3.fromRGB(68, 160, 255)
local COL_PURPLE     = Color3.fromRGB(160, 68, 255)
local COL_PINK       = Color3.fromRGB(255, 78, 178)
local COL_TOG_OFF    = Color3.fromRGB(90, 90, 90)
local COL_TOG_ON     = Color3.fromRGB(55, 185, 80)
local COL_BTN_LOCK_OFF  = Color3.fromRGB(185, 45, 45)
local COL_BTN_LOCK_ON   = Color3.fromRGB(55, 185, 80)
local COL_BTN_HIDE      = Color3.fromRGB(185, 45, 45)
local COL_BTN_SHOW      = Color3.fromRGB(55, 185, 80)

-- Sync theme
Theme.Font   = RBXFONT; Theme.GREEN  = COL_GREEN;  Theme.RED    = COL_RED
Theme.YELLOW = COL_YELLOW; Theme.ORANGE = COL_ORANGE; Theme.BLUE   = COL_BLUE
Theme.PURPLE = COL_PURPLE; Theme.PINK   = COL_PINK;   Theme.WHITE  = COL_TEXT_WHITE
Theme.LGRAY  = COL_TEXT_LIGHT; Theme.MGRAY  = COL_TEXT_MID
Theme.TOG_ON = COL_TOG_ON; Theme.TOG_OFF = COL_TOG_OFF
Theme.TOG_KNOB = Color3.fromRGB(230,230,230); Theme.ACCENT = COL_GREEN
Theme.BG_TOP = COL_BG_MAIN; Theme.CHECK_BG = COL_BG_ITEM; Theme.CHECK_BORDER = COL_BORDER

-- ===== HELPER: Add text stroke to any TextLabel/TextButton =====
local function AddTextStroke(lbl, color, thickness)
    local st = Instance.new("UIStroke", lbl)
    st.Name = "TextStroke"
    st.Color = color or Color3.fromRGB(0,0,0)
    st.Thickness = thickness or 1
    st.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    return st
end

-- ===== SCREEN GUI =====
local ScreenGui = Instance.new("ScreenGui", pGui)
ScreenGui.Name = "TwistedDodger_Ultimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- ===== MAIN DRAG FRAME =====
local MainDragFrame = Instance.new("Frame")
MainDragFrame.Name = "MainDragFrame"
MainDragFrame.Parent = ScreenGui
MainDragFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainDragFrame.BackgroundColor3 = COL_BG_MAIN
MainDragFrame.BorderSizePixel = 0
-- Position relative to top-left so minimize is stable
MainDragFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainDragFrame.Size = UDim2.new(0, TOTAL_W, 0, TOTAL_H)
MainDragFrame.ClipsDescendants = true
MainDragFrame.Active = true
MainDragFrame.ZIndex = 2

local uiGradient = Instance.new("UIGradient")
uiGradient.Name = "MainGradient"
uiGradient.Rotation = 270
uiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
uiGradient.Parent = MainDragFrame

local mainCorner = Instance.new("UICorner", MainDragFrame)
mainCorner.Name = "MainCorner"
mainCorner.CornerRadius = UDim.new(0, Px(18))

local mainStroke = Instance.new("UIStroke", MainDragFrame)
mainStroke.Name = "MainStroke"
mainStroke.Color = COL_BORDER
mainStroke.Thickness = 3
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Alias for Part 3 compatibility
local MainFrame = MainDragFrame

-- GlowHolder (shadow behind main frame)
local GlowHolder = Instance.new("Frame", ScreenGui)
GlowHolder.Name = "GlowHolder"
GlowHolder.BackgroundTransparency = 1
GlowHolder.Size = UDim2.new(0, TOTAL_W + Px(24), 0, TOTAL_H + Px(24))
GlowHolder.ZIndex = 1

local glowImg = Instance.new("ImageLabel", GlowHolder)
glowImg.Name = "GlowImage"
glowImg.Size = UDim2.new(1,0,1,0)
glowImg.BackgroundTransparency = 1
glowImg.Image = "rbxasset://textures/ui/Controls/DropShadow.png"
glowImg.ImageColor3 = Color3.fromRGB(0,0,0)
glowImg.ImageTransparency = 0.55
glowImg.ScaleType = Enum.ScaleType.Slice
glowImg.SliceCenter = Rect.new(12,12,12,12)
glowImg.ZIndex = 1

local function SyncGlow()
    GlowHolder.Position = UDim2.new(
        MainDragFrame.Position.X.Scale, MainDragFrame.Position.X.Offset - Px(12),
        MainDragFrame.Position.Y.Scale, MainDragFrame.Position.Y.Offset - Px(12))
end
SyncGlow()

-- ===== TITLE BAR =====
local TitleBar = Instance.new("Frame", MainDragFrame)
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
TitleBar.BackgroundTransparency = 1
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 5

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -Px(140), 0, Px(28))
TitleLabel.Position = UDim2.new(0, Px(14), 0, Px(6))
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Yatta's Crazy GUI"
TitleLabel.TextColor3 = COL_TEXT_WHITE
TitleLabel.Font = RBXFONT
TitleLabel.TextSize = Px(18)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 6
AddTextStroke(TitleLabel)

local SubLabel = Instance.new("TextLabel", TitleBar)
SubLabel.Name = "SubLabel"
SubLabel.Size = UDim2.new(1, -Px(140), 0, Px(18))
SubLabel.Position = UDim2.new(0, Px(14), 0, Px(36))
SubLabel.BackgroundTransparency = 1
SubLabel.Text = ""
SubLabel.TextColor3 = COL_TEXT_MID
SubLabel.Font = RBXFONT
SubLabel.TextSize = Px(12)
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.ZIndex = 6
SubLabel.TextTruncate = Enum.TextTruncate.AtEnd
SubLabel.RichText = true
AddTextStroke(SubLabel)

-- Subtitle animation - store connections for cleanup
local _subtitleConn = nil
local subtitleIdx = P.subtitleIdx or 1
task.spawn(function()
    task.wait(0.5)
    if subtitleIdx <= #SUBTITLE_WORDS then SubLabel.Text = SUBTITLE_WORDS[subtitleIdx] end
end)
task.spawn(function()
    task.wait(0.5)
    while SubLabel and SubLabel.Parent do
        task.wait(25)
        subtitleIdx = (subtitleIdx % #SUBTITLE_WORDS) + 1
        pcall(function() SubLabel.Text = SUBTITLE_WORDS[subtitleIdx] end)
    end
end)

-- ===== TITLE BUTTONS =====
local function MakeTitleBtn(name, text, bgColor, xOffsetFromRight, w, h)
    local btn = Instance.new("TextButton", TitleBar)
    btn.Name = name
    btn.Size = UDim2.new(0, w or Px(50), 0, h or Px(26))
    btn.Position = UDim2.new(1, -(xOffsetFromRight), 0.5, -((h or Px(26))/2))
    btn.BackgroundColor3 = bgColor
    btn.Text = text
    btn.TextColor3 = COL_TEXT_WHITE
    btn.Font = RBXFONT
    btn.TextSize = Px(12)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 8
    local c = Instance.new("UICorner", btn); c.Name = "BtnCorner"; c.CornerRadius = UDim.new(0, Px(6))
    local st = Instance.new("UIStroke", btn); st.Name = "BtnBorderStroke"; st.Color = COL_BORDER
    st.Thickness = 2; st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AddTextStroke(btn)
    return btn
end

local DragLockBtn = MakeTitleBtn("DragLockBtn", "LOCK",  COL_BTN_LOCK_OFF, Px(108), Px(50), Px(26))
local MinBtn      = MakeTitleBtn("MinimizeBtn", "-",  COL_BTN_HIDE,     Px(52),  Px(50), Px(26))

local function RefreshDragBtn()
    if S.DRAG_LOCKED then
        DragLockBtn.BackgroundColor3 = COL_BTN_LOCK_ON
        DragLockBtn.Text = "UNLOCK"
    else
        DragLockBtn.BackgroundColor3 = COL_BTN_LOCK_OFF
        DragLockBtn.Text = "LOCK"
    end
end

DragLockBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUND_MINIMIZE)
    S.DRAG_LOCKED = not S.DRAG_LOCKED
    RefreshDragBtn()
end)

-- Credit label (below the main frame)
local CreditLabel = Instance.new("TextLabel", ScreenGui)
CreditLabel.Name = "CreditLabel"
CreditLabel.Size = UDim2.new(0, TOTAL_W, 0, Px(14))
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = " "
CreditLabel.TextColor3 = COL_TEXT_DIM
CreditLabel.Font = RBXFONT
CreditLabel.TextSize = Px(10)
CreditLabel.ZIndex = 2
AddTextStroke(CreditLabel)

local function UpdateCreditPos()
    local h = S.IS_MINIMIZED and TITLE_H or TOTAL_H
    -- Use same scale/offset as MainDragFrame so it tracks correctly
    CreditLabel.Position = UDim2.new(
        MainDragFrame.Position.X.Scale, MainDragFrame.Position.X.Offset - (TOTAL_W/2),
        MainDragFrame.Position.Y.Scale, MainDragFrame.Position.Y.Offset + (h/2) + Px(4))
end
UpdateCreditPos()

-- ===== LIST FRAME (Tab rail) =====
local ListFrame = Instance.new("ScrollingFrame", MainDragFrame)
ListFrame.Name = "TabRailFrame"
ListFrame.Size = UDim2.new(0, TAB_W, 1, -TITLE_H)
ListFrame.Position = UDim2.new(0, 0, 0, TITLE_H)
ListFrame.BackgroundColor3 = COL_BG_LIST
ListFrame.BackgroundTransparency = 1
ListFrame.BorderSizePixel = 0
ListFrame.ScrollBarThickness = 0
ListFrame.CanvasSize = UDim2.new(0,0,0,0)
ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListFrame.ZIndex = 3
ListFrame.ClipsDescendants = true

local lfLayout = Instance.new("UIListLayout", ListFrame)
lfLayout.Name = "TabRailLayout"
lfLayout.Padding = UDim.new(0, Px(6))
lfLayout.SortOrder = Enum.SortOrder.LayoutOrder
lfLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local lfPad = Instance.new("UIPadding", ListFrame)
lfPad.Name = "TabRailPadding"
lfPad.PaddingTop = UDim.new(0, Px(10))
lfPad.PaddingLeft = UDim.new(0, Px(4))
lfPad.PaddingRight = UDim.new(0, Px(4))

-- ===== CONTENT AREA =====
local ContentArea = Instance.new("ScrollingFrame", MainDragFrame)
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(0, CONT_W, 1, -TITLE_H)
ContentArea.Position = UDim2.new(0, TAB_W, 0, TITLE_H)
ContentArea.BackgroundColor3 = Color3.fromRGB(54, 69, 79)
ContentArea.BackgroundTransparency = 0
ContentArea.ScrollBarThickness = Px(3)
ContentArea.ScrollBarImageColor3 = COL_TEXT_DIM
ContentArea.CanvasSize = UDim2.new(0,0,0,0)
ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 3

local contentCorner = Instance.new("UICorner", ContentArea)
contentCorner.Name = "ContentAreaCorner"
contentCorner.CornerRadius = UDim.new(0, 14)

-- ===== PAGE FACTORY =====
local function MakePage(name)
    local sf = Instance.new("Frame", ContentArea)
    sf.Name = name or "Page"
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.Visible = false
    sf.ZIndex = 4
    sf.AutomaticSize = Enum.AutomaticSize.Y
    local lay = Instance.new("UIListLayout", sf)
    lay.Name = "PageLayout"
    lay.Padding = UDim.new(0, Px(3)); lay.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", sf)
    pad.Name = "PagePadding"
    pad.PaddingLeft = UDim.new(0, Px(8)); pad.PaddingRight = UDim.new(0, Px(6))
    pad.PaddingTop = UDim.new(0, Px(6)); pad.PaddingBottom = UDim.new(0, Px(8))
    return sf
end

local Pages = {
    Main     = MakePage("PageMain"),
    Other    = MakePage("PageOther"),
    Settings = MakePage("PageSettings"),
    Scripts  = MakePage("PageScripts"),
}
Pages.Main.Visible = true

-- ===== TAB BUTTONS =====
local TAB_DEFS = {
    {label="Main",     icon="≡",  page=Pages.Main},
    {label="Other",    icon="?",  page=Pages.Other},
    {label="Settings", icon="⚙",  page=Pages.Settings},
    {label="Scripts",  icon="►",  page=Pages.Scripts},
}
local tabBtnRefs = {}

local function SetTab(tp)
    for _, ref in ipairs(tabBtnRefs) do
        local a = (ref.page == tp)
        ref.iconL.TextColor3 = a and COL_TEXT_WHITE or COL_TEXT_MID
        ref.nameL.TextColor3 = a and COL_TEXT_WHITE or COL_TEXT_MID
    end
    for _, td in ipairs(TAB_DEFS) do
        td.page.Visible = (td.page == tp)
    end
end

for i, td in ipairs(TAB_DEFS) do
    local btn = Instance.new("TextButton", ListFrame)
    btn.Name = "TabBtn_"..td.label
    btn.Size = UDim2.new(1, 0, 0, TAB_BTN_H)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 4

    local iconL = Instance.new("TextLabel", btn)
    iconL.Name = "TabIcon_"..td.label
    iconL.Size = UDim2.new(1, 0, 0, Px(26)); iconL.Position = UDim2.new(0, 0, 0, Px(8))
    iconL.BackgroundTransparency = 1; iconL.Text = td.icon
    iconL.Font = Enum.Font.GothamBold; iconL.TextSize = Px(18)
    iconL.TextColor3 = (i==1) and COL_TEXT_WHITE or COL_TEXT_MID
    iconL.TextXAlignment = Enum.TextXAlignment.Center; iconL.ZIndex = 5
    AddTextStroke(iconL)

    local nameL = Instance.new("TextLabel", btn)
    nameL.Name = "TabName_"..td.label
    nameL.Size = UDim2.new(1, 0, 0, Px(16)); nameL.Position = UDim2.new(0, 0, 0, Px(36))
    nameL.BackgroundTransparency = 1; nameL.Text = td.label
    nameL.Font = RBXFONT; nameL.TextSize = Px(10)
    nameL.TextColor3 = (i==1) and COL_TEXT_WHITE or COL_TEXT_MID
    nameL.TextXAlignment = Enum.TextXAlignment.Center; nameL.ZIndex = 5
    AddTextStroke(nameL)

    tabBtnRefs[#tabBtnRefs+1] = {btn=btn, iconL=iconL, nameL=nameL, page=td.page}
    local capTd = td
    btn.MouseButton1Click:Connect(function() PlaySound(SOUND_CLICK); SetTab(capTd.page) end)
end

-- ===== UI HELPERS =====

local function SecHeader(parent, text, lo)
    local f = Instance.new("Frame", parent)
    f.Name = "SecHeader_"..text:gsub("%s+","_"):sub(1,30)
    f.Size = UDim2.new(1, 0, 0, Px(28))
    f.BackgroundColor3 = COL_BG_LIST
    f.BackgroundTransparency = 0
    f.BorderSizePixel = 0; f.LayoutOrder = lo or 0; f.ZIndex = 4
    local fCorner = Instance.new("UICorner", f)
    fCorner.Name = "SecHeaderCorner"
    fCorner.CornerRadius = UDim.new(0, Px(7))
    local lbl = Instance.new("TextLabel", f)
    lbl.Name = "SecHeaderLabel"
    lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.TextColor3 = COL_TEXT_WHITE
    lbl.Font = RBXFONT; lbl.TextSize = HDR_SZ
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 5
    AddTextStroke(lbl)
    local lPad = Instance.new("UIPadding", f)
    lPad.Name = "SecHeaderPadding"
    lPad.PaddingLeft = UDim.new(0, Px(8))
    return f, lbl
end

local function InfoLbl(parent, text, color, lo)
    local l = Instance.new("TextLabel", parent)
    l.Name = "InfoLbl_"..text:gsub("%s+","_"):gsub("[^%w_]",""):sub(1,30)
    l.Size = UDim2.new(1, 0, 0, Px(17)); l.BackgroundTransparency = 1
    l.Text = text; l.TextColor3 = color or COL_TEXT_LIGHT
    l.Font = RBXFONT; l.TextSize = FONT_SZ
    l.TextXAlignment = Enum.TextXAlignment.Left; l.LayoutOrder = lo or 0; l.ZIndex = 4
    AddTextStroke(l)
    return l
end

local function ListLbl(parent, text, color)
    local l = Instance.new("TextLabel", parent)
    l.Name = "ListLbl_"..text:gsub("%s+","_"):gsub("[^%w_]",""):sub(1,30)
    l.Size = UDim2.new(1, 0, 0, Px(16)); l.BackgroundTransparency = 1
    l.Text = text; l.TextColor3 = color or COL_TEXT_LIGHT
    l.Font = RBXFONT; l.TextSize = FONT_SZ
    l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 4
    AddTextStroke(l)
    return l
end

local function Gap(parent, h, lo)
    local f = Instance.new("Frame", parent)
    f.Name = "GapFrame"
    f.Size = UDim2.new(1, 0, 0, Px(h or 4)); f.BackgroundTransparency = 1
    f.LayoutOrder = lo or 0; f.ZIndex = 4
    return f
end

-- ===== SLIDER =====
local function MakeSlider(parent, labelText, minVal, maxVal, defaultVal, lo, onChange)
    local safeName = labelText:gsub("%s+","_"):gsub("[^%w_]",""):sub(1,24)
    local wrapper = Instance.new("Frame", parent)
    wrapper.Name = "SliderWrapper_"..safeName
    wrapper.Size = UDim2.new(1, 0, 0, Px(54)); wrapper.BackgroundColor3 = COL_BG_ITEM
    wrapper.BorderSizePixel = 0; wrapper.LayoutOrder = lo or 0; wrapper.ZIndex = 4
    local wCorner = Instance.new("UICorner", wrapper)
    wCorner.Name = "SliderCorner"
    wCorner.CornerRadius = UDim.new(0, Px(8))
    local wStroke = Instance.new("UIStroke", wrapper)
    wStroke.Name = "SliderBorderStroke"
    wStroke.Color = COL_BORDER; wStroke.Thickness = 2; wStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local wPad = Instance.new("UIPadding", wrapper)
    wPad.Name = "SliderPadding"
    wPad.PaddingLeft = UDim.new(0, Px(10)); wPad.PaddingRight = UDim.new(0, Px(10))
    wPad.PaddingTop = UDim.new(0, Px(6)); wPad.PaddingBottom = UDim.new(0, Px(6))
    local lbl = Instance.new("TextLabel", wrapper)
    lbl.Name = "SliderLabel"
    lbl.Size = UDim2.new(1,0,0,Px(19)); lbl.BackgroundTransparency = 1
    lbl.Text = labelText..": "..tostring(defaultVal); lbl.TextColor3 = COL_TEXT_LIGHT
    lbl.Font = RBXFONT; lbl.TextSize = SM_SZ; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 5
    AddTextStroke(lbl)
    local trackBg = Instance.new("Frame", wrapper)
    trackBg.Name = "SliderTrack"
    trackBg.Size = UDim2.new(1,0,0,Px(8)); trackBg.Position = UDim2.new(0,0,0,Px(26))
    trackBg.BackgroundColor3 = Color3.fromRGB(60,60,60); trackBg.BorderSizePixel = 0; trackBg.ZIndex = 5
    local tbCorner = Instance.new("UICorner", trackBg)
    tbCorner.Name = "TrackCorner"
    tbCorner.CornerRadius = UDim.new(0, Px(4))
    local fill = Instance.new("Frame", trackBg)
    fill.Name = "SliderFill"
    fill.Size = UDim2.new((defaultVal-minVal)/(maxVal-minVal),0,1,0)
    fill.BackgroundColor3 = COL_GREEN; fill.BorderSizePixel = 0; fill.ZIndex = 6
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.Name = "FillCorner"
    fillCorner.CornerRadius = UDim.new(0, Px(4))
    local ks = Px(16)
    local knob = Instance.new("Frame", trackBg)
    knob.Name = "SliderKnob"
    knob.Size = UDim2.new(0,ks,0,ks); knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((defaultVal-minVal)/(maxVal-minVal),0,0.5,0)
    knob.BackgroundColor3 = COL_TEXT_WHITE; knob.BorderSizePixel = 0; knob.ZIndex = 7
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.Name = "KnobCorner"
    knobCorner.CornerRadius = UDim.new(0, Px(8))
    local currentVal = defaultVal; local dragging = false
    local moveConn, endConn
    local function SetValue(v)
        v = math.clamp(math.floor(v*10+0.5)/10, minVal, maxVal); currentVal = v
        local pct = (v-minVal)/(maxVal-minVal)
        fill.Size = UDim2.new(pct,0,1,0); knob.Position = UDim2.new(pct,0,0.5,0)
        lbl.Text = labelText..": "..tostring(v); if onChange then onChange(v) end
    end
    local function StopDrag()
        dragging = false
        if moveConn then moveConn:Disconnect(); moveConn = nil end
        if endConn then endConn:Disconnect(); endConn = nil end
    end
    trackBg.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging then StopDrag() end; dragging = true
        SetValue(minVal + math.clamp((inp.Position.X - trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)*(maxVal-minVal))
        moveConn = UserInputService.InputChanged:Connect(function(i2)
            if not dragging then return end
            if i2.UserInputType == Enum.UserInputType.MouseMovement or i2.UserInputType == Enum.UserInputType.Touch then
                SetValue(minVal + math.clamp((i2.Position.X - trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)*(maxVal-minVal))
            end
        end)
        endConn = UserInputService.InputEnded:Connect(function(i2)
            if i2.UserInputType == Enum.UserInputType.MouseButton1 or i2.UserInputType == Enum.UserInputType.Touch then StopDrag() end
        end)
    end)
    trackBg.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then StopDrag() end
    end)
    return wrapper, {GetValue=function() return currentVal end, SetValue=SetValue}
end

-- ===== GRID SLIDER =====
local function MakeGridSlider(parent, labelText, minVal, maxVal, defaultVal, step, lo, onChange)
    local safeName = labelText:gsub("%s+","_"):gsub("[^%w_]",""):sub(1,24)
    local wrapper = Instance.new("Frame", parent)
    wrapper.Name = "GridSliderWrapper_"..safeName
    wrapper.Size = UDim2.new(1,0,0,Px(54)); wrapper.BackgroundColor3 = COL_BG_ITEM
    wrapper.BorderSizePixel = 0; wrapper.LayoutOrder = lo or 0; wrapper.ZIndex = 4
    local wCorner = Instance.new("UICorner", wrapper)
    wCorner.Name = "GridSliderCorner"
    wCorner.CornerRadius = UDim.new(0, Px(8))
    local wStroke = Instance.new("UIStroke", wrapper)
    wStroke.Name = "GridSliderBorderStroke"
    wStroke.Color = COL_BORDER; wStroke.Thickness = 2; wStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local wPad = Instance.new("UIPadding", wrapper)
    wPad.Name = "GridSliderPadding"
    wPad.PaddingLeft = UDim.new(0, Px(10)); wPad.PaddingRight = UDim.new(0, Px(10))
    wPad.PaddingTop = UDim.new(0, Px(6)); wPad.PaddingBottom = UDim.new(0, Px(6))
    local lbl = Instance.new("TextLabel", wrapper)
    lbl.Name = "GridSliderLabel"
    lbl.Size = UDim2.new(1,0,0,Px(19)); lbl.BackgroundTransparency = 1
    lbl.Text = labelText..": "..tostring(defaultVal); lbl.TextColor3 = COL_TEXT_LIGHT
    lbl.Font = RBXFONT; lbl.TextSize = SM_SZ; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 5
    AddTextStroke(lbl)
    local trackBg = Instance.new("Frame", wrapper)
    trackBg.Name = "GridSliderTrack"
    trackBg.Size = UDim2.new(1,0,0,Px(8)); trackBg.Position = UDim2.new(0,0,0,Px(26))
    trackBg.BackgroundColor3 = Color3.fromRGB(60,60,60); trackBg.BorderSizePixel = 0; trackBg.ZIndex = 5
    local tbCorner = Instance.new("UICorner", trackBg)
    tbCorner.Name = "GridTrackCorner"
    tbCorner.CornerRadius = UDim.new(0, Px(4))
    local steps = math.floor((maxVal-minVal)/step)
    for i = 0, steps do
        local dot = Instance.new("Frame", trackBg)
        dot.Name = "GridDot_"..i
        dot.Size = UDim2.new(0,Px(2),0,Px(8)); dot.AnchorPoint = Vector2.new(0.5,0.5)
        dot.Position = UDim2.new(i/math.max(steps,1),0,0.5,0)
        dot.BackgroundColor3 = Color3.fromRGB(90,90,90); dot.BorderSizePixel = 0; dot.ZIndex = 6
    end
    local fill = Instance.new("Frame", trackBg)
    fill.Name = "GridSliderFill"
    fill.Size = UDim2.new((defaultVal-minVal)/(maxVal-minVal),0,1,0)
    fill.BackgroundColor3 = COL_YELLOW; fill.BorderSizePixel = 0; fill.ZIndex = 7
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.Name = "GridFillCorner"
    fillCorner.CornerRadius = UDim.new(0, Px(4))
    local ks = Px(16)
    local knob = Instance.new("Frame", trackBg)
    knob.Name = "GridSliderKnob"
    knob.Size = UDim2.new(0,ks,0,ks); knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new((defaultVal-minVal)/(maxVal-minVal),0,0.5,0)
    knob.BackgroundColor3 = COL_TEXT_WHITE; knob.BorderSizePixel = 0; knob.ZIndex = 8
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.Name = "GridKnobCorner"
    knobCorner.CornerRadius = UDim.new(0, Px(8))
    local currentVal = defaultVal; local dragging = false
    local moveConn, endConn
    local function SetValue2(v)
        v = math.clamp(math.floor((v-minVal)/step+0.5)*step+minVal, minVal, maxVal); currentVal = v
        local pct = (v-minVal)/(maxVal-minVal)
        fill.Size = UDim2.new(pct,0,1,0); knob.Position = UDim2.new(pct,0,0.5,0)
        lbl.Text = labelText..": "..tostring(v); if onChange then onChange(v) end
    end
    local function StopDrag2()
        dragging = false
        if moveConn then moveConn:Disconnect(); moveConn = nil end
        if endConn then endConn:Disconnect(); endConn = nil end
    end
    trackBg.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging then StopDrag2() end; dragging = true
        SetValue2(minVal + math.clamp((inp.Position.X - trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)*(maxVal-minVal))
        moveConn = UserInputService.InputChanged:Connect(function(i2)
            if not dragging then return end
            if i2.UserInputType == Enum.UserInputType.MouseMovement or i2.UserInputType == Enum.UserInputType.Touch then
                SetValue2(minVal + math.clamp((i2.Position.X - trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)*(maxVal-minVal))
            end
        end)
        endConn = UserInputService.InputEnded:Connect(function(i2)
            if i2.UserInputType == Enum.UserInputType.MouseButton1 or i2.UserInputType == Enum.UserInputType.Touch then StopDrag2() end
        end)
    end)
    trackBg.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then StopDrag2() end
    end)
    return wrapper, {GetValue=function() return currentVal end, SetValue=SetValue2}
end

-- ===== TOGGLE =====
local function MakeToggle(parent, labelText, initState, lo)
    local state = initState
    local callbacks = {}
    local safeName = labelText:gsub("%s+","_"):gsub("[^%w_]",""):sub(1,24)
    local row = Instance.new("Frame", parent)
    row.Name = "ToggleRow_"..safeName
    row.Size = UDim2.new(1, 0, 0, Px(34))
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.LayoutOrder = lo or 0
    row.ZIndex = 4
    local rowPad = Instance.new("UIPadding", row)
    rowPad.Name = "ToggleRowPadding"
    rowPad.PaddingLeft = UDim.new(0, Px(4)); rowPad.PaddingRight = UDim.new(0, Px(4))

    local lbl = Instance.new("TextLabel", row)
    lbl.Name = "ToggleLabel"
    lbl.Size = UDim2.new(1, -(TOG_W + Px(14)), 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = COL_TEXT_LIGHT
    lbl.Font = RBXFONT
    lbl.TextSize = FONT_SZ
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5
    AddTextStroke(lbl)

    local track = Instance.new("Frame", row)
    track.Name = "ToggleTrack"
    track.Size = UDim2.new(0, TOG_W, 0, TOG_H)
    track.Position = UDim2.new(1, -TOG_W, 0.5, -TOG_H/2)
    track.BackgroundColor3 = state and COL_TOG_ON or COL_TOG_OFF
    track.BorderSizePixel = 0; track.ZIndex = 5
    local trackCorner = Instance.new("UICorner", track)
    trackCorner.Name = "ToggleTrackCorner"
    trackCorner.CornerRadius = UDim.new(0, Px(13))
    local trackStroke = Instance.new("UIStroke", track)
    trackStroke.Name = "ToggleTrackStroke"
    trackStroke.Color = COL_BORDER; trackStroke.Thickness = 2; trackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local ks = TOG_H - Px(6)
    local knob = Instance.new("Frame", track)
    knob.Name = "ToggleKnob"
    knob.Size = UDim2.new(0, ks, 0, ks)
    knob.Position = state and UDim2.new(1,-(ks+Px(3)),0.5,-ks/2) or UDim2.new(0,Px(3),0.5,-ks/2)
    knob.BackgroundColor3 = Color3.fromRGB(230,230,230)
    knob.BorderSizePixel = 0; knob.ZIndex = 7
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.Name = "ToggleKnobCorner"
    knobCorner.CornerRadius = UDim.new(0, Px(10))

    local checkmark = Instance.new("TextLabel", track)
    checkmark.Name = "ToggleCheckmark"
    checkmark.Size = UDim2.new(0,Px(18),1,0); checkmark.Position = UDim2.new(0,Px(4),0,0)
    checkmark.BackgroundTransparency = 1; checkmark.Text = "√"
    checkmark.TextColor3 = COL_TEXT_WHITE; checkmark.Font = Enum.Font.GothamBold
    checkmark.TextSize = Px(12); checkmark.ZIndex = 6; checkmark.Visible = state
    AddTextStroke(checkmark)

    local xmark = Instance.new("TextLabel", track)
    xmark.Name = "ToggleXmark"
    xmark.Size = UDim2.new(0,Px(18),1,0); xmark.Position = UDim2.new(1,-Px(18),0,0)
    xmark.BackgroundTransparency = 1; xmark.Text = "X"
    xmark.TextColor3 = COL_TEXT_WHITE; xmark.Font = Enum.Font.GothamBold
    xmark.TextSize = Px(12); xmark.ZIndex = 6; xmark.Visible = not state
    AddTextStroke(xmark)

    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function Anim(ns)
        state = ns
        TweenService:Create(knob, tweenInfo,
            ns and {Position=UDim2.new(1,-(ks+Px(3)),0.5,-ks/2)} or {Position=UDim2.new(0,Px(3),0.5,-ks/2)}):Play()
        TweenService:Create(track, tweenInfo, {BackgroundColor3 = ns and COL_TOG_ON or COL_TOG_OFF}):Play()
        checkmark.Visible = ns; xmark.Visible = not ns
        for _, cb in ipairs(callbacks) do cb(ns) end
    end

    local clickBtn = Instance.new("TextButton", row)
    clickBtn.Name = "ToggleClickBtn"
    clickBtn.Size = UDim2.new(1,0,1,0); clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""; clickBtn.ZIndex = 9
    clickBtn.MouseButton1Click:Connect(function() PlaySound(SOUND_CLICK); Anim(not state) end)

    return row, {
        GetState=function() return state end, SetState=Anim,
        OnChanged=function(f) callbacks[#callbacks+1]=f end,
        Label=lbl, Track=track, Knob=knob, ClickBtn=clickBtn,
    }
end

-- ===== CHECKBOX ROW =====
local function MakeCheckboxRow(parent, itemName, isBlacklisted, lo, onToggle)
    local CUBE_SZ = Px(20)
    local safeName = itemName:gsub("%s+","_"):gsub("[^%w_]",""):sub(1,24)
    local row = Instance.new("Frame", parent)
    row.Name = "CheckboxRow_"..safeName
    row.Size = UDim2.new(1,0,0,Px(30)); row.BackgroundColor3 = COL_BG_ITEM
    row.BorderSizePixel = 0; row.LayoutOrder = lo or 0; row.ZIndex = 4
    local rowCorner = Instance.new("UICorner", row)
    rowCorner.Name = "CheckboxCorner"
    rowCorner.CornerRadius = UDim.new(0, Px(7))
    local rowStroke = Instance.new("UIStroke", row)
    rowStroke.Name = "CheckboxBorderStroke"
    rowStroke.Color = COL_BORDER; rowStroke.Thickness = 2; rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local rPad = Instance.new("UIPadding", row)
    rPad.Name = "CheckboxPadding"
    rPad.PaddingLeft = UDim.new(0, Px(8)); rPad.PaddingRight = UDim.new(0, Px(6))
    rPad.PaddingTop = UDim.new(0, Px(4)); rPad.PaddingBottom = UDim.new(0, Px(4))
    local nl = Instance.new("TextLabel", row)
    nl.Name = "CheckboxItemLabel"
    nl.Size = UDim2.new(1,-(CUBE_SZ+Px(10)),1,0); nl.BackgroundTransparency = 1
    nl.Text = itemName; nl.TextColor3 = isBlacklisted and COL_TEXT_MID or COL_TEXT_LIGHT
    nl.Font = RBXFONT; nl.TextSize = SM_SZ; nl.TextXAlignment = Enum.TextXAlignment.Left; nl.ZIndex = 5
    AddTextStroke(nl)
    local cube = Instance.new("Frame", row)
    cube.Name = "CheckboxCube"
    cube.Size = UDim2.new(0,CUBE_SZ,0,CUBE_SZ); cube.Position = UDim2.new(1,-CUBE_SZ,0.5,-CUBE_SZ/2)
    cube.BackgroundColor3 = COL_BG_MAIN; cube.BorderSizePixel = 0; cube.ZIndex = 5
    local cubeCorner = Instance.new("UICorner", cube)
    cubeCorner.Name = "CubeCorner"
    cubeCorner.CornerRadius = UDim.new(0, Px(5))
    local cubeStroke = Instance.new("UIStroke", cube)
    cubeStroke.Name = "CubeBorderStroke"
    cubeStroke.Color = COL_BORDER; cubeStroke.Thickness = 2; cubeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local checkLbl = Instance.new("TextLabel", cube)
    checkLbl.Name = "CheckboxCheckmark"
    checkLbl.Size = UDim2.new(1,0,1,0); checkLbl.BackgroundTransparency = 1; checkLbl.Text = "✓"
    checkLbl.TextColor3 = COL_RED; checkLbl.Font = Enum.Font.GothamBold; checkLbl.TextSize = Px(14)
    checkLbl.TextXAlignment = Enum.TextXAlignment.Center; checkLbl.TextYAlignment = Enum.TextYAlignment.Center
    checkLbl.ZIndex = 6; checkLbl.Visible = isBlacklisted
    AddTextStroke(checkLbl)
    local clickBtn = Instance.new("TextButton", row)
    clickBtn.Name = "CheckboxClickBtn"
    clickBtn.Size = UDim2.new(1,0,1,0); clickBtn.BackgroundTransparency = 1; clickBtn.Text = ""; clickBtn.ZIndex = 9
    local currentState = isBlacklisted
    local function RefreshVisual()
        checkLbl.Visible = currentState; nl.TextColor3 = currentState and COL_TEXT_MID or COL_TEXT_LIGHT
        rowStroke.Color = currentState and Color3.fromRGB(130,30,30) or COL_BORDER
    end
    RefreshVisual()
    clickBtn.MouseButton1Click:Connect(function()
        PlaySound(SOUND_CLICK); currentState = not currentState; RefreshVisual()
        if onToggle then onToggle(currentState) end
    end)
    return row, {GetState=function() return currentState end, SetState=function(v) currentState=v; RefreshVisual() end}
end

-- ===== CYCLE BUTTON =====
local function MakeCycleBtn(parent, options, _, lo)
    local idx = 1
    local btn = Instance.new("TextButton", parent)
    btn.Name = "CycleBtn_"..tostring(lo or 0)
    btn.Size = UDim2.new(1,0,0,Px(34)); btn.BackgroundColor3 = COL_BG_ITEM
    btn.Text = options[idx]; btn.TextColor3 = COL_TEXT_WHITE; btn.Font = RBXFONT; btn.TextSize = FONT_SZ
    btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.LayoutOrder = lo or 0; btn.ZIndex = 4
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.Name = "CycleBtnCorner"
    btnCorner.CornerRadius = UDim.new(0, Px(8))
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Name = "CycleBtnBorderStroke"
    btnStroke.Color = COL_BORDER; btnStroke.Thickness = 2.5; btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AddTextStroke(btn)
    local cbs = {}
    btn.MouseButton1Click:Connect(function()
        PlaySound(SOUND_CLICK); idx = (idx % #options) + 1; btn.Text = options[idx]
        btn.BackgroundColor3 = Color3.fromRGB(65,65,65)
        task.delay(0.1, function() if btn and btn.Parent then btn.BackgroundColor3 = COL_BG_ITEM end end)
        for _, f in ipairs(cbs) do f(idx, options[idx]) end
    end)
    return btn, {GetIdx=function() return idx end, OnChanged=function(f) cbs[#cbs+1]=f end, SetIdx=function(i) idx=i; btn.Text=options[i] end}
end

-- ===== ACTION BUTTON =====
local function MakeActionBtn(parent, text, _, lo)
    local safeName = text:gsub("%s+","_"):gsub("[^%w_]",""):sub(1,24)
    local btn = Instance.new("TextButton", parent)
    btn.Name = "ActionBtn_"..safeName
    btn.Size = UDim2.new(1,0,0,Px(34)); btn.BackgroundColor3 = COL_BG_ITEM
    btn.Text = text; btn.TextColor3 = COL_TEXT_WHITE; btn.Font = RBXFONT; btn.TextSize = FONT_SZ
    btn.BorderSizePixel = 0; btn.AutoButtonColor = false; btn.LayoutOrder = lo or 0; btn.ZIndex = 4
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.Name = "ActionBtnCorner"
    btnCorner.CornerRadius = UDim.new(0, Px(8))
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Name = "ActionBtnBorderStroke"
    btnStroke.Color = COL_BORDER; btnStroke.Thickness = 2.5; btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AddTextStroke(btn)
    btn.MouseButton1Click:Connect(function()
        PlaySound(SOUND_CLICK); btn.BackgroundColor3 = Color3.fromRGB(65,65,65)
        task.delay(0.12, function() if btn and btn.Parent then btn.BackgroundColor3 = COL_BG_ITEM end end)
    end)
    return btn
end

-- ===== TRIGGER ROW =====
local function MakeTriggerRow(parent, cfg, lo)
    local TRIGGER_LABELS = {decoding="Decoding",icon="Seen",always="Always",heal="Heal",stamina="Stamina",disabled="Disabled"}
    local safeName = cfg.name:gsub("%s+","_"):gsub("[^%w_]",""):sub(1,24)
    local row = Instance.new("Frame", parent)
    row.Name = "TriggerRow_"..safeName
    row.Size = UDim2.new(1,0,0,Px(30)); row.BackgroundColor3 = COL_BG_ITEM
    row.BorderSizePixel = 0; row.LayoutOrder = lo or 0; row.ZIndex = 4
    local rowCorner = Instance.new("UICorner", row)
    rowCorner.Name = "TriggerCorner"
    rowCorner.CornerRadius = UDim.new(0, Px(7))
    local rowStroke = Instance.new("UIStroke", row)
    rowStroke.Name = "TriggerBorderStroke"
    rowStroke.Color = COL_BORDER; rowStroke.Thickness = 2; rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local rPad = Instance.new("UIPadding", row)
    rPad.Name = "TriggerPadding"
    rPad.PaddingLeft = UDim.new(0, Px(8)); rPad.PaddingRight = UDim.new(0, Px(6))
    rPad.PaddingTop = UDim.new(0, Px(4)); rPad.PaddingBottom = UDim.new(0, Px(4))
    local nl = Instance.new("TextLabel", row)
    nl.Name = "TriggerItemLabel"
    nl.Size = UDim2.new(0.52,0,1,0); nl.BackgroundTransparency = 1
    nl.Text = cfg.name; nl.TextColor3 = COL_TEXT_LIGHT; nl.Font = RBXFONT; nl.TextSize = SM_SZ
    nl.TextXAlignment = Enum.TextXAlignment.Left; nl.ZIndex = 5
    AddTextStroke(nl)
    local tb = Instance.new("TextButton", row)
    tb.Name = "TriggerCycleBtn"
    tb.Size = UDim2.new(0.48,-Px(4),1,0); tb.Position = UDim2.new(0.52,Px(4),0,0)
    tb.BackgroundColor3 = COL_BG_MAIN; tb.Text = TRIGGER_LABELS[cfg.trigger] or cfg.trigger
    tb.TextColor3 = COL_TEXT_WHITE; tb.Font = RBXFONT; tb.TextSize = Px(11)
    tb.BorderSizePixel = 0; tb.AutoButtonColor = false; tb.ZIndex = 5
    local tbCorner = Instance.new("UICorner", tb)
    tbCorner.Name = "TriggerBtnCorner"
    tbCorner.CornerRadius = UDim.new(0, Px(5))
    local tbStroke = Instance.new("UIStroke", tb)
    tbStroke.Name = "TriggerBtnStroke"
    tbStroke.Color = COL_BORDER; tbStroke.Thickness = 1.5; tbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AddTextStroke(tb)
    tb.MouseButton1Click:Connect(function()
        PlaySound(SOUND_CLICK)
        local ci = table.find(TRIGGER_OPTIONS, cfg.trigger) or 1
        cfg.trigger = TRIGGER_OPTIONS[(ci % #TRIGGER_OPTIONS) + 1]
        tb.Text = TRIGGER_LABELS[cfg.trigger] or cfg.trigger
        tb.BackgroundColor3 = Color3.fromRGB(65,65,65)
        task.delay(0.1, function() if tb and tb.Parent then tb.BackgroundColor3 = COL_BG_MAIN end end)
    end)
    return row, tb
end

-- ===== STYLED TEXT BOX =====
local function MakeStyledTextBox(parent, placeholder, defaultTxt, lo, onChanged)
    local wrapper = Instance.new("Frame", parent)
    wrapper.Name = "TextBoxWrapper_"..tostring(lo or 0)
    wrapper.Size = UDim2.new(1,0,0,Px(34)); wrapper.BackgroundColor3 = COL_BG_ITEM
    wrapper.BorderSizePixel = 0; wrapper.LayoutOrder = lo or 0; wrapper.ZIndex = 4
    local wCorner = Instance.new("UICorner", wrapper)
    wCorner.Name = "TextBoxCorner"
    wCorner.CornerRadius = UDim.new(0, Px(8))
    local wStroke = Instance.new("UIStroke", wrapper)
    wStroke.Name = "TextBoxBorderStroke"
    wStroke.Color = COL_BORDER; wStroke.Thickness = 2; wStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local pad = Instance.new("UIPadding", wrapper)
    pad.Name = "TextBoxPadding"
    pad.PaddingLeft = UDim.new(0, Px(10)); pad.PaddingRight = UDim.new(0, Px(10))
    pad.PaddingTop = UDim.new(0, Px(5)); pad.PaddingBottom = UDim.new(0, Px(5))
    local tb2 = Instance.new("TextBox", wrapper)
    tb2.Name = "StyledTextBox"
    tb2.Size = UDim2.new(1,0,1,0); tb2.BackgroundTransparency = 1
    tb2.Text = defaultTxt or ""; tb2.PlaceholderText = placeholder or ""
    tb2.TextColor3 = COL_TEXT_WHITE; tb2.PlaceholderColor3 = COL_TEXT_DIM
    tb2.Font = RBXFONT; tb2.TextSize = FONT_SZ; tb2.ClearTextOnFocus = false
    tb2.ZIndex = 5; tb2.TextXAlignment = Enum.TextXAlignment.Left
    if onChanged then
        tb2.FocusLost:Connect(function()
            local tr = tb2.Text:match("^%s*(.-)%s*$"); onChanged(tr, tb2)
        end)
    end
    return wrapper, tb2
end

-- ===== MAIN TAB =====
local UI = {}
do
    local PM = Pages.Main
    SecHeader(PM, "Special Main", 1)

    local ToggleList = Instance.new("Frame", PM)
    ToggleList.Name = "ToggleList_SpecialMain"
    ToggleList.Size = UDim2.new(1,0,0,0)
    ToggleList.AutomaticSize = Enum.AutomaticSize.Y
    ToggleList.BackgroundTransparency = 1
    ToggleList.LayoutOrder = 2; ToggleList.ZIndex = 4
    local togListLayout = Instance.new("UIListLayout", ToggleList)
    togListLayout.Name = "ToggleListLayout"
    togListLayout.Padding = UDim.new(0, Px(3)); togListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    if IS_RESTRICTED then
        S.AUTO_VOTE=false; S.AUTO_BUY=false; S.INSTANT_SKILLCHECK=false
        S.AUTO_ENABLED=false; S.EGGSON_MODE=false; S.FIRE_STOP=false
        S.PICKUP_ENABLED=false; S.SAFE_TP=false; S.AUTO_USE_ITEMS=false
    end

    local _,t = MakeToggle(ToggleList, "Auto Vote", S.AUTO_VOTE, 1)
    t.OnChanged(function(v) S.AUTO_VOTE = v end); UI.autoVoteTog = t
    if IS_RESTRICTED then t.Label.Parent.Visible = false end

    local _,t2 = MakeToggle(ToggleList, "Auto Buy", S.AUTO_BUY, 2)
    t2.OnChanged(function(v) S.AUTO_BUY = v end); UI.autoBuyTog = t2
    if IS_RESTRICTED then t2.Label.Parent.Visible = false end

    local _,t3 = MakeToggle(ToggleList, "Instant Skillcheck", S.INSTANT_SKILLCHECK, 3)
    t3.OnChanged(function(v) S.INSTANT_SKILLCHECK = v; ApplyInstantSkillcheck(v) end); UI.skillcheckTog = t3

    local unableCredits = InfoLbl(ToggleList, "  Credits to Unable for the Instant SkillCheck", COL_TEXT_DIM, 4)
    unableCredits.TextSize = Px(11)
    if IS_RESTRICTED then t3.Label.Parent.Visible = false; unableCredits.Visible = false end

    Gap(PM, 4, 5)
    SecHeader(PM, "Other Toggles", 6)

    local OtherTogList = Instance.new("Frame", PM)
    OtherTogList.Name = "ToggleList_OtherToggles"
    OtherTogList.Size = UDim2.new(1,0,0,0); OtherTogList.AutomaticSize = Enum.AutomaticSize.Y
    OtherTogList.BackgroundTransparency = 1; OtherTogList.LayoutOrder = 7; OtherTogList.ZIndex = 4
    local otherLayout = Instance.new("UIListLayout", OtherTogList)
    otherLayout.Name = "OtherTogListLayout"
    otherLayout.Padding = UDim.new(0, Px(3)); otherLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local _,t4 = MakeToggle(OtherTogList, "Auto Farm", S.AUTO_ENABLED, 1)
    t4.OnChanged(function(v) S.AUTO_ENABLED = v; if not v and S.FarmBall then S.FarmBall.Transparency = 1 end end)
    UI.autoFarmTog = t4
    if IS_RESTRICTED then t4.Label.Parent.Visible = false end

    local eggsonRow, eggsonTog = MakeToggle(OtherTogList, "Eggson Mode", S.EGGSON_MODE, 2)
    UI.eggsonTog = eggsonTog; UI.eggsonRow = eggsonRow
    if IS_RESTRICTED then eggsonRow.Visible = false end

    local eggsonTrack = eggsonTog.Track
    local eggsonKnob  = eggsonTog.Knob

    local eggsonWarnLbl = InfoLbl(OtherTogList, "", COL_RED, 3)
    eggsonWarnLbl.TextSize = Px(11); eggsonWarnLbl.Visible = false; UI.eggsonWarnLbl = eggsonWarnLbl

    local eggsonRunPopup = InfoLbl(OtherTogList, "Please use eggson if you are in a run!", COL_YELLOW, 4)
    eggsonRunPopup.TextSize = Px(10); eggsonRunPopup.Visible = false; UI.eggsonRunPopup = eggsonRunPopup

    local function IsEggsonUnlocked()
        local info = workspace:FindFirstChild("Info"); if not info then return false end
        local pc = info:FindFirstChild("PickedCharacters"); if not pc then return false end
        local sv = pc:FindFirstChild(player.Name)
        return sv and sv:IsA("StringValue") and sv.Value == "Eggson"
    end

    local eggsonShaking = false
    local function ShakeEggsonKnob()
        if eggsonShaking then return end; eggsonShaking = true
        PlaySound(SOUND_ERROR)
        task.spawn(function()
            local ks2 = TOG_H - Px(6)
            TweenService:Create(eggsonTrack, TweenInfo.new(0.08), {BackgroundColor3 = COL_RED}):Play()
            for _ = 1, 5 do
                TweenService:Create(eggsonKnob, TweenInfo.new(0.05, Enum.EasingStyle.Linear),
                    {Position=UDim2.new(0,Px(6),0.5,-ks2/2)}):Play(); task.wait(0.055)
                TweenService:Create(eggsonKnob, TweenInfo.new(0.05, Enum.EasingStyle.Linear),
                    {Position=UDim2.new(0,Px(1),0.5,-ks2/2)}):Play(); task.wait(0.055)
            end
            TweenService:Create(eggsonKnob, TweenInfo.new(0.08), {Position=UDim2.new(0,Px(3),0.5,-ks2/2)}):Play()
            task.wait(0.15)
            TweenService:Create(eggsonTrack, TweenInfo.new(0.3), {BackgroundColor3 = COL_TOG_OFF}):Play()
            eggsonShaking = false
        end)
    end

    eggsonTog.ClickBtn.MouseButton1Click:Connect(function()
        if not IsEggsonUnlocked() then
            eggsonWarnLbl.Text = "You must be playing as Eggson!"
            eggsonWarnLbl.Visible = true; ShakeEggsonKnob()
            task.delay(2, function() pcall(function() eggsonWarnLbl.Visible = false end) end)
        else
            eggsonRunPopup.Visible = true
            task.delay(1, function() pcall(function() eggsonRunPopup.Visible = false end) end)
        end
    end)
    eggsonTog.OnChanged(function(v)
        if v and not IsEggsonUnlocked() then eggsonTog.SetState(false); return end
        S.EGGSON_MODE = v
        if not v then
            S.eggsonStopLoopActive=false; S.eggsonStopSpamActive=false
            S.eggsonStopSpamGen=nil; S.eggsonCompletionWaitStart={}
            eggsonWarnLbl.Visible = false
        end
    end)

    local _,t5 = MakeToggle(OtherTogList, "Anti-AFK", S.ANTI_AFK, 5)
    t5.OnChanged(function(v) S.ANTI_AFK = v; S.antiAfkTimer = 30 end); UI.antiAfkTog = t5

    local _,t6 = MakeToggle(OtherTogList, "Auto Stop Extracting", S.FIRE_STOP, 6)
    t6.OnChanged(function(v) S.FIRE_STOP = v end); UI.fireStopTog = t6
    if IS_RESTRICTED then t6.Label.Parent.Visible = false end

    local _,t7 = MakeToggle(OtherTogList, "Auto Pick Up Items", S.PICKUP_ENABLED, 7)
    t7.OnChanged(function(v) S.PICKUP_ENABLED = v end); UI.pickupTog = t7
    if IS_RESTRICTED then t7.Label.Parent.Visible = false end

    local _,t8 = MakeToggle(OtherTogList, "Teleport to Safe Area", S.SAFE_TP, 8)
    t8.OnChanged(function(v) S.SAFE_TP = v end); UI.safeTpTog = t8
    if IS_RESTRICTED then t8.Label.Parent.Visible = false end

    local _,t9 = MakeToggle(OtherTogList, "Auto Use Items", S.AUTO_USE_ITEMS, 9)
    t9.OnChanged(function(v) S.AUTO_USE_ITEMS = v end); UI.autoUseTog = t9
    if IS_RESTRICTED then t9.Label.Parent.Visible = false end

    local _,tAntiLag = MakeToggle(OtherTogList, "Anti Lag", S.ANTI_LAG, 10)
    tAntiLag.OnChanged(function(v) S.ANTI_LAG = v; if v then StartAntiLag() else StopAntiLag() end end)
    UI.antiLagTog = tAntiLag

    local _,tMaxHeal = MakeToggle(OtherTogList, "Max Heal (enche cura)", S.MAX_HEAL, 13)
    tMaxHeal.OnChanged(function(v) S.MAX_HEAL = v end)
    UI.maxHealTog = tMaxHeal

    local _,tResearch = MakeToggle(OtherTogList, "Research Hunt", S.RESEARCH_HUNT, 15)
    tResearch.OnChanged(function(v) S.RESEARCH_HUNT = v end)
    UI.researchHuntTog = tResearch

    local _,tIgnoreFullRes = MakeToggle(OtherTogList, "Ignore Full Research", S.IGNORE_FULL_RESEARCH, 16)
    tIgnoreFullRes.OnChanged(function(v) S.IGNORE_FULL_RESEARCH = v end)
    UI.ignoreFullResTog = tIgnoreFullRes

    -- Seletor de quantos slots de cura (1-4)
    local healSlotRow = Instance.new("Frame", OtherTogList)
    healSlotRow.Name = "HealSlotRow"
    healSlotRow.Size = UDim2.new(1,0,0,Px(32))
    healSlotRow.BackgroundColor3 = COL_BG_ITEM
    healSlotRow.BorderSizePixel = 0; healSlotRow.LayoutOrder = 14; healSlotRow.ZIndex = 4
    local hsCorner = Instance.new("UICorner", healSlotRow); hsCorner.CornerRadius = UDim.new(0, Px(8))
    local hsStroke = Instance.new("UIStroke", healSlotRow); hsStroke.Color = COL_BORDER
    hsStroke.Thickness = 2; hsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local hsPad = Instance.new("UIPadding", healSlotRow)
    hsPad.PaddingLeft = UDim.new(0, Px(8)); hsPad.PaddingRight = UDim.new(0, Px(8))
    hsPad.PaddingTop = UDim.new(0, Px(4)); hsPad.PaddingBottom = UDim.new(0, Px(4))
    local hsLabel = Instance.new("TextLabel", healSlotRow)
    hsLabel.Size = UDim2.new(0.6,0,1,0); hsLabel.BackgroundTransparency = 1
    hsLabel.Text = "Slots de cura: "..S.HEAL_SLOT_COUNT; hsLabel.TextColor3 = COL_TEXT_LIGHT
    hsLabel.Font = RBXFONT; hsLabel.TextSize = FONT_SZ
    hsLabel.TextXAlignment = Enum.TextXAlignment.Left; hsLabel.ZIndex = 5
    local hsBtn = Instance.new("TextButton", healSlotRow)
    hsBtn.Size = UDim2.new(0.38,0,1,0); hsBtn.Position = UDim2.new(0.62,0,0,0)
    hsBtn.BackgroundColor3 = COL_BG_MAIN; hsBtn.Text = "< "..S.HEAL_SLOT_COUNT.." >"
    hsBtn.TextColor3 = COL_TEXT_WHITE; hsBtn.Font = RBXFONT; hsBtn.TextSize = FONT_SZ
    hsBtn.BorderSizePixel = 0; hsBtn.AutoButtonColor = false; hsBtn.ZIndex = 5
    local hsBtnCorner = Instance.new("UICorner", hsBtn); hsBtnCorner.CornerRadius = UDim.new(0, Px(5))
    local hsBtnStroke = Instance.new("UIStroke", hsBtn); hsBtnStroke.Color = COL_BORDER
    hsBtnStroke.Thickness = 1.5; hsBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    hsBtn.MouseButton1Click:Connect(function()
        S.HEAL_SLOT_COUNT = (S.HEAL_SLOT_COUNT % 4) + 1
        hsLabel.Text = "Slots de cura: "..S.HEAL_SLOT_COUNT
        hsBtn.Text = "< "..S.HEAL_SLOT_COUNT.." >"
    end)
    UI.healSlotLabel = hsLabel; UI.healSlotBtn = hsBtn

    local _,tResearch = MakeToggle(OtherTogList, "Research Hunt", S.RESEARCH_HUNT, 15)
    tResearch.OnChanged(function(v) S.RESEARCH_HUNT = v end)
    UI.researchHuntTog = tResearch

    local _,tIgnoreFull = MakeToggle(OtherTogList, "Ignore Full Research Twisted", S.IGNORE_FULL_RESEARCH, 16)
    tIgnoreFull.OnChanged(function(v) S.IGNORE_FULL_RESEARCH = v end)
    UI.ignoreFullResearchTog = tIgnoreFull

    S.FULL_BRIGHT = S.FULL_BRIGHT or false
    S.FULL_BRIGHT_LOWER = S.FULL_BRIGHT_LOWER or false

    local _,tFullBright = MakeToggle(OtherTogList, "Full Brightness", S.FULL_BRIGHT, 11)
    local _tFBL_row, tFullBrightLower -- forward declare for cross-reference

    tFullBright.OnChanged(function(v)
        S.FULL_BRIGHT = v
        if v then
            if S.FULL_BRIGHT_LOWER then tFullBrightLower.SetState(false); S.FULL_BRIGHT_LOWER = false end
            pcall(function()
                local L = game:GetService("Lighting")
                L.Brightness=2; L.ClockTime=14; L.FogEnd=100000; L.GlobalShadows=false
                L.Ambient=Color3.fromRGB(128,128,128); L.OutdoorAmbient=Color3.fromRGB(128,128,128)
                for _, ch in ipairs(L:GetChildren()) do
                    if ch:IsA("Atmosphere") or ch:IsA("BlurEffect") or ch:IsA("ColorCorrectionEffect") then ch:Destroy() end
                end
            end)
        else
            pcall(function()
                local L = game:GetService("Lighting")
                L.Brightness=1; L.ClockTime=14; L.FogEnd=100000; L.GlobalShadows=true
                L.Ambient=Color3.fromRGB(70,70,70); L.OutdoorAmbient=Color3.fromRGB(70,70,70)
            end)
        end
    end); UI.fullBrightTog = tFullBright

    _tFBL_row, tFullBrightLower = MakeToggle(OtherTogList, "Full Bright (Lower)", S.FULL_BRIGHT_LOWER, 12)
    tFullBrightLower.OnChanged(function(v)
        S.FULL_BRIGHT_LOWER = v
        if v then
            if S.FULL_BRIGHT then tFullBright.SetState(false); S.FULL_BRIGHT = false end
            pcall(function()
                local L = game:GetService("Lighting")
                L.Brightness=1.5; L.ClockTime=14; L.FogEnd=100000; L.GlobalShadows=false
                L.Ambient=Color3.fromRGB(90,90,90); L.OutdoorAmbient=Color3.fromRGB(90,90,90)
            end)
        else
            pcall(function()
                local L = game:GetService("Lighting")
                L.Brightness=1; L.GlobalShadows=true
                L.Ambient=Color3.fromRGB(70,70,70); L.OutdoorAmbient=Color3.fromRGB(70,70,70)
            end)
        end
    end); UI.fullBrightLowerTog = tFullBrightLower

    Gap(PM, 4, 20); SecHeader(PM, "Extra", 21)
    local extraFrame = Instance.new("Frame", PM)
    extraFrame.Name = "ExtraFrame"
    extraFrame.Size = UDim2.new(1,0,0,0); extraFrame.AutomaticSize = Enum.AutomaticSize.Y
    extraFrame.BackgroundTransparency = 1; extraFrame.LayoutOrder = 22; extraFrame.ZIndex = 4
    local extraLayout = Instance.new("UIListLayout", extraFrame)
    extraLayout.Name = "ExtraLayout"
    extraLayout.Padding = UDim.new(0, Px(3)); extraLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local _,flyTog = MakeToggle(extraFrame, "Fly", FlyState.flying, 1)
    flyTog.OnChanged(function(v) if FlyState.flying ~= v then FlyToggle() end end); UI.flyTog = flyTog

    local speedWrapper = Instance.new("Frame", extraFrame)
    speedWrapper.Name = "FlySpeedWrapper"
    speedWrapper.Size = UDim2.new(1,0,0,Px(36)); speedWrapper.BackgroundColor3 = COL_BG_ITEM
    speedWrapper.BorderSizePixel = 0; speedWrapper.LayoutOrder = 2; speedWrapper.ZIndex = 4
    local swCorner = Instance.new("UICorner", speedWrapper)
    swCorner.Name = "FlySpeedCorner"
    swCorner.CornerRadius = UDim.new(0, Px(8))
    local swStroke = Instance.new("UIStroke", speedWrapper)
    swStroke.Name = "FlySpeedBorderStroke"
    swStroke.Color = COL_BORDER; swStroke.Thickness = 2; swStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local swPad = Instance.new("UIPadding", speedWrapper)
    swPad.Name = "FlySpeedPadding"
    swPad.PaddingLeft = UDim.new(0, Px(10)); swPad.PaddingRight = UDim.new(0, Px(8))
    swPad.PaddingTop = UDim.new(0, Px(5)); swPad.PaddingBottom = UDim.new(0, Px(5))
    local speedNameLbl = Instance.new("TextLabel", speedWrapper)
    speedNameLbl.Name = "FlySpeedLabel"
    speedNameLbl.Size = UDim2.new(0.5,0,1,0); speedNameLbl.BackgroundTransparency = 1
    speedNameLbl.Text = "Fly Speed"; speedNameLbl.TextColor3 = COL_TEXT_LIGHT
    speedNameLbl.Font = RBXFONT; speedNameLbl.TextSize = FONT_SZ
    speedNameLbl.TextXAlignment = Enum.TextXAlignment.Left; speedNameLbl.ZIndex = 5
    AddTextStroke(speedNameLbl)
    local speedBox = Instance.new("TextBox", speedWrapper)
    speedBox.Name = "FlySpeedBox"
    speedBox.Size = UDim2.new(0.48,0,1,0); speedBox.Position = UDim2.new(0.52,0,0,0)
    speedBox.BackgroundColor3 = COL_BG_MAIN; speedBox.BorderSizePixel = 0
    speedBox.Text = tostring(FlyState.speed); speedBox.TextColor3 = COL_TEXT_WHITE
    speedBox.PlaceholderText = "50"; speedBox.Font = RBXFONT; speedBox.TextSize = FONT_SZ
    speedBox.ClearTextOnFocus = false; speedBox.ZIndex = 5
    local sbCorner = Instance.new("UICorner", speedBox)
    sbCorner.Name = "SpeedBoxCorner"
    sbCorner.CornerRadius = UDim.new(0, Px(5))
    local sbStroke = Instance.new("UIStroke", speedBox)
    sbStroke.Name = "SpeedBoxStroke"
    sbStroke.Color = COL_BORDER; sbStroke.Thickness = 1.5; sbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    speedBox.FocusLost:Connect(function()
        local v = tonumber(speedBox.Text)
        if v then FlyState.speed = math.clamp(v, 1, 500) end
        speedBox.Text = tostring(FlyState.speed)
    end); UI.flySpeedBox = speedBox

    Gap(PM, 4, 23); SecHeader(PM, "Move Mode", 24)
    local MOVE_OPT = {"MOVE: Instant","MOVE: Fast","MOVE: Tween"}
    local MOVE_MODES = {"instant","fast","tween (slow)"}
    local mb, ma = MakeCycleBtn(PM, MOVE_OPT, nil, 25)
    ma.OnChanged(function(i) C.TELEPORT_MODE = MOVE_MODES[i] end)
    local mi = table.find(MOVE_MODES, C.TELEPORT_MODE) or 1
    ma.SetIdx(mi); mb.Text = MOVE_OPT[mi]
    UI.moveModeBtn = mb; UI.moveModeApi = ma; UI.MOVE_OPT = MOVE_OPT; UI.MOVE_MODES = MOVE_MODES

    Gap(PM, 4, 26); SecHeader(PM, "Status", 27)
    UI.elevLbl  = InfoLbl(PM, "- Fake Elevator: SEARCHING...", COL_TEXT_LIGHT, 28)
    UI.panicLbl = InfoLbl(PM, "- Panic: waiting",   COL_TEXT_MID, 29)
    UI.hideLbl  = InfoLbl(PM, "- Seen: No",         COL_TEXT_MID, 30)
    UI.autoUseLbl = InfoLbl(PM, "- Item Used: None", COL_TEXT_MID, 31)

    Gap(PM, 4, 32); SecHeader(PM, "Inventory", 33)
    local slotListFrame = Instance.new("Frame", PM)
    slotListFrame.Name = "InventorySlotList"
    slotListFrame.Size = UDim2.new(1,0,0,0); slotListFrame.AutomaticSize = Enum.AutomaticSize.Y
    slotListFrame.BackgroundTransparency = 1; slotListFrame.LayoutOrder = 34; slotListFrame.ZIndex = 4
    local slotLayout = Instance.new("UIListLayout", slotListFrame)
    slotLayout.Name = "InventorySlotLayout"
    slotLayout.Padding = UDim.new(0, 1)
    UI.SlotLabels = {}
    for i = 1, 4 do
        local l = ListLbl(slotListFrame, "Slot "..i..": None", COL_TEXT_MID)
        l.Name = "SlotLabel_"..i
        l.Visible = false
        UI.SlotLabels[i] = l
    end
    UI.healCountLbl = ListLbl(slotListFrame, "Healing Items: 0", COL_GREEN)
    UI.healCountLbl.Name = "HealCountLabel"
    UI.spLbl = ListLbl(slotListFrame, "Tapes: 0", COL_YELLOW)
    UI.spLbl.Name = "TapeCountLabel"
    UI.staminaLbl = ListLbl(slotListFrame, "Stamina: --", COL_PURPLE)
    UI.staminaLbl.Name = "StaminaLabel"

    Gap(PM, 4, 35); SecHeader(PM, "Decoding Status", 36)
    local decodingFrame = Instance.new("Frame", PM)
    decodingFrame.Name = "DecodingStatusFrame"
    decodingFrame.Size = UDim2.new(1,0,0,0); decodingFrame.AutomaticSize = Enum.AutomaticSize.Y
    decodingFrame.BackgroundTransparency = 1; decodingFrame.LayoutOrder = 37; decodingFrame.ZIndex = 4
    local decLayout = Instance.new("UIListLayout", decodingFrame)
    decLayout.Name = "DecodingStatusLayout"
    decLayout.Padding = UDim.new(0, 1)
    UI.decGenLbl  = ListLbl(decodingFrame, "Decoding: None",            COL_TEXT_MID)
    UI.decGenLbl.Name = "DecodingGenLabel"
    UI.decMonLbl  = ListLbl(decodingFrame, "Twisteds Nearby: No (0)",   COL_TEXT_MID)
    UI.decMonLbl.Name = "DecodingTwistedLabel"
    UI.decTenLbl  = ListLbl(decodingFrame, "Tendrils Nearby: No (0)",   COL_TEXT_MID)
    UI.decTenLbl.Name = "DecodingTendrilLabel"
    UI.decBlotLbl = ListLbl(decodingFrame, "Blot Hands Nearby: No (0)", COL_TEXT_MID)
    UI.decBlotLbl.Name = "DecodingBlotLabel"

    Gap(PM, 4, 38); SecHeader(PM, "Auto Waste Heals", 39)
    UI.drainLbl = InfoLbl(PM, "- Auto Waste Heals: Inactive", COL_TEXT_MID, 40)
    UI.drainLbl.Name = "DrainHealLabel"

    Gap(PM, 4, 41); SecHeader(PM, "Eggson Mode Status", 42)
    UI.eggsonStatusLbl = InfoLbl(PM, "- Eggson: Off", COL_TEXT_MID, 43)
    UI.eggsonStatusLbl.Name = "EggsonStatusLabel"

    Gap(PM, 4, 44); SecHeader(PM, "Sprint / Spin Status", 45)
    UI.sprintStatusLbl = InfoLbl(PM, "- Sprint: Idle", COL_TEXT_MID, 46)
    UI.sprintStatusLbl.Name = "SprintStatusLabel"
    UI.spinStatusLbl   = InfoLbl(PM, "- Spin: Idle",   COL_TEXT_MID, 47)
    UI.spinStatusLbl.Name = "SpinStatusLabel"

    Gap(PM, 4, 48); SecHeader(PM, "Spin Orbit Radius", 49)
    local _, spinSliderApi = MakeSlider(PM, "Orbit Radius", 3, 30, C.SPIN_ORBIT_RADIUS, 50, function(v) C.SPIN_ORBIT_RADIUS = v end)
    UI.spinSliderApi = spinSliderApi
end

-- ===== OTHER TAB =====
do
    local PO = Pages.Other
    if not IS_RESTRICTED then
        -- Twisteds list
        SecHeader(PO, "Twisteds", 1)
        local tw = Instance.new("Frame", PO)
        tw.Name = "TwistedLabelList"
        tw.Size = UDim2.new(1,0,0,0); tw.AutomaticSize = Enum.AutomaticSize.Y
        tw.BackgroundTransparency = 1; tw.LayoutOrder = 2; tw.ZIndex = 4
        local twLayout = Instance.new("UIListLayout", tw)
        twLayout.Name = "TwistedLabelLayout"
        twLayout.Padding = UDim.new(0, 1)
        UI.TwistedList = tw

        Gap(PO, 4, 3)
        SecHeader(PO, "Dangerous Twisteds (Auto)", 4)
        local sm = Instance.new("Frame", PO)
        sm.Name = "SMTLabelList"
        sm.Size = UDim2.new(1,0,0,0); sm.AutomaticSize = Enum.AutomaticSize.Y
        sm.BackgroundTransparency = 1; sm.LayoutOrder = 5; sm.ZIndex = 4
        local smLayout = Instance.new("UIListLayout", sm)
        smLayout.Name = "SMTLabelLayout"
        smLayout.Padding = UDim.new(0, 1)
        UI.SMTList = sm

        Gap(PO, 4, 6)
        SecHeader(PO, "Status", 7)
        UI.tendrilLbl  = InfoLbl(PO, "Tendrils: 0   Blot Hands: 0", COL_GREEN, 8)
        UI.tendrilLbl.Name = "TendrilCountLabel"
        UI.grabLbl     = InfoLbl(PO, "Active Grabs: 0",              COL_PURPLE, 9)
        UI.grabLbl.Name = "GrabCountLabel"
        UI.interactLbl = InfoLbl(PO, "Auto Stop Extracting: READY",  COL_YELLOW, 4)
        UI.interactLbl.Name = "ExtractStatusLabel"
        Gap(PO, 4, 5); SecHeader(PO, "Eye Visibility", 6)
        UI.eyeLbl = InfoLbl(PO, "Twisted Eye: 0%", COL_TEXT_LIGHT, 7)
        UI.eyeLbl.Name = "EyeVisibilityLabel"
        UI.eyeLbl.TextSize = Px(14)
        Gap(PO, 4, 8); SecHeader(PO, "Generator Progress", 9)
        UI.genHalfLbl     = InfoLbl(PO, "Gen Progress: N/A",          COL_TEXT_MID, 10)
        UI.genHalfLbl.Name = "GenProgressLabel"
        UI.genRestrictLbl = InfoLbl(PO, "Valve/JumperCable: waiting", COL_TEXT_MID, 11)
        UI.genRestrictLbl.Name = "GenRestrictLabel"
        Gap(PO, 4, 12); SecHeader(PO, "Auto Buy Blacklist", 13)
        local bwnote = InfoLbl(PO, "Check=blacklisted (won't buy).", COL_TEXT_DIM, 13)
        bwnote.Name = "BuyBlacklistNote"
        bwnote.TextSize = Px(10)
        local bwf = Instance.new("Frame", PO)
        bwf.Name = "BuyBlacklistFrame"
        bwf.Size = UDim2.new(1,0,0,0); bwf.AutomaticSize = Enum.AutomaticSize.Y
        bwf.BackgroundTransparency = 1; bwf.LayoutOrder = 14; bwf.ZIndex = 4
        local bwfLayout = Instance.new("UIListLayout", bwf)
        bwfLayout.Name = "BuyBlacklistLayout"
        bwfLayout.Padding = UDim.new(0, Px(3)); bwfLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UI.buyBlacklistRefs = {}
        for i, cfg in ipairs(BUY_BLACKLIST) do
            local capCfg = cfg
            local _, checkApi = MakeCheckboxRow(bwf, capCfg.name, capCfg.blacklisted, i, function(v) capCfg.blacklisted = v end)
            UI.buyBlacklistRefs[#UI.buyBlacklistRefs+1] = {cfg=capCfg, api=checkApi}
        end
        Gap(PO, 4, 15); SecHeader(PO, "Pickup Items", 16)
        local pinote = InfoLbl(PO, "Check=blacklisted (won't pick up).", COL_TEXT_DIM, 16)
        pinote.Name = "PickupBlacklistNote"
        pinote.TextSize = Px(10)
        local pif = Instance.new("Frame", PO)
        pif.Name = "PickupBlacklistFrame"
        pif.Size = UDim2.new(1,0,0,0); pif.AutomaticSize = Enum.AutomaticSize.Y
        pif.BackgroundTransparency = 1; pif.LayoutOrder = 17; pif.ZIndex = 4
        local pifLayout = Instance.new("UIListLayout", pif)
        pifLayout.Name = "PickupBlacklistLayout"
        pifLayout.Padding = UDim.new(0, Px(3)); pifLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UI.pickupCheckRefs = {}
        for i, cfg in ipairs(PICKUP_CFG) do
            local capCfg = cfg
            local _, checkApi = MakeCheckboxRow(pif, capCfg.name, capCfg.blacklisted, i, function(v) capCfg.blacklisted = v end)
            UI.pickupCheckRefs[#UI.pickupCheckRefs+1] = {cfg=capCfg, api=checkApi}
        end
        Gap(PO, 4, 18); SecHeader(PO, "Item Use Triggers", 19)
        local tn = InfoLbl(PO, "Tap to cycle trigger.", COL_TEXT_DIM, 19)
        tn.Name = "ItemTriggerNote"
        tn.TextSize = Px(10)
        local itf = Instance.new("Frame", PO)
        itf.Name = "ItemTriggerFrame"
        itf.Size = UDim2.new(1,0,0,0); itf.AutomaticSize = Enum.AutomaticSize.Y
        itf.BackgroundTransparency = 1; itf.LayoutOrder = 20; itf.ZIndex = 4
        local itfLayout = Instance.new("UIListLayout", itf)
        itfLayout.Name = "ItemTriggerLayout"
        itfLayout.Padding = UDim.new(0, Px(3)); itfLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UI.itemTriggerRowRefs = {}
        for i, cfg in ipairs(ITEM_CONFIG) do
            local capCfg = cfg
            local row, tb = MakeTriggerRow(itf, capCfg, i)
            UI.itemTriggerRowRefs[#UI.itemTriggerRowRefs+1] = {cfg=capCfg, btn=tb, row=row}
        end
        Gap(PO, 4, 21); SecHeader(PO, "Monster Farm Detector Radius", 22)
        local drNote = InfoLbl(PO, "Adjust monster block radius (20-145).", COL_TEXT_DIM, 22)
        drNote.Name = "MonsterRadiusNote"
        drNote.TextSize = Px(10)
        local drFrame = Instance.new("Frame", PO)
        drFrame.Name = "MonsterRadiusFrame"
        drFrame.Size = UDim2.new(1,0,0,0); drFrame.AutomaticSize = Enum.AutomaticSize.Y
        drFrame.BackgroundTransparency = 1; drFrame.LayoutOrder = 23; drFrame.ZIndex = 4
        local drLayout = Instance.new("UIListLayout", drFrame)
        drLayout.Name = "MonsterRadiusLayout"
        drLayout.Padding = UDim.new(0, Px(3)); drLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UI.monsterRadiusSliders = {}
        local monsterNames = {"DandyMonster","DyleMonster","SproutMonster","ScrapsMonster","GoobMonster"}
        for idx2, mn in ipairs(monsterNames) do
            local capMn = mn; local shortName = mn:gsub("Monster",""); local curVal = MONSTER_RADIUS[mn] or 85
            local _, slApi = MakeGridSlider(drFrame, shortName, 20, 145, curVal, 5, idx2, function(v) MONSTER_RADIUS[capMn] = v end)
            UI.monsterRadiusSliders[mn] = slApi
        end
        Gap(PO, 4, 24); SecHeader(PO, "Advanced Item Use Status", 25)
        local advStatusFrame = Instance.new("Frame", PO)
        advStatusFrame.Name = "AdvancedItemStatusFrame"
        advStatusFrame.Size = UDim2.new(1,0,0,0); advStatusFrame.AutomaticSize = Enum.AutomaticSize.Y
        advStatusFrame.BackgroundTransparency = 1; advStatusFrame.LayoutOrder = 26; advStatusFrame.ZIndex = 4
        local advLayout = Instance.new("UIListLayout", advStatusFrame)
        advLayout.Name = "AdvancedItemStatusLayout"
        advLayout.Padding = UDim.new(0, 1)
        UI.valveLbl  = ListLbl(advStatusFrame, "Valve: waiting (fires when gen < 50%)", COL_TEXT_MID)
        UI.valveLbl.Name = "ValveStatusLabel"
        UI.jumperLbl = ListLbl(advStatusFrame, "JumperCable: waiting",                  COL_TEXT_MID)
        UI.jumperLbl.Name = "JumperCableStatusLabel"
    else
        local rLbl = InfoLbl(PO, "Others tab not available in this place.", COL_TEXT_MID, 1)
        rLbl.Name = "RestrictedNoticeLabel"
        rLbl.TextSize = Px(11)
    end
end

-- ===== SETTINGS TAB =====
local settingsAPI = {}
do
    local PS = Pages.Settings
    SecHeader(PS, "Font", 1)
    local fdn = {}
    for _, n in ipairs(FONT_NAMES) do fdn[#fdn+1] = "Font: "..n end
    local fb, fa = MakeCycleBtn(PS, fdn, nil, 2)
    fb.Name = "FontCycleBtn"
    fa.SetIdx(IDX.font); fb.Text = fdn[IDX.font]
    fa.OnChanged(function(i)
        IDX.font = i; Theme.Font = FONT_OPTIONS[i]
        for _, pg in pairs(Pages) do
            for _, v in ipairs(pg:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextButton") then pcall(function() v.Font = FONT_OPTIONS[i] end) end
            end
        end
        TitleLabel.Font = FONT_OPTIONS[i]; SubLabel.Font = FONT_OPTIONS[i]
        MinBtn.Font = FONT_OPTIONS[i]; CreditLabel.Font = FONT_OPTIONS[i]; DragLockBtn.Font = FONT_OPTIONS[i]
    end)
    settingsAPI.fontBtn = fb; settingsAPI.fontApi = fa; settingsAPI.fontNames = fdn

    Gap(PS, 5, 3); SecHeader(PS, "Config", 4)
    local cnl = Instance.new("TextLabel", PS)
    cnl.Name = "ConfigNameLabel"
    cnl.Size = UDim2.new(1,0,0,Px(16)); cnl.BackgroundTransparency = 1; cnl.Text = "Config Name:"
    cnl.TextColor3 = COL_TEXT_LIGHT; cnl.Font = RBXFONT; cnl.TextSize = SM_SZ
    cnl.TextXAlignment = Enum.TextXAlignment.Left; cnl.LayoutOrder = 5; cnl.ZIndex = 4
    AddTextStroke(cnl)

    local cnbWrapper, cnb = MakeStyledTextBox(PS, "Enter config name...", C.CONFIG_FILE_NAME, 6,
        function(tr, tb2) if tr ~= "" then C.CONFIG_FILE_NAME = tr; tb2.Text = tr else tb2.Text = C.CONFIG_FILE_NAME end end)

    local csl = Instance.new("TextLabel", PS)
    csl.Name = "ConfigStatusLabel"
    csl.Size = UDim2.new(1,0,0,Px(18)); csl.BackgroundTransparency = 1; csl.Text = ""
    csl.TextColor3 = COL_TEXT_MID; csl.Font = RBXFONT; csl.TextSize = SM_SZ
    csl.TextXAlignment = Enum.TextXAlignment.Left; csl.LayoutOrder = 7; csl.ZIndex = 4
    AddTextStroke(csl)
    settingsAPI.cfgStatusLbl = csl

    local ccl = Instance.new("TextLabel", PS)
    ccl.Name = "ConfigContentsLabel"
    ccl.Size = UDim2.new(1,0,0,0); ccl.AutomaticSize = Enum.AutomaticSize.Y; ccl.BackgroundTransparency = 1
    ccl.TextColor3 = COL_TEXT_DIM; ccl.Font = RBXFONT; ccl.TextSize = Px(10)
    ccl.TextXAlignment = Enum.TextXAlignment.Left; ccl.TextWrapped = true; ccl.LayoutOrder = 8; ccl.ZIndex = 4; ccl.RichText = true
    AddTextStroke(ccl)
    settingsAPI.cfgContentsLbl = ccl

    local BuildConfigTable = P.BuildConfigTable; local GetConfigFile = P.GetConfigFile
    local SaveConfig = P.SaveConfig; local LoadConfig = P.LoadConfig
    local function UpdateCfgContents()
        local cfg = BuildConfigTable()
        ccl.Text = "Saved: "..GetConfigFile().."\n"
            .."Farm: "..(cfg.autoFarm and "ON" or "OFF").."  AFK: "..(cfg.antiAfk and "ON" or "OFF").."  Vote: "..(cfg.autoVote and "ON" or "OFF").."\n"
            .."Buy: "..(cfg.autoBuy and "ON" or "OFF").."  Eggson: "..(cfg.eggsonMode and "ON" or "OFF")
    end
    settingsAPI.UpdateCfgContents = UpdateCfgContents; UpdateCfgContents()

    local function ApplyLoadedConfig()
        if UI.autoVoteTog   then UI.autoVoteTog.SetState(S.AUTO_VOTE) end
        if UI.autoBuyTog    then UI.autoBuyTog.SetState(S.AUTO_BUY) end
        if UI.autoFarmTog   then UI.autoFarmTog.SetState(S.AUTO_ENABLED) end
        if UI.antiAfkTog    then UI.antiAfkTog.SetState(S.ANTI_AFK) end
        if UI.fireStopTog   then UI.fireStopTog.SetState(S.FIRE_STOP) end
        if UI.pickupTog     then UI.pickupTog.SetState(S.PICKUP_ENABLED) end
        if UI.safeTpTog     then UI.safeTpTog.SetState(S.SAFE_TP) end
        if UI.autoUseTog    then UI.autoUseTog.SetState(S.AUTO_USE_ITEMS) end
        if UI.skillcheckTog then UI.skillcheckTog.SetState(S.INSTANT_SKILLCHECK); ApplyInstantSkillcheck(S.INSTANT_SKILLCHECK) end
        if UI.eggsonTog     then UI.eggsonTog.SetState(S.EGGSON_MODE) end
        if UI.moveModeApi   then
            local mi2 = table.find(UI.MOVE_MODES or {}, C.TELEPORT_MODE) or 1
            UI.moveModeApi.SetIdx(mi2); if UI.moveModeBtn then UI.moveModeBtn.Text = (UI.MOVE_OPT or {})[mi2] end
        end
        if settingsAPI.fontApi then settingsAPI.fontApi.SetIdx(IDX.font); settingsAPI.fontBtn.Text = settingsAPI.fontNames[IDX.font] end
        if UI.spinSliderApi   then UI.spinSliderApi.SetValue(C.SPIN_ORBIT_RADIUS) end
        if UI.flySpeedBox     then UI.flySpeedBox.Text = tostring(FlyState.speed) end
        if UI.itemTriggerRowRefs then
            local TL = {decoding="Decoding",icon="Seen",always="Always",heal="Heal",stamina="Stamina",disabled="Disabled"}
            for _, ref in ipairs(UI.itemTriggerRowRefs) do ref.btn.Text = TL[ref.cfg.trigger] or ref.cfg.trigger end
        end
        if UI.pickupCheckRefs then for _, ref in ipairs(UI.pickupCheckRefs) do ref.api.SetState(ref.cfg.blacklisted) end end
        if UI.buyBlacklistRefs then for _, ref in ipairs(UI.buyBlacklistRefs) do ref.api.SetState(ref.cfg.blacklisted) end end
        if UI.monsterRadiusSliders then for mn, sliderApi in pairs(UI.monsterRadiusSliders) do local v = MONSTER_RADIUS[mn]; if v then sliderApi.SetValue(v) end end end
        if UI.maxHealTog          then UI.maxHealTog.SetState(S.MAX_HEAL) end
        if UI.researchHuntTog     then UI.researchHuntTog.SetState(S.RESEARCH_HUNT) end
        if UI.ignoreFullResearchTog then UI.ignoreFullResearchTog.SetState(S.IGNORE_FULL_RESEARCH) end
        if UI.researchHuntTog   then UI.researchHuntTog.SetState(S.RESEARCH_HUNT) end
        if UI.ignoreFullResTog  then UI.ignoreFullResTog.SetState(S.IGNORE_FULL_RESEARCH) end
        if UI.healSlotLabel then UI.healSlotLabel.Text = "Slots de cura: "..S.HEAL_SLOT_COUNT end
        if UI.healSlotBtn   then UI.healSlotBtn.Text = "< "..S.HEAL_SLOT_COUNT.." >" end
        if cnb then cnb.Text = C.CONFIG_FILE_NAME end; UpdateCfgContents()
    end
    settingsAPI.ApplyLoadedConfig = ApplyLoadedConfig

    local savBtn = MakeActionBtn(PS, "Save Config", nil, 9)
    savBtn.MouseButton1Click:Connect(function()
        SaveConfig(); UpdateCfgContents(); csl.Text = "Config saved!"; csl.TextColor3 = COL_GREEN
        task.delay(3, function() pcall(function() csl.Text = "" end) end)
    end)
    local ldBtn = MakeActionBtn(PS, "Load Config", nil, 10)
    ldBtn.MouseButton1Click:Connect(function()
        local d = LoadConfig()
        if d then ApplyLoadedConfig(); csl.Text = "Config loaded!"; csl.TextColor3 = COL_GREEN
        else PlaySound(SOUND_ERROR); csl.Text = "No config found."; csl.TextColor3 = COL_RED end
        task.delay(3, function() pcall(function() csl.Text = "" end) end)
    end)

    Gap(PS, 6, 14); SecHeader(PS, "Saved Configs", 15)
    local clf = Instance.new("Frame", PS)
    clf.Name = "SavedConfigsFrame"
    clf.Size = UDim2.new(1,0,0,0); clf.AutomaticSize = Enum.AutomaticSize.Y
    clf.BackgroundTransparency = 1; clf.LayoutOrder = 16; clf.ZIndex = 4
    local cll = Instance.new("UIListLayout", clf)
    cll.Name = "SavedConfigsLayout"
    cll.Padding = UDim.new(0, Px(3)); cll.SortOrder = Enum.SortOrder.LayoutOrder

    local cls = Instance.new("TextLabel", clf)
    cls.Name = "NoConfigsLabel"
    cls.Size = UDim2.new(1,0,0,Px(15)); cls.BackgroundTransparency = 1; cls.Text = "No saved configs found."
    cls.TextColor3 = COL_TEXT_MID; cls.Font = RBXFONT; cls.TextSize = SM_SZ
    cls.TextXAlignment = Enum.TextXAlignment.Left; cls.ZIndex = 4
    AddTextStroke(cls)

    local refBtn = MakeActionBtn(PS, "Refresh List", nil, 17)
    refBtn.Name = "RefreshConfigListBtn"
    local rowBtns = {}

    local function RefreshList()
        for _, b in ipairs(rowBtns) do pcall(function() b:Destroy() end) end; rowBtns = {}
        local files = {}
        if listfiles then
            pcall(function()
                for _, f in ipairs(listfiles("")) do
                    local nm = f:match("([^/\\]+)$") or f
                    if nm:match("%.json$") then files[#files+1] = nm end
                end
            end)
        end
        if #files == 0 then PlaySound(SOUND_ERROR); cls.Text = "No saved configs found."; cls.Visible = true; return end
        cls.Visible = false
        for i, fname in ipairs(files) do
            local row = Instance.new("Frame", clf)
            row.Name = "SavedConfigRow_"..fname:gsub("%.json$",""):gsub("[^%w_]",""):sub(1,20)
            row.Size = UDim2.new(1,0,0,Px(30)); row.BackgroundTransparency = 1; row.LayoutOrder = i; row.ZIndex = 4
            rowBtns[#rowBtns+1] = row
            local rl = Instance.new("TextLabel", row)
            rl.Name = "ConfigRowNameLabel"
            rl.Size = UDim2.new(1,-Px(110),1,0); rl.BackgroundTransparency = 1
            rl.Text = fname:gsub("%.json$",""); rl.TextColor3 = COL_TEXT_LIGHT; rl.Font = RBXFONT
            rl.TextSize = SM_SZ; rl.TextXAlignment = Enum.TextXAlignment.Left
            rl.TextTruncate = Enum.TextTruncate.AtEnd; rl.ZIndex = 4
            AddTextStroke(rl)
            local rb = Instance.new("TextButton", row)
            rb.Name = "LoadConfigBtn"
            rb.Size = UDim2.new(0,Px(52),0,Px(24)); rb.Position = UDim2.new(1,-Px(98),0.5,-Px(12))
            rb.BackgroundColor3 = COL_BG_ITEM; rb.Text = "Load"; rb.TextColor3 = COL_TEXT_WHITE
            rb.Font = RBXFONT; rb.TextSize = SM_SZ; rb.BorderSizePixel = 0; rb.AutoButtonColor = false; rb.ZIndex = 5
            local rbCorner = Instance.new("UICorner", rb)
            rbCorner.Name = "LoadBtnCorner"
            rbCorner.CornerRadius = UDim.new(0, Px(5))
            local rbStroke = Instance.new("UIStroke", rb)
            rbStroke.Name = "LoadBtnStroke"
            rbStroke.Color = COL_BORDER; rbStroke.Thickness = 2; rbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            AddTextStroke(rb)
            local db = Instance.new("TextButton", row)
            db.Name = "DeleteConfigBtn"
            db.Size = UDim2.new(0,Px(38),0,Px(24)); db.Position = UDim2.new(1,-Px(40),0.5,-Px(12))
            db.BackgroundColor3 = Color3.fromRGB(160,40,40); db.Text = "Del"; db.TextColor3 = COL_TEXT_WHITE
            db.Font = RBXFONT; db.TextSize = SM_SZ; db.BorderSizePixel = 0; db.AutoButtonColor = false; db.ZIndex = 5
            local dbCorner = Instance.new("UICorner", db)
            dbCorner.Name = "DeleteBtnCorner"
            dbCorner.CornerRadius = UDim.new(0, Px(5))
            local dbStroke = Instance.new("UIStroke", db)
            dbStroke.Name = "DeleteBtnStroke"
            dbStroke.Color = COL_BORDER; dbStroke.Thickness = 2; dbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            AddTextStroke(db)
            local capF = fname
            rb.MouseButton1Click:Connect(function()
                PlaySound(SOUND_CLICK); rb.BackgroundColor3 = Color3.fromRGB(70,70,70)
                task.delay(0.12, function() if rb and rb.Parent then rb.BackgroundColor3 = COL_BG_ITEM end end)
                local no = capF:gsub("%.json$",""); C.CONFIG_FILE_NAME = no; if cnb then cnb.Text = no end
                local d = LoadConfig()
                if d then ApplyLoadedConfig(); csl.Text = "Loaded: "..no; csl.TextColor3 = COL_GREEN
                else PlaySound(SOUND_ERROR); csl.Text = "Failed: "..no; csl.TextColor3 = COL_RED end
                task.delay(3, function() pcall(function() csl.Text = "" end) end)
            end)
            db.MouseButton1Click:Connect(function()
                PlaySound(SOUND_CLICK); db.BackgroundColor3 = Color3.fromRGB(200,60,60)
                task.delay(0.12, function() if db and db.Parent then db.BackgroundColor3 = Color3.fromRGB(160,40,40) end end)
                if delfile then
                    local ok2 = pcall(function() delfile(capF) end); local nm2 = capF:gsub("%.json$","")
                    csl.Text = ok2 and ("Deleted: "..nm2) or ("Error: "..nm2); csl.TextColor3 = ok2 and COL_ORANGE or COL_RED
                else PlaySound(SOUND_ERROR); csl.Text = "delfile not available."; csl.TextColor3 = COL_RED end
                task.delay(3, function() pcall(function() csl.Text = "" end) end)
                task.delay(0.15, RefreshList)
            end)
        end
    end
    refBtn.MouseButton1Click:Connect(RefreshList); RefreshList()
end

-- ===== SCRIPTS TAB =====
do
    local PSC = Pages.Scripts
    SecHeader(PSC, "Copyable Scripts", 1)
    local noteL = InfoLbl(PSC, "Click a button to copy the script.", COL_TEXT_MID, 2)
    noteL.Name = "ScriptsNoteLabel"
    noteL.TextSize = Px(10)
    local copiedNotif = Instance.new("TextLabel", PSC)
    copiedNotif.Name = "CopiedNotifLabel"
    copiedNotif.Size = UDim2.new(1,0,0,Px(20)); copiedNotif.BackgroundTransparency = 1; copiedNotif.Text = ""
    copiedNotif.TextColor3 = COL_GREEN; copiedNotif.Font = RBXFONT; copiedNotif.TextSize = FONT_SZ
    copiedNotif.TextXAlignment = Enum.TextXAlignment.Left; copiedNotif.LayoutOrder = 3; copiedNotif.ZIndex = 4
    copiedNotif.Visible = false
    AddTextStroke(copiedNotif)

    local confirmOverlay = Instance.new("Frame", ScreenGui)
    confirmOverlay.Name = "ConfirmOverlay"
    confirmOverlay.Size = UDim2.new(1,0,1,0); confirmOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    confirmOverlay.BackgroundTransparency = 0.5; confirmOverlay.BorderSizePixel = 0
    confirmOverlay.ZIndex = 50; confirmOverlay.Visible = false

    local confirmBox = Instance.new("Frame", confirmOverlay)
    confirmBox.Name = "ConfirmBox"
    confirmBox.Size = UDim2.new(0,Px(250),0,Px(120)); confirmBox.AnchorPoint = Vector2.new(0.5,0.5)
    confirmBox.Position = UDim2.new(0.5,0,0.5,0); confirmBox.BackgroundColor3 = COL_BG_MAIN
    confirmBox.BorderSizePixel = 0; confirmBox.ZIndex = 51
    local cbCorner = Instance.new("UICorner", confirmBox)
    cbCorner.Name = "ConfirmBoxCorner"
    cbCorner.CornerRadius = UDim.new(0, Px(14))
    local cbStroke = Instance.new("UIStroke", confirmBox)
    cbStroke.Name = "ConfirmBoxStroke"
    cbStroke.Color = COL_BORDER; cbStroke.Thickness = 3; cbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local confirmTitle = Instance.new("TextLabel", confirmBox)
    confirmTitle.Name = "ConfirmTitleLabel"
    confirmTitle.Size = UDim2.new(1,0,0,Px(30)); confirmTitle.Position = UDim2.new(0,0,0,Px(10))
    confirmTitle.BackgroundTransparency = 1; confirmTitle.Text = "Are you sure?"
    confirmTitle.TextColor3 = COL_TEXT_WHITE; confirmTitle.Font = RBXFONT; confirmTitle.TextSize = Px(18)
    confirmTitle.TextXAlignment = Enum.TextXAlignment.Center; confirmTitle.ZIndex = 52
    AddTextStroke(confirmTitle)

    local confirmSub = Instance.new("TextLabel", confirmBox)
    confirmSub.Name = "ConfirmSubLabel"
    confirmSub.Size = UDim2.new(1,-Px(20),0,Px(26)); confirmSub.Position = UDim2.new(0,Px(10),0,Px(38))
    confirmSub.BackgroundTransparency = 1; confirmSub.Text = "Just making sure you didn't click that accidentally"
    confirmSub.TextColor3 = COL_TEXT_MID; confirmSub.Font = RBXFONT; confirmSub.TextSize = Px(10)
    confirmSub.TextWrapped = true; confirmSub.TextXAlignment = Enum.TextXAlignment.Center; confirmSub.ZIndex = 52
    AddTextStroke(confirmSub)

    local confirmYes = Instance.new("TextButton", confirmBox)
    confirmYes.Name = "ConfirmYesBtn"
    confirmYes.Size = UDim2.new(0,Px(94),0,Px(30)); confirmYes.Position = UDim2.new(0.5,-Px(100),1,-Px(40))
    confirmYes.BackgroundColor3 = COL_GREEN; confirmYes.Text = "Yes, Copy"
    confirmYes.TextColor3 = COL_TEXT_WHITE; confirmYes.Font = RBXFONT; confirmYes.TextSize = Px(13)
    confirmYes.BorderSizePixel = 0; confirmYes.AutoButtonColor = false; confirmYes.ZIndex = 52
    local cyCorner = Instance.new("UICorner", confirmYes)
    cyCorner.Name = "ConfirmYesCorner"
    cyCorner.CornerRadius = UDim.new(0, Px(7))
    local cyStroke = Instance.new("UIStroke", confirmYes)
    cyStroke.Name = "ConfirmYesStroke"
    cyStroke.Color = COL_BORDER; cyStroke.Thickness = 2; cyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AddTextStroke(confirmYes)

    local confirmNo = Instance.new("TextButton", confirmBox)
    confirmNo.Name = "ConfirmNoBtn"
    confirmNo.Size = UDim2.new(0,Px(94),0,Px(30)); confirmNo.Position = UDim2.new(0.5,Px(6),1,-Px(40))
    confirmNo.BackgroundColor3 = COL_RED; confirmNo.Text = "No"
    confirmNo.TextColor3 = COL_TEXT_WHITE; confirmNo.Font = RBXFONT; confirmNo.TextSize = Px(13)
    confirmNo.BorderSizePixel = 0; confirmNo.AutoButtonColor = false; confirmNo.ZIndex = 52
    local cnCorner = Instance.new("UICorner", confirmNo)
    cnCorner.Name = "ConfirmNoCorner"
    cnCorner.CornerRadius = UDim.new(0, Px(7))
    local cnStroke = Instance.new("UIStroke", confirmNo)
    cnStroke.Name = "ConfirmNoStroke"
    cnStroke.Color = COL_BORDER; cnStroke.Thickness = 2; cnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AddTextStroke(confirmNo)

    local _confirmCallback = nil
    local function ShowConfirmPopup(onYes) _confirmCallback = onYes; confirmOverlay.Visible = true end
    confirmNo.MouseButton1Click:Connect(function()
        PlaySound(SOUND_CLICK); confirmOverlay.Visible = false; _confirmCallback = nil
    end)
    confirmYes.MouseButton1Click:Connect(function()
        PlaySound(SOUND_CLICK); confirmOverlay.Visible = false
        if _confirmCallback then pcall(_confirmCallback); _confirmCallback = nil end
    end)

    Gap(PSC, 4, 4)
    local scriptsListFrame = Instance.new("Frame", PSC)
    scriptsListFrame.Name = "ScriptsListFrame"
    scriptsListFrame.Size = UDim2.new(1,0,0,0); scriptsListFrame.AutomaticSize = Enum.AutomaticSize.Y
    scriptsListFrame.BackgroundTransparency = 1; scriptsListFrame.LayoutOrder = 5; scriptsListFrame.ZIndex = 4
    local sListLayout = Instance.new("UIListLayout", scriptsListFrame)
    sListLayout.Name = "ScriptsListLayout"
    sListLayout.Padding = UDim.new(0, Px(4)); sListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function ShowCopiedNotif(scriptName)
        copiedNotif.Text = scriptName.." copied to clipboard!"
        copiedNotif.Visible = true
        task.delay(3, function() pcall(function() copiedNotif.Visible = false; copiedNotif.Text = "" end) end)
    end

    for i, scriptDef in ipairs(SCRIPTS_DATA) do
        local capDef = scriptDef
        local safeSN = capDef.textName:gsub("%s+","_"):gsub("[^%w_]",""):sub(1,20)
        local btn = Instance.new("TextButton", scriptsListFrame)
        btn.Name = "ScriptEntryBtn_"..safeSN
        btn.Size = UDim2.new(1,0,0,Px(36)); btn.BackgroundColor3 = COL_BG_ITEM
        btn.Text = ""; btn.AutoButtonColor = false; btn.BorderSizePixel = 0; btn.LayoutOrder = i; btn.ZIndex = 4
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.Name = "ScriptBtnCorner"
        btnCorner.CornerRadius = UDim.new(0, Px(8))
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Name = "ScriptBtnStroke"
        btnStroke.Color = COL_BORDER; btnStroke.Thickness = 2.5; btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local btnPad = Instance.new("UIPadding", btn)
        btnPad.Name = "ScriptBtnPadding"
        btnPad.PaddingLeft = UDim.new(0, Px(10)); btnPad.PaddingRight = UDim.new(0, Px(10))
        local nameLbl = Instance.new("TextLabel", btn)
        nameLbl.Name = "ScriptNameLabel"
        nameLbl.Size = UDim2.new(0.72,0,1,0); nameLbl.BackgroundTransparency = 1
        nameLbl.Text = capDef.textName; nameLbl.TextColor3 = COL_TEXT_LIGHT
        nameLbl.Font = RBXFONT; nameLbl.TextSize = FONT_SZ
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left; nameLbl.ZIndex = 5
        AddTextStroke(nameLbl)
        local copyLbl = Instance.new("TextLabel", btn)
        copyLbl.Name = "ScriptCopyLabel"
        copyLbl.Size = UDim2.new(0.28,0,1,0); copyLbl.Position = UDim2.new(0.72,0,0,0)
        copyLbl.BackgroundTransparency = 1; copyLbl.Text = "[ COPY ]"
        copyLbl.TextColor3 = COL_GREEN; copyLbl.Font = RBXFONT
        copyLbl.TextSize = SM_SZ; copyLbl.TextXAlignment = Enum.TextXAlignment.Right; copyLbl.ZIndex = 5
        AddTextStroke(copyLbl)
        btn.MouseButton1Click:Connect(function()
            PlaySound(SOUND_CLICK); btn.BackgroundColor3 = Color3.fromRGB(65,65,65)
            task.delay(0.12, function() if btn and btn.Parent then btn.BackgroundColor3 = COL_BG_ITEM end end)
            ShowConfirmPopup(function() pcall(function() setclipboard(capDef.code) end); ShowCopiedNotif(capDef.textName) end)
        end)
    end
end

-- ===== EXPOSE FOR PART 3 =====

-- ===== HIDE BUTTON (draggable, sempre na tela) =====
local HideBtn = Instance.new("TextButton", ScreenGui)
HideBtn.Name = "HideBtn"
HideBtn.Size = UDim2.new(0, Px(80), 0, Px(36))
HideBtn.Position = UDim2.new(0, Px(8), 0.5, -Px(18))
HideBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HideBtn.Text = "Hide GUI"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.Font = RBXFONT
HideBtn.TextSize = Px(14)
HideBtn.BorderSizePixel = 0
HideBtn.ZIndex = 200
HideBtn.AutoButtonColor = false
local hideBtnCorner = Instance.new("UICorner", HideBtn)
hideBtnCorner.CornerRadius = UDim.new(0, Px(8))
local hideBtnStroke = Instance.new("UIStroke", HideBtn)
hideBtnStroke.Color = Color3.fromRGB(85,190,255)
hideBtnStroke.Thickness = 2
hideBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
AddTextStroke(HideBtn)

local guiHidden = false
HideBtn.MouseButton1Click:Connect(function()
    guiHidden = not guiHidden
    MainDragFrame.Visible = not guiHidden
    GlowHolder.Visible = not guiHidden
    CreditLabel.Visible = not guiHidden
    HideBtn.Text = guiHidden and "Show GUI" or "Hide GUI"
    HideBtn.BackgroundColor3 = guiHidden and Color3.fromRGB(55,185,80) or Color3.fromRGB(30,30,30)
    hideBtnStroke.Color = guiHidden and Color3.fromRGB(55,185,80) or Color3.fromRGB(85,190,255)
end)

-- Drag do HideBtn (sempre na tela)
local hideDrag = {dragging=false, startPos=nil, startBtn=nil}
HideBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
    hideDrag.dragging = true
    hideDrag.startPos = inp.Position
    hideDrag.startBtn = HideBtn.Position
end)
HideBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        hideDrag.dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if not hideDrag.dragging then return end
    if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = inp.Position - hideDrag.startPos
    local vp = workspace.CurrentCamera.ViewportSize
    local bw = HideBtn.AbsoluteSize.X
    local bh = HideBtn.AbsoluteSize.Y
    local newX = math.clamp(hideDrag.startBtn.X.Offset + delta.X, 0, vp.X - bw)
    local newY = math.clamp(hideDrag.startBtn.Y.Scale * vp.Y + hideDrag.startBtn.Y.Offset + delta.Y, 0, vp.Y - bh)
    HideBtn.Position = UDim2.new(0, newX, 0, newY)
end)

_G.YattaP2 = {
    ScreenGui=ScreenGui, MainFrame=MainFrame, GlowHolder=GlowHolder,
    glowImg=glowImg, TitleBar=TitleBar, TitleLabel=TitleLabel,
    SubLabel=SubLabel, MinBtn=MinBtn, CreditLabel=CreditLabel,
    Pages=Pages, tabBtnRefs=tabBtnRefs, SetTab=SetTab,
    UI=UI, TOTAL_W=TOTAL_W, TOTAL_H=TOTAL_H, TITLE_H=TITLE_H,
    TOG_W=TOG_W, TOG_H=TOG_H, CONT_W=CONT_W,
    SyncGlow=SyncGlow, UpdateCreditPos=UpdateCreditPos,
    isDraggingRef=function() return isDragging end,
    SecHeader=SecHeader, InfoLbl=InfoLbl, ListLbl=ListLbl, Gap=Gap,
    MakeSlider=MakeSlider, MakeGridSlider=MakeGridSlider,
    MakeToggle=MakeToggle, MakeCheckboxRow=MakeCheckboxRow,
    MakeCycleBtn=MakeCycleBtn, MakeActionBtn=MakeActionBtn,
    MakeTriggerRow=MakeTriggerRow,
    DragLockBtn=DragLockBtn, RefreshDragBtn=RefreshDragBtn,
    COL_BTN_HIDE=COL_BTN_HIDE, COL_BTN_SHOW=COL_BTN_SHOW,
    COL_BTN_LOCK_OFF=COL_BTN_LOCK_OFF, COL_BTN_LOCK_ON=COL_BTN_LOCK_ON,
    FONT_OPTIONS=FONT_OPTIONS, FONT_NAMES=FONT_NAMES, IDX=IDX,
    settingsAPI=settingsAPI,
    MOVE_OPT=UI.MOVE_OPT or {}, MOVE_MODES=UI.MOVE_MODES or {},
}


---------


local P  = _G.YattaP1
local P2 = _G.YattaP2
assert(P,  "Run Part 1 first!")
assert(P2, "Run Part 2 second!")

-- ===== NIL SAFETY CHECK =====
-- Detecta EXATAMENTE qual key está nil antes de crashar com "attempt to call a nil value"
do
    local p1Keys = {
        "Players","RunService","TweenService","UserInputService","VirtualUser",
        "player","pGui","IS_RESTRICTED","Theme","S","C","MONSTER_RADIUS",
        "SPECIAL_MONSTERS","FARM_IGNORE","GRAB_NAMES","THREAT_LIST","HEAL_CARDS",
        "GEN_HALF_RESTRICTED","ITEM_CONFIG","PICKUP_CFG","BUY_BLACKLIST",
        "SCRIPTS_DATA","FONT_OPTIONS","FONT_NAMES","IDX","DodgeBalls","TendrilBalls",
        "GrabBalls","TwistedLabels","MachineLabels","SMTLabels","ESPHighlights",
        "FlyState","playerBillboards","VisualFolder","PlaySound","SOUND_CLICK",
        "SOUND_ERROR","SOUND_MINIMIZE","TeleportTo","GetInvStats","GetEnabledPickup",
        "GetSurvivalPoints","GetTapeCount","HasItemInInventory","IsPlayerEggson",
        "GetEggsonGenPlayerNumberValue","EggsonGenHasPlayerNumberValue",
        "GetCurrentRoomGenerators","FireStopGenCurrentRoom","CleanName","CreateBall",
        "GetAvailableItems","MakeVacuumPad","InBaseBounds","FindBase","FindPanicBase",
        "GetDecodingValue","GetActiveGen","TENDRIL_LIKE","IsGenSafe","GetGenThreats",
        "FireStopGen","StartStopFireLoop","ApplyInstantSkillcheck","FireItemSlot",
        "SlotWithItem","GetCurrentStamina","IsFloorActive","IsDandyStoreOpen",
        "IsCardVoting","FireSprint","StopSprintLoop","StartSprintLoop",
        "GetFloorActiveValue","ShouldSpin","StopSpinLoop","StartSpinLoop",
        "DoAutoVote","DoAutoBuy","FindSafeMonster","FixAllGeneratorPipes",
        "RemoveInvisWall","FindGenTeleportPosition","FindGenPipePart",
        "GetGenTeleportCFrame","StartAntiLag","StopAntiLag","UpdateAllESP",
        "SaveConfig","LoadConfig","BuildConfigTable","GetConfigFile",
    }
    local p2Keys = {
        "ScreenGui","MainFrame","GlowHolder","glowImg","TitleBar","TitleLabel",
        "SubLabel","MinBtn","CreditLabel","Pages","tabBtnRefs","SetTab","UI",
        "TOTAL_W","TOTAL_H","TITLE_H","TOG_W","TOG_H","SyncGlow","UpdateCreditPos",
        "SecHeader","InfoLbl","ListLbl","Gap","MakeSlider","MakeGridSlider",
        "MakeToggle","MakeCheckboxRow","MakeCycleBtn","MakeActionBtn","MakeTriggerRow",
        "DragLockBtn","RefreshDragBtn",
    }
    local missing = {}
    for _, k in ipairs(p1Keys) do
        if P[k] == nil then missing[#missing+1] = "P1."..k end
    end
    for _, k in ipairs(p2Keys) do
        if P2[k] == nil then missing[#missing+1] = "P2."..k end
    end
    if #missing > 0 then
        warn("[Yatta P3] ERRO: Keys faltando! Reexecute Part1 e Part2 antes.")
        for _, m in ipairs(missing) do warn("  [Yatta P3] nil -> " .. m) end
        error("[Yatta P3] Abortado: " .. #missing .. " key(s) nil. Veja o console.", 2)
    end
end
-- ===== FIM NIL SAFETY CHECK =====

-- ===== UNPACK P1 =====
local Players           = P.Players
local RunService        = P.RunService
local TweenService      = P.TweenService
local UserInputService  = P.UserInputService
local VirtualUser       = P.VirtualUser
local player            = P.player
local pGui              = P.pGui
local IS_RESTRICTED     = P.IS_RESTRICTED
local Theme             = P.Theme
local S                 = P.S
local C                 = P.C
local MONSTER_RADIUS    = P.MONSTER_RADIUS
local SPECIAL_MONSTERS  = P.SPECIAL_MONSTERS
local FARM_IGNORE       = P.FARM_IGNORE
local GRAB_NAMES        = P.GRAB_NAMES
local THREAT_LIST       = P.THREAT_LIST
local HEAL_CARDS        = P.HEAL_CARDS
local GEN_HALF_RESTRICTED = P.GEN_HALF_RESTRICTED
local ITEM_CONFIG       = P.ITEM_CONFIG
local PICKUP_CFG        = P.PICKUP_CFG
local BUY_BLACKLIST     = P.BUY_BLACKLIST
local SCRIPTS_DATA      = P.SCRIPTS_DATA
local FONT_OPTIONS      = P.FONT_OPTIONS
local FONT_NAMES        = P.FONT_NAMES
local IDX               = P.IDX
local DodgeBalls        = P.DodgeBalls
local TendrilBalls      = P.TendrilBalls
local GrabBalls         = P.GrabBalls
local TwistedLabels     = P.TwistedLabels
local MachineLabels     = P.MachineLabels
local SMTLabels         = P.SMTLabels
local ESPHighlights     = P.ESPHighlights
local FlyState          = P.FlyState
local playerBillboards  = P.playerBillboards
local VisualFolder      = P.VisualFolder
local PlaySound         = P.PlaySound
local SOUND_CLICK       = P.SOUND_CLICK
local SOUND_ERROR       = P.SOUND_ERROR
local SOUND_MINIMIZE    = P.SOUND_MINIMIZE
local TeleportTo        = P.TeleportTo
local GetInvStats       = P.GetInvStats
local GetEnabledPickup  = P.GetEnabledPickup
local GetSurvivalPoints = P.GetSurvivalPoints
local GetTapeCount      = P.GetTapeCount
local HasItemInInventory= P.HasItemInInventory
local IsPlayerEggson    = P.IsPlayerEggson
local GetEggsonGenPlayerNumberValue = P.GetEggsonGenPlayerNumberValue
local EggsonGenHasPlayerNumberValue = P.EggsonGenHasPlayerNumberValue
local GetCurrentRoomGenerators = P.GetCurrentRoomGenerators
local FireStopGenCurrentRoom   = P.FireStopGenCurrentRoom
local CleanName         = P.CleanName
local CreateBall        = P.CreateBall
local GetAvailableItems = P.GetAvailableItems
local MakeVacuumPad     = P.MakeVacuumPad
local InBaseBounds      = P.InBaseBounds
local FindBase          = P.FindBase
local FindPanicBase     = P.FindPanicBase
local GetDecodingValue  = P.GetDecodingValue
local GetActiveGen      = P.GetActiveGen
local TENDRIL_LIKE      = P.TENDRIL_LIKE
local IsGenSafe         = P.IsGenSafe
local GetGenThreats     = P.GetGenThreats
local FireStopGen       = P.FireStopGen
local StartStopFireLoop = P.StartStopFireLoop
local ApplyInstantSkillcheck = P.ApplyInstantSkillcheck
local FireItemSlot      = P.FireItemSlot
local SlotWithItem      = P.SlotWithItem
local GetCurrentStamina = P.GetCurrentStamina
local IsFloorActive     = P.IsFloorActive
local IsDandyStoreOpen  = P.IsDandyStoreOpen
local IsCardVoting      = P.IsCardVoting
local FireSprint        = P.FireSprint
local StopSprintLoop    = P.StopSprintLoop
local StartSprintLoop   = P.StartSprintLoop
local GetFloorActiveValue = P.GetFloorActiveValue
local ShouldSpin        = P.ShouldSpin
local StopSpinLoop      = P.StopSpinLoop
local StartSpinLoop     = P.StartSpinLoop
local DoAutoVote        = P.DoAutoVote
local DoAutoBuy         = P.DoAutoBuy
local FindSafeMonster   = P.FindSafeMonster
local FixAllGeneratorPipes = P.FixAllGeneratorPipes
local RemoveInvisWall   = P.RemoveInvisWall
local FindGenTeleportPosition = P.FindGenTeleportPosition
local FindGenPipePart   = P.FindGenPipePart
local GetGenTeleportCFrame = P.GetGenTeleportCFrame
local StartAntiLag      = P.StartAntiLag
local StopAntiLag       = P.StopAntiLag
local UpdateAllESP      = P.UpdateAllESP
local SaveConfig        = P.SaveConfig
local LoadConfig        = P.LoadConfig
local BuildConfigTable  = P.BuildConfigTable
local GetConfigFile     = P.GetConfigFile

-- ===== UNPACK P2 =====
local ScreenGui       = P2.ScreenGui
local MainFrame       = P2.MainFrame
local GlowHolder      = P2.GlowHolder
local glowImg         = P2.glowImg
local TitleBar        = P2.TitleBar
local TitleLabel      = P2.TitleLabel
local SubLabel        = P2.SubLabel
local MinBtn          = P2.MinBtn
local CreditLabel     = P2.CreditLabel
local FloatBtn        = P2.FloatBtn or {}
local Pages           = P2.Pages
local tabBtnRefs      = P2.tabBtnRefs
local SetTab          = P2.SetTab
local UI              = P2.UI
local TOTAL_W         = P2.TOTAL_W
local TOTAL_H         = P2.TOTAL_H
local TITLE_H         = P2.TITLE_H
local TOG_W           = P2.TOG_W
local TOG_H           = P2.TOG_H
local SyncGlow        = P2.SyncGlow
local UpdateCreditPos = P2.UpdateCreditPos
local SecHeader       = P2.SecHeader
local InfoLbl         = P2.InfoLbl
local ListLbl         = P2.ListLbl
local Gap             = P2.Gap
local MakeSlider      = P2.MakeSlider
local MakeGridSlider  = P2.MakeGridSlider
local MakeToggle      = P2.MakeToggle
local MakeCheckboxRow = P2.MakeCheckboxRow
local MakeCycleBtn    = P2.MakeCycleBtn
local MakeActionBtn   = P2.MakeActionBtn
local MakeTriggerRow  = P2.MakeTriggerRow
local DragLockBtn     = P2.DragLockBtn
local RefreshDragBtn  = P2.RefreshDragBtn
local MOVE_OPT        = P2.MOVE_OPT or {}
local MOVE_MODES      = P2.MOVE_MODES or {}
local HUD             = P2.HUD or {}
local HUDFrame        = P2.HUDFrame or Instance.new("Frame")
local StopRenderOverlay = P2.StopRenderOverlay or function() end
local DoMinimize      = P2.DoMinimize or function() end

-- ===== CONSTANTS =====
local DECODE_MONSTER_STOP_RADIUS = 20
local PICKUP_MONSTER_SKIP_RADIUS = 20
local FARM_TP_COOLDOWN = 2.0

-- How many studs below the item's Y the player is teleported
-- This ensures the player is NEVER at the item's exact position
local PICKUP_BELOW_ITEM = 5

-- ===== HELPER: Check if any monster is within radius of a position =====
local function IsMonsterNearPosition(pos, radius)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local n = obj.Name
            if n:find("Monster") or SPECIAL_MONSTERS[n] then
                local prim = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
                    or obj:FindFirstChildWhichIsA("BasePart", true)
                if prim and (prim.Position - pos).Magnitude <= radius then
                    return true
                end
            end
        end
    end
    return false
end

-- ==========================================================================
-- CLAMP HELPER
-- ==========================================================================
local Camera = workspace.CurrentCamera

local function ClampGUIToScreen()
    local vp = Camera.ViewportSize
    local halfW = TOTAL_W / 2
    local currentH = MainFrame.Size.Y.Offset > 0 and MainFrame.Size.Y.Offset or TOTAL_H
    local halfH = currentH / 2

    local curX = MainFrame.Position.X.Scale * vp.X + MainFrame.Position.X.Offset
    local curY = MainFrame.Position.Y.Scale * vp.Y + MainFrame.Position.Y.Offset

    local clampedX = math.clamp(curX, halfW, vp.X - halfW)
    local clampedY = math.clamp(curY, halfH, vp.Y - halfH)

    if clampedX ~= curX or clampedY ~= curY then
        MainFrame.Position = UDim2.new(0, clampedX, 0, clampedY)
        SyncGlow()
        UpdateCreditPos()
    end
end

-- ===== WASD SPIN LOOP =====
local _spinKeyConn = nil
local _lastSpinKeySet = {}

local function _ReleaseAllSpinKeys()
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local kmap = {w=Enum.KeyCode.W,a=Enum.KeyCode.A,s=Enum.KeyCode.S,d=Enum.KeyCode.D}
        for _,k in ipairs({"w","a","s","d"}) do
            vim:SendKeyEvent(false, kmap[k], false, game)
        end
    end)
    pcall(function()
        local mouse = player:GetMouse()
        for _,k in ipairs({"w","a","s","d"}) do
            if mouse and mouse.KeyUp then mouse.KeyUp:Fire(k) end
        end
    end)
    _lastSpinKeySet = {}
end

local function _PressSpinKey(keyChar)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local kmap = {w=Enum.KeyCode.W,a=Enum.KeyCode.A,s=Enum.KeyCode.S,d=Enum.KeyCode.D}
        local kc = kmap[keyChar]
        if kc then vim:SendKeyEvent(true, kc, false, game) end
    end)
    pcall(function()
        local mouse = player:GetMouse()
        if mouse and mouse.KeyDown then mouse.KeyDown:Fire(keyChar) end
    end)
end

local function _ReleaseSpinKey(keyChar)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local kmap = {w=Enum.KeyCode.W,a=Enum.KeyCode.A,s=Enum.KeyCode.S,d=Enum.KeyCode.D}
        local kc = kmap[keyChar]
        if kc then vim:SendKeyEvent(false, kc, false, game) end
    end)
    pcall(function()
        local mouse = player:GetMouse()
        if mouse and mouse.KeyUp then mouse.KeyUp:Fire(keyChar) end
    end)
end

local function _GetWASDForDirection(hrp, targetPos)
    local diff = targetPos - hrp.Position
    if diff.Magnitude < 0.5 then return {} end
    local cam = workspace.CurrentCamera
    local ref = cam and cam.CFrame or hrp.CFrame
    local localDir = ref:VectorToObjectSpace(Vector3.new(diff.X,0,diff.Z).Unit)
    local keys = {}
    local threshold = 0.25
    if localDir.Z < -threshold then keys[#keys+1] = "w" end
    if localDir.Z >  threshold then keys[#keys+1] = "s" end
    if localDir.X >  threshold then keys[#keys+1] = "d" end
    if localDir.X < -threshold then keys[#keys+1] = "a" end
    if #keys == 0 then
        if math.abs(localDir.Z) >= math.abs(localDir.X) then
            keys[#keys+1] = localDir.Z < 0 and "w" or "s"
        else
            keys[#keys+1] = localDir.X > 0 and "d" or "a"
        end
    end
    return keys
end

local function DestroySpinPlatform()
    if S.SpinPlatform then
        pcall(function() S.SpinPlatform:Destroy() end)
        S.SpinPlatform = nil
    end
end

local function StopSpinLoopLocal()
    S.spinLoopActive = false
    if _spinKeyConn then _spinKeyConn:Disconnect(); _spinKeyConn = nil end
    _ReleaseAllSpinKeys()
    if S.spinOrbitTween then
        pcall(function() S.spinOrbitTween:Cancel() end)
        S.spinOrbitTween = nil
    end
    S.spinLoopConnection = nil
    DestroySpinPlatform()
end

-- Expose to _G so orbit toggle in P2 can call it
_G._YattaStopSpinLoopFn = StopSpinLoopLocal

local function StartSpinLoopLocal()
    -- FIX: Check orbit toggle before starting
    if not S.ORBIT_ENABLED then return end
    if S.spinLoopActive then return end
    S.spinLoopActive = true
    local orbitAngle  = 0
    local orbitCenter = nil
    _lastSpinKeySet   = {}

    _spinKeyConn = RunService.RenderStepped:Connect(function()
        if not S.spinLoopActive then return end
        -- FIX: Stop immediately if orbit disabled mid-spin
        if not S.ORBIT_ENABLED then StopSpinLoopLocal(); return end
        local dandyStore = IsDandyStoreOpen()
        local cardVoting = IsCardVoting()
        local spinOk     = ShouldSpin()
        local activeGen  = GetActiveGen()
        if not spinOk or activeGen or dandyStore or cardVoting then
            StopSpinLoopLocal(); return
        end
        local char = player.Character
        local hrp  = char and char.PrimaryPart
        if not hrp then return end
        if not orbitCenter then orbitCenter = hrp.Position end
        orbitAngle = orbitAngle + C.SPIN_ORBIT_STEP
        if orbitAngle >= 2 * math.pi then
            orbitAngle = orbitAngle - 2 * math.pi
        end
        local radius   = C.SPIN_ORBIT_RADIUS
        local targetX  = orbitCenter.X + math.cos(orbitAngle) * radius
        local targetZ  = orbitCenter.Z + math.sin(orbitAngle) * radius
        local targetPos = Vector3.new(targetX, hrp.Position.Y, targetZ)
        local newKeys   = _GetWASDForDirection(hrp, targetPos)
        local newKeySet = {}
        for _,k in ipairs(newKeys) do newKeySet[k] = true end
        for k in pairs(_lastSpinKeySet) do
            if not newKeySet[k] then _ReleaseSpinKey(k) end
        end
        for k in pairs(newKeySet) do
            if not _lastSpinKeySet[k] then _PressSpinKey(k) end
        end
        _lastSpinKeySet = newKeySet
        local plat = S.SpinPlatform
        if not plat or not plat.Parent then
            local p = Instance.new("Part")
            p.Name = "SpinWalkPlatform"; p.Size = Vector3.new(6,1,6)
            p.Anchored = true; p.CanCollide = false; p.CastShadow = false
            p.Material = Enum.Material.Neon
            p.Color = Color3.fromRGB(85,190,255); p.Transparency = 0.3
            p.Parent = workspace; S.SpinPlatform = p; plat = p
        end
        plat.CFrame = CFrame.new(targetX, hrp.Position.Y - 1, targetZ)
    end)
end

-- ==========================================================================
-- DRAGGING (clamped to screen)
-- ==========================================================================
local Drag = {
    dragging=false, dragInput=nil, dragStartPos=nil,
    frameStartPos=nil, touches={},
}
local function GetTouchCount()
    local n=0; for _ in pairs(Drag.touches) do n+=1 end; return n
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
       input.UserInputType ~= Enum.UserInputType.Touch then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        Drag.touches[input] = true
    end
    if S.DRAG_LOCKED then return end
    if GetTouchCount() > 1 then
        Drag.dragging = false; Drag.dragInput = nil; return
    end
    Drag.dragging = true; Drag.dragInput = input
    Drag.dragStartPos = input.Position
    Drag.frameStartPos = MainFrame.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            if input.UserInputType == Enum.UserInputType.Touch then
                Drag.touches[input] = nil
            end
            if Drag.dragInput == input then
                Drag.dragging = false; Drag.dragInput = nil
            end
        end
    end)
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        Drag.touches[input] = nil
    end
    if Drag.dragInput == input then
        Drag.dragging = false; Drag.dragInput = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not Drag.dragging or Drag.dragInput == nil or input ~= Drag.dragInput then return end
    if S.DRAG_LOCKED then Drag.dragging = false; Drag.dragInput = nil; return end
    if GetTouchCount() > 1 then
        Drag.dragging = false; Drag.dragInput = nil; return
    end
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        local vp    = Camera.ViewportSize
        local delta = input.Position - Drag.dragStartPos
        local rawX  = Drag.frameStartPos.X.Scale * vp.X + Drag.frameStartPos.X.Offset + delta.X
        local rawY  = Drag.frameStartPos.Y.Scale * vp.Y + Drag.frameStartPos.Y.Offset + delta.Y

        local halfW = TOTAL_W / 2
        local currentH = MainFrame.Size.Y.Offset > 0 and MainFrame.Size.Y.Offset or TOTAL_H
        local halfH = currentH / 2
        local clampedX = math.clamp(rawX, halfW, vp.X - halfW)
        local clampedY = math.clamp(rawY, halfH, vp.Y - halfH)

        MainFrame.Position = UDim2.new(0, clampedX, 0, clampedY)
        SyncGlow(); UpdateCreditPos()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        Drag.touches[input] = nil
    end
    if Drag.dragInput == input then
        Drag.dragging = false; Drag.dragInput = nil
    end
end)

-- ===== MINIMIZE =====
MinBtn.MouseButton1Click:Connect(function()
    PlaySound(SOUND_MINIMIZE)
    S.IS_MINIMIZED = not S.IS_MINIMIZED
    local targetH = S.IS_MINIMIZED and TITLE_H or TOTAL_H
    TweenService:Create(MainFrame,
        TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size=UDim2.new(0,TOTAL_W,0,targetH)}):Play()
    MinBtn.Text = "-"
    GlowHolder.Visible = not S.IS_MINIMIZED
    RefreshDragBtn()
    task.delay(0.25, UpdateCreditPos)
end)

-- ===== BACKGROUND LOOPS =====
task.spawn(function()
    while true do
        task.wait(1)
        if S.ANTI_AFK then
            S.antiAfkTimer -= 1
            if S.antiAfkTimer <= 0 then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
                S.antiAfkTimer = 30
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(C.VOTE_SPAM_INTERVAL)
        if S.AUTO_VOTE then pcall(DoAutoVote) end
    end
end)

task.spawn(function()
    while true do task.wait(1.5); pcall(FixAllGeneratorPipes) end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(UpdateAllESP)
    end
end)

-- ==========================================================================
-- CHARACTER COLLISION HELPERS
--
-- FIX v2: Full collision isolation during pickup.
-- We disable collision on ALL character parts, then we also store
-- which workspace parts were already CanCollide=false so we don't
-- accidentally re-enable them on restore. The ONLY thing that can
-- collide with the player is the PickupPad itself.
--
-- Counter-based: nested calls handled gracefully.
-- ==========================================================================
local _collisionDisableCount = 0
local _partOriginalCollision = {}  -- [part] = originalCanCollide bool

local function DisableCharacterCollision()
    _collisionDisableCount = _collisionDisableCount + 1
    if _collisionDisableCount > 1 then return end  -- already disabled
    local char = player.Character
    if not char then return end
    table.clear(_partOriginalCollision)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            _partOriginalCollision[part] = part.CanCollide
            part.CanCollide = false
        end
    end
end

local function RestoreCharacterCollision()
    _collisionDisableCount = math.max(0, _collisionDisableCount - 1)
    if _collisionDisableCount > 0 then return end
    local char = player.Character
    if not char then
        table.clear(_partOriginalCollision)
        return
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local orig = _partOriginalCollision[part]
            -- Restore to original; if not tracked, default true
            part.CanCollide = (orig == nil) and true or orig
        end
    end
    table.clear(_partOriginalCollision)
end

-- Safety: reset on character respawn
player.CharacterAdded:Connect(function()
    _collisionDisableCount = 0
    table.clear(_partOriginalCollision)
end)

-- ==========================================================================
-- FPS COUNTER (rolling average, no new instances per frame)
-- ==========================================================================
local _fpsWindow     = {}
local _fpsWindowMax  = 30
local _fpsWindowIdx  = 0
local _lastFpsTime   = tick()

local function UpdateFPS()
    local now   = tick()
    local delta = now - _lastFpsTime
    _lastFpsTime = now
    if delta <= 0 then return end
    _fpsWindowIdx = (_fpsWindowIdx % _fpsWindowMax) + 1
    _fpsWindow[_fpsWindowIdx] = 1 / delta
    local sum, count = 0, 0
    for _, v in ipairs(_fpsWindow) do sum = sum + v; count = count + 1 end
    return math.floor(sum / math.max(count, 1) + 0.5)
end

-- ==========================================================================
-- HUD UPDATE
-- ==========================================================================
local _hudUpdateSkip = 0

local function UpdateStopRenderHUD(invStats, fps)
    if not S.STOP_RENDERING then return end
    _hudUpdateSkip = _hudUpdateSkip + 1
    local doFull = (_hudUpdateSkip % 6 == 0)

    if HUD.fpsLbl then
        HUD.fpsLbl.Text = "FPS: " .. (fps or "--")
    end

    if HUD.memLbl then
        local memMB = 0
        pcall(function()
            memMB = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() + 0.5)
        end)
        HUD.memLbl.Text = "Memory: " .. memMB .. " MB"
    end

    if not doFull then return end

    local floorVal = "?"
    pcall(function()
        local info = workspace:FindFirstChild("Info")
        if info then
            local fl = info:FindFirstChild("Floor") or info:FindFirstChild("CurrentFloor")
            if fl then floorVal = tostring(fl.Value) end
        end
    end)
    if HUD.floorLbl then HUD.floorLbl.Text = "Floor: " .. floorVal end

    local gCompleted, gRequired = 0, 0
    pcall(function()
        local info = workspace:FindFirstChild("Info")
        if info then
            local comp = info:FindFirstChild("GeneratorsCompleted") or info:FindFirstChild("CompletedGenerators")
            local req  = info:FindFirstChild("RequiredGenerators")  or info:FindFirstChild("GeneratorsRequired")
            if comp then gCompleted = comp.Value end
            if req  then gRequired  = req.Value  end
        end
    end)
    if HUD.genLbl then HUD.genLbl.Text = "Generators: " .. gCompleted .. " / " .. gRequired end

    local monsterCount = S._cachedMonsterCount or 0
    if HUD.monsterLbl then HUD.monsterLbl.Text = "Monsters: " .. monsterCount end

    local itemCount = 0
    pcall(function()
        local items = GetAvailableItems()
        if items then itemCount = #items end
    end)
    if HUD.itemLbl then HUD.itemLbl.Text = "Items: " .. itemCount end

    if HUD.playerLbl then HUD.playerLbl.Text = "Players: " .. #Players:GetPlayers() end

    if invStats then
        for i = 1, 4 do
            local slotLbl = HUD.slotLabels[i]
            if slotLbl then
                if invStats.slotData and invStats.slotData[i] then
                    local val = invStats.slotData[i]
                    slotLbl.Text = "(" .. i .. ") " .. tostring(val)
                    slotLbl.Visible = true
                    slotLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    slotLbl.Visible = false
                end
            end
        end
    else
        for i = 1, 4 do
            if HUD.slotLabels[i] then HUD.slotLabels[i].Visible = false end
        end
    end
end

-- ===== UPDATE HELPERS =====
local function UpdateInventoryUI(invStats)
    if not UI.SlotLabels or #UI.SlotLabels == 0 then
        return invStats.healingCount
    end
    if invStats.noSlots then
        UI.SlotLabels[1].Visible = true
        UI.SlotLabels[1].Text = "No slots found."
        UI.SlotLabels[1].TextColor3 = Theme.RED
        for i=2,4 do UI.SlotLabels[i].Visible = false end
    else
        for i=1,4 do
            local lbl = UI.SlotLabels[i]
            local val = invStats.slotData[i]
            if val then
                lbl.Visible = true; lbl.Text = "Slot "..i..": "..val
                if val == "None" then lbl.TextColor3 = Theme.MGRAY
                elseif val=="HealthKit" or val=="Bandage" then lbl.TextColor3 = Theme.GREEN
                else lbl.TextColor3 = Theme.LGRAY end
            else lbl.Visible = false end
        end
    end
    local hc = invStats.healingCount
    if UI.healCountLbl then
        if hc >= 2 then
            UI.healCountLbl.Text = "Heals: "..hc.." (Max)"
            UI.healCountLbl.TextColor3 = Theme.RED
        else
            UI.healCountLbl.Text = "Heals: "..hc
            UI.healCountLbl.TextColor3 = Theme.GREEN
        end
    end
    if UI.spLbl then
        local tc = GetTapeCount()
        UI.spLbl.Text = "Tapes: "..tc
        UI.spLbl.TextColor3 = tc > 0 and Theme.YELLOW or Theme.MGRAY
    end
    if UI.staminaLbl then
        local stam = GetCurrentStamina()
        if stam == math.huge then
            UI.staminaLbl.Text = "Stamina: N/A"
            UI.staminaLbl.TextColor3 = Theme.MGRAY
        else
            UI.staminaLbl.Text = "Stamina: "..math.floor(stam)
            UI.staminaLbl.TextColor3 =
                stam <= C.STAMINA_STOP_THRESHOLD and Theme.RED or Theme.PURPLE
        end
    end
    return invStats.healingCount
end

local function UpdateGenUI(activeGen)
    if not UI.genHalfLbl then return false, false end
    if not activeGen then
        UI.genHalfLbl.Text = "Gen Progress: N/A"
        UI.genHalfLbl.TextColor3 = Theme.MGRAY
        if UI.genRestrictLbl then UI.genRestrictLbl.Text = "Valve/JumperCable: N/A"; UI.genRestrictLbl.TextColor3 = Theme.MGRAY end
        if UI.valveLbl  then UI.valveLbl.Text  = "Valve: N/A"; UI.valveLbl.TextColor3  = Theme.MGRAY end
        if UI.jumperLbl then UI.jumperLbl.Text = "JumperCable: N/A"; UI.jumperLbl.TextColor3 = Theme.MGRAY end
        return false, false
    end
    local stats = activeGen:FindFirstChild("Stats")
    local genCur,genReq,belowHalf,halfOrMore = 0,0,false,false
    if stats then
        local cur = stats:FindFirstChild("CurrentAmount")
        local req = stats:FindFirstChild("RequiredAmount")
        if cur and req and req.Value > 0 then
            genCur = cur.Value; genReq = req.Value
            halfOrMore = (genCur >= (genReq/2))
            belowHalf  = (genCur < (genReq/2))
        end
    end
    UI.genHalfLbl.Text = string.format("Gen Progress: %d / %d (%.0f%%)", genCur, genReq, genReq>0 and (genCur/genReq*100) or 0)
    UI.genHalfLbl.TextColor3 = halfOrMore and Theme.GREEN or Theme.ORANGE
    local firing = belowHalf and "FIRING (< 50%)" or "WAITING (>= 50%)"
    if UI.genRestrictLbl then UI.genRestrictLbl.Text = "Valve/JumperCable: "..firing; UI.genRestrictLbl.TextColor3 = belowHalf and Theme.GREEN or Theme.MGRAY end
    if UI.valveLbl  then UI.valveLbl.Text  = "Valve: "..(belowHalf and "FIRING (< 50%)" or "waiting"); UI.valveLbl.TextColor3  = belowHalf and Theme.GREEN or Theme.MGRAY end
    if UI.jumperLbl then UI.jumperLbl.Text = "JumperCable: "..(belowHalf and "FIRING (< 50%)" or "waiting"); UI.jumperLbl.TextColor3 = belowHalf and Theme.GREEN or Theme.MGRAY end
    return belowHalf, halfOrMore
end

local function UpdateDecodingUI(activeGen)
    if not UI.decGenLbl then return end
    if not activeGen then
        UI.decGenLbl.Text = "Decoding: None"; UI.decGenLbl.TextColor3 = Theme.MGRAY
        if UI.decMonLbl  then UI.decMonLbl.Text  = "Monsters Nearby: No (0)"; UI.decMonLbl.TextColor3  = Theme.MGRAY end
        if UI.decTenLbl  then UI.decTenLbl.Text  = "Tendrils Nearby: No (0)"; UI.decTenLbl.TextColor3  = Theme.MGRAY end
        if UI.decBlotLbl then UI.decBlotLbl.Text = "Blot Hands Nearby: No (0)"; UI.decBlotLbl.TextColor3 = Theme.MGRAY end
        return
    end
    local genPos = activeGen:GetPivot().Position
    local mc,tc,bc = GetGenThreats(genPos)
    UI.decGenLbl.Text = "Decoding: "..activeGen.Name; UI.decGenLbl.TextColor3 = Theme.GREEN
    local function tt(c) return (c>0 and "Yes ( " or "No ( ")..c.." )" end
    if UI.decMonLbl  then UI.decMonLbl.Text  = "Twisteds Nearby: "..tt(mc);   UI.decMonLbl.TextColor3  = mc>0 and Theme.RED    or Theme.MGRAY end
    if UI.decTenLbl  then UI.decTenLbl.Text  = "Tendrils Nearby: "..tt(tc);   UI.decTenLbl.TextColor3  = tc>0 and Theme.PURPLE or Theme.MGRAY end
    if UI.decBlotLbl then UI.decBlotLbl.Text = "Blot Hands Nearby: "..tt(bc); UI.decBlotLbl.TextColor3 = bc>0 and Theme.PINK   or Theme.MGRAY end

    if IsMonsterNearPosition(genPos, DECODE_MONSTER_STOP_RADIUS) then
        pcall(function() FireStopGen(activeGen) end)
    end
    if S.FIRE_STOP then
        local icon = pGui:FindFirstChild("MonsterIcon",true)
        if (tc+bc)>0 or (icon and icon.ImageTransparency==0) then
            StartStopFireLoop()
        end
    end
end

-- ===== AUTO USE ITEMS =====
local function DoAutoUseItems(activeGen, genIsBelowHalf, isFullDanger, char)
    if not S.AUTO_USE_ITEMS then return end
    local igp = workspace:FindFirstChild("InGamePlayers")
    local pm  = igp and igp:FindFirstChild(player.Name)
    local statsFolder = pm and pm:FindFirstChild("Stats")
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    local used = nil
    local hpStat = statsFolder and statsFolder:FindFirstChild("Health")
    local hpVal  = hpStat and hpStat.Value or nil
    local humHp  = humanoid and humanoid.Health or nil

    if hpVal and humHp and (tick()-S.lastHealUse >= C.HEAL_COOLDOWN) then
        local useKit,useBand = false,false
        if hpVal >= 4 then
            if humHp <= 1 then useKit=true elseif humHp <= 2 then useBand=true end
        elseif hpVal >= 3 then
            if humHp <= 1 then useKit=true elseif humHp <= 2 then useBand=true end
        elseif hpVal >= 2 then
            if humHp <= 1 then useKit=true end; useBand=true
        end
        if useKit then
            local sl = SlotWithItem("HealthKit") or SlotWithItem("Bandage")
            if sl then FireItemSlot(sl); S.lastItemUse=tick(); S.lastHealUse=tick(); used=sl.Value end
        elseif useBand then
            local sl = SlotWithItem("Bandage") or SlotWithItem("HealthKit")
            if sl then FireItemSlot(sl); S.lastItemUse=tick(); S.lastHealUse=tick(); used=sl.Value end
        end
    end

    if not used and (tick()-S.lastItemUse >= C.ITEM_USE_COOLDOWN) then
        local currentStamina = GetCurrentStamina()
        local staminaLow = (currentStamina~=math.huge) and (currentStamina<=C.STAMINA_STOP_THRESHOLD)
        for _,cfg in ipairs(ITEM_CONFIG) do
            if cfg.trigger=="disabled" or cfg.trigger=="heal" then continue end
            if GEN_HALF_RESTRICTED[cfg.name] then
                if not activeGen then continue end
                if not genIsBelowHalf then continue end
                if tick()-S.lastDecodingUse < C.DECODING_USE_DELAY then continue end
            end
            local fire = false
            if cfg.trigger=="always" then fire=true
            elseif cfg.trigger=="decoding" then fire=(activeGen~=nil)
            elseif cfg.trigger=="Seen" then fire=isFullDanger
            elseif cfg.trigger=="stamina" then fire=staminaLow end
            if fire then
                local sl = SlotWithItem(cfg.name)
                if sl then
                    FireItemSlot(sl); S.lastItemUse=tick()
                    if GEN_HALF_RESTRICTED[cfg.name] then S.lastDecodingUse=tick() end
                    used=cfg.name; break
                end
            end
        end
    end

    if UI.autoUseLbl then
        if used then
            UI.autoUseLbl.Text = "- Item Used: "..used; UI.autoUseLbl.TextColor3 = Theme.GREEN
        else
            UI.autoUseLbl.Text = "- Item Used: None"; UI.autoUseLbl.TextColor3 = Theme.MGRAY
        end
    end
end

local function GetMonsterIconVisibility()
    local icon = pGui:FindFirstChild("MonsterIcon",true)
    if not icon then return 0 end
    return math.floor((1-icon.ImageTransparency)*100)
end

-- ==========================================================================
-- ITEM PICKUP - FULLY FIXED v2
--
-- FIX 1: Player teleports to itemPos.Y - PICKUP_BELOW_ITEM (5 studs below item)
--         NEVER to the item's exact position. This also prevents the player
--         being blocked by or inside the item.
--
-- FIX 2: Platform spawns at playerLandY - 3 (3 studs below player landing spot)
--         so it's always a floor the player stands on, never above the item.
--
-- FIX 3: All character parts CanCollide=false during pickup. Platform has
--         CanCollide=true, providing the ONLY collision surface for the player.
--         This means player falls through the world ONLY onto the pad.
--
-- FIX 4: Collision fully restored after batch (counter-based, leak-safe).
-- ==========================================================================
local PICKUP_SETTLE_TIME    = 0.20   -- wait after teleport for physics to settle
local PICKUP_POST_FIRE_TIME = 0.15   -- wait after firing prompts
local PICKUP_ITEM_GAP       = 0.08   -- gap between items in batch

-- Pickup platform singleton
local _pickupPad = nil

local function DestroyPickupPad()
    if _pickupPad then
        if _pickupPad.Parent then _pickupPad:Destroy() end
        _pickupPad = nil
    end
end

-- FIX: Platform Y is always playerLandY - 3 (floor under player)
-- playerLandY = itemPos.Y - PICKUP_BELOW_ITEM
-- pad Y       = playerLandY - 3
-- So pad is always 3 studs below where the player appears, as a floor
local function SpawnOrMovePad(playerLandX, playerLandY, playerLandZ)
    local padY = playerLandY - 3  -- floor under the player

    if _pickupPad and _pickupPad.Parent then
        _pickupPad.CFrame = CFrame.new(playerLandX, padY, playerLandZ)
        return
    end

    DestroyPickupPad()
    local pad = Instance.new("Part")
    pad.Name       = "PickupPad"
    pad.Size       = Vector3.new(8, 0.5, 8)
    pad.CFrame     = CFrame.new(playerLandX, padY, playerLandZ)
    pad.Anchored   = true
    pad.CanCollide = true   -- ONLY surface the player can collide with
    pad.CastShadow = false
    pad.Transparency = 0.4
    pad.Material   = Enum.Material.SmoothPlastic
    pad.Color      = Color3.fromRGB(100, 210, 255)
    pad.Parent     = workspace
    -- Auto-cleanup after 10 seconds in case batch errors out
    game:GetService("Debris"):AddItem(pad, 10)
    _pickupPad = pad
end

-- Teleport to 5 studs below item, fire proximity prompts, return success
local function DoPickupItem(hrp, item)
    local handle = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
    if not handle or not handle.Parent then return false end

    local itemPos = handle.Position

    -- Skip if monster nearby
    if IsMonsterNearPosition(itemPos, PICKUP_MONSTER_SKIP_RADIUS) then return false end

    -- FIX: Land 5 studs BELOW item Y, never at item Y
    local landX = itemPos.X
    local landY = itemPos.Y - PICKUP_BELOW_ITEM
    local landZ = itemPos.Z

    -- Spawn/move pad first (so it's there when player arrives)
    SpawnOrMovePad(landX, landY, landZ)

    -- Teleport player to position 5 studs below item
    hrp.CFrame = CFrame.new(landX, landY, landZ)

    -- Wait for physics settle (player lands on pad)
    task.wait(PICKUP_SETTLE_TIME)

    -- Item may have been collected or despawned
    if not handle.Parent then return false end

    -- Fire all proximity prompts on this item
    for _, p in ipairs(item:GetDescendants()) do
        if p:IsA("ProximityPrompt") then
            p.HoldDuration = 0
            if fireproximityprompt then
                pcall(fireproximityprompt, p)
            else
                pcall(function() p:InputHoldBegin() end)
                task.wait(0.05)
                pcall(function() p:InputHoldEnd() end)
            end
        end
    end

    task.wait(PICKUP_POST_FIRE_TIME)
    return true
end

local function RunPickupBatch(hrp)
    local items = GetAvailableItems()
    if not items or #items == 0 then return end
    S.PICKING_UP = true

    -- Disable ALL character collision once at batch start
    DisableCharacterCollision()

    for _, item in ipairs(items) do
        if not S.PICKUP_ENABLED or not S.AUTO_ENABLED then break end
        if GetActiveGen() then break end
        local icon2 = pGui:FindFirstChild("MonsterIcon", true)
        local vis2  = icon2 and math.floor((1 - icon2.ImageTransparency) * 100) or 0
        if vis2 > 99 then break end

        DoPickupItem(hrp, item)
        task.wait(PICKUP_ITEM_GAP)
    end

    -- Always clean up pad and restore collision after batch
    DestroyPickupPad()
    RestoreCharacterCollision()
    S.PICKING_UP = false
end

S.PICKING_UP = false
S.pickupLoopRunning = false

local function StartPickupLoop()
    if S.pickupLoopRunning then return end
    S.pickupLoopRunning = true
    task.spawn(function()
        while S.pickupLoopRunning do
            task.wait(C.PICKUP_LOOP_INTERVAL or 1.5)
            if not S.PICKUP_ENABLED or not S.AUTO_ENABLED then S.PICKING_UP = false; continue end
            local char = player.Character; local hrp = char and char.PrimaryPart
            if not hrp then S.PICKING_UP = false; continue end
            local floorActive = GetFloorActiveValue()
            if not (floorActive and floorActive:IsA("BoolValue") and floorActive.Value == true) then S.PICKING_UP = false; continue end
            if GetActiveGen() then S.PICKING_UP = false; continue end
            local panicBool = workspace:FindFirstChild("Panic", true)
            if panicBool and panicBool:IsA("BoolValue") and panicBool.Value == true then S.PICKING_UP = false; continue end
            local icon = pGui:FindFirstChild("MonsterIcon", true)
            local vis  = icon and math.floor((1 - icon.ImageTransparency) * 100) or 0
            if vis > 99 then S.PICKING_UP = false; continue end
            RunPickupBatch(hrp)
        end
        S.PICKING_UP = false
    end)
end
StartPickupLoop()

-- ===== EGGSON FARM =====
local function GetServerPlayerCount() return #Players:GetPlayers() end

local function AllRoomGensHavePlayerValue(roomGens)
    for _,entry in ipairs(roomGens) do
        local gen = entry.gen
        local st = gen:FindFirstChild("Stats")
        if st and st:FindFirstChild("Completed") and st.Completed.Value==true then continue end
        local nv = GetEggsonGenPlayerNumberValue(gen)
        if not nv or nv.Value < 6 then return false end
    end
    return true
end

local function DoEggsonFarm(hrp, currentBase, isPanicChecked, floorActiveValue)
    if not S.AUTO_ENABLED or not S.EGGSON_MODE then return false end
    if S.PICKING_UP then
        if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Waiting for pickup..."; UI.eggsonStatusLbl.TextColor3=Theme.MGRAY end
        return true
    end
    if not floorActiveValue then
        if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Waiting for Floor..."; UI.eggsonStatusLbl.TextColor3=Theme.MGRAY end
        return true
    end
    if not IsPlayerEggson() then
        if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Need Eggson character!"; UI.eggsonStatusLbl.TextColor3=Theme.RED end
        return false
    end
    if isPanicChecked then
        if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: PANIC (waiting)"; UI.eggsonStatusLbl.TextColor3=Theme.RED end
        return false
    end
    local iconVis = GetMonsterIconVisibility()
    if iconVis >= 1 then
        if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Waiting (icon "..iconVis.."%)"; UI.eggsonStatusLbl.TextColor3=Theme.RED end
        if currentBase and not InBaseBounds(currentBase, hrp.Position) then
            if tick()-S.lastBaseTP >= C.BASE_TP_LOOP_CD then
                S.lastBaseTP = tick()
                TeleportTo(hrp, currentBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0))
            end
        end
        return true
    end
    if S.AUTO_USE_ITEMS then
        local hc = GetInvStats().healingCount
        if hc < 2 then
            if S.PICKUP_ENABLED then
                if S.AUTO_BUY then pcall(DoAutoBuy, hrp) end
            else
                local items = GetAvailableItems()
                local healItems = {}
                for _, item in ipairs(items) do
                    local iname = item.Name or ""
                    if iname:find("HealthKit") or iname:find("Bandage") or iname:find("Heal") then healItems[#healItems+1]=item end
                end
                if #healItems > 0 then
                    S.PICKING_UP = true
                    DisableCharacterCollision()
                    for _, item in ipairs(healItems) do DoPickupItem(hrp, item); task.wait(PICKUP_ITEM_GAP) end
                    DestroyPickupPad(); RestoreCharacterCollision(); S.PICKING_UP = false
                end
                if S.AUTO_BUY then pcall(DoAutoBuy, hrp) end
            end
        end
    elseif S.AUTO_BUY then pcall(DoAutoBuy, hrp) end

    local roomGens = GetCurrentRoomGenerators()
    if #roomGens == 0 then
        if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: No gens in CurrentRoom"; UI.eggsonStatusLbl.TextColor3=Theme.MGRAY end
        return false
    end
    local serverCount = GetServerPlayerCount()
    if serverCount < 5 then
        if not AllRoomGensHavePlayerValue(roomGens) then
            local unseededGens = {}
            for _,entry in ipairs(roomGens) do
                local gen = entry.gen
                local st = gen:FindFirstChild("Stats")
                if st and st:FindFirstChild("Completed") and st.Completed.Value==true then continue end
                local nv = GetEggsonGenPlayerNumberValue(gen)
                if not nv then
                    local apVal = st and st:FindFirstChild("ActivePlayer")
                    if apVal then local apName=apVal.Value; if apName~="" and apName~=nil and apName~=player.Name then continue end end
                    unseededGens[#unseededGens+1]=gen
                end
            end
            local activeGen = GetActiveGen()
            if #unseededGens == 0 then
            else
                if activeGen then
                    local nv=GetEggsonGenPlayerNumberValue(activeGen); local hasVal=(nv~=nil and nv.Value>=6)
                    if not hasVal then
                        if tick()-S.lastFarmTeleport >= FARM_TP_COOLDOWN then
                            S.lastFarmTeleport=tick()
                            local pipe=FindGenPipePart(activeGen)
                            if pipe then TeleportTo(hrp,pipe.CFrame)
                            else local tpPart=FindGenTeleportPosition(activeGen); if tpPart then TeleportTo(hrp,tpPart.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end end
                        end
                        if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Seeding gen ("..serverCount.." players)"; UI.eggsonStatusLbl.TextColor3=Theme.BLUE end
                        return true
                    end
                    local genKey=tostring(activeGen)
                    if not S.eggsonCompletionWaitStart[genKey] then S.eggsonCompletionWaitStart[genKey]=tick() end
                    local elapsed=tick()-S.eggsonCompletionWaitStart[genKey]
                    if elapsed>=C.EGGSON_COMPLETION_WAIT then pcall(function() FireStopGenCurrentRoom(activeGen) end) end
                    if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Value >= 6, stopping gen..."; UI.eggsonStatusLbl.TextColor3=Theme.YELLOW end
                    return true
                end
                if tick()-S.lastFarmTeleport < FARM_TP_COOLDOWN then return true end
                S.lastFarmTeleport=tick()
                local targetGen,closestDist=nil,math.huge
                for _,gen in ipairs(unseededGens) do
                    local prim=gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart",true)
                    if prim then local d=(hrp.Position-prim.Position).Magnitude; if d<closestDist then closestDist=d; targetGen=gen end end
                end
                if targetGen then
                    local tpPart=FindGenTeleportPosition(targetGen)
                    if tpPart then TeleportTo(hrp,tpPart.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0))
                    else local pipe=FindGenPipePart(targetGen); if pipe then TeleportTo(hrp,pipe.CFrame) else local prim=targetGen.PrimaryPart or targetGen:FindFirstChildWhichIsA("BasePart",true); if prim then TeleportTo(hrp,CFrame.new(prim.Position+Vector3.new(0,C.TELEPORT_HEIGHT,0))) end end end
                    for _,p in ipairs(targetGen:GetDescendants()) do if p:IsA("ProximityPrompt") then p.HoldDuration=0; if fireproximityprompt then pcall(fireproximityprompt,p) else pcall(function() p:InputHoldBegin() end); task.wait(0.05); pcall(function() p:InputHoldEnd() end) end end end
                    if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Seeding gen ("..serverCount.." players)"; UI.eggsonStatusLbl.TextColor3=Theme.BLUE end
                else
                    if currentBase and not InBaseBounds(currentBase,hrp.Position) then
                        if tick()-S.lastBaseTP>=C.BASE_TP_LOOP_CD then S.lastBaseTP=tick(); TeleportTo(hrp,currentBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end
                    end
                    if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: No unseeded gens found..."; UI.eggsonStatusLbl.TextColor3=Theme.MGRAY end
                end
                return true
            end
            return false
        else return false end
    end

    local pendingGens={}
    for _,entry in ipairs(roomGens) do
        local gen=entry.gen; local st=gen:FindFirstChild("Stats")
        if st and st:FindFirstChild("Completed") and st.Completed.Value==true then continue end
        if not EggsonGenHasPlayerNumberValue(gen) then
            local activePlayerVal=st and st:FindFirstChild("ActivePlayer")
            if activePlayerVal then local apName=activePlayerVal.Value; if apName~="" and apName~=nil and apName~=player.Name then continue end end
            pendingGens[#pendingGens+1]=entry
        end
    end
    local activeGen=GetActiveGen()
    if #pendingGens==0 then
        if activeGen then
            if not S.eggsonStopSpamActive or S.eggsonStopSpamGen~=activeGen then
                S.eggsonStopSpamActive=true; S.eggsonStopSpamGen=activeGen
                local capturedGen=activeGen
                task.spawn(function()
                    while S.EGGSON_MODE and S.AUTO_ENABLED and S.eggsonStopSpamActive and S.eggsonStopSpamGen==capturedGen do
                        local cg=GetActiveGen(); if cg~=capturedGen then S.eggsonStopSpamActive=false; S.eggsonStopSpamGen=nil; return end
                        pcall(function() FireStopGenCurrentRoom(capturedGen) end); task.wait(0.1)
                    end
                    if S.eggsonStopSpamGen==capturedGen then S.eggsonStopSpamActive=false; S.eggsonStopSpamGen=nil end
                end)
            end
            if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: All done, firing Stop"; UI.eggsonStatusLbl.TextColor3=Theme.YELLOW end
        else
            S.eggsonStopSpamActive=false; S.eggsonStopSpamGen=nil
            if currentBase and not InBaseBounds(currentBase,hrp.Position) then
                if tick()-S.lastBaseTP>=C.BASE_TP_LOOP_CD then S.lastBaseTP=tick(); TeleportTo(hrp,currentBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end
            end
            if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: All gens done! Waiting."; UI.eggsonStatusLbl.TextColor3=Theme.GREEN end
        end
        return true
    end
    if activeGen then
        local nv=GetEggsonGenPlayerNumberValue(activeGen); local hasCompletion=(nv~=nil and nv.Value>=6)
        if hasCompletion then
            local genKey=tostring(activeGen)
            if not S.eggsonCompletionWaitStart[genKey] then S.eggsonCompletionWaitStart[genKey]=tick() end
            local elapsed=tick()-S.eggsonCompletionWaitStart[genKey]
            if elapsed>=C.EGGSON_COMPLETION_WAIT then
                if not S.eggsonStopSpamActive or S.eggsonStopSpamGen~=activeGen then
                    S.eggsonStopSpamActive=true; S.eggsonStopSpamGen=activeGen
                    local capturedGen=activeGen
                    task.spawn(function()
                        while S.EGGSON_MODE and S.AUTO_ENABLED and S.eggsonStopSpamActive and S.eggsonStopSpamGen==capturedGen do
                            local cg=GetActiveGen(); if cg~=capturedGen then S.eggsonStopSpamActive=false; S.eggsonStopSpamGen=nil; return end
                            pcall(function() FireStopGenCurrentRoom(capturedGen) end); task.wait(0.1)
                        end
                        if S.eggsonStopSpamGen==capturedGen then S.eggsonStopSpamActive=false; S.eggsonStopSpamGen=nil end
                    end)
                end
                if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Firing Stop! (>= 6)"; UI.eggsonStatusLbl.TextColor3=Theme.YELLOW end
            else
                if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Waiting before stop..."; UI.eggsonStatusLbl.TextColor3=Theme.ORANGE end
            end
            return true
        else
            S.eggsonCompletionWaitStart[tostring(activeGen)]=nil
            if tick()-S.lastFarmTeleport>=FARM_TP_COOLDOWN then
                S.lastFarmTeleport=tick()
                local pipe=FindGenPipePart(activeGen)
                if pipe then TeleportTo(hrp,pipe.CFrame); if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Decoding (at Pipe)"; UI.eggsonStatusLbl.TextColor3=Theme.BLUE end
                else local tpPart=FindGenTeleportPosition(activeGen); if tpPart then TeleportTo(hrp,tpPart.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end; if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Decoding (no pipe)"; UI.eggsonStatusLbl.TextColor3=Theme.BLUE end end
            end
            return true
        end
    end
    if tick()-S.lastFarmTeleport<FARM_TP_COOLDOWN then return true end
    S.lastFarmTeleport=tick()
    S.eggsonStopSpamActive=false; S.eggsonStopSpamGen=nil
    local targetGen,closestDist=nil,math.huge
    for _,entry in ipairs(pendingGens) do
        local gen=entry.gen; local prim=gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart",true)
        if prim then local d=(hrp.Position-prim.Position).Magnitude; if d<closestDist then closestDist=d; targetGen=gen end end
    end
    if not targetGen then
        if currentBase and not InBaseBounds(currentBase,hrp.Position) then
            if tick()-S.lastBaseTP>=C.BASE_TP_LOOP_CD then S.lastBaseTP=tick(); TeleportTo(hrp,currentBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end
        end
        if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Waiting for gens..."; UI.eggsonStatusLbl.TextColor3=Theme.MGRAY end
        return true
    end
    local tpPart=FindGenTeleportPosition(targetGen)
    if tpPart then TeleportTo(hrp,tpPart.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0))
    else local pipe=FindGenPipePart(targetGen); if pipe then TeleportTo(hrp,pipe.CFrame) else local prim=targetGen.PrimaryPart or targetGen:FindFirstChildWhichIsA("BasePart",true); if prim then TeleportTo(hrp,CFrame.new(prim.Position+Vector3.new(0,C.TELEPORT_HEIGHT,0))) end end end
    for _,p in ipairs(targetGen:GetDescendants()) do if p:IsA("ProximityPrompt") then p.HoldDuration=0; if fireproximityprompt then pcall(fireproximityprompt,p) else pcall(function() p:InputHoldBegin() end); task.wait(0.05); pcall(function() p:InputHoldEnd() end) end end end
    if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Going to gen..."; UI.eggsonStatusLbl.TextColor3=Theme.ORANGE end
    return true
end

-- ===== NORMAL AUTO FARM =====
local function DoNormalAutoFarm(hrp, currentBase, visibility, isPanicChecked, floorActive, activeGen)
    if not S.AUTO_ENABLED then if S.FarmBall then S.FarmBall.Transparency=1 end; return end
    if not floorActive or not floorActive.Value then if S.FarmBall then S.FarmBall.Transparency=1 end; return end
    if visibility>99 or isPanicChecked then if S.FarmBall then S.FarmBall.Transparency=1 end; return end
    if S.PICKING_UP then if S.FarmBall then S.FarmBall.Transparency=1 end; return end
    if tick()-S.lastFarmTeleport<FARM_TP_COOLDOWN then return end
    S.lastFarmTeleport=tick()
    if activeGen then
        local cv=activeGen:FindFirstChild("Connie",true); local isConnie=cv and cv:IsA("BoolValue") and cv.Value==true
        if isConnie or not IsGenSafe(activeGen) then
            if S.SAFE_TP and currentBase and not InBaseBounds(currentBase,hrp.Position) then TeleportTo(hrp,currentBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end
        else
            local pipe=FindGenPipePart(activeGen)
            if pipe then TeleportTo(hrp,pipe.CFrame) else local tpCf=GetGenTeleportCFrame(activeGen); if tpCf then TeleportTo(hrp,tpCf) end end
        end
        return
    end
    local allGens={}
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj.Name=="Generator" and obj:IsA("Model") then
            local cv=obj:FindFirstChild("Connie",true); if cv and cv:IsA("BoolValue") and cv.Value then continue end
            local st=obj:FindFirstChild("Stats")
            if st then
                local comp=st:FindFirstChild("Completed"); if comp and comp.Value==true then continue end
                local active=st:FindFirstChild("ActivePlayer"); if active and active.Value~=nil and active.Value~="" and active.Value~=player.Name then continue end
                if IsGenSafe(obj) then allGens[#allGens+1]=obj end
            end
        end
    end
    if #allGens==0 then
        if S.FarmBall then S.FarmBall.Transparency=1 end
        if S.SAFE_TP and currentBase and not InBaseBounds(currentBase,hrp.Position) then
            if tick()-S.lastFarmBaseTP>=C.BASE_TP_COOLDOWN then S.lastFarmBaseTP=tick(); TeleportTo(hrp,currentBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end
        end
        return
    end
    local closestGen,closestDist=nil,math.huge
    for _,gen in ipairs(allGens) do local d=(hrp.Position-gen:GetPivot().Position).Magnitude; if d<closestDist then closestDist=d; closestGen=gen end end
    if not closestGen then return end
    local tpPart=FindGenTeleportPosition(closestGen)
    if tpPart then
        TeleportTo(hrp,tpPart.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0))
        task.wait(0.2)
        for _,p in ipairs(closestGen:GetDescendants()) do
            if p:IsA("ProximityPrompt") then
                p.HoldDuration=0
                if fireproximityprompt then
                    pcall(function() fireproximityprompt(p) end)
                else
                    pcall(function() p:InputHoldBegin() end)
                    task.wait(0.05)
                    pcall(function() p:InputHoldEnd() end)
                end
            end
        end
    else
        if S.FarmBall then S.FarmBall.Transparency=1 end
        if S.SAFE_TP and currentBase and not InBaseBounds(currentBase,hrp.Position) then
            if tick()-S.lastFarmBaseTP>=C.BASE_TP_COOLDOWN then S.lastFarmBaseTP=tick(); TeleportTo(hrp,currentBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end
        end
    end
end

-- ===== AUTO WASTE HEALS =====
local _drainHealCooldown = 0
local DRAIN_HEAL_USE_CD = 1.5

local function TryWasteHeal(char)
    local inv=GetInvStats(); if inv.healingCount<=2 then return end
    if tick()-_drainHealCooldown<DRAIN_HEAL_USE_CD then return end
    local sl=SlotWithItem("Bandage") or SlotWithItem("HealthKit")
    if sl then FireItemSlot(sl); _drainHealCooldown=tick() end
end

-- ===== MACHINE LOCATOR =====
local function UpdateMachineLocatorEmpty()
    if not UI.noGenLbl or not UI.MachineList then return end
    local hasAny=false
    for _,child in ipairs(UI.MachineList:GetChildren()) do
        if child:IsA("TextLabel") and child.Visible then hasAny=true; break end
    end
    UI.noGenLbl.Visible = not hasAny
end

-- ==========================================================================
-- MAIN UPDATE LOOP
-- Memory fixes:
--   - _seenObjects cleared AFTER use, not before
--   - _activeTendrils rebuilt compactly in periodic cleanup
--   - Stale pad ref cleaned
--   - Collision counter leak reset if PICKING_UP is false
--   - Monster count cached for HUD
-- ==========================================================================
local _frameCount    = 0
local _seenObjects   = {}  -- used to skip already-processed objects this scan
local _activeTendrils = {}
local WORLD_SCAN_INTERVAL = 6

local function Update()
    _frameCount += 1
    SyncGlow(); UpdateCreditPos()

    if _frameCount % 30 == 0 then
        pcall(ClampGUIToScreen)
    end

    pcall(RemoveInvisWall)

    local fps = UpdateFPS()

    local char = player.Character
    if not char or not char.PrimaryPart then return end
    local hrp = char.PrimaryPart
    if IS_RESTRICTED then
        if S.STOP_RENDERING then pcall(UpdateStopRenderHUD, nil, fps) end
        return
    end

    local currentBase   = FindBase()
    local panicBase     = FindPanicBase()
    local userInBase    = InBaseBounds(currentBase, hrp.Position)
    local panicBool     = workspace:FindFirstChild("Panic",true)
    local isPanicChecked = panicBool and panicBool:IsA("BoolValue") and panicBool.Value==true
    local floorActive   = GetFloorActiveValue()
    local floorActiveValue = floorActive and floorActive:IsA("BoolValue") and floorActive.Value==true
    local icon          = pGui:FindFirstChild("MonsterIcon",true)
    local visibility    = icon and math.floor((1-icon.ImageTransparency)*100) or 0
    local isDanger      = (visibility >= 1)
    local isFullDanger  = (visibility >= 100)
    local activeGen     = GetActiveGen()
    local genIsBelowHalf,_ = UpdateGenUI(activeGen)
    local invStats      = GetInvStats()
    local hc            = UpdateInventoryUI(invStats)
    UpdateDecodingUI(activeGen)

    if S.STOP_RENDERING then
        pcall(UpdateStopRenderHUD, invStats, fps)
    end

    -- Sprint / Spin
    do
        local dandyStore=IsDandyStoreOpen(); local cardVoting=IsCardVoting()
        local shouldSprint=(activeGen~=nil) or (not floorActiveValue)
        if shouldSprint and not S.sprintLoopActive then StartSprintLoop()
        elseif not shouldSprint and S.sprintLoopActive then StopSprintLoop(); if S.isSprinting then pcall(function() FireSprint(false) end) end end

        -- FIX: Orbit toggle gates spin loop
        local spinOk = ShouldSpin() and S.ORBIT_ENABLED
        local shouldSpin = spinOk and (activeGen==nil) and (not dandyStore) and (not cardVoting)
        if shouldSpin and not S.spinLoopActive then StartSpinLoopLocal()
        elseif not shouldSpin and S.spinLoopActive then StopSpinLoopLocal() end

        if UI.sprintStatusLbl then
            if S.sprintLoopActive then
                local stam=GetCurrentStamina()
                if stam==math.huge then UI.sprintStatusLbl.Text="- Sprint: Active (stamina N/A)"; UI.sprintStatusLbl.TextColor3=Theme.MGRAY
                elseif stam<=C.STAMINA_STOP_THRESHOLD then UI.sprintStatusLbl.Text="- Sprint: PAUSED (stamina "..math.floor(stam)..")"; UI.sprintStatusLbl.TextColor3=Theme.RED
                else UI.sprintStatusLbl.Text="- Sprint: Running (stamina "..math.floor(stam)..")"; UI.sprintStatusLbl.TextColor3=Theme.GREEN end
            else UI.sprintStatusLbl.Text="- Sprint: Idle"; UI.sprintStatusLbl.TextColor3=Theme.MGRAY end
        end
        if UI.spinStatusLbl then
            if S.spinLoopActive then
                UI.spinStatusLbl.Text="- Spin: ACTIVE (radius "..C.SPIN_ORBIT_RADIUS..")"; UI.spinStatusLbl.TextColor3=Theme.YELLOW
            else
                local faVal=GetFloorActiveValue(); local reason
                if not S.ORBIT_ENABLED then reason="Orbit disabled"
                elseif faVal==nil then reason="FloorActive absent"
                elseif faVal:IsA("BoolValue") and faVal.Value==true then reason="FloorActive=true"
                elseif activeGen then reason="decoding"
                elseif dandyStore then reason="store open"
                elseif cardVoting then reason="voting"
                else reason="idle" end
                UI.spinStatusLbl.Text="- Spin: Off ( "..reason.." )"; UI.spinStatusLbl.TextColor3=Theme.MGRAY
            end
        end
    end

    -- Auto Waste Heals
    if hc>2 then S.DRAIN_HUNT=true elseif hc<=2 then S.DRAIN_HUNT=false end
    if S.DRAIN_HUNT then
        if UI.drainLbl then UI.drainLbl.Text="- Auto Waste Heals: ACTIVE ( heals: "..hc.." )"; UI.drainLbl.TextColor3=Theme.ORANGE end
        TryWasteHeal(char)
        if floorActiveValue then
            if currentBase then
                if userInBase then
                    if tick()-S.drainHuntLastTP>=C.DRAIN_HUNT_DELAY then S.drainHuntLastTP=tick(); local tgt=FindSafeMonster(hrp); if tgt then TeleportTo(hrp,tgt.CFrame*CFrame.new(0,2,0)) end end
                else
                    if tick()-S.drainHuntLastTP>=C.DRAIN_HUNT_DELAY then S.drainHuntLastTP=tick(); TeleportTo(hrp,currentBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end
                end
            else
                if tick()-S.drainHuntLastTP>=C.DRAIN_HUNT_DELAY then S.drainHuntLastTP=tick(); local tgt=FindSafeMonster(hrp); if tgt then TeleportTo(hrp,tgt.CFrame*CFrame.new(0,2,0)) end end
            end
        else
            if tick()-S.drainHuntLastTP>=C.DRAIN_HUNT_DELAY then S.drainHuntLastTP=tick(); local tgt=FindSafeMonster(hrp); if tgt then TeleportTo(hrp,tgt.CFrame*CFrame.new(0,2,0)) end end
        end
        if UI.panicLbl then UI.panicLbl.Text="- Panic: "..(isPanicChecked and "ACTIVE" or "waiting"); UI.panicLbl.TextColor3=isPanicChecked and Theme.RED or Theme.MGRAY end
        if UI.elevLbl then
            UI.elevLbl.Text=currentBase and ("- Fake Elevator ("..math.floor((hrp.Position-currentBase.Position).Magnitude).." studs)") or "- Fake Elevator: SEARCHING..."
            UI.elevLbl.TextColor3=currentBase and Theme.LGRAY or Theme.ORANGE
        end
        return
    else
        if UI.drainLbl then UI.drainLbl.Text="- Auto Waste Heals: Inactive"; UI.drainLbl.TextColor3=Theme.MGRAY end
    end

    if S.AUTO_BUY then pcall(DoAutoBuy,hrp) end
    DoAutoUseItems(activeGen,genIsBelowHalf,isFullDanger,char)

    if S.SAFE_TP and isDanger and not isPanicChecked then
        if tick()-S.lastIconTeleport>=C.ICON_LOOP_DELAY then
            S.lastIconTeleport=tick()
            if currentBase and not userInBase then TeleportTo(hrp,currentBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end
        end
        if UI.hideLbl then UI.hideLbl.Text="- Seen: Yes"; UI.hideLbl.TextColor3=Theme.RED end
    else
        if UI.hideLbl then UI.hideLbl.Text="- Seen: No"; UI.hideLbl.TextColor3=Theme.MGRAY end
    end

    if isPanicChecked and panicBase then
        if tick()-S.lastPanicTeleport>=C.PANIC_COOLDOWN then S.lastPanicTeleport=tick(); TeleportTo(hrp,panicBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end
    end

    local eggsonHandled=false
    if S.AUTO_ENABLED and S.EGGSON_MODE then eggsonHandled=DoEggsonFarm(hrp,currentBase,isPanicChecked,floorActiveValue) end
    if not eggsonHandled then
        DoNormalAutoFarm(hrp,currentBase,visibility,isPanicChecked,floorActive,activeGen)
        if not S.EGGSON_MODE then
            if UI.eggsonStatusLbl then UI.eggsonStatusLbl.Text="- Eggson: Off"; UI.eggsonStatusLbl.TextColor3=Theme.MGRAY end
        end
    end

    if UI.panicLbl then UI.panicLbl.Text="- Panic: "..(isPanicChecked and "ACTIVE" or "waiting"); UI.panicLbl.TextColor3=isPanicChecked and Theme.RED or Theme.MGRAY end
    if UI.eyeLbl  then UI.eyeLbl.Text="Twisted Eye: "..visibility.."%"; UI.eyeLbl.TextColor3=isDanger and Theme.RED or Theme.LGRAY end
    if UI.interactLbl then UI.interactLbl.Text="Auto stop Extracting: "..(visibility>99 and "ACTIVE" or "READY"); UI.interactLbl.TextColor3=visibility>99 and Theme.RED or Theme.YELLOW end
    if UI.elevLbl then
        UI.elevLbl.Text=currentBase and ("- Fake Elevator ("..math.floor((hrp.Position-currentBase.Position).Magnitude).." studs)") or "- Fake Elevator: SEARCHING..."
        UI.elevLbl.TextColor3=currentBase and Theme.LGRAY or Theme.ORANGE
    end

    -- ===== WORLD RENDERING / SCAN =====
    local tCount,gCount,blotCount=0,0,0

    if _frameCount % WORLD_SCAN_INTERVAL == 0 then
        local monsterCount = 0
        -- FIX: Use a fresh seen set each scan (table.clear at start of scan, not end)
        -- We use a local seen table and do NOT clear the module-level _seenObjects
        -- during iteration, to avoid any mid-iteration issues.
        local seenThisScan = {}

        local allDesc = workspace:GetDescendants()
        for _,obj in ipairs(allDesc) do
            if not obj:IsA("Model") then continue end
            if seenThisScan[obj] then continue end
            seenThisScan[obj] = true

            local objName=obj.Name
            local isMonster=(objName:find("Monster") or SPECIAL_MONSTERS[objName]) and not table.find(GRAB_NAMES,objName)
            local isMachine=(objName:find("Station") or objName=="Generator")
            local isTendril=table.find(TENDRIL_LIKE,objName)
            local isGrab=table.find(GRAB_NAMES,objName)

            if isMonster then
                monsterCount = monsterCount + 1
                local prim=obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
                if prim then
                    local config=SPECIAL_MONSTERS[objName]
                    if not DodgeBalls[obj] or not DodgeBalls[obj].Parent then DodgeBalls[obj]=CreateBall((config and config.Range or C.DEFAULT_RANGE)/2,nil,obj) end
                    DodgeBalls[obj].CFrame=prim.CFrame
                    DodgeBalls[obj].Color=isDanger and Theme.RED or Color3.fromRGB(0,255,255)
                    if UI.TwistedList and UI.SMTList then
                        local labelTable=config and SMTLabels or TwistedLabels
                        local targetList=config and UI.SMTList or UI.TwistedList
                        if not labelTable[obj] or not labelTable[obj].Parent then
                            local lbl=Instance.new("TextLabel",targetList)
                            lbl.Size=UDim2.new(1,0,0,16); lbl.BackgroundTransparency=1
                            lbl.Font=Theme.Font; lbl.TextSize=12; lbl.ZIndex=204
                            lbl.TextColor3=config and Theme.ORANGE or Theme.LGRAY
                            lbl.TextXAlignment=Enum.TextXAlignment.Left
                            labelTable[obj]=lbl
                        end
                        labelTable[obj].Text=CleanName(objName).."  ["..math.floor((hrp.Position-prim.Position).Magnitude).."m]"
                    end
                end
            elseif isMachine then
                local st=obj:FindFirstChild("Stats")
                local completed=st and st:FindFirstChild("Completed") and st.Completed.Value==true
                if st and not completed then
                    local p=obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)
                    if p and UI.MachineList then
                        if not MachineLabels[obj] or not MachineLabels[obj].Parent then
                            local l=Instance.new("TextLabel",UI.MachineList)
                            l.Size=UDim2.new(1,0,0,16); l.BackgroundTransparency=1
                            l.TextColor3=Theme.BLUE; l.Font=Theme.Font; l.TextSize=12
                            l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=204
                            MachineLabels[obj]=l
                        end
                        MachineLabels[obj].Text=CleanName(objName).."  ["..math.floor((hrp.Position-p.Position).Magnitude).."m]"
                    end
                else
                    if MachineLabels[obj] then pcall(function() MachineLabels[obj]:Destroy() end); MachineLabels[obj]=nil end
                end
            elseif isTendril then
                tCount+=1; if objName~="SproutTendril" then blotCount+=1 end
                local tp=obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)
                if tp then
                    _activeTendrils[#_activeTendrils+1]=tp
                    if not TendrilBalls[obj] or not TendrilBalls[obj].Parent then TendrilBalls[obj]=CreateBall(C.TENDRIL_DODGE_RANGE,Theme.PURPLE,obj) end
                    TendrilBalls[obj].CFrame=tp.CFrame
                end
            elseif isGrab then
                gCount+=1
                local gp=obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)
                if gp then
                    if not GrabBalls[obj] or not GrabBalls[obj].Parent then GrabBalls[obj]=CreateBall(C.GRAB_DODGE_RANGE,Color3.fromRGB(255,0,150),obj) end
                    GrabBalls[obj].CFrame=gp.CFrame
                    if not userInBase and (hrp.Position-gp.Position).Magnitude<C.GRAB_DODGE_RANGE then
                        if tick()-S.lastTeleport>C.teleportCooldown then
                            S.lastTeleport=tick()
                            if currentBase then TeleportTo(hrp,currentBase.CFrame*CFrame.new(0,C.TELEPORT_HEIGHT,0)) end
                        end
                    end
                end
            end
        end

        -- FIX: seenThisScan is local, let it GC naturally (no global table to clear)
        seenThisScan = nil
        allDesc = nil

        UpdateMachineLocatorEmpty()
        S._cachedTCount=tCount; S._cachedGCount=gCount; S._cachedBlotCount=blotCount
        S._cachedTendrilLen=#_activeTendrils
        S._cachedMonsterCount=monsterCount
    else
        tCount=S._cachedTCount or 0; gCount=S._cachedGCount or 0; blotCount=S._cachedBlotCount or 0
    end

    -- Tendril dodge
    local tendrilLen=S._cachedTendrilLen or 0
    local nearbyTendril=nil
    for i=1,tendrilLen do
        local tPart=_activeTendrils[i]
        if tPart and tPart.Parent and (hrp.Position-tPart.Position).Magnitude<C.TENDRIL_DODGE_RANGE then nearbyTendril=tPart; break end
    end
    if nearbyTendril then
        local bestPos=hrp.Position
        if userInBase and currentBase then
            local minT,maxD=999,0
            for x=-2,2 do for z=-2,2 do
                local cp=(currentBase.CFrame*CFrame.new(x*(currentBase.Size.X/5),0,z*(currentBase.Size.Z/5))).Position
                if InBaseBounds(currentBase,cp) then
                    local tc2,td2=0,0
                    for i2=1,tendrilLen do local tPart=_activeTendrils[i2]; if tPart and tPart.Parent then local d=(cp-tPart.Position).Magnitude; if d<C.TENDRIL_DODGE_RANGE then tc2+=1 end; td2+=d end end
                    if tc2<minT or (tc2==minT and td2>maxD) then minT=tc2; maxD=td2; bestPos=cp end
                end
            end end
        else
            local maxDist=0
            for angle=0,315,45 do
                local dir=Vector3.new(math.cos(math.rad(angle)),0,math.sin(math.rad(angle)))
                local cp=hrp.Position+(dir*15); local cmd=999
                for i2=1,tendrilLen do local tPart=_activeTendrils[i2]; if tPart and tPart.Parent then local d=(cp-tPart.Position).Magnitude; if d<cmd then cmd=d end end end
                if cmd>maxDist then maxDist=cmd; bestPos=cp end
            end
        end
        hrp.CFrame=CFrame.new(bestPos.X,hrp.Position.Y,bestPos.Z)
    end

    if UI.tendrilLbl then UI.tendrilLbl.Text="Tendrils: "..(tCount-blotCount).."   Blot Hands: "..blotCount end
    if UI.grabLbl    then UI.grabLbl.Text="Active Grabs: "..gCount end

    -- ===== PERIODIC CLEANUP (every 90 frames) =====
    if _frameCount % 90 == 0 then
        for o,b in pairs(DodgeBalls) do if not o.Parent or not o:IsDescendantOf(workspace) then pcall(function() b:Destroy() end); DodgeBalls[o]=nil end end
        for o,l in pairs(TwistedLabels) do if not o.Parent or not o:IsDescendantOf(workspace) then pcall(function() l:Destroy() end); TwistedLabels[o]=nil end end
        for o,l in pairs(SMTLabels) do if not o.Parent or not o:IsDescendantOf(workspace) then pcall(function() l:Destroy() end); SMTLabels[o]=nil end end
        for o,b in pairs(TendrilBalls) do if not o.Parent or not o:IsDescendantOf(workspace) then pcall(function() b:Destroy() end); TendrilBalls[o]=nil end end
        for o,b in pairs(GrabBalls) do if not o.Parent or not o:IsDescendantOf(workspace) then pcall(function() b:Destroy() end); GrabBalls[o]=nil end end
        for o,l in pairs(MachineLabels) do
            local remove=false
            if not o.Parent or not o:IsDescendantOf(workspace) then remove=true
            else local st=o:FindFirstChild("Stats"); if st then local comp=st:FindFirstChild("Completed"); if comp and comp.Value==true then remove=true end end end
            if remove then pcall(function() l:Destroy() end); MachineLabels[o]=nil end
        end
        UpdateMachineLocatorEmpty()

        for k in pairs(S.eggsonCompletionWaitStart) do
            local found=false
            for _,entry in ipairs(GetCurrentRoomGenerators()) do if tostring(entry.gen)==k then found=true; break end end
            if not found then S.eggsonCompletionWaitStart[k]=nil end
        end
        for plr,bb in pairs(playerBillboards) do
            if not plr or not plr.Parent then pcall(function() bb:Destroy() end); playerBillboards[plr]=nil end
        end

        -- FIX: Rebuild _activeTendrils compactly (no holes, no stale refs)
        local cleanTendrils={}
        for i=1,S._cachedTendrilLen or 0 do
            local tp=_activeTendrils[i]
            if tp and tp.Parent then cleanTendrils[#cleanTendrils+1]=tp end
        end
        -- Clear old slots then fill with cleaned data
        for i=1,math.max(#cleanTendrils, S._cachedTendrilLen or 0) do
            _activeTendrils[i] = cleanTendrils[i]  -- nil for slots past #cleanTendrils
        end
        S._cachedTendrilLen = #cleanTendrils
        cleanTendrils = nil

        -- FIX: Clean stale pickup pad reference
        if _pickupPad and not _pickupPad.Parent then _pickupPad=nil end

        -- FIX: If collision counter leaked (PICKING_UP false but counter > 0), reset
        if _collisionDisableCount > 0 and not S.PICKING_UP then
            _collisionDisableCount = 0
            table.clear(_partOriginalCollision)
            local char2 = player.Character
            if char2 then
                for _, part in ipairs(char2:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end

        -- FIX: Clean _fpsWindow of any nil slots to prevent sparse array issues
        local newFpsWindow = {}
        for _, v in ipairs(_fpsWindow) do
            if v then newFpsWindow[#newFpsWindow+1] = v end
        end
        _fpsWindow = newFpsWindow
        _fpsWindowIdx = #_fpsWindow % _fpsWindowMax
        newFpsWindow = nil
    end
end

-- Disconnect previous main update conn if re-running
if _G._YattaMainUpdateConn then
    pcall(function() _G._YattaMainUpdateConn:Disconnect() end)
end

local _mainUpdateConn = RunService.RenderStepped:Connect(function()
    local ok,err = pcall(Update)
    if not ok then warn("YattaGUI Update error:",err) end
end)

_G._YattaMainUpdateConn = _mainUpdateConn
_G._YattaSpinKeyConn    = nil

print("[Yatta GUI - Archival Edition 1.0] Yatta GUI loaded. Please read the text I print below.")
print([[ Yatta's Crazy GUI – 1.0 Archival Edition—By no means, may you use this version to gain profit or any other.
The Creator, "" doesn't want to keep talking about this version. Since the creator had something, he is planning to redo / recode YCGui entirely.
If you are reading this creator (thou name will not be sent due to the owner possibly not liking this), thank you for taking the situation greatly.
Please do not harass the owner, nor inflict harm opon thee.
THIS IS NOT SKIDDED, THIS IS A CODE ARCHIVE]]

