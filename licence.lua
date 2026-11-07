enter the main script of the sistema here. 
inserte el script principal del sistema.

-- MAIN REMOTE SCRIPT
-- Este archivo se descarga después de validar la licencia.

print("================================")
print("       KIT LICENSED")
print("       MAIN SYSTEM LOADED")
print("================================")

-- Aquí comienza el código de tu kit.

-- EJEMPLO:
local Players = game:GetService("Players")

print("Sistema principal iniciado.")


-- LUX PRODUCTIONS | FX SELECTOR V4.1
-- UNICO SCRIPT: sistem | RunContext = Client.
-- La pantalla SOLO aparece sobre PantallaFisica (SurfaceGui.Adornee).
-- NOTA: al ser un unico script de cliente, los cambios de Enabled son LOCALES
-- a cada jugador. Para sincronizar todos los jugadores se requiere servidor+cliente.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local panel = script.Parent
local screen = panel:WaitForChild("PantallaFisica")
local folder = panel:WaitForChild("Emitters")
local pg = player:WaitForChild("PlayerGui")

-- Cada salida controla TODOS los ParticleEmitter que contiene,
-- incluso cuando estan dentro de un Attachment o una carpeta.
-- No importa el nombre de ningun ParticleEmitter.
-- Solo estos 3 nombres de PIEZA deben coincidir con los del Explorer.
local CONFIG = {
    FUEGO = { part = "SalidaFuego", label = "FUEGO", subtitle = "FIRE / EFFECT 01" },
    HAZE  = { part = "SalidaHaze", label = "HAZE", subtitle = "HAZE / EFFECT 02" },
    CO2   = { part = "SalidaCO2", label = "CO2", subtitle = "CO2 / EFFECT 03" }
}
local ORDER = {"FUEGO", "HAZE", "CO2"}
local fixed = {FUEGO = false, HAZE = false, CO2 = false}
local holding = {FUEGO = false, HAZE = false, CO2 = false}
local page = "MENU"
local currentHoldButton = nil

local DARK = Color3.fromRGB(16,17,19)
local PANEL = Color3.fromRGB(28,29,32)
local TILE = Color3.fromRGB(47,49,54)
local BORDER = Color3.fromRGB(95,98,105)
local WHITE = Color3.fromRGB(236,238,240)
local MUTED = Color3.fromRGB(157,160,166)
local ACTIVE = Color3.fromRGB(202,206,210)

local gui = Instance.new("SurfaceGui")
gui.Name = "LuxProductions_FX_Panel"

gui.Adornee = screen
gui.Face = Enum.NormalId.Front
gui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
gui.CanvasSize = Vector2.new(1100, 660)
gui.LightInfluence = 0
gui.AlwaysOnTop = false
gui.MaxDistance = 100
gui.Active = true
gui.ResetOnSpawn = false
gui.Parent = pg
screen.CanQuery = true

local base = Instance.new("Frame")
base.Name = "Root"
base.Size = UDim2.fromScale(1,1)
base.BackgroundColor3 = DARK
base.BorderSizePixel = 0
base.Parent = gui

local function rounded(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = obj
end
local function stroke(obj, color, size)
    local s = Instance.new("UIStroke")
    s.Color = color or BORDER
    s.Thickness = size or 1
    s.Parent = obj
end
local function txt(parent, name, text, pos, size, font, color, scale)
    local l = Instance.new("TextLabel")
    l.Name=name
    l.BackgroundTransparency=1
    l.Position=pos
    l.Size=size
    l.Text=text
    l.Font=font or Enum.Font.Gotham
    l.TextColor3=color or WHITE
    l.TextScaled=scale == true
    l.TextSize=scale and 22 or 22
    l.TextXAlignment=Enum.TextXAlignment.Center
    l.Parent=parent
    return l
end
local function button(parent, name, caption, pos, size)
    local b = Instance.new("TextButton")
    b.Name=name
    b.Position=pos
    b.Size=size
    b.Text=caption
    b.Font=Enum.Font.GothamBold
    b.TextSize=27
    b.TextColor3=WHITE
    b.BackgroundColor3=TILE
    b.AutoButtonColor=true
    b.BorderSizePixel=0
    rounded(b,12)
    stroke(b,BORDER,2)
    b.Parent=parent
    return b
end
local function layer(name)
    local f=Instance.new("Frame")
    f.Name=name
    f.Size=UDim2.fromScale(1,1)
    f.BackgroundTransparency=1
    f.Visible=false
    f.Parent=base
    return f
end

-- Marco y cabecera oscura compartida
local top=Instance.new("Frame")
top.Name="Header"
top.Size=UDim2.new(1,0,0,120)
top.BackgroundColor3=PANEL
top.BorderSizePixel=0
top.Parent=base
local brand=txt(top,"Brand","LUX PRODUCTIONS",UDim2.fromOffset(40,16),UDim2.fromOffset(630,58),Enum.Font.GothamBlack,WHITE,false)
brand.TextSize=46
brand.TextXAlignment=Enum.TextXAlignment.Left
local series=txt(top,"Series","FX / DIGITAL CONTROL",UDim2.fromOffset(40,77),UDim2.fromOffset(550,25),Enum.Font.GothamMedium,MUTED,false)
series.TextXAlignment=Enum.TextXAlignment.Left
series.TextSize=19
local edition=txt(top,"Edition","3 CHANNELS  /  V4.1",UDim2.fromOffset(745,40),UDim2.fromOffset(320,40),Enum.Font.GothamBold,MUTED,false)
edition.TextXAlignment=Enum.TextXAlignment.Right

local menu=layer("MENU")
txt(menu,"MenuTitle","SELECT EFFECT",UDim2.fromOffset(50,149),UDim2.fromOffset(1000,66),Enum.Font.GothamBold,WHITE,true)
txt(menu,"MenuTip","CHOOSE ONE OUTPUT TO OPEN ITS CONTROLS",UDim2.fromOffset(150,215),UDim2.fromOffset(800,40),Enum.Font.GothamMedium,MUTED,false)
local menuButtons={}
for index,key in ipairs(ORDER) do
    local b=button(menu,"Select"..key,CONFIG[key].label,UDim2.fromOffset(65+(index-1)*346,310),UDim2.fromOffset(310,170))
    b.TextSize=34
    menuButtons[key]=b
    txt(menu,"Hint"..key,CONFIG[key].subtitle,UDim2.fromOffset(65+(index-1)*346,500),UDim2.fromOffset(310,38),Enum.Font.GothamMedium,MUTED,false)
end
txt(menu,"Footer","INDEPENDENT EFFECT CONTROLS     •     BLACK / GREY INTERFACE",UDim2.fromOffset(100,594),UDim2.fromOffset(900,28),Enum.Font.Gotham,MUTED,false)

local detail=layer("DETAIL")
local back=button(detail,"RETURN","<  RETURN",UDim2.fromOffset(50,151),UDim2.fromOffset(215,70))
back.TextSize=25
local heading=txt(detail,"EffectName","FUEGO",UDim2.fromOffset(284,157),UDim2.fromOffset(760,62),Enum.Font.GothamBlack,WHITE,true)
local desc=txt(detail,"Description","EFFECT 01",UDim2.fromOffset(300,231),UDim2.fromOffset(700,32),Enum.Font.GothamMedium,MUTED,false)
local statusBox=Instance.new("Frame")
statusBox.Position=UDim2.fromOffset(80,288)
statusBox.Size=UDim2.fromOffset(940,68)
statusBox.BackgroundColor3=PANEL
statusBox.BorderSizePixel=0
rounded(statusBox,10)
statusBox.Parent=detail
local status=txt(statusBox,"Status","OUTPUT / OFF",UDim2.fromOffset(30,12),UDim2.fromOffset(880,42),Enum.Font.GothamBold,WHITE,true)
local bHold=button(detail,"HOLD","HOLD",UDim2.fromOffset(65,395),UDim2.fromOffset(310,145))
local bOn=button(detail,"ON","ON",UDim2.fromOffset(395,395),UDim2.fromOffset(310,145))
local bOff=button(detail,"OFF","OFF",UDim2.fromOffset(725,395),UDim2.fromOffset(310,145))
for _,b in ipairs({bHold,bOn,bOff}) do b.TextSize=37 end
txt(detail,"HoldTip","HOLD: KEEP PRESSED  |  ON: LATCH  |  OFF: STOP",UDim2.fromOffset(105,576),UDim2.fromOffset(890,34),Enum.Font.GothamMedium,MUTED,false)

-- Busca en la PIEZA correspondiente, NO por nombre de emisor.
-- Se ejecuta en cada cambio ON/OFF/HOLD para admitir emisores agregados o renombrados.
local function emitters(key)
    local cfg = CONFIG[key]
    local source = folder:FindFirstChild(cfg.part)
    local result = {}
    if not source or not source:IsA("BasePart") then
        warn("[LUX PRODUCTIONS] No se encontro la pieza:", cfg.part)
        return result
    end

    for _, obj in ipairs(source:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            table.insert(result, obj)
        end
    end
    return result
end

local function apply(key)
    local enabled = fixed[key] or holding[key]
    local targets = emitters(key)
    for _, emitter in ipairs(targets) do
        emitter.Enabled = enabled
    end
    if #targets == 0 then
        warn("[LUX PRODUCTIONS] No hay ParticleEmitter dentro de:", CONFIG[key].part)
    else
        print("[LUX PRODUCTIONS]", key, enabled and "ON" or "OFF", "| emisores:", #targets)
    end
end
local function update()
    menu.Visible=page=="MENU"
    detail.Visible=page~="MENU"
    if page=="MENU" then return end
    heading.Text=CONFIG[page].label
    desc.Text=CONFIG[page].subtitle .. "  /  INDEPENDENT OUTPUT"
    local state=holding[page] and "HOLD" or (fixed[page] and "ON" or "OFF")
    status.Text="OUTPUT  /  " .. state
    bHold.BackgroundColor3=holding[page] and ACTIVE or TILE
    bOn.BackgroundColor3=fixed[page] and ACTIVE or TILE
    bOff.BackgroundColor3=(not fixed[page] and not holding[page]) and Color3.fromRGB(96,98,103) or TILE
    bHold.TextColor3=holding[page] and DARK or WHITE
    bOn.TextColor3=fixed[page] and DARK or WHITE
end
local function releaseHold()
    if not currentHoldButton then return end
    local key=currentHoldButton
    currentHoldButton=nil
    holding[key]=false
    apply(key)
    update()
end
for key,b in pairs(menuButtons) do
    b.Activated:Connect(function()
        releaseHold()
        page=key
        apply(key)
        update()
    end)
end
back.Activated:Connect(function()
    releaseHold()
    page="MENU"
    update()
end)
bOn.Activated:Connect(function()
    releaseHold()
    fixed[page]=true
    apply(page)
    update()
end)
bOff.Activated:Connect(function()
    releaseHold()
    fixed[page]=false
    apply(page)
    update()
end)
-- HOLD: detect the actual mouse or touch press on the 3D SurfaceGui button.
bHold.InputBegan:Connect(function(input)
    if page=="MENU" then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        releaseHold()
        currentHoldButton=page
        holding[page]=true
        apply(page)
        update()
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        releaseHold()
    end
end)
-- Avoid a stuck HOLD when leaving or losing focus.
UserInputService.WindowFocusReleased:Connect(releaseHold)

for _,key in ipairs(ORDER) do apply(key) end
update()
print("[LUX PRODUCTIONS] sistem running. Independent effects: FUEGO, HAZE, CO2.")
