--[[
    japscript — panel edition
    Client-side cosmetics: Korblox leg, Headless, Face, Limited accessories.
    Nothing runs automatically — toggle features from the panel.
    All items: original Roblox-created catalog items.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

------------------------------------------------------------
-- Feature config
------------------------------------------------------------
local FACE_ID = 494291269 -- Super Super Happy Face (Face)

local ACC_ITEMS = {
    -- kepala
    { id = 1365767,     name = "Valkyrie Helm",        sub = "Limited OG • valk", cat = "head" },
    { id = 1125510,     name = "The Void Star",        sub = "OG 2007 • 2.9M", cat = "head" },
    { id = 1285307,     name = "Sparkle Time Fedora",  sub = "Limited OG • sparkle", cat = "head" },
    { id = 1323384,     name = "The Ice Crown",        sub = "Limited • ice", cat = "head" },
    { id = 193696233,   name = "Green Ice Crown",      sub = "Limited • ice", cat = "head" },
    { id = 13241836994, name = "Verdant Crown",        sub = "gift card • leafy", cat = "head" },
    { id = 119916949,   name = "Midnight Blue STF",    sub = "100 copies", cat = "head" },
    { id = 215751161,   name = "Orange STF",           sub = "100 copies", cat = "head" },
    { id = 332772333,   name = "Korblox Ice Crown",    sub = "Limited • korblox", cat = "head" },
    { id = 102887469225690, name = "Blue Inferno Skull", sub = "Limited • inferno", cat = "head" },
    { id = 17756304457, name = "Flaming Pink Horned",  sub = "Limited • pink", cat = "head" },
    { id = 1272714,     name = "Wanwood Antlers",      sub = "OG 2007 • 350k", cat = "head" },
    { id = 215718515,   name = "Fiery Horns",          sub = "Limited • fiery", cat = "head" },
    { id = 74891470,    name = "Frozen Horns",         sub = "Limited • frozen", cat = "head" },
    { id = 19027209,    name = "Legit Business Hat",   sub = "aka Al Capwn", cat = "head" },
    { id = 10159600649, name = "8-Bit Royal Crown",    sub = "8-bit • effect", cat = "head" },
    { id = 10159610478, name = "8-Bit HP Bar",         sub = "8-bit • effect", cat = "head" },
    { id = 63690008,    name = "Pal Hair",             sub = "OG 2011 • hair", cat = "head" },
    { id = 451221329,   name = "True Blue Hair",       sub = "Roblox • hair", cat = "head" },
    { id = 1028859,     name = "Pirate Captain's Hat", sub = "OG 2007 • classic", cat = "head" },
    { id = 1029025,     name = "Classic ROBLOX Fedora", sub = "OG • classic", cat = "head" },
    { id = 1567446,     name = "Verified Sign",        sub = "OG • classic", cat = "head" },
    { id = 104768408817732, name = "The Biggest Head", sub = "dynamic head • viral", cat = "head" },
    { id = 111865906859195, name = "LOOL Head",        sub = "dynamic head • meme", cat = "head" },
    -- face
    { id = 11748356,    name = "Clockwork's Shades",   sub = "Limited • shades", cat = "face" },
    -- lainnya
    { id = 141742418,   name = "Winter Fairy",         sub = "Limited • back", cat = "other" },
    { id = 10159622004, name = "8-Bit Roblox Coin",    sub = "8-bit • effect", cat = "other" },
    { id = 10159606132, name = "8-Bit Extra Life",     sub = "8-bit • effect", cat = "other" },
    { id = 10159617728, name = "8-Bit Tabby Cat",      sub = "shoulder • effect", cat = "other" },
}

local state = {
    korblox = false,
    headless = false,
    face = false,
    acc = {},
    clearFace = false,
    clearClothes = false,
    clearAcc = false,
    fx = { trail = false, api = false, petir = false, sparkles = false, asap = false },
    materialMode = nil,      -- "neon" | "glass" | "gold" | "ice" | "force"
    scales = { height = 1, width = 1, head = 1, prop = 0, bodytype = 0 },
    scalesTouched = false,
    bodyColorName = nil,     -- nama BrickColor
    nametagText = "",
    fog = false,
    world = { gravity = 196.2, fov = 70, zoom = 128 },
    worldTouched = false,
}
for _, item in ipairs(ACC_ITEMS) do state.acc[item.id] = false end

local restore = { korblox = nil, headless = nil }

-- Stats movement (upgrade)
local stats = { walk = 16, jump = 50 }

local function applyStats(char)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function()
        humanoid.WalkSpeed = stats.walk
        humanoid.JumpPower = stats.jump
    end)
end

------------------------------------------------------------
-- Animation packs (ID klasik dari dokumentasi resmi Roblox,
-- tipe Animation bebas dipakai tanpa perlu memiliki pack-nya)
------------------------------------------------------------
local ANIM_PACKS = {
    Toy       = { idle = 782841498,  idle2 = 782845736,  walk = 782843345,  run = 782842708,  jump = 782847020,  fall = 782846423,  climb = 782843869,  swim = 782844582,  swimidle = 782845186 },
    Zombie    = { idle = 616158929,  idle2 = 616160636,  walk = 616168032,  run = 616163682,  jump = 616161997,  fall = 616157476,  climb = 616156119,  swim = 616165109,  swimidle = 616166655 },
    Ninja     = { idle = 656117400,  idle2 = 656118341,  walk = 656121766,  run = 656118852,  jump = 656117878,  fall = 656115606,  climb = 656114359,  swim = 656119721,  swimidle = 656121397 },
    Robot     = { idle = 616088211,  idle2 = 616089559,  walk = 616095330,  run = 616091570,  jump = 616090535,  fall = 616087089,  climb = 616086039,  swim = 616092998,  swimidle = 616094091 },
    Astronaut = { idle = 891621366,  idle2 = 891633237,  walk = 891636393,  run = 891636393,  jump = 891627522,  fall = 891617961,  climb = 891609353,  swim = 891639666,  swimidle = 891663592 },
    Superhero = { idle = 616111295,  idle2 = 616113536,  walk = 616122287,  run = 616117076,  jump = 616115533,  fall = 616108001,  climb = 616104706,  swim = 616119360,  swimidle = 616120861 },
    Bubbly    = { idle = 910004836,  idle2 = 910009958,  walk = 910034870,  run = 910025107,  jump = 910016857,  fall = 910001910,  climb = 909997997,  swim = 910028158,  swimidle = 910030921 },
    Cartoony  = { idle = 742637544,  idle2 = 742638445,  walk = 742640026,  run = 742638842,  jump = 742637942,  fall = 742637151,  climb = 742636889,  swim = 742639220,  swimidle = 742639812 },
    Pirate    = { idle = 750781874,  idle2 = 750782770,  walk = 750785693,  run = 750783738,  jump = 750782230,  fall = 750780242,  climb = 750779899,  swim = 750784579,  swimidle = 750785176 },
    Knight    = { idle = 657595757,  idle2 = 657568135,  walk = 657552124,  run = 657564596,  jump = 658409194,  fall = 657600338,  climb = 658360781,  swim = 657560551,  swimidle = 657557095 },
    Mage      = { idle = 707742142,  idle2 = 707855907,  walk = 707897309,  run = 707861613,  jump = 707853694,  fall = 707829716,  climb = 707826056,  swim = 707876443,  swimidle = 707894699 },
}

local ANIM_PATHS = {
    { "idle", "Animation1", "idle" },
    { "idle", "Animation2", "idle2" },
    { "walk", "WalkAnim", "walk" },
    { "run", "RunAnim", "run" },
    { "jump", "JumpAnim", "jump" },
    { "fall", "FallAnim", "fall" },
    { "climb", "ClimbAnim", "climb" },
    { "swim", "SwimAnim", "swim" },
    { "swimidle", "SwimIdleAnim", "swimidle" },
}

local activeAnimPack = "Default"
local origAnimIds = nil    -- AnimationId asli per slot (untuk reset Default)
local origAnimChar = nil   -- karakter sumber data asli

local function stopAllTracks(char)
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function()
        for _, tr in ipairs(humanoid:GetPlayingAnimationTracks()) do
            pcall(function() tr:Stop(0) end)
        end
    end)
end

local function getAnimSlot(animate, grp, child)
    local g = animate and animate:FindFirstChild(grp)
    return g and g:FindFirstChild(child)
end

-- Teknik paling stabil: ubah AnimationId LANGSUNG di dalam script Animate,
-- lalu restart script-nya (Disabled toggle). Tanpa clone/destroy — di banyak
-- executor, clone LocalScript tidak mau jalan ulang dan bikin karakter kaku.
local function applyAnimPack(name)
    local char = localPlayer.Character
    local animate = char and char:FindFirstChild("Animate")
    if not char or not animate then return false end

    stopAllTracks(char)

    -- Catat AnimationId asli sekali per karakter (sebelum diubah apa pun)
    if origAnimChar ~= char then
        local map = {}
        for _, p in ipairs(ANIM_PATHS) do
            local o = getAnimSlot(animate, p[1], p[2])
            if o then
                pcall(function() map[p[1] .. "." .. p[2]] = o.AnimationId end)
            end
        end
        origAnimIds = map
        origAnimChar = char
    end

    -- Tulis ID baru (atau kembalikan asli kalau Default) langsung di tempat
    for _, p in ipairs(ANIM_PATHS) do
        local o = getAnimSlot(animate, p[1], p[2])
        if o then
            local target = nil
            if name then
                local pack = ANIM_PACKS[name]
                if pack and pack[p[3]] then
                    target = "rbxassetid://" .. pack[p[3]]
                end
            else
                target = origAnimIds and origAnimIds[p[1] .. "." .. p[2]]
            end
            if target then
                pcall(function() o.AnimationId = target end)
            end
        end
    end

    -- Restart script Animate supaya semua track dimuat ulang dengan ID baru
    pcall(function() animate.Disabled = true end)
    task.delay(0.15, function()
        pcall(function()
            if animate and animate.Parent then animate.Disabled = false end
        end)
    end)

    activeAnimPack = name or "Default"
    return true
end

------------------------------------------------------------
-- Emotes
------------------------------------------------------------
-- Emotes: nama + ID animasi resmi Roblox (terverifikasi via API Roblox).
-- PlayEmote dicoba duluan (jalan kalau emote terpasang di avatar),
-- kalau gagal baru load langsung animasi resminya via ID.
local EMOTES = {
    { name = "Wave",    id = 128777973 },
    { name = "Hello",   id = 3576686446 },
    { name = "Point",   id = 128853357 },
    { name = "Cheer",   id = 129423030 },
    { name = "Laugh",   id = 129423131 },
    { name = "Shrug",   id = 3576968026 },
    { name = "Salute",  id = 3360689775 },
    { name = "Victory", id = nil }, -- tanpa aset katalog; via PlayEmote saja
}

------------------------------------------------------------
-- Core helpers
------------------------------------------------------------
local function lockTransparency(part)
    local h = { part = part, orig = part.Transparency, origLTM = part.LocalTransparencyModifier, conn = nil }
    pcall(function()
        h.conn = part:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
            if part.LocalTransparencyModifier ~= 1 then
                part.LocalTransparencyModifier = 1
            end
        end)
    end)
    part.Transparency = 1
    part.LocalTransparencyModifier = 1
    return h
end

local function unlockTransparency(h)
    if not h or not h.part or not h.part.Parent then return end
    if h.conn then pcall(function() h.conn:Disconnect() end) end
    h.part.Transparency = h.orig
    h.part.LocalTransparencyModifier = h.origLTM
end

------------------------------------------------------------
-- Korblox leg
------------------------------------------------------------
local function applyKorblox(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local isR15 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R15
    local data = { rig = isR15 and "R15" or "R6", locks = {}, wraps = {}, extras = {} }

    if isR15 then
        local upper = char:WaitForChild("RightUpperLeg", 8)
        local lower = char:WaitForChild("RightLowerLeg", 8)
        local foot = char:WaitForChild("RightFoot", 8)
        if not (upper and lower and foot) then return nil end

        for _, part in ipairs({ upper, lower, foot }) do
            table.insert(data.locks, lockTransparency(part))
            for _, child in ipairs(part:GetChildren()) do
                if child:IsA("SurfaceAppearance") or child:IsA("WrapTarget") then
                    child:Destroy()
                elseif child:IsA("WrapLayer") then
                    table.insert(data.wraps, child)
                    child.Enabled = false
                end
            end
        end

        local old = upper:FindFirstChild("KorbloxVisualPart")
        if old then old:Destroy() end

        local kPart = Instance.new("Part")
        kPart.Name = "KorbloxVisualPart"
        kPart.CanCollide = false
        kPart.CanTouch = false
        kPart.CanQuery = false
        kPart.Massless = true
        kPart.Size = Vector3.new(1, 1, 1)
        kPart.CFrame = upper.CFrame

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://902942096"
        mesh.TextureId = "rbxassetid://902843398"
        mesh.Parent = kPart

        local weld = Instance.new("Weld")
        weld.Part0 = upper
        weld.Part1 = kPart
        weld.Parent = kPart

        kPart.Parent = upper
        table.insert(data.extras, kPart)
    else
        local rightLeg = char:WaitForChild("Right Leg", 8)
        if not rightLeg then return nil end

        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.RightLeg then
                child:Destroy()
            end
        end
        for _, child in ipairs(rightLeg:GetChildren()) do
            if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") or child:IsA("SurfaceAppearance") or child:IsA("WrapTarget") then
                child:Destroy()
            end
        end

        pcall(function()
            local charMesh = Instance.new("CharacterMesh")
            charMesh.MeshId = 101851696
            charMesh.BodyPart = Enum.BodyPart.RightLeg
            charMesh.Parent = char
            table.insert(data.extras, charMesh)
        end)
        pcall(function()
            local sm = Instance.new("SpecialMesh")
            sm.MeshType = Enum.MeshType.FileMesh
            sm.MeshId = "http://www.roblox.com/asset/?id=101851696"
            sm.TextureId = "http://www.roblox.com/asset/?id=101851254"
            sm.Parent = rightLeg
            table.insert(data.extras, sm)
        end)
    end
    return data
end

local function unapplyKorblox(char, data)
    if not data then return end
    for _, extra in ipairs(data.extras) do
        if extra and extra.Parent then extra:Destroy() end
    end
    for _, h in ipairs(data.locks) do unlockTransparency(h) end
    for _, w in ipairs(data.wraps) do
        if w and w.Parent then w.Enabled = true end
    end
    if data.rig == "R6" and char and char.Parent then
        pcall(function()
            local cm = Instance.new("CharacterMesh")
            cm.BodyPart = Enum.BodyPart.RightLeg
            cm.Parent = char
        end)
    end
end

------------------------------------------------------------
-- Headless
------------------------------------------------------------
local function applyHeadless(char)
    local head = char:WaitForChild("Head", 8)
    if not head then return nil end
    local data = { locks = {}, decals = {}, meshes = {}, wraps = {} }
    table.insert(data.locks, lockTransparency(head))
    for _, child in ipairs(head:GetChildren()) do
        if child:IsA("Decal") then
            table.insert(data.decals, { obj = child, orig = child.Transparency })
            child.Transparency = 1
        elseif child:IsA("SpecialMesh") then
            table.insert(data.meshes, { obj = child, orig = child.Scale })
            child.Scale = Vector3.new(0, 0, 0)
        elseif child:IsA("SurfaceAppearance") or child:IsA("WrapTarget") then
            child:Destroy()
        elseif child:IsA("WrapLayer") then
            table.insert(data.wraps, child)
            child.Enabled = false
        end
    end
    return data
end

local function unapplyHeadless(data)
    if not data then return end
    for _, h in ipairs(data.locks) do unlockTransparency(h) end
    for _, d in ipairs(data.decals) do
        if d.obj.Parent then d.obj.Transparency = d.orig end
    end
    for _, m in ipairs(data.meshes) do
        if m.obj.Parent then m.obj.Scale = m.orig end
    end
    for _, w in ipairs(data.wraps) do
        if w.Parent then w.Enabled = true end
    end
end

------------------------------------------------------------
-- Face (Super Super Happy Face)
------------------------------------------------------------
local FACE_TAG = "CustomFace_SSHF"

local function attachFace(char)
    local head = char:WaitForChild("Head", 8)
    if not head then return end

    local old = head:FindFirstChild(FACE_TAG)
    if old then old:Destroy() end

    local success, asset = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(FACE_ID))[1]
    end)
    if not success or not asset then return end

    -- hide existing face decals (default face)
    for _, child in ipairs(head:GetChildren()) do
        if child:IsA("Decal") then child.Transparency = 1 end
    end

    if asset:IsA("Decal") then
        asset.Name = FACE_TAG
        asset.Face = Enum.NormalId.Front
        asset.Transparency = 0
        asset.Parent = head
    else
        -- fallback: in case the asset arrives as an accessory
        asset.Name = FACE_TAG
        asset.Parent = char
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then pcall(function() humanoid:AddAccessory(asset) end) end
    end
end

local function detachFace(char)
    local head = char:FindFirstChild("Head")
    if head then
        local obj = head:FindFirstChild(FACE_TAG)
        if obj then obj:Destroy() end
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("Decal") then
                child.Transparency = state.headless and 1 or 0
            end
        end
    end
    local tagged = char:FindFirstChild(FACE_TAG)
    if tagged then tagged:Destroy() end
end

------------------------------------------------------------
-- Clear: hapus face / baju / aksesoris avatar (client-side)
-- Item yang dipasang japscript (CustomAcc_*) TIDAK ikut terhapus
------------------------------------------------------------
local clearStash = setmetatable({}, { __mode = "k" })

local function stashFor(char)
    local s = clearStash[char]
    if not s then
        s = { clothes = {}, acc = {} }
        clearStash[char] = s
    end
    return s
end

local faceBackup = setmetatable({}, { __mode = "k" })

local function applyClearFace(char, on)
    local head = char and char:FindFirstChild("Head")
    if not char or not head then return end
    local bk = faceBackup[char]
    if not bk then
        bk = { decals = {}, wraps = {}, meshes = {}, faceCtrl = nil, faceAcc = nil }
        faceBackup[char] = bk
    end

    if on then
        -- 1) decal wajah (semua, termasuk face dari script)
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("Decal") then
                if bk.decals[child] == nil then bk.decals[child] = child.Transparency end
                pcall(function() child.Transparency = 1 end)
            end
        end
        -- 2) wrap layer (dynamic head)
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("WrapLayer") then
                if bk.wraps[child] == nil then bk.wraps[child] = child.Enabled end
                pcall(function() child.Enabled = false end)
            end
        end
        -- 3) FaceControls (dynamic head)
        local fc = head:FindFirstChildOfClass("FaceControls")
        if fc and not bk.faceCtrl then
            bk.faceCtrl = fc
            pcall(function() fc.Parent = nil end)
        end
        -- 4) tekstur mesh kepala (R6 classic face)
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") then
                pcall(function()
                    if bk.meshes[child] == nil then bk.meshes[child] = child.TextureId end
                    if child.TextureId ~= "" then child.TextureId = "" end
                end)
            end
        end
        -- 5) aksesoris wajah bawaan dynamic head (biasanya bernama "Face")
        local fa = char:FindFirstChild("Face")
        if fa and fa:IsA("Accessory") and not bk.faceAcc then
            bk.faceAcc = fa
            pcall(function() fa.Parent = nil end)
        end
    else
        for child, orig in pairs(bk.decals) do
            if child.Parent then pcall(function() child.Transparency = orig end) end
        end
        bk.decals = {}
        for child, orig in pairs(bk.wraps) do
            if child.Parent then pcall(function() child.Enabled = orig end) end
        end
        bk.wraps = {}
        for child, orig in pairs(bk.meshes) do
            if child.Parent then pcall(function() child.TextureId = orig end) end
        end
        bk.meshes = {}
        if bk.faceCtrl and head and not head:FindFirstChildOfClass("FaceControls") then
            pcall(function() bk.faceCtrl.Parent = head end)
        end
        bk.faceCtrl = nil
        if bk.faceAcc and char and not char:FindFirstChild("Face") then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            pcall(function()
                if humanoid then humanoid:AddAccessory(bk.faceAcc) else bk.faceAcc.Parent = char end
            end)
        end
        bk.faceAcc = nil
    end
end

local CLOTH_CLASSES = { "Shirt", "Pants", "ShirtGraphic" }

local function applyClearClothes(char, on)
    if not char then return end
    local s = stashFor(char)
    if on then
        for _, cls in ipairs(CLOTH_CLASSES) do
            local item = char:FindFirstChildOfClass(cls)
            if item then
                pcall(function() item.Parent = nil end)
                table.insert(s.clothes, item)
            end
        end
    else
        local list = s.clothes
        s.clothes = {}
        for _, item in ipairs(list) do
            pcall(function() item.Parent = char end)
        end
    end
end

local function applyClearAcc(char, on)
    if not char then return end
    local s = stashFor(char)
    if on then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Accessory") and not item.Name:find("CustomAcc_") then
                pcall(function() item.Parent = nil end)
                table.insert(s.acc, item)
            end
        end
    else
        local list = s.acc
        s.acc = {}
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        for _, item in ipairs(list) do
            pcall(function()
                if humanoid then
                    humanoid:AddAccessory(item)
                else
                    item.Parent = char
                end
            end)
        end
    end
end

local function applyAllClears(char)
    if not char then return end
    if state.clearFace then applyClearFace(char, true) end
    if state.clearClothes then applyClearClothes(char, true) end
    if state.clearAcc then applyClearAcc(char, true) end
end

------------------------------------------------------------
-- FX: trail, aura partikel, material badan (client-side)
------------------------------------------------------------
local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

local function removeFx(char, name)
    if not char then return end
    local function sweep(parent)
        if not parent then return end
        for _, o in ipairs(parent:GetChildren()) do
            if o.Name:sub(1, #name) == name then
                pcall(function() o:Destroy() end)
            end
        end
    end
    sweep(getRoot(char))
    sweep(char)
end

local function applyTrail(char, on)
    local root = getRoot(char)
    if not root then return end
    removeFx(char, "JapRainbowTrail")
    if not on then return end
    -- Attachment HARUS parent ke BasePart (bukan Folder), kalau tidak
    -- Trail tidak akan pernah ter-render.
    local a0 = Instance.new("Attachment")
    a0.Name = "JapRainbowTrail_a0"
    a0.Position = Vector3.new(0, 1, 0)
    a0.Parent = root
    local a1 = Instance.new("Attachment")
    a1.Name = "JapRainbowTrail_a1"
    a1.Position = Vector3.new(0, -1, 0)
    a1.Parent = root
    local trail = Instance.new("Trail")
    trail.Name = "JapRainbowTrail"
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Lifetime = 1
    trail.LightEmission = 1
    trail.LightInfluence = 0
    trail.MinWidth = 0.6
    trail.MaxWidth = 1
    pcall(function() trail.FaceCamera = true end)
    local keypoints = {}
    for i = 0, 6 do
        table.insert(keypoints, ColorSequenceKeypoint.new(
            i / 6, Color3.fromHSV((i % 6) / 6, 0.9, 1)
        ))
    end
    trail.Color = ColorSequence.new(keypoints)
    trail.Enabled = true
    trail.Parent = root
    -- Partikel pelangi pendamping: kelihatan walau karakter diam
    -- (Trail asli hanya muncul saat karakter bergerak).
    local glow = Instance.new("ParticleEmitter")
    glow.Name = "JapRainbowTrail_glow"
    glow.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    glow.Rate = 24
    glow.Lifetime = NumberRange.new(0.6, 1.2)
    glow.Size = NumberSequence.new(0.3, 0.05)
    glow.Speed = NumberRange.new(1.5, 3)
    glow.SpreadAngle = Vector2.new(180, 180)
    glow.LightEmission = 1
    glow.LightInfluence = 0
    glow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 0.9, 1)),
        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 0.9, 1)),
        ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 0.9, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(0.95, 0.9, 1)),
    })
    glow.Enabled = true
    glow.Parent = root
    pcall(function() glow:Emit(20) end)
end

local function makeEmitter(name, props)
    local e = Instance.new("ParticleEmitter")
    e.Name = name
    for k, v in pairs(props) do
        pcall(function() e[k] = v end)
    end
    return e
end

local function applyAura(char, kind, on)
    local root = getRoot(char)
    if not root then return end
    local tag = "JapFX_" .. kind
    removeFx(char, tag)
    if not on then return end
    if kind == "sparkles" then
        local s = Instance.new("Sparkles")
        s.Name = tag
        s.SparkleColor = Color3.fromRGB(255, 210, 80)
        s.Parent = root
        return
    end
    local function addLight(color, brightness, range)
        local light = Instance.new("PointLight")
        light.Name = tag .. "_light"
        light.Color = color
        light.Brightness = brightness
        light.Range = range
        light.Parent = root
    end
    local e = nil
    if kind == "api" then
        e = makeEmitter(tag, {
            Texture = "rbxasset://textures/particles/fire_main.dds",
            Rate = 70, Lifetime = NumberRange.new(0.7, 1.2),
            Size = NumberSequence.new(0.8, 2.0),
            Speed = NumberRange.new(4, 8),
            EmissionDirection = Enum.NormalId.Top,
            Color = ColorSequence.new(Color3.fromRGB(255, 190, 60), Color3.fromRGB(255, 60, 20)),
            LightEmission = 1, LightInfluence = 0,
            Transparency = NumberSequence.new(0.15, 1),
        })
        addLight(Color3.fromRGB(255, 140, 40), 1.6, 12)
    elseif kind == "asap" then
        e = makeEmitter(tag, {
            Texture = "rbxasset://textures/particles/smoke_main.dds",
            Rate = 40, Lifetime = NumberRange.new(1.2, 2.0),
            Size = NumberSequence.new(1.0, 2.6),
            Speed = NumberRange.new(3, 5),
            EmissionDirection = Enum.NormalId.Top,
            Color = ColorSequence.new(Color3.fromRGB(140, 140, 148)),
            Transparency = NumberSequence.new(0.25, 1),
        })
    elseif kind == "petir" then
        e = makeEmitter(tag, {
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            Rate = 110, Lifetime = NumberRange.new(0.25, 0.55),
            Size = NumberSequence.new(0.35, 0.05),
            Speed = NumberRange.new(7, 12),
            SpreadAngle = Vector2.new(180, 180),
            Color = ColorSequence.new(Color3.fromRGB(120, 230, 255), Color3.fromRGB(255, 255, 255)),
            LightEmission = 1, LightInfluence = 0,
        })
        addLight(Color3.fromRGB(140, 230, 255), 1.4, 10)
    end
    if e then
        e.Enabled = true
        e.Parent = root
        pcall(function() e:Emit(25) end)
    end
end

local MAT_MODES = {
    neon    = { Material = Enum.Material.Neon },
    glass   = { Material = Enum.Material.Glass },
    gold    = { Material = Enum.Material.Metal, Color = Color3.fromRGB(255, 180, 40) },
    ice     = { Material = Enum.Material.Ice },
    force   = { Material = Enum.Material.ForceField },
    diamond = { Material = Enum.Material.DiamondPlate },
}

local function bodyParts(char)
    local t = {}
    for _, p in ipairs(char:GetChildren()) do
        if p:IsA("BasePart") and p.Name ~= "KorbloxVisualPart"
            and not p.Name:find("CustomAcc_") then
            table.insert(t, p)
        end
    end
    return t
end

local function applyMaterialMode(char, mode)
    if not char then return end
    local spec = mode and MAT_MODES[mode] or nil
    for _, p in ipairs(bodyParts(char)) do
        pcall(function()
            if spec then
                if not p:GetAttribute("JapOrigMat") then
                    p:SetAttribute("JapOrigMat", p.Material.Name)
                    p:SetAttribute("JapOrigCol", p.Color)
                end
                p.Material = spec.Material
                if spec.Color then p.Color = spec.Color end
            else
                local mn = p:GetAttribute("JapOrigMat")
                local mc = p:GetAttribute("JapOrigCol")
                if mn then
                    p.Material = Enum.Material[mn] or p.Material
                    if typeof(mc) == "Color3" then p.Color = mc end
                    p:SetAttribute("JapOrigMat", nil)
                    p:SetAttribute("JapOrigCol", nil)
                end
            end
        end)
    end
end

local function applyAllFx(char)
    if not char then return end
    if state.fx.trail then applyTrail(char, true) end
    if state.fx.api then applyAura(char, "api", true) end
    if state.fx.asap then applyAura(char, "asap", true) end
    if state.fx.petir then applyAura(char, "petir", true) end
    if state.fx.sparkles then applyAura(char, "sparkles", true) end
    if state.materialMode then applyMaterialMode(char, state.materialMode) end
end

-- pasang FX dengan retry (tunggu sampai root karakter siap)
local function setFx(kind, on)
    state.fx[kind] = on
    task.spawn(function()
        for _ = 1, 12 do
            local c = localPlayer.Character
            if c and getRoot(c) then
                if kind == "trail" then
                    applyTrail(c, on)
                else
                    applyAura(c, kind, on)
                end
                return
            end
            task.wait(0.3)
        end
    end)
end

-- Loop pemelihara: kalau game menghapus FX/material japscript,
-- pasang ulang otomatis tiap 2 detik selama masih aktif.
task.spawn(function()
    while true do
        task.wait(2)
        local ok = pcall(function()
            local c = localPlayer.Character
            local root = getRoot(c)
            if not (c and root) then return end
            if state.fx.trail and not root:FindFirstChild("JapRainbowTrail") then
                applyTrail(c, true)
            end
            for _, k in ipairs({ "api", "asap", "petir", "sparkles" }) do
                if state.fx[k] and not root:FindFirstChild("JapFX_" .. k) then
                    applyAura(c, k, true)
                end
            end
            if state.materialMode then
                applyMaterialMode(c, state.materialMode)
            end
        end)
        if not ok then break end
    end
end)

------------------------------------------------------------
-- Karakter: skala R15, warna badan, nametag, T-pose
------------------------------------------------------------
local function applyScales(char)
    if not char or not state.scalesTouched then return end
    local h = char:FindFirstChildOfClass("Humanoid")
    if not h then return end
    pcall(function()
        h.BodyHeightScale = state.scales.height
        h.BodyWidthScale = state.scales.width
        h.HeadScale = state.scales.head
        h.BodyProportionScale = state.scales.prop
        h.BodyTypeScale = state.scales.bodytype
    end)
end

local BODY_COLOR_PROPS = {
    "HeadColor", "LeftArmColor", "RightArmColor",
    "LeftLegColor", "RightLegColor", "TorsoColor",
}

local function applyBodyColor(char)
    if not char then return end
    local bc = char:FindFirstChildOfClass("BodyColors")
    if not bc then return end
    if state.bodyColorName then
        local brick = BrickColor.new(state.bodyColorName)
        for _, prop in ipairs(BODY_COLOR_PROPS) do
            pcall(function() bc[prop] = brick end)
        end
    end
end

local function applyNametag(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("JapNametag")
    if old then old:Destroy() end
    if state.nametagText == "" then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "JapNametag"
    bb.Adornee = head
    bb.Size = UDim2.fromOffset(180, 34)
    bb.StudsOffset = Vector3.new(0, 2.4, 0)
    bb.AlwaysOnTop = true
    bb.Parent = head
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.Text = state.nametagText
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 20
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    lbl.BackgroundTransparency = 0.25
    lbl.BorderSizePixel = 0
    lbl.Parent = bb
    pcall(function()
        Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 9)
        local st = Instance.new("UIStroke", lbl)
        st.Thickness = 1.5
        st.Color = Color3.fromRGB(255, 106, 26)
        local gr = Instance.new("UIGradient", lbl)
        gr.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
    end)
end

local animateStash = setmetatable({}, { __mode = "k" })

local function applyTPose(char)
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if animate then
        if not animateStash[char] then
            pcall(function() animateStash[char] = animate:Clone() end)
        end
        pcall(function() animate:Destroy() end)
    end
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then
        for _, tr in ipairs(h:GetPlayingAnimationTracks()) do
            pcall(function() tr:Stop(0) end)
        end
    end
end

local function stopTPose(char)
    if not char then return end
    local stash = animateStash[char]
    if stash and not char:FindFirstChild("Animate") then
        pcall(function() stash.Parent = char end)
    end
    animateStash[char] = nil
end

------------------------------------------------------------
-- Animasi custom & dance
------------------------------------------------------------
local customTrack = nil

local function stopCustomAnim()
    if customTrack then
        pcall(function() customTrack:Stop(0.15) end)
        customTrack = nil
    end
end

local function playCustomAnim(assetId, looped)
    local char = localPlayer.Character
    local h = char and char:FindFirstChildOfClass("Humanoid")
    if not h then return false end
    stopCustomAnim()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(assetId)
    local ok, track = pcall(function() return h:LoadAnimation(anim) end)
    if ok and track then
        track.Looped = looped and true or false
        pcall(function() track.Priority = Enum.AnimationPriority.Action end)
        pcall(function() track:Play() end)
        customTrack = track
        return true
    end
    return false
end

-- Putar emote hasil pencarian katalog: coba jalur emote resmi dulu,
-- kalau gagal baru load langsung dari ID aset. Return true kalau jalan.
local function playFoundEmote(item)
    local char = localPlayer.Character
    local h = char and char:FindFirstChildOfClass("Humanoid")
    if not h or not item then return false end
    stopCustomAnim()
    local okEmote = false
    if item.name then
        pcall(function() okEmote = h:PlayEmote(item.name, 0.1) end)
    end
    if okEmote then return true end
    return playCustomAnim(item.id, false)
end

-- Emote dari tab EMOTE: PlayEmote dulu, fallback ke ID animasi resmi.
local function playEmoteName(name)
    local char = localPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    stopCustomAnim()
    local okEmote = false
    pcall(function() okEmote = humanoid:PlayEmote(name, 0.1) end)
    if okEmote then return true end
    local id = nil
    for _, e in ipairs(EMOTES) do
        if e.name == name then id = e.id end
    end
    if id then return playCustomAnim(id, false) end
    return false
end

local DANCES = {
    { name = "Dance",  id = 507771019 },
    { name = "Dance 2", id = 507776043 },
    { name = "Dance 3", id = 507777268 },
}

------------------------------------------------------------
-- Dunia & kamera: waktu, kabut, gravitasi, FOV, zoom
------------------------------------------------------------
local Lighting = game:GetService("Lighting")
local fogBackup = nil

local function applyTime(name)
    local hours = { siang = 14, sore = 17.3, malam = 0 }
    pcall(function()
        if name and hours[name] ~= nil then
            Lighting.ClockTime = hours[name]
        end
    end)
end

local function applyFog(on)
    pcall(function()
        if on then
            if not fogBackup then
                fogBackup = { endD = Lighting.FogEnd, startD = Lighting.FogStart, col = Lighting.FogColor }
            end
            Lighting.FogStart = 0
            Lighting.FogEnd = 120
            Lighting.FogColor = Color3.fromRGB(160, 165, 175)
        elseif fogBackup then
            Lighting.FogEnd = fogBackup.endD
            Lighting.FogStart = fogBackup.startD
            Lighting.FogColor = fogBackup.col
            fogBackup = nil
        end
    end)
end

local function applyGravity()
    pcall(function() workspace.Gravity = state.world.gravity end)
end

local function applyCamera()
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam and state.worldTouched then cam.FieldOfView = state.world.fov end
    end)
    pcall(function()
        localPlayer.MaximumZoomDistance = state.world.zoom
        localPlayer.MinimumZoomDistance = 0.5
    end)
end

------------------------------------------------------------
-- Pencarian katalog Roblox (by NAME, tanpa ID)
------------------------------------------------------------
local HttpService = game:GetService("HttpService")

local function httpGet(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" and body ~= "" then return body end
    local reqFns = {}
    pcall(function()
        if request then table.insert(reqFns, request) end
        if http_request then table.insert(reqFns, http_request) end
        if syn and syn.request then table.insert(reqFns, syn.request) end
    end)
    for _, fn in ipairs(reqFns) do
        local o2, r = pcall(function() return fn({ Url = url, Method = "GET" }) end)
        if o2 and type(r) == "table" and r.Body then return r.Body end
    end
    return nil
end

local WEARABLE_TYPES = {
    [8] = true, [41] = true, [42] = true, [43] = true,
    [44] = true, [45] = true, [46] = true, [47] = true,
}

local searchState = { mode = "acc", query = "", results = nil, busy = false, err = nil }

local function runCatalogSearch()
    local keyword = searchState.query
    local mode = searchState.mode
    if keyword == "" then return end
    searchState.busy = true
    searchState.err = nil
    task.spawn(function()
        local url = "https://catalog.roblox.com/v1/search/items/details?Keyword="
            .. HttpService:UrlEncode(keyword) .. "&Limit=30"
        local body = httpGet(url)
        if searchState.query ~= keyword then return end
        if not body then
            searchState.busy = false
            searchState.err = "HTTP gagal — executor tidak mendukung request"
            pcall(rebuildContent)
            return
        end
        local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
        local out = {}
        if ok and type(data) == "table" and type(data.data) == "table" then
            for _, it in ipairs(data.data) do
                local t = it.assetType
                if mode == "acc" then
                    if WEARABLE_TYPES[t or 0] then table.insert(out, it) end
                else
                    if t == 61 or t == 24 then table.insert(out, it) end
                end
            end
            -- utamakan tipe Animation (24) yang bebas dipakai,
            -- emote (61) kebanyakan terkunci kepemilikan
            if mode ~= "acc" then
                table.sort(out, function(a, b)
                    return (a.assetType == 24) and (b.assetType ~= 24)
                end)
            end
        end
        if searchState.query ~= keyword then return end
        searchState.busy = false
        searchState.results = out
        if #out == 0 then searchState.err = "tidak ada hasil" end
        pcall(rebuildContent)
    end)
end

-- wearFound dipindah setelah attachAccessory (lihat bawah)

------------------------------------------------------------
-- Accessories
------------------------------------------------------------
local function attachAccessory(char, assetId)
    local tag = "CustomAcc_" .. tostring(assetId)
    local old = char:FindFirstChild(tag)
    if old then old:Destroy() end

    local success, asset = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(assetId))[1]
    end)
    if not success or not asset then return end

    asset.Name = tag
    local handle = asset:FindFirstChild("Handle")
    local head = char:WaitForChild("Head", 8)
    if not handle or not head then return end

    handle.CanCollide = false
    handle.Massless = true
    asset.Parent = char

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        pcall(function() humanoid:AddAccessory(asset) end)
    end

    local existingWeld = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("WeldConstraint")
    if not existingWeld then
        local handleAtt = handle:FindFirstChildOfClass("Attachment")
        local targetPart = head
        local targetAtt = nil

        if handleAtt then
            local found = char:FindFirstChild(handleAtt.Name, true)
            if found and found:IsA("Attachment") and found.Parent and found.Parent:IsA("BasePart") then
                targetPart = found.Parent
                targetAtt = found
            end
        end

        local weld = Instance.new("Weld")
        weld.Name = "AccessoryWeld"
        weld.Part0 = targetPart
        weld.Part1 = handle
        if handleAtt and targetAtt then
            weld.C0 = targetAtt.CFrame
            weld.C1 = handleAtt.CFrame
        else
            weld.C0 = CFrame.new(0, 0.6, 0)
        end
        weld.Parent = handle
    end

    -- terapkan offset/scale yang tersimpan (kalau ada)
    task.delay(0.25, function()
        if asset and asset.Parent then
            applyAdjustToChar(char, assetId)
        end
    end)
end

local function detachAccessory(char, assetId)
    local obj = char:FindFirstChild("CustomAcc_" .. tostring(assetId))
    if obj then obj:Destroy() end
end

-- pakai item hasil pencarian katalog (client-side)
local function wearFound(id)
    local char = localPlayer.Character
    if not char or not id then return end
    state.acc[id] = true
    task.spawn(attachAccessory, char, id)
end

-- Lepas SEMUA aksesoris yang dipasang japscript (hasil cari + panel)
local function removeAllCustomAcc()
    local char = localPlayer.Character
    local n = 0
    if char then
        for _, o in ipairs(char:GetChildren()) do
            if o:IsA("Accessory") and o.Name:sub(1, 10) == "CustomAcc_" then
                pcall(function() o:Destroy() end)
                n = n + 1
            end
        end
    end
    for id in pairs(state.acc) do state.acc[id] = false end
    return n
end

------------------------------------------------------------
-- Adjust mode: offset posisi + scale per aksesori
------------------------------------------------------------
local adjust = {} -- [id] = { x, y, z, s }
local bases = {}  -- [id] = { c0, scale }

local function adjFor(id)
    local a = adjust[id]
    if not a then
        a = { x = 0, y = 0, z = 0, s = 1 }
        adjust[id] = a
    end
    return a
end

local function applyAdjustToChar(char, id)
    if not char then return end
    local obj = char:FindFirstChild("CustomAcc_" .. tostring(id))
    if not obj then return end
    local handle = obj:FindFirstChild("Handle") or obj
    local a = adjFor(id)

    local weld = handle:FindFirstChildOfClass("Weld")
    if weld then
        local b = bases[id]
        if not b then
            b = { c0 = weld.C0, scale = nil }
            bases[id] = b
        end
        pcall(function()
            weld.C0 = b.c0 * CFrame.new(a.x, a.y, a.z)
        end)
    end

    local mesh = handle:FindFirstChildOfClass("SpecialMesh")
    if mesh then
        local b = bases[id]
        if not b then
            b = { c0 = nil, scale = mesh.Scale }
            bases[id] = b
        end
        if not b.scale then b.scale = mesh.Scale end
        pcall(function()
            mesh.Scale = b.scale * Vector3.new(a.s, a.s, a.s)
        end)
    end
end

local function resetAdjust(id)
    adjust[id] = { x = 0, y = 0, z = 0, s = 1 }
    local char = localPlayer.Character
    if char then
        local b = bases[id]
        local obj = char:FindFirstChild("CustomAcc_" .. tostring(id))
        if obj and b then
            local handle = obj:FindFirstChild("Handle") or obj
            local weld = handle:FindFirstChildOfClass("Weld")
            if weld and b.c0 then pcall(function() weld.C0 = b.c0 end) end
            local mesh = handle:FindFirstChildOfClass("SpecialMesh")
            if mesh and b.scale then pcall(function() mesh.Scale = b.scale end) end
        end
    end
end

-- Pastikan adjust TIDAK hilang saat respawn: ulang terus sampai
-- semua aksesori yang di-adjust benar-benar ada di karakter baru
local function reapplyAllAdjusts(char)
    task.spawn(function()
        for _ = 1, 20 do
            task.wait(0.5)
            if not char or not char.Parent then return end
            local missing = 0
            for id, onA in pairs(state.acc) do
                if onA then
                    local a = adjust[id]
                    if a and (a.x ~= 0 or a.y ~= 0 or a.z ~= 0 or a.s ~= 1) then
                        if char:FindFirstChild("CustomAcc_" .. tostring(id)) then
                            applyAdjustToChar(char, id)
                        else
                            missing = missing + 1
                        end
                    end
                end
            end
            if missing == 0 then return end
        end
    end)
end

------------------------------------------------------------
-- Toggle dispatch
------------------------------------------------------------
local function stateFor(key)
    if key == "korblox" then return state.korblox end
    if key == "headless" then return state.headless end
    if key == "face" then return state.face end
    if key == "clearface" then return state.clearFace end
    if key == "clearclothes" then return state.clearClothes end
    if key == "clearacc" then return state.clearAcc end
    local fxKey = key:match("^fx_(%w+)$")
    if fxKey then return state.fx[fxKey] or false end
    if key:match("^mat_%w+$") then return state.materialMode == key:sub(5) end
    if key == "fog" then return state.fog end
    local id = tonumber(key)
    return id and state.acc[id] or false
end

local function setFeature(key, on)
    local char = localPlayer.Character
    if key == "korblox" then
        state.korblox = on
        if char then
            if restore.korblox then unapplyKorblox(char, restore.korblox) end
            restore.korblox = on and applyKorblox(char) or nil
        end
    elseif key == "headless" then
        state.headless = on
        if char then
            if restore.headless then unapplyHeadless(restore.headless) end
            restore.headless = on and applyHeadless(char) or nil
        end
    elseif key == "face" then
        state.face = on
        if char then
            if on then
                task.spawn(attachFace, char)
            else
                detachFace(char)
            end
        end
    elseif key == "clearface" then
        state.clearFace = on
        if char then applyClearFace(char, on) end
    elseif key == "clearclothes" then
        state.clearClothes = on
        if char then applyClearClothes(char, on) end
    elseif key == "clearacc" then
        state.clearAcc = on
        if char then applyClearAcc(char, on) end
    elseif key == "fx_trail" then
        setFx("trail", on)
    elseif key == "fx_api" then
        setFx("api", on)
    elseif key == "fx_petir" then
        setFx("petir", on)
    elseif key == "fx_sparkles" then
        setFx("sparkles", on)
    elseif key == "fx_asap" then
        setFx("asap", on)
    elseif key:match("^mat_%w+$") then
        local mode = key:sub(5)
        if on then
            state.materialMode = mode
            -- retry sampai karakter siap (mirip FX), biar pasti kepasang
            task.spawn(function()
                for _ = 1, 12 do
                    local c = localPlayer.Character
                    if c and c:FindFirstChildOfClass("Humanoid") then
                        if state.materialMode == mode then
                            applyMaterialMode(c, mode)
                        end
                        return
                    end
                    task.wait(0.3)
                end
            end)
        else
            if char and state.materialMode == mode then
                applyMaterialMode(char, nil)
            end
            state.materialMode = nil
        end
    elseif key == "fog" then
        state.fog = on
        applyFog(on)
    else
        local id = tonumber(key)
        if not id then return end
        state.acc[id] = on
        if char then
            if on then
                task.spawn(attachAccessory, char, id)
            else
                detachAccessory(char, id)
            end
        end
    end
end

-- Re-apply enabled features on respawn
local function reapplyEnabled(char)
    restore.korblox = nil
    restore.headless = nil
    local humanoid = char:WaitForChild("Humanoid", 10)
    if not humanoid then return end
    task.wait(0.2)
    applyStats(char)
    if state.headless then restore.headless = applyHeadless(char) end
    if state.korblox then restore.korblox = applyKorblox(char) end
    if state.face then task.spawn(attachFace, char) end
    for id, onA in pairs(state.acc) do
        if onA then task.spawn(attachAccessory, char, id) end
    end
    if activeAnimPack ~= "Default" then
        local packName = activeAnimPack
        task.spawn(function()
            for _ = 1, 8 do
                task.wait(0.5)
                if applyAnimPack(packName) then break end
            end
        end)
    end
    reapplyAllAdjusts(char)
    if state.clearFace or state.clearClothes or state.clearAcc then
        task.delay(1.2, function()
            if char and char.Parent then applyAllClears(char) end
        end)
        task.delay(3.0, function()
            if char and char.Parent then applyAllClears(char) end
        end)
    end
    task.delay(0.8, function()
        if not (char and char.Parent) then return end
        applyAllFx(char)
        applyScales(char)
        applyBodyColor(char)
        applyNametag(char)
        applyGravity()
        applyCamera()
        if state.fog then applyFog(true) end
    end)
end

if localPlayer.Character then
    task.spawn(reapplyEnabled, localPlayer.Character)
end
localPlayer.CharacterAdded:Connect(function(char)
    task.spawn(reapplyEnabled, char)
end)

------------------------------------------------------------
-- GUI
------------------------------------------------------------
local C = {
    bg     = Color3.fromRGB(23, 23, 27),
    card   = Color3.fromRGB(33, 33, 39),
    hov    = Color3.fromRGB(41, 41, 48),
    text   = Color3.fromRGB(235, 236, 240),
    sub    = Color3.fromRGB(138, 140, 150),
    accent = Color3.fromRGB(255, 106, 26),
    off    = Color3.fromRGB(58, 58, 66),
}

local function new(className, props, parent)
    local inst = nil
    pcall(function() inst = Instance.new(className) end)
    if not inst then return nil end
    for k, v in pairs(props or {}) do
        pcall(function() inst[k] = v end)
    end
    if parent then pcall(function() inst.Parent = parent end) end
    return inst
end

local function corner(radius, parent)
    if not parent then return nil end
    return new("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function stroke(parent, color, thickness)
    if not parent then return nil end
    return new("UIStroke", { Color = color, Thickness = thickness }, parent)
end

local function fieryGradient(parent, rotation)
    if not parent then return nil end
    return new("UIGradient", {
        Color = ColorSequence.new(Color3.fromRGB(255, 190, 80), Color3.fromRGB(255, 70, 40)),
        Rotation = rotation or 45,
    }, parent)
end

local vp = Vector2.new(800, 450)
pcall(function()
    local cam = workspace.CurrentCamera
    if cam and cam.ViewportSize.X > 50 then
        vp = cam.ViewportSize
    end
end)

local panelW = math.floor(math.min(480, vp.X - 16))
local cols = 3
if panelW < 430 then cols = 2 end
if panelW < 270 then cols = 1 end
local rowH, gap = 32, 5

------------------------------------------------------------
-- Ikon vektor (digambar pakai Frame — bebas glyph rusak/[])
------------------------------------------------------------
local function drawX(parent, color, size)
    local s = size or 11
    for _, r in ipairs({ 45, -45 }) do
        local bar = new("Frame", {
            Size = UDim2.fromOffset(s, 2),
            Position = UDim2.new(0.5, -s / 2, 0.5, -1),
            Rotation = r,
            BackgroundColor3 = color or C.sub,
            BorderSizePixel = 0,
        }, parent)
        corner(1, bar)
    end
end

local function drawGear(parent, color)
    local col = color or C.sub
    for i = 0, 1 do
        local y = 5 + i * 6
        new("Frame", {
            Size = UDim2.new(1, -8, 0, 2),
            Position = UDim2.new(0, 4, 0, y),
            BackgroundColor3 = col, BorderSizePixel = 0,
        }, parent)
        local knob = new("Frame", {
            Size = UDim2.fromOffset(5, 5),
            Position = UDim2.new(0, (i == 0) and 10 or 4, 0, y - 1.5),
            BackgroundColor3 = col, BorderSizePixel = 0,
        }, parent)
        corner(2, knob)
    end
end

local function drawPlay(parent, color)
    local col = color or C.accent
    local heights = { 12, 9.5, 7, 4.5, 2 }
    for i, h in ipairs(heights) do
        new("Frame", {
            Size = UDim2.fromOffset(2, h),
            Position = UDim2.new(0, (i - 1) * 2, 0.5, -h / 2),
            BackgroundColor3 = col, BorderSizePixel = 0,
        }, parent)
    end
end

local function drawDiamond(parent, color)
    local d = new("Frame", {
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.new(0.5, -4, 0.5, -4),
        Rotation = 45,
        BackgroundColor3 = color or Color3.fromRGB(120, 200, 255),
        BorderSizePixel = 0,
    }, parent)
    corner(2, d)
end

local function drawChevron(parent, color)
    local col = color or C.accent
    local b1 = new("Frame", {
        Size = UDim2.fromOffset(7, 2),
        Position = UDim2.new(0.5, -4, 0.5, -3.5),
        Rotation = 45, BackgroundColor3 = col, BorderSizePixel = 0,
    }, parent)
    corner(1, b1)
    local b2 = new("Frame", {
        Size = UDim2.fromOffset(7, 2),
        Position = UDim2.new(0.5, -4, 0.5, 1.5),
        Rotation = -45, BackgroundColor3 = col, BorderSizePixel = 0,
    }, parent)
    corner(1, b2)
end

local function xButton(parent, pos, size, cb)
    local b = new("TextButton", {
        Size = size, Position = pos, Text = "",
        AutoButtonColor = false, BackgroundColor3 = C.hov, BorderSizePixel = 0,
    }, parent)
    corner(6, b)
    if b then
        drawX(b, C.sub)
        b.MouseEnter:Connect(function() b.BackgroundColor3 = C.card end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = C.hov end)
        b.MouseButton1Click:Connect(cb)
    end
    return b
end

------------------------------------------------------------
-- Tab data
------------------------------------------------------------
local TABS = { "body", "face", "acc", "anim", "emote", "clear", "char", "fx", "world", "cari" }
local TAB_NAMES = {
    body = "Body", face = "Face", acc = "Acc", anim = "Anim", emote = "Emote",
    clear = "Clear", char = "Char", fx = "FX", world = "World", cari = "Cari",
}
local activeTab = "body"

local ALLROWS = {
    { tab = "body", kind = "stat",   stat = "walk", label = "WalkSpeed", sub = "movement speed" },
    { tab = "body", kind = "stat",   stat = "jump", label = "JumpPower", sub = "jump height" },
    { tab = "body", kind = "toggle", key = "korblox",  label = "Korblox Leg", sub = "crystal leg • R6/R15" },
    { tab = "body", kind = "toggle", key = "headless", label = "Headless",    sub = "hide head & face" },
    { tab = "face", kind = "toggle", key = "face", label = "Super Super Happy Face", sub = "494291269 • decal face", gear = false },
}
for _, item in ipairs(ACC_ITEMS) do
    if item.cat == "face" then
        table.insert(ALLROWS, { tab = "face", kind = "toggle", key = tostring(item.id), label = item.name, sub = item.sub .. " • bisa digeser", gear = true, scale = false })
    end
end
table.insert(ALLROWS, { tab = "acc", kind = "header", label = "KEPALA" })
for _, item in ipairs(ACC_ITEMS) do
    if item.cat == "head" then
        table.insert(ALLROWS, { tab = "acc", kind = "toggle", key = tostring(item.id), label = item.name, sub = item.sub, gear = true, scale = true })
    end
end
table.insert(ALLROWS, { tab = "acc", kind = "header", label = "LAINNYA" })
for _, item in ipairs(ACC_ITEMS) do
    if item.cat == "other" then
        table.insert(ALLROWS, { tab = "acc", kind = "toggle", key = tostring(item.id), label = item.name, sub = item.sub, gear = true, scale = true })
    end
end
for _, name in ipairs({ "Default", "Toy", "Zombie", "Ninja", "Robot", "Astronaut", "Superhero", "Bubbly", "Cartoony", "Pirate", "Knight", "Mage" }) do
    table.insert(ALLROWS, { tab = "anim", kind = "anim", pack = name, label = name, sub = name == "Default" and "balik ke bawaan" or "animation pack" })
end
for _, e in ipairs(EMOTES) do
    table.insert(ALLROWS, { tab = "emote", kind = "emote", emote = e.name, label = e.name, sub = "play emote" })
end
table.insert(ALLROWS, { tab = "emote", kind = "animinput", label = "Emote by ID", sub = "putar emote/animasi pakai ID", h = 34, loop = false, placeholder = "paste ID emote..." })
table.insert(ALLROWS, { tab = "emote", kind = "header", label = "DANCE RESMI - PASTI JALAN (bebas dipakai)" })
for _, d in ipairs(DANCES) do
    table.insert(ALLROWS, { tab = "emote", kind = "emoteid", id = d.id, label = d.name, sub = "dance resmi Roblox" })
end
table.insert(ALLROWS, { tab = "emote", kind = "header", label = "ANIMASI SERU KLASIK (gaya FE hub, bebas)" })
local CLASSIC_ANIMS = {
    { id = 181526230,  label = "Faint",        sub = "pingsan jatuh" },
    { id = 181525546,  label = "Floor Faint",  sub = "pingsan lantai" },
    { id = 313762630,  label = "Levitate",     sub = "melayang" },
    { id = 188632011,  label = "Spinner",      sub = "berputar" },
    { id = 179224234,  label = "Float Sit",    sub = "duduk melayang" },
    { id = 180612465,  label = "Scared",       sub = "ketakutan" },
    { id = 429703734,  label = "Moving Dance", sub = "charleston", loop = true },
    { id = 429730430,  label = "Spin Dance",   sub = "joget putar", loop = true },
    { id = 186934910,  label = "Spin Dance 2", sub = "putar pedang", loop = true },
    { id = 204292303,  label = "Bow Down",     sub = "membungkuk" },
    { id = 204295235,  label = "Sword Slam",   sub = "hentakan pedang" },
    { id = 33796059,   label = "Insane",       sub = "joget gila", loop = true },
    { id = 184574340,  label = "Mega Insane",  sub = "joget mega", loop = true },
    { id = 35978879,   label = "Sword Slice",  sub = "tebasan" },
    { id = 35154961,   label = "Head Throw",   sub = "lempar kepala" },
    { id = 204328711,  label = "Dino Walk",    sub = "jalan dino", loop = true },
    { id = 215384594,  label = "Griffin Fly",  sub = "terbang", loop = true },
}
for _, a in ipairs(CLASSIC_ANIMS) do
    table.insert(ALLROWS, { tab = "emote", kind = "emoteid", id = a.id, label = a.label, sub = a.sub, loop = a.loop })
end

-- Ambil emote yang TERPASANG di avatar (kayak halaman My Avatar)
-- dan jadikan baris yang bisa diputar langsung lewat ID-nya.
local function refreshEmoteRows()
    for i = #ALLROWS, 1, -1 do
        local d = ALLROWS[i]
        if d.tab == "emote" and d.dyn then table.remove(ALLROWS, i) end
    end
    local h = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not h then return end
    local okDesc, desc = pcall(function() return h:GetAppliedDescription() end)
    local em = okDesc and desc and desc.Emotes
    if type(em) ~= "table" then return end
    local slots = {}
    for slot, id in pairs(em) do
        if type(id) == "number" and id > 0 then
            table.insert(slots, { slot = slot, id = id })
        end
    end
    table.sort(slots, function(a, b) return a.slot < b.slot end)
    if #slots == 0 then return end
    table.insert(ALLROWS, { tab = "emote", kind = "header", label = "EMOTE TERPASANG DI AVATAR KAMU", dyn = true })
    for _, s in ipairs(slots) do
        table.insert(ALLROWS, {
            tab = "emote", kind = "emoteid", id = s.id, dyn = true,
            label = "Emote Slot " .. s.slot, sub = "ID " .. tostring(s.id),
        })
    end
end
table.insert(ALLROWS, { tab = "clear", kind = "toggle", key = "clearface", label = "Hapus Face", sub = "sembunyikan wajah • toggle balik", gear = false })
table.insert(ALLROWS, { tab = "clear", kind = "toggle", key = "clearclothes", label = "Hapus Baju", sub = "lepas baju, celana, kaos", gear = false })
table.insert(ALLROWS, { tab = "clear", kind = "toggle", key = "clearacc", label = "Hapus Aksesoris", sub = "lepas rambut/topi avatar • item japscript aman", gear = false })

-- Char: ukuran, warna, nametag, pose
table.insert(ALLROWS, { tab = "char", kind = "header", label = "UKURAN (R15)" })
table.insert(ALLROWS, { tab = "char", kind = "slider", label = "Tinggi", sub = "body height",
    min = 0.6, max = 1.4, step = 0.05, fmt = "%.2f",
    get = function() return state.scales.height end,
    set = function(v) state.scales.height = v; state.scalesTouched = true; applyScales(localPlayer.Character) end })
table.insert(ALLROWS, { tab = "char", kind = "slider", label = "Lebar", sub = "body width",
    min = 0.6, max = 1.4, step = 0.05, fmt = "%.2f",
    get = function() return state.scales.width end,
    set = function(v) state.scales.width = v; state.scalesTouched = true; applyScales(localPlayer.Character) end })
table.insert(ALLROWS, { tab = "char", kind = "slider", label = "Ukuran Kepala", sub = "head size",
    min = 0.5, max = 1.5, step = 0.05, fmt = "%.2f",
    get = function() return state.scales.head end,
    set = function(v) state.scales.head = v; state.scalesTouched = true; applyScales(localPlayer.Character) end })
table.insert(ALLROWS, { tab = "char", kind = "slider", label = "Proporsi", sub = "proportion",
    min = 0, max = 1, step = 0.1, fmt = "%.1f",
    get = function() return state.scales.prop end,
    set = function(v) state.scales.prop = v; state.scalesTouched = true; applyScales(localPlayer.Character) end })
table.insert(ALLROWS, { tab = "char", kind = "slider", label = "Body Type", sub = "body type",
    min = 0, max = 1, step = 0.1, fmt = "%.1f",
    get = function() return state.scales.bodytype end,
    set = function(v) state.scales.bodytype = v; state.scalesTouched = true; applyScales(localPlayer.Character) end })
table.insert(ALLROWS, { tab = "char", kind = "header", label = "TAMPILAN" })
table.insert(ALLROWS, { tab = "char", kind = "swatches", label = "Warna Badan", sub = "pilih warna kulit/badan", h = 54 })
table.insert(ALLROWS, { tab = "char", kind = "nametag", label = "Nametag Custom", sub = "tulisan di atas kepala", h = 34 })
table.insert(ALLROWS, { tab = "char", kind = "action", label = "T-Pose", sub = "bekukan karakter tanpa animasi",
    onTap = function() applyTPose(localPlayer.Character) end, notifyText = "T-pose aktif" })
table.insert(ALLROWS, { tab = "char", kind = "action", label = "Pulihkan Animasi", sub = "balik dari T-pose",
    onTap = function() stopTPose(localPlayer.Character) end, notifyText = "Animasi dipulihkan" })

-- FX: efek visual
table.insert(ALLROWS, { tab = "fx", kind = "header", label = "EFEK" })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "fx_trail", label = "Rainbow Trail", sub = "jejak pelangi saat gerak", gear = false })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "fx_api", label = "Aura Api", sub = "partikel api naik", gear = false })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "fx_petir", label = "Aura Petir", sub = "percikan listrik + cahaya", gear = false })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "fx_sparkles", label = "Sparkles", sub = "kelap-kelip emas", gear = false })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "fx_asap", label = "Aura Asap", sub = "asap mengepul", gear = false })
table.insert(ALLROWS, { tab = "fx", kind = "header", label = "MATERIAL BADAN (pilih satu)" })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "mat_neon", label = "Glow / Neon", sub = "badan menyala", gear = false, radio = "mat" })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "mat_glass", label = "Kaca", sub = "badan transparan", gear = false, radio = "mat" })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "mat_gold", label = "Emas", sub = "metalik kuning", gear = false, radio = "mat" })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "mat_ice", label = "Es", sub = "dingin & licin", gear = false, radio = "mat" })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "mat_force", label = "ForceField", sub = "kilau klasik Roblox", gear = false, radio = "mat" })
table.insert(ALLROWS, { tab = "fx", kind = "toggle", key = "mat_diamond", label = "Berlian", sub = "tubuh motif diamond plate", gear = false, radio = "mat" })

-- World: waktu, kabut, fisika, kamera
table.insert(ALLROWS, { tab = "world", kind = "header", label = "WAKTU & CUACA" })
table.insert(ALLROWS, { tab = "world", kind = "timebtns", label = "Waktu Dunia", sub = "siang / sore / malam (client-side)" })
table.insert(ALLROWS, { tab = "world", kind = "toggle", key = "fog", label = "Kabut", sub = "kabut tebal misterius", gear = false })
table.insert(ALLROWS, { tab = "world", kind = "header", label = "FISIKA & KAMERA" })
table.insert(ALLROWS, { tab = "world", kind = "slider", label = "Gravitasi", sub = "0 = melayang ala luar angkasa",
    min = 0, max = 196, step = 8, fmt = "%.0f",
    get = function() return state.world.gravity end,
    set = function(v) state.world.gravity = v; state.worldTouched = true; applyGravity() end })
table.insert(ALLROWS, { tab = "world", kind = "slider", label = "FOV Kamera", sub = "sudut pandang",
    min = 50, max = 120, step = 5, fmt = "%.0f",
    get = function() return state.world.fov end,
    set = function(v) state.world.fov = v; state.worldTouched = true; applyCamera() end })
table.insert(ALLROWS, { tab = "world", kind = "slider", label = "Zoom Maks", sub = "sejauh apa kamera bisa keluar",
    min = 10, max = 400, step = 10, fmt = "%.0f",
    get = function() return state.world.zoom end,
    set = function(v) state.world.zoom = v; state.worldTouched = true; applyCamera() end })

-- Anim: dance & custom ID
table.insert(ALLROWS, { tab = "anim", kind = "header", label = "DANCE & CUSTOM" })
for _, d in ipairs(DANCES) do
    table.insert(ALLROWS, { tab = "anim", kind = "action", label = d.name, sub = "dance loop • anim resmi",
        onTap = function() playCustomAnim(d.id, true) end, notifyText = d.name .. " diputar" })
end
table.insert(ALLROWS, { tab = "anim", kind = "action", label = "Stop Anim", sub = "hentikan dance/custom anim",
    onTap = stopCustomAnim, notifyText = "Animasi dihentikan" })
table.insert(ALLROWS, { tab = "anim", kind = "animinput", label = "Custom Anim ID", sub = "paste ID animasi apa pun", h = 34 })

local guiParent = nil
pcall(function()
    if gethui then guiParent = gethui() end
end)
if not guiParent then
    pcall(function() guiParent = localPlayer:WaitForChild("PlayerGui") end)
end
if not guiParent then return end

pcall(function()
    local oldGui = guiParent:FindFirstChild("japscript_ui")
    if oldGui then oldGui:Destroy() end
    for _, g in ipairs(guiParent:GetChildren()) do
        if g.Name == "japscript_preview" or g.Name == "japscript_adjust" then g:Destroy() end
    end
end)

local gui = new("ScreenGui", {
    Name = "japscript_ui",
    ResetOnSpawn = false,
    DisplayOrder = 100,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, guiParent)
if not gui then return end

-- ScreenGui terpisah biar adjust & preview selalu DI DEPAN panel
local adjustGui = new("ScreenGui", {
    Name = "japscript_adjust",
    ResetOnSpawn = false,
    DisplayOrder = 150,
}, guiParent)
local previewGui = new("ScreenGui", {
    Name = "japscript_preview",
    ResetOnSpawn = false,
    DisplayOrder = 120,
}, guiParent)

------------------------------------------------------------
-- Loading screen
------------------------------------------------------------
local loading = new("Frame", {
    Name = "Loading",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(10, 10, 12),
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
}, gui)

local loadingDone = false
if loading then
    local card = new("Frame", {
        Size = UDim2.fromOffset(190, 128),
        Position = UDim2.new(0.5, -95, 0.5, -64),
        BackgroundColor3 = C.bg,
        BorderSizePixel = 0,
    }, loading)
    corner(14, card)
    stroke(card, Color3.fromRGB(48, 48, 56), 1)
    if card then
        local logoBox = new("Frame", {
            Size = UDim2.fromOffset(40, 40),
            Position = UDim2.new(0.5, -20, 0, 14),
            BackgroundColor3 = C.card, BorderSizePixel = 0,
        }, card)
        corner(10, logoBox)
        stroke(logoBox, C.accent, 1.5)
        new("TextLabel", {
            Text = "J", Font = Enum.Font.GothamBlack, TextSize = 20,
            TextColor3 = C.accent, BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
        }, logoBox)
        new("TextLabel", {
            Text = "japscript", Font = Enum.Font.GothamBold, TextSize = 14,
            TextColor3 = C.text, BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 60), Size = UDim2.new(1, 0, 0, 16),
        }, card)
        local barBg = new("Frame", {
            Size = UDim2.fromOffset(140, 6),
            Position = UDim2.new(0.5, -70, 0, 88),
            BackgroundColor3 = C.off, BorderSizePixel = 0,
        }, card)
        corner(3, barBg)
        local barFill = new("Frame", {
            Size = UDim2.new(0.18, 0, 1, 0),
            BackgroundColor3 = C.accent, BorderSizePixel = 0,
        }, barBg)
        corner(3, barFill)
        fieryGradient(barFill, 90)
        task.spawn(function()
            while not loadingDone do
                if not barFill or not barFill.Parent then break end
                pcall(function() barFill.Size = UDim2.new(1, 0, 1, 0) end)
                task.wait(0.3)
                if not barFill or not barFill.Parent then break end
                pcall(function() barFill.Size = UDim2.new(0.18, 0, 1, 0) end)
                task.wait(0.3)
            end
        end)
    end
    task.wait(1.3)
    loadingDone = true
    pcall(function() loading:Destroy() end)
end

------------------------------------------------------------
-- Main panel
------------------------------------------------------------
local userMovedMain = false

local main = new("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(panelW, 200),
    Position = UDim2.new(0.5, -math.floor(panelW / 2), 0.5, -100),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Visible = false,
}, gui)
if not main then
    gui:Destroy()
    return
end
corner(12, main)
local mainStroke = stroke(main, Color3.fromRGB(48, 48, 56), 1)
if mainStroke then
    pcall(function()
        mainStroke.Gradient = ColorSequence.new(
            Color3.fromRGB(120, 70, 40), Color3.fromRGB(45, 45, 55)
        )
    end)
end
new("UIPadding", {
    PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
}, main)
new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, main)

-- Title bar
local titleBar = new("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 30),
    LayoutOrder = 0,
}, main)
if titleBar then
    local logoDot = new("Frame", {
        Size = UDim2.fromOffset(12, 12),
        Position = UDim2.new(0, 2, 0.5, -6),
        BackgroundColor3 = C.accent, BorderSizePixel = 0,
    }, titleBar)
    corner(6, logoDot)
    fieryGradient(logoDot, 45)
    new("TextLabel", {
        Text = "japscript", Font = Enum.Font.GothamBold, TextSize = 17,
        TextColor3 = C.text, BackgroundTransparency = 1,
        Position = UDim2.new(0, 22, 0, 0), Size = UDim2.new(0, 120, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, titleBar)
end

-- Ikon: eye (preview), minimize (chevron), close (X)
local function iconButton(kind, posX)
    local b = new("TextButton", {
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, posX, 0.5, -12),
        Text = "", AutoButtonColor = false,
        BackgroundColor3 = C.card, BorderSizePixel = 0,
    }, titleBar)
    corner(7, b)
    if b then
        if kind == "close" then
            drawX(b, C.sub, 12)
        elseif kind == "min" then
            local bar = new("Frame", {
                Size = UDim2.fromOffset(12, 2),
                Position = UDim2.new(0.5, -6, 0.5, -1),
                BackgroundColor3 = C.sub, BorderSizePixel = 0,
            }, b)
            corner(1, bar)
        else -- eye: bentuk solid (tanpa stroke, aman di semua client)
            local eye = new("Frame", {
                Size = UDim2.fromOffset(14, 9),
                Position = UDim2.new(0.5, -7, 0.5, -4.5),
                BackgroundColor3 = C.sub, BorderSizePixel = 0,
            }, b)
            corner(5, eye)
            local pupil = new("Frame", {
                Name = "Pupil",
                Size = UDim2.fromOffset(5, 5),
                Position = UDim2.new(0.5, -2.5, 0.5, -2.5),
                BackgroundColor3 = C.bg, BorderSizePixel = 0,
            }, eye)
            corner(3, pupil)
        end
        local hovCol = kind == "close" and Color3.fromRGB(255, 110, 110) or C.text
        b.MouseEnter:Connect(function()
            b.BackgroundColor3 = C.hov
            for _, x in ipairs(b:GetChildren()) do
                if x:IsA("Frame") then
                    for _, y in ipairs(x:GetChildren()) do
                        if y:IsA("Frame") then y.BackgroundColor3 = hovCol end
                        if y:IsA("UIStroke") then pcall(function() y.Color = hovCol end) end
                    end
                    if x.BackgroundTransparency == 0 then x.BackgroundColor3 = hovCol end
                end
            end
        end)
        b.MouseLeave:Connect(function()
            b.BackgroundColor3 = C.card
            for _, x in ipairs(b:GetChildren()) do
                if x:IsA("Frame") then
                    for _, y in ipairs(x:GetChildren()) do
                        if y:IsA("Frame") then y.BackgroundColor3 = (y.Name == "Pupil") and C.bg or C.sub end
                        if y:IsA("UIStroke") then pcall(function() y.Color = C.sub end) end
                    end
                    if x.BackgroundTransparency == 0 then x.BackgroundColor3 = C.sub end
                end
            end
        end)
    end
    return b
end

local closeBtn = iconButton("close", -26)
local minBtn = iconButton("min", -54)
local eyeBtn = iconButton("eye", -82)

-- Tab bar
local tabBar = new("ScrollingFrame", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 28),
    LayoutOrder = 1,
    CanvasSize = UDim2.new(0, #TABS * 58 + 4, 0, 0),
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = C.accent,
    ScrollBarImageTransparency = 0.5,
    ScrollingDirection = Enum.ScrollingDirection.X,
}, main)
local tabButtons = {}
if tabBar then
    for i, t in ipairs(TABS) do
        local tb = new("TextButton", {
            Size = UDim2.new(0, 54, 1, -3),
            Position = UDim2.new(0, (i - 1) * 58 + 2, 0, 0),
            Text = TAB_NAMES[t],
            Font = Enum.Font.GothamMedium, TextSize = 11,
            BackgroundColor3 = C.card, TextColor3 = C.sub,
            AutoButtonColor = false, BorderSizePixel = 0,
        }, tabBar)
        corner(6, tb)
        local underline = new("Frame", {
            Size = UDim2.new(1, -10, 0, 2),
            Position = UDim2.new(0, 5, 1, -4),
            BackgroundColor3 = C.accent, BorderSizePixel = 0,
            Visible = false,
        }, tb)
        corner(1, underline)
        if tb then
            tabButtons[t] = { btn = tb, underline = underline }
            tb.MouseButton1Click:Connect(function()
                if activeTab ~= t then
                    activeTab = t
                    refreshTabs()
                    rebuildContent()
                end
            end)
        end
    end
end

function refreshTabs()
    for t, v in pairs(tabButtons) do
        local on = t == activeTab
        if v.btn then
            v.btn.TextColor3 = on and C.text or C.sub
            v.btn.BackgroundColor3 = on and C.hov or C.card
        end
        if v.underline then v.underline.Visible = on end
    end
end

-- Content holder
-- Search box (tab Acc)
local searchQuery = ""
local rowRegistry = {}

local searchBar = new("Frame", {
    BackgroundColor3 = C.card,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 22),
    LayoutOrder = 1.5,
    Visible = false,
}, main)
local searchBox = nil
if searchBar then
    corner(8, searchBar)
    searchBox = new("TextBox", {
        PlaceholderText = "cari aksesoris...",
        Text = "",
        Font = Enum.Font.Gotham, TextSize = 10,
        TextColor3 = C.text, PlaceholderColor3 = C.sub,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -38, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
    }, searchBar)
    xButton(searchBar, UDim2.new(1, -22, 0.5, -8), UDim2.fromOffset(16, 16), function()
        if searchBox then searchBox.Text = "" end
        searchQuery = ""
        for _, r in ipairs(rowRegistry) do
            if r.frame then r.frame.Visible = true end
        end
    end)
end

local function filterAccRows()
    local q = searchQuery
    for _, r in ipairs(rowRegistry) do
        if r.frame then
            if q == "" then
                r.frame.Visible = true
            else
                r.frame.Visible = (r.name:find(q, 1, true) ~= nil)
            end
        end
    end
end

if searchBox then
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchQuery = searchBox.Text:lower()
        filterAccRows()
    end)
end

local holder = new("ScrollingFrame", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 100),
    LayoutOrder = 2,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = C.accent,
    ClipsDescendants = true,
}, main)
if not holder or not holder:IsA("ScrollingFrame") then
    holder = new("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 100),
        LayoutOrder = 2,
        ClipsDescendants = true,
    }, main)
end

-- Footer: status + FPS + credit
local footer = new("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 14),
    LayoutOrder = 99,
}, main)
local footerLabel = nil
local creditBtn = nil
if footer then
    footerLabel = new("TextLabel", {
        Text = "v7 • aktif: 0 • -- fps",
        Font = Enum.Font.Gotham, TextSize = 9,
        TextColor3 = C.sub, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, -92, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, footer)
    creditBtn = new("TextButton", {
        Text = "japvisblox",
        Font = Enum.Font.GothamBold, TextSize = 9,
        TextColor3 = C.accent, BackgroundTransparency = 1,
        Position = UDim2.new(1, -90, 0, 0),
        Size = UDim2.new(0, 76, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        AutoButtonColor = false,
    }, footer)
    if creditBtn then
        local chev = new("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(12, 12),
            Position = UDim2.new(1, -13, 0.5, -6),
        }, creditBtn)
        if chev then drawChevron(chev, C.accent) end
    end
end

local fpsValue = 0
pcall(function()
    local RunService = game:GetService("RunService")
    local frames, acc = 0, 0
    RunService.RenderStepped:Connect(function(dt)
        frames = frames + 1
        acc = acc + dt
        if acc >= 0.5 then
            fpsValue = math.floor(frames / acc + 0.5)
            frames, acc = 0, 0
            updateFooter()
        end
    end)
end)

local function countActive()
    local n = 0
    if state.korblox then n = n + 1 end
    if state.headless then n = n + 1 end
    if state.face then n = n + 1 end
    for _, onA in pairs(state.acc) do
        if onA then n = n + 1 end
    end
    return n
end

function updateFooter()
    if footerLabel then
        footerLabel.Text = "v7 • aktif: " .. countActive() .. " • " .. (fpsValue > 0 and (fpsValue .. " fps") or "-- fps")
    end
end

------------------------------------------------------------
-- Notifikasi toast
------------------------------------------------------------
local notifyGui = new("ScreenGui", {
    Name = "japscript_notify",
    ResetOnSpawn = false,
    DisplayOrder = 300,
}, guiParent)
local toast, toastLabel, toastToken = nil, nil, 0

local function notify(text)
    if not notifyGui then return end
    if not toast then
        toast = new("Frame", {
            Size = UDim2.fromOffset(220, 26),
            Position = UDim2.new(0.5, -110, 0, 10),
            BackgroundColor3 = C.bg,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            Visible = false,
        }, notifyGui)
        if toast then
            corner(8, toast)
            stroke(toast, C.accent, 1)
            local dot = new("Frame", {
                Size = UDim2.fromOffset(6, 6),
                Position = UDim2.new(0, 9, 0.5, -3),
                BackgroundColor3 = C.accent, BorderSizePixel = 0,
            }, toast)
            corner(3, dot)
            fieryGradient(dot, 45)
            toastLabel = new("TextLabel", {
                Text = "", Font = Enum.Font.GothamMedium, TextSize = 11,
                TextColor3 = C.text, BackgroundTransparency = 1,
                Position = UDim2.new(0, 22, 0, 0), Size = UDim2.new(1, -30, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
            }, toast)
        end
    end
    if not toast then return end
    if toastLabel then toastLabel.Text = tostring(text) end
    toast.Visible = true
    toast.BackgroundTransparency = 0.1
    toastToken = toastToken + 1
    local myToken = toastToken
    task.spawn(function()
        task.wait(1.8)
        if toastToken ~= myToken then return end
        for i = 1, 8 do
            if toastToken ~= myToken or not toast or not toast.Parent then return end
            pcall(function()
                toast.BackgroundTransparency = 0.1 + (i / 8) * 0.9
                if toastLabel then toastLabel.TextTransparency = (i / 8) end
            end)
            task.wait(0.05)
        end
        if toastToken == myToken and toast then
            toast.Visible = false
            if toastLabel then pcall(function() toastLabel.TextTransparency = 0 end) end
        end
    end)
end

-- Credit yang bisa diklik
if creditBtn then
    creditBtn.MouseButton1Click:Connect(function()
        local url = "https://github.com/JAPofc/japvisblox"
        pcall(function()
            if setclipboard then setclipboard(url) end
        end)
        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(url)
        end)
        notify("Credit: JAPofc/japvisblox • link disalin")
    end)
end

------------------------------------------------------------
-- Adjust popup (ScreenGui terpisah => selalu paling depan)
------------------------------------------------------------
local adjPopup, adjTitle, adjValue, adjId = nil, nil, nil, nil
local sRowParts = {}

local function fmtAdj(a)
    return string.format("X %.1f  Y %.1f  Z %.1f  S %.1f", a.x, a.y, a.z, a.s)
end

local function mkBtn(parent, text, pos, size, cb)
    local b = new("TextButton", {
        Size = size, Position = pos,
        Text = text, Font = Enum.Font.GothamBold, TextSize = 11,
        TextColor3 = C.text, BackgroundColor3 = C.card,
        AutoButtonColor = false, BorderSizePixel = 0,
    }, parent)
    corner(6, b)
    if b then
        b.MouseEnter:Connect(function() b.BackgroundColor3 = C.hov end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = C.card end)
        b.MouseButton1Click:Connect(cb)
    end
    return b
end

local function bumpAdj(axis, delta)
    if not adjId then return end
    local a = adjFor(adjId)
    local v = a[axis] + delta
    if axis == "s" then
        v = math.clamp(v, 0.2, 3)
    else
        v = math.clamp(v, -3, 3)
    end
    a[axis] = math.floor(v * 10 + 0.5) / 10
    if adjValue then adjValue.Text = fmtAdj(a) end
    pcall(applyAdjustToChar, localPlayer.Character, adjId)
end

local function openAdjust(id, name, allowScale)
    if not adjustGui then return end
    if not adjPopup then
        adjPopup = new("Frame", {
            Name = "Adjust",
            Size = UDim2.fromOffset(252, 180),
            Position = UDim2.new(0.5, -126, 0.5, -90),
            BackgroundColor3 = C.bg,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Visible = false,
        }, adjustGui)
        if adjPopup then
            corner(12, adjPopup)
            stroke(adjPopup, Color3.fromRGB(48, 48, 56), 1)
            adjTitle = new("TextLabel", {
                Text = "", Font = Enum.Font.GothamBold, TextSize = 12,
                TextColor3 = C.text, BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 8), Size = UDim2.new(1, -46, 0, 16),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
            }, adjPopup)
            xButton(adjPopup, UDim2.new(1, -28, 0, 6), UDim2.fromOffset(22, 22), function()
                adjPopup.Visible = false
            end)
            local axes = { { "X", "x" }, { "Y", "y" }, { "Z", "z" }, { "S", "s" } }
            for i, ax in ipairs(axes) do
                local y = 30 + (i - 1) * 24
                local parts = {}
                local lbl = new("TextLabel", {
                    Text = ax[1], Font = Enum.Font.GothamBold, TextSize = 11,
                    TextColor3 = C.accent, BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(0, 14, 0, 20),
                }, adjPopup)
                table.insert(parts, lbl)
                local mb = mkBtn(adjPopup, "-", UDim2.new(0, 30, 0, y), UDim2.fromOffset(30, 20), function()
                    bumpAdj(ax[2], -0.1)
                end)
                table.insert(parts, mb)
                local pb = mkBtn(adjPopup, "+", UDim2.new(1, -40, 0, y), UDim2.fromOffset(30, 20), function()
                    bumpAdj(ax[2], 0.1)
                end)
                table.insert(parts, pb)
                local line = new("Frame", {
                    BackgroundColor3 = C.off, BorderSizePixel = 0,
                    Position = UDim2.new(0, 66, 0, y + 9), Size = UDim2.new(1, -112, 0, 2),
                }, adjPopup)
                table.insert(parts, line)
                if ax[2] == "s" then sRowParts = parts end
            end
            adjValue = new("TextLabel", {
                Text = "", Font = Enum.Font.Gotham, TextSize = 10,
                TextColor3 = C.sub, BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 132), Size = UDim2.new(1, -80, 0, 14),
                TextXAlignment = Enum.TextXAlignment.Left,
            }, adjPopup)
            mkBtn(adjPopup, "reset", UDim2.new(1, -62, 0, 128), UDim2.fromOffset(52, 20), function()
                if adjId then
                    resetAdjust(adjId)
                    if adjValue then adjValue.Text = fmtAdj(adjFor(adjId)) end
                end
            end)
        end
    end
    if adjPopup then
        adjId = id
        if adjTitle then adjTitle.Text = name end
        if adjValue then
            local a = adjFor(id)
            adjValue.Text = allowScale and fmtAdj(a) or string.format("X %.1f  Y %.1f  Z %.1f", a.x, a.y, a.z)
        end
        for _, p in ipairs(sRowParts) do
            if p then p.Visible = allowScale and true or false end
        end
        adjPopup.Visible = true
    end
end

------------------------------------------------------------
-- Preview (tampilan diri) — ViewportFrame + clone karakter
------------------------------------------------------------
local pvWindow, viewport, worldModel, pvCam = nil, nil, nil, nil
local previewOpen = false

local function refreshPreview()
    if not previewOpen or not worldModel or not viewport then return end
    pcall(function()
        for _, ch in ipairs(worldModel:GetChildren()) do ch:Destroy() end
    end)
    local char = localPlayer.Character
    if not char then return end
    local clone = nil
    pcall(function() clone = char:Clone() end)
    if not clone then return end
    -- buang script di clone biar tidak ganggu render
    pcall(function()
        for _, s in ipairs(clone:GetDescendants()) do
            if s:IsA("BaseScript") then pcall(function() s:Destroy() end) end
        end
    end)
    clone.Parent = worldModel
    -- pindahkan rig ke origin supaya kamera pasti melihatnya
    local root = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("Torso") or clone:FindFirstChild("Head")
    if root then
        pcall(function() root.CFrame = CFrame.new(0, 0, 0) end)
    end
    if pvCam then
        pcall(function()
            viewport.CurrentCamera = pvCam
            pvCam.FieldOfView = 45
            pvCam.CFrame = CFrame.new(Vector3.new(3.2, 1.6, 7.5), Vector3.new(0, 0.8, 0))
        end)
    end
end

local function togglePreview()
    if not previewGui then return end
    previewOpen = not previewOpen
    if previewOpen and not pvWindow then
        pvWindow = new("Frame", {
            Name = "Preview",
            Size = UDim2.fromOffset(190, 235),
            Position = UDim2.new(0.5, 70, 0.5, -117),
            BackgroundColor3 = C.bg,
            BorderSizePixel = 0,
            ClipsDescendants = true,
        }, previewGui)
        if pvWindow then
            corner(12, pvWindow)
            stroke(pvWindow, Color3.fromRGB(120, 70, 40), 1)
            local pvTitle = new("TextLabel", {
                Text = "tampilan diri",
                Font = Enum.Font.GothamBold, TextSize = 11,
                TextColor3 = C.accent, BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 6), Size = UDim2.new(1, -60, 0, 16),
                TextXAlignment = Enum.TextXAlignment.Left,
            }, pvWindow)
            xButton(pvWindow, UDim2.new(1, -28, 0, 5), UDim2.fromOffset(22, 22), function()
                previewOpen = false
                if pvWindow then pvWindow.Visible = false end
            end)
            viewport = new("ViewportFrame", {
                Size = UDim2.new(1, -12, 1, -36),
                Position = UDim2.new(0, 6, 0, 28),
                BackgroundColor3 = Color3.fromRGB(15, 15, 18),
                BorderSizePixel = 0,
                LightColor = Color3.fromRGB(255, 255, 255),
                LightBrightness = 2,
                Ambient = Color3.fromRGB(120, 120, 130),
            }, pvWindow)
            corner(8, viewport)
            if viewport then
                worldModel = new("WorldModel", {}, viewport)
                pvCam = new("Camera", {}, viewport)
                if pvCam then
                    pcall(function() viewport.CurrentCamera = pvCam end)
                end
            end
            makeDraggable(pvWindow, pvTitle)
        end
    end
    if pvWindow then
        pvWindow.Visible = previewOpen
    end
    if previewOpen then
        refreshPreview()
        task.spawn(function()
            while previewOpen do
                task.wait(2.5)
                if previewOpen then refreshPreview() end
            end
        end)
    end
end

------------------------------------------------------------
-- Row builders
------------------------------------------------------------
local function makeHeader(text, parent)
    if not parent then return end
    new("TextLabel", {
        Text = text,
        Font = Enum.Font.GothamBold, TextSize = 9,
        TextColor3 = C.accent, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom,
    }, parent)
end

local function makeStatRow(def, parent)
    if not parent then return end
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, rowH),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
    }, parent)
    if not row then return end
    corner(8, row)
    new("TextLabel", {
        Text = def.label, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = C.text, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 3), Size = UDim2.new(1, -110, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    new("TextLabel", {
        Text = def.sub, Font = Enum.Font.Gotham, TextSize = 9,
        TextColor3 = C.sub, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 16), Size = UDim2.new(1, -110, 0, 11),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local val = new("TextLabel", {
        Text = tostring(stats[def.stat]),
        Font = Enum.Font.GothamBold, TextSize = 11,
        TextColor3 = C.accent, BackgroundTransparency = 1,
        Position = UDim2.new(1, -92, 0, 0), Size = UDim2.new(0, 30, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
    }, row)
    local function bump(d)
        stats[def.stat] = math.clamp(stats[def.stat] + d, 8, 250)
        if val then val.Text = tostring(stats[def.stat]) end
        applyStats(localPlayer.Character)
    end
    mkBtn(row, "-", UDim2.new(1, -58, 0.5, -10), UDim2.fromOffset(24, 20), function() bump(-2) end)
    mkBtn(row, "+", UDim2.new(1, -30, 0.5, -10), UDim2.fromOffset(24, 20), function() bump(2) end)
end

local function makeActionRow(def, parent)
    if not parent then return end
    local row = new("TextButton", {
        Size = UDim2.new(1, 0, 0, rowH),
        BackgroundColor3 = C.card,
        AutoButtonColor = false,
        Text = "", BorderSizePixel = 0,
    }, parent)
    if not row then return end
    corner(8, row)
    local label = new("TextLabel", {
        Text = def.label, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = C.text, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 3), Size = UDim2.new(1, -50, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)
    new("TextLabel", {
        Text = def.sub, Font = Enum.Font.Gotham, TextSize = 9,
        TextColor3 = C.sub, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 16), Size = UDim2.new(1, -50, 0, 11),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    -- ikon aksi vektor: play (animasi/aksi) / diamond (emote)
    local iconBox = new("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, -30, 0.5, -8),
    }, row)
    if iconBox then
        if def.kind == "emote" then
            drawDiamond(iconBox, Color3.fromRGB(120, 200, 255))
        else
            drawPlay(iconBox, C.accent)
        end
    end

    row.MouseEnter:Connect(function() row.BackgroundColor3 = C.hov end)
    row.MouseLeave:Connect(function() row.BackgroundColor3 = C.card end)

    row.MouseButton1Click:Connect(function()
        if def.kind == "anim" then
            local okPack = applyAnimPack(def.pack == "Default" and nil or def.pack)
            if def.pack == "Default" then activeAnimPack = "Default" end
            if label then
                label.TextColor3 = C.accent
                task.delay(0.6, function()
                    if label and label.Parent then label.TextColor3 = C.text end
                end)
            end
            if okPack then
                notify("Anim pack: " .. def.label)
            else
                notify("Gagal pasang pack — coba lagi setelah respawn")
            end
        elseif def.kind == "emoteid" then
            if playCustomAnim(def.id, def.loop == true) then
                notify(def.label .. " diputar")
            else
                notify(def.label .. " gagal diputar (ID terkunci)")
            end
        elseif def.kind == "action" then
            if def.onTap then pcall(def.onTap) end
            if def.notifyText then notify(def.notifyText) end
        else
            if playEmoteName(def.emote) then
                notify("Emote: " .. tostring(def.emote))
            else
                notify("Emote " .. tostring(def.emote) .. " tidak tersedia di avatar ini")
            end
        end
        if previewOpen then refreshPreview() end
    end)
end

-- Baris slider: label + nilai + tombol -/+
local function makeSliderRow(def, parent)
    if not parent then return end
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, rowH),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
    }, parent)
    if not row then return end
    corner(8, row)
    new("TextLabel", {
        Text = def.label, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = C.text, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 3), Size = UDim2.new(1, -120, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)
    new("TextLabel", {
        Text = def.sub or "", Font = Enum.Font.Gotham, TextSize = 9,
        TextColor3 = C.sub, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 16), Size = UDim2.new(1, -120, 0, 11),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)
    local val = new("TextLabel", {
        Text = "", Font = Enum.Font.GothamBold, TextSize = 11,
        TextColor3 = C.accent, BackgroundTransparency = 1,
        Position = UDim2.new(1, -102, 0, 0), Size = UDim2.new(0, 40, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
    }, row)
    local fmt = def.fmt or "%.2f"
    local function show()
        if val then val.Text = string.format(fmt, def.get()) end
    end
    local function bump(dir)
        local v = def.get() + dir * def.step
        v = math.clamp(v, def.min, def.max)
        v = math.floor(v * 100 + 0.5) / 100
        pcall(def.set, v)
        show()
    end
    mkBtn(row, "-", UDim2.new(1, -58, 0.5, -10), UDim2.fromOffset(24, 20), function() bump(-1) end)
    mkBtn(row, "+", UDim2.new(1, -30, 0.5, -10), UDim2.fromOffset(24, 20), function() bump(1) end)
    show()
end

-- Baris swatch warna badan
local SWATCHES = {
    "White", "Light stone grey", "Black", "Really red", "Bright orange",
    "Bright yellow", "Bright green", "Teal", "Bright blue",
    "Bright violet", "Magenta", "Reddish brown",
}

local function makeSwatchRow(def, parent)
    if not parent then return end
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, def.h or 54),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
    }, parent)
    if not row then return end
    corner(8, row)
    new("TextLabel", {
        Text = def.label, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = C.text, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 3), Size = UDim2.new(1, -20, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    new("TextLabel", {
        Text = def.sub or "", Font = Enum.Font.Gotham, TextSize = 9,
        TextColor3 = C.sub, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 16), Size = UDim2.new(1, -20, 0, 10),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local bw, bh, pad = 17, 11, 3
    for i, name in ipairs(SWATCHES) do
        local col = (i - 1) % 6
        local rowI = math.floor((i - 1) / 6)
        local brick = BrickColor.new(name)
        local b = new("TextButton", {
            Text = "", AutoButtonColor = false,
            BackgroundColor3 = brick.Color,
            Size = UDim2.fromOffset(bw, bh),
            Position = UDim2.new(0, 10 + col * (bw + pad), 0, 28 + rowI * (bh + 3)),
            BorderSizePixel = 0,
        }, row)
        corner(3, b)
        if b then
            stroke(b, Color3.fromRGB(60, 60, 70), 1)
            b.MouseButton1Click:Connect(function()
                state.bodyColorName = name
                applyBodyColor(localPlayer.Character)
                notify("Warna badan: " .. name)
            end)
        end
    end
end

-- Baris input nametag
local function makeNametagRow(def, parent)
    if not parent then return end
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, def.h or 34),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
    }, parent)
    if not row then return end
    corner(8, row)
    local box = new("TextBox", {
        PlaceholderText = "tulis nametag...",
        Text = state.nametagText,
        Font = Enum.Font.Gotham, TextSize = 10,
        TextColor3 = C.text, PlaceholderColor3 = C.sub,
        BackgroundColor3 = C.hov, BorderSizePixel = 0,
        Position = UDim2.new(0, 6, 0.5, -9),
        Size = UDim2.new(1, -112, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    corner(5, box)
    if box then
        pcall(function()
            local pad = Instance.new("UIPadding", box)
            pad.PaddingLeft = UDim.new(0, 6)
        end)
    end
    mkBtn(row, "Pasang", UDim2.new(1, -100, 0.5, -9), UDim2.fromOffset(52, 18), function()
        if box then
            state.nametagText = box.Text
            applyNametag(localPlayer.Character)
            notify(state.nametagText ~= "" and ("Nametag: " .. state.nametagText) or "Nametag dihapus")
        end
    end)
    xButton(row, UDim2.new(1, -34, 0.5, -9), UDim2.fromOffset(26, 18), function()
        state.nametagText = ""
        if box then box.Text = "" end
        applyNametag(localPlayer.Character)
        notify("Nametag dihapus")
    end)
end

-- Baris tombol waktu dunia
local function makeTimeRow(def, parent)
    if not parent then return end
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, rowH + 6),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
    }, parent)
    if not row then return end
    corner(8, row)
    new("TextLabel", {
        Text = def.label, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = C.text, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 3), Size = UDim2.new(1, -20, 0, 13),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    new("TextLabel", {
        Text = def.sub or "", Font = Enum.Font.Gotham, TextSize = 9,
        TextColor3 = C.sub, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 15), Size = UDim2.new(1, -20, 0, 10),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local opts = { { "Siang", "siang" }, { "Sore", "sore" }, { "Malam", "malam" } }
    local bw = math.floor((120) / 3)
    for i, o in ipairs(opts) do
        mkBtn(row, o[1], UDim2.new(0, 8 + (i - 1) * (bw + 4), 1, -26), UDim2.fromOffset(bw, 20), function()
            applyTime(o[2])
            notify("Waktu: " .. o[1])
        end)
    end
end

-- Baris input custom anim ID
local function makeAnimInputRow(def, parent)
    if not parent then return end
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, def.h or 34),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
    }, parent)
    if not row then return end
    corner(8, row)
    local box = new("TextBox", {
        PlaceholderText = def.placeholder or "paste ID animasi...",
        Text = "",
        Font = Enum.Font.Gotham, TextSize = 10,
        TextColor3 = C.text, PlaceholderColor3 = C.sub,
        BackgroundColor3 = C.hov, BorderSizePixel = 0,
        Position = UDim2.new(0, 6, 0.5, -9),
        Size = UDim2.new(1, -112, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    corner(5, box)
    if box then
        pcall(function()
            local pad = Instance.new("UIPadding", box)
            pad.PaddingLeft = UDim.new(0, 6)
        end)
    end
    mkBtn(row, "Play", UDim2.new(1, -100, 0.5, -9), UDim2.fromOffset(52, 18), function()
        local id = box and tonumber(box.Text)
        if id then
            if playCustomAnim(id, def.loop ~= false) then
                notify("ID #" .. id .. " diputar")
            else
                notify("ID #" .. id .. " gagal diputar (ID tidak valid / terkunci)")
            end
        else
            notify("ID tidak valid")
        end
    end)
    mkBtn(row, "Stop", UDim2.new(1, -42, 0.5, -9), UDim2.fromOffset(34, 18), function()
        stopCustomAnim()
        notify("Animasi dihentikan")
    end)
end

local function makeRow(def, parent)
    if not parent then return end
    local key = def.key
    local row = new("TextButton", {
        Size = UDim2.new(1, 0, 0, rowH),
        BackgroundColor3 = C.card,
        AutoButtonColor = false,
        Text = "", BorderSizePixel = 0,
    }, parent)
    if not row then return end
    corner(8, row)

    local gear = nil
    if def.gear then
        gear = new("TextButton", {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.new(1, -58, 0.5, -10),
            Text = "", BackgroundColor3 = C.hov,
            AutoButtonColor = false, BorderSizePixel = 0,
        }, row)
        corner(6, gear)
        if gear then drawGear(gear, C.sub) end
    end
    local textW = def.gear and -80 or -50

    new("TextLabel", {
        Text = def.label, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = C.text, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 3), Size = UDim2.new(1, textW, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)
    new("TextLabel", {
        Text = def.sub, Font = Enum.Font.Gotham, TextSize = 9,
        TextColor3 = C.sub, BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 16), Size = UDim2.new(1, textW, 0, 11),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)

    local pill = new("Frame", {
        Size = UDim2.fromOffset(26, 14),
        Position = UDim2.new(1, -34, 0.5, -7),
        BackgroundColor3 = C.off, BorderSizePixel = 0,
    }, row)
    corner(7, pill)
    local pillGrad = nil
    if pill then
        pillGrad = fieryGradient(pill, 45)
        if pillGrad then
            pcall(function()
                pillGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
            end)
        end
    end
    local knob = nil
    if pill then
        knob = new("Frame", {
            Size = UDim2.fromOffset(10, 10),
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
        }, pill)
        corner(5, knob)
    end

    row.MouseEnter:Connect(function() row.BackgroundColor3 = C.hov end)
    row.MouseLeave:Connect(function() row.BackgroundColor3 = C.card end)

    local function refresh()
        local on = stateFor(key)
        if pill then
            pill.BackgroundColor3 = on and C.accent or C.off
        end
        if pillGrad then
            pcall(function()
                pillGrad.Color = on and ColorSequence.new(
                    Color3.fromRGB(255, 190, 80), Color3.fromRGB(255, 70, 40)
                ) or ColorSequence.new(
                    Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)
                )
            end)
        end
        if knob then
            knob.Position = on and UDim2.new(1, -12, 0, 2) or UDim2.new(0, 2, 0, 2)
        end
    end

    row.MouseButton1Click:Connect(function()
        local nowOn = not stateFor(key)
        pcall(setFeature, key, nowOn)
        if def.radio and nowOn then
            pcall(rebuildContent)
        else
            refresh()
        end
        pcall(updateFooter)
        notify(def.label .. (nowOn and " - aktif" or " - mati"))
        if previewOpen then refreshPreview() end
    end)

    if gear then
        local scaleAllowed = def.scale ~= false
        gear.MouseButton1Click:Connect(function()
            openAdjust(tonumber(key), def.label, scaleAllowed)
        end)
    end

    refresh()
end

------------------------------------------------------------
-- Content rebuild per tab
------------------------------------------------------------
local colFrames = {}

local function defH(d)
    if d.kind == "header" then return 16 end
    if d.kind == "timebtns" then return rowH + 6 end
    if d.h then return d.h end
    return rowH
end

------------------------------------------------------------
-- Tab Cari: pencarian katalog Roblox by NAME (tanpa ID)
------------------------------------------------------------
local cariBox = nil

local function buildSearchTab(parent)
    -- baris mode
    local modeRow = new("Frame", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
    }, parent)
    corner(8, modeRow)
    local modes = { { "acc", "Aksesoris" }, { "emote", "Emote / Dance" } }
    for i, m in ipairs(modes) do
        local active = searchState.mode == m[1]
        local mb = new("TextButton", {
            Text = m[2], Font = Enum.Font.GothamBold, TextSize = 11,
            TextColor3 = active and Color3.fromRGB(20, 20, 24) or C.sub,
            BackgroundColor3 = active and C.accent or C.hov,
            AutoButtonColor = false, BorderSizePixel = 0,
            Size = UDim2.new(0.5, -6, 1, -6),
            Position = UDim2.new(0, 3 + (i - 1) * 0.5 * 0, 0, 3),
        }, modeRow)
        corner(6, mb)
        if mb then
            mb.Position = UDim2.new((i - 1) * 0.5, 3, 0, 3)
            mb.Size = UDim2.new(0.5, -6, 1, -6)
            mb.MouseButton1Click:Connect(function()
                if searchState.mode ~= m[1] then
                    searchState.mode = m[1]
                    searchState.results = nil
                    searchState.err = nil
                    pcall(rebuildContent)
                end
            end)
        end
    end

    -- tombol reset aksesoris (lepas semua yang dipasang japscript)
    local resetBtn = new("TextButton", {
        Text = "Reset Aksesoris - lepas semua yang dipasang japscript",
        Font = Enum.Font.GothamBold, TextSize = 11,
        TextColor3 = Color3.fromRGB(255, 140, 120),
        BackgroundColor3 = C.card,
        AutoButtonColor = false, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 26),
    }, parent)
    corner(8, resetBtn)
    if resetBtn then
        resetBtn.MouseEnter:Connect(function() resetBtn.BackgroundColor3 = C.hov end)
        resetBtn.MouseLeave:Connect(function() resetBtn.BackgroundColor3 = C.card end)
        resetBtn.MouseButton1Click:Connect(function()
            local n = removeAllCustomAcc()
            pcall(rebuildContent)
            if n > 0 then
                notify("Dilepas: " .. n .. " aksesoris")
            else
                notify("Tidak ada aksesoris japscript terpasang")
            end
            if previewOpen then refreshPreview() end
        end)
    end

    -- baris input + tombol cari
    local inputRow = new("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
    }, parent)
    corner(8, inputRow)
    cariBox = new("TextBox", {
        PlaceholderText = searchState.mode == "acc" and "nama aksesoris... cth: valkyrie" or "nama dance... cth: tomato dance",
        Text = searchState.query,
        Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = C.text, PlaceholderColor3 = C.sub,
        BackgroundColor3 = C.hov, BorderSizePixel = 0,
        Position = UDim2.new(0, 6, 0, 6),
        Size = UDim2.new(1, -118, 0, 24),
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
    }, inputRow)
    corner(6, cariBox)
    if cariBox then
        pcall(function()
            local pad = Instance.new("UIPadding", cariBox)
            pad.PaddingLeft = UDim.new(0, 8)
        end)
        cariBox:GetPropertyChangedSignal("Text"):Connect(function()
            searchState.query = cariBox.Text
        end)
    end
    mkBtn(inputRow, "Cari", UDim2.new(1, -104, 0, 6), UDim2.fromOffset(96, 24), function()
        if cariBox then searchState.query = cariBox.Text end
        searchState.results = nil
        searchState.err = nil
        searchState.busy = true
        pcall(rebuildContent)
        runCatalogSearch()
    end)

    -- status
    if searchState.busy then
        new("TextLabel", {
            Text = "mencari di katalog Roblox...",
            Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = C.sub, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
        }, parent)
    elseif searchState.err then
        new("TextLabel", {
            Text = searchState.err,
            Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = Color3.fromRGB(255, 130, 110), BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
        }, parent)
    end

    -- hasil
    if searchState.results then
        for _, it in ipairs(searchState.results) do
            local rr = new("TextButton", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = C.card,
                AutoButtonColor = false, Text = "", BorderSizePixel = 0,
            }, parent)
            if rr then
                corner(8, rr)
                local priceTxt = it.price and ("R$ " .. tostring(it.price)) or (it.lowestPrice and ("R$ " .. tostring(it.lowestPrice)) or "")
                new("TextLabel", {
                    Text = it.name or "(tanpa nama)",
                    Font = Enum.Font.GothamMedium, TextSize = 12,
                    TextColor3 = C.text, BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 3), Size = UDim2.new(1, -90, 0, 14),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                }, rr)
                local subLine = (it.creatorName or "") .. "  " .. priceTxt
                if searchState.mode ~= "acc" and it.id then
                    subLine = "ID: " .. tostring(it.id) .. "   " .. subLine
                    if it.assetType == 61 then
                        subLine = subLine .. "  (emote: perlu dimiliki)"
                    end
                end
                new("TextLabel", {
                    Text = subLine,
                    Font = Enum.Font.Gotham, TextSize = 9,
                    TextColor3 = C.sub, BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 17), Size = UDim2.new(1, -90, 0, 11),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                }, rr)
                local ab = new("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.new(1, -30, 0.5, -8),
                }, rr)
                if ab then
                    if searchState.mode == "acc" then drawDiamond(ab, C.accent) else drawPlay(ab, C.accent) end
                end
                rr.MouseEnter:Connect(function() rr.BackgroundColor3 = C.hov end)
                rr.MouseLeave:Connect(function() rr.BackgroundColor3 = C.card end)
                rr.MouseButton1Click:Connect(function()
                    if searchState.mode == "acc" then
                        wearFound(it.id)
                        notify("Dipakai: " .. (it.name or "item"))
                    else
                        local okPlay = playFoundEmote(it)
                        if okPlay then
                            notify("Diputar: " .. (it.name or "emote"))
                        else
                            notify("Gagal diputar: item mungkin berbayar/premium")
                        end
                    end
                    if previewOpen then refreshPreview() end
                end)
            end
        end
    end
end

function rebuildContent()
    local isCari = (activeTab == "cari")
    if activeTab == "emote" then pcall(refreshEmoteRows) end
    local defs = {}
    if not isCari then
        for _, d in ipairs(ALLROWS) do
            if d.tab == activeTab then table.insert(defs, d) end
        end
    end
    local n = #defs
    local colsT = math.min(cols, n)
    if colsT < 1 then colsT = 1 end
    local perCol = math.ceil(n / colsT)

    local ch = 0
    if isCari then
        colsT = 1
        ch = 26 + gap + 26 + gap + 36 + gap + 18
        if searchState.results then
            ch = ch + #searchState.results * (34 + gap)
        end
    else
        local colHeights = {}
        for c = 1, colsT do colHeights[c] = 0 end
        for idx, d in ipairs(defs) do
            local c = math.min(colsT, math.floor((idx - 1) / perCol) + 1)
            colHeights[c] = colHeights[c] + defH(d) + gap
        end
        for _, h in ipairs(colHeights) do if h > ch then ch = h end end
        if ch > 0 then ch = ch - gap end
    end

    for _, cf in ipairs(colFrames) do pcall(function() cf:Destroy() end) end
    colFrames = {}
    local innerW = panelW - 20
    local colW = math.floor((innerW - (colsT - 1) * 6) / colsT)
    if holder then
        for c = 0, colsT - 1 do
            local colFrame = new("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, colW, 0, ch + 4),
                Position = UDim2.new(0, c * (colW + 6), 0, 0),
            }, holder)
            if colFrame then
                new("UIListLayout", { Padding = UDim.new(0, gap) }, colFrame)
                table.insert(colFrames, colFrame)
            end
        end
        if holder:IsA("ScrollingFrame") then
            holder.CanvasSize = UDim2.new(0, 0, 0, ch + 8)
        end
    end

    rowRegistry = {}
    if isCari then
        if colFrames[1] then buildSearchTab(colFrames[1]) end
    else
        for idx, d in ipairs(defs) do
            local c = math.min(colsT, math.floor((idx - 1) / perCol) + 1)
            local parent = colFrames[c] or colFrames[1]
            if parent then
                local pre = {}
                for _, x in ipairs(parent:GetChildren()) do pre[x] = true end
                if d.kind == "header" then
                    makeHeader(d.label, parent)
                elseif d.kind == "stat" then
                    makeStatRow(d, parent)
                elseif d.kind == "anim" or d.kind == "emote" or d.kind == "emoteid" or d.kind == "action" then
                    makeActionRow(d, parent)
                elseif d.kind == "slider" then
                    makeSliderRow(d, parent)
                elseif d.kind == "swatches" then
                    makeSwatchRow(d, parent)
                elseif d.kind == "nametag" then
                    makeNametagRow(d, parent)
                elseif d.kind == "timebtns" then
                    makeTimeRow(d, parent)
                elseif d.kind == "animinput" then
                    makeAnimInputRow(d, parent)
                else
                    makeRow(d, parent)
                end
                for _, x in ipairs(parent:GetChildren()) do
                    if not pre[x] and (x:IsA("Frame") or x:IsA("TextButton")) then
                        table.insert(rowRegistry, { frame = x, name = (d.label or ""):lower() })
                    end
                end
            end
        end
    end
    filterAccRows()

    if searchBar then
        searchBar.Visible = (activeTab == "acc")
    end
    local chrome = 106 + ((activeTab == "acc" and searchBar) and 28 or 0)
    local holderH = math.min(ch + 4, vp.Y - 16 - chrome)
    if holderH < 60 then holderH = math.min(60, vp.Y - 16 - chrome) end
    if holder then holder.Size = UDim2.new(1, 0, 0, holderH) end
    local panelH = math.floor(holderH + chrome)
    main.Size = UDim2.fromOffset(panelW, panelH)
    if not userMovedMain then
        main.Position = UDim2.new(0.5, -math.floor(panelW / 2), 0.5, -math.floor(panelH / 2))
    end
end

-- Mini logo
local mini = new("TextButton", {
    Name = "Mini",
    Size = UDim2.fromOffset(46, 46),
    Position = UDim2.new(0.5, -23, 0.5, -23),
    BackgroundColor3 = C.bg,
    Text = "", AutoButtonColor = false,
    BorderSizePixel = 0, Visible = false,
}, gui)
if mini then
    corner(12, mini)
    local miniStroke = stroke(mini, C.accent, 1.5)
    if miniStroke then
        pcall(function()
            miniStroke.Gradient = ColorSequence.new(
                Color3.fromRGB(255, 190, 80), Color3.fromRGB(255, 70, 40)
            )
        end)
    end
    new("TextLabel", {
        Text = "J", Font = Enum.Font.GothamBlack, TextSize = 22,
        TextColor3 = C.accent, BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, mini)
end

if minBtn and mini then
    minBtn.MouseButton1Click:Connect(function()
        mini.Position = main.Position
        main.Visible = false
        mini.Visible = true
    end)
end
if mini then
    mini.MouseButton1Click:Connect(function()
        main.Position = mini.Position
        mini.Visible = false
        main.Visible = true
    end)
end
if closeBtn then
    closeBtn.MouseButton1Click:Connect(function()
        previewOpen = false
        gui:Destroy()
        if adjustGui then pcall(function() adjustGui:Destroy() end) end
        if previewGui then pcall(function() previewGui:Destroy() end) end
    end)
end
if eyeBtn then
    eyeBtn.MouseButton1Click:Connect(togglePreview)
end

refreshTabs()
rebuildContent()
updateFooter()
main.Visible = true

-- Dragging
function makeDraggable(frame, handle, onMove)
    if not frame or not handle then return end
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            if onMove and (math.abs(delta.X) > 4 or math.abs(delta.Y) > 4) then
                onMove()
            end
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(main, titleBar, function() userMovedMain = true end)
makeDraggable(mini, mini)
