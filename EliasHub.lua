local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "Multi-Account Utility (4x Optimized)",
   LoadingTitle = "Loading Utility...",
   LoadingSubtitle = "by Elias",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main Utilities", 4483362458)

-------------------------------------------------------------------------
-- 1. AUTOMATIC ANTI-AFK (Enabled by default on startup)
-------------------------------------------------------------------------
local AntiAFKEnabled = true

LocalPlayer.Idled:Connect(function()
   if AntiAFKEnabled then
      VirtualUser:CaptureController()
      VirtualUser:ClickButton2(Vector2.new())
   end
end)

MainTab:CreateToggle({
   Name = "Anti-AFK (Auto-On)",
   CurrentValue = true,
   Flag = "AntiAFK_Toggle",
   Callback = function(Value)
      AntiAFKEnabled = Value
   end,
})

-------------------------------------------------------------------------
-- 2. AUTO-RECONNECT (Rejoins immediately upon disconnect/error prompt)
-------------------------------------------------------------------------
local AutoReconnectEnabled = true
local Reconnecting = false

local function AttemptReconnect()
   if not AutoReconnectEnabled or Reconnecting then return end
   Reconnecting = true

   task.wait(2) -- Brief buffer to avoid instant rate-limit loops
   if #Players:GetPlayers() <= 1 then
      TeleportService:Teleport(game.PlaceId, LocalPlayer)
   else
      TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
   end
end

GuiService.ErrorMessageChanged:Connect(function()
   local err = GuiService:GetErrorMessage()
   if err and err ~= "" then
      AttemptReconnect()
   end
end)

TeleportService.TeleportInitFailed:Connect(function()
   task.wait(3)
   Reconnecting = false
   AttemptReconnect()
end)

MainTab:CreateToggle({
   Name = "Auto-Reconnect (Auto-On)",
   CurrentValue = true,
   Flag = "AutoReconnect_Toggle",
   Callback = function(Value)
      AutoReconnectEnabled = Value
   end,
})

-------------------------------------------------------------------------
-- 3. ULTRA FPS BOOST & DEEP MEMORY OPTIMIZATION
-------------------------------------------------------------------------
local FPSBoostApplied = false
local StripAvatars = false
local DescendantConnection = nil

local function OptimizeInstance(v)
   if v:IsA("BasePart") then
      v.Material = Enum.Material.SmoothPlastic
      v.Reflectance = 0
      v.CastShadow = false
   elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("SurfaceAppearance") then
      v:Destroy()
   elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
      v.Enabled = false
   elseif v:IsA("Highlight") or v:IsA("PostEffect") then
      v.Enabled = false
   elseif v:IsA("Sound") then
      v.Volume = 0
      v:Stop()
   elseif StripAvatars and (v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic")) then
      v:Destroy()
   end
end

local function ApplyUltraFPSBoost()
   if FPSBoostApplied then return end
   FPSBoostApplied = true

   -- Strip Terrain & Animated Grass
   local Terrain = workspace:FindFirstChildOfClass("Terrain")
   if Terrain then
      Terrain.WaterWaveSize = 0
      Terrain.WaterWaveSpeed = 0
      Terrain.WaterReflectance = 0
      Terrain.WaterTransparency = 0
      Terrain.Decoration = false
   end

   -- Strip Lighting & Audio Processing
   Lighting.GlobalShadows = false
   Lighting.FogEnd = 9e9
   Lighting.Brightness = 1
   SoundService.AmbientReverb = Enum.ReverbType.NoReverb
   settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

   for _, effect in ipairs(Lighting:GetChildren()) do
      if effect:IsA("PostEffect") or effect:IsA("Sky") or effect:IsA("Atmosphere") then
         if effect:IsA("PostEffect") then
            effect.Enabled = false
         else
            effect:Destroy()
         end
      end
   end

   -- Yielded Workspace Sweep (Prevents freezing across 4 clients)
   local descendants = workspace:GetDescendants()
   for i = 1, #descendants do
      OptimizeInstance(descendants[i])
      if i % 500 == 0 then
         task.wait()
      end
   end

   -- Monitor future spawned objects
   if not DescendantConnection then
      DescendantConnection = workspace.DescendantAdded:Connect(OptimizeInstance)
   end

   -- Force Lua RAM cleanup
   collectgarbage("collect")
end

MainTab:CreateToggle({
   Name = "Strip Player Clothes/Accessories",
   CurrentValue = false,
   Flag = "StripAvatars_Toggle",
   Callback = function(Value)
      StripAvatars = Value
   end,
})

MainTab:CreateButton({
   Name = "Ultra FPS Boost",
   Callback = function()
      ApplyUltraFPSBoost()
      Rayfield:Notify({
         Title = "Ultra FPS Boost Applied",
         Content = "Textures, PBR maps, audio, lighting, and RAM purged.",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

-------------------------------------------------------------------------
-- 4. MULTI-INSTANCE RESOURCE SAVERS
-------------------------------------------------------------------------
MainTab:CreateToggle({
   Name = "Disable 3D Rendering (AFK Mode)",
   CurrentValue = false,
   Flag = "Disable3D_Toggle",
   Callback = function(Value)
      RunService:Set3dRenderingEnabled(not Value)
   end,
})

MainTab:CreateSlider({
   Name = "FPS Cap (15 Recommended for Alts)",
   Range = {10, 60},
   Increment = 5,
   Suffix = " FPS",
   CurrentValue = 60,
   Flag = "FPSCap_Slider",
   Callback = function(Value)
      if setfpscap then
         setfpscap(Value)
      end
   end,
})

Rayfield:Notify({
   Title = "Multi-Account Utility Loaded",
   Content = "Anti-AFK and Auto-Reconnect are active.",
   Duration = 4,
   Image = 4483362458,
})
