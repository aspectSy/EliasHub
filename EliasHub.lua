local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- State Variables (Auto-enabled by default)
local AntiAFKEnabled = true
local FPSBoostApplied = false
local DescendantConnection = nil

-- 1. Anti-AFK Connection (Active immediately on execution)
LocalPlayer.Idled:Connect(function()
   if AntiAFKEnabled then
      VirtualUser:CaptureController()
      VirtualUser:ClickButton2(Vector2.new())
   end
end)

-- 2. Optimized FPS Boost Function
local function OptimizeInstance(v)
   if v:IsA("BasePart") then
      v.Material = Enum.Material.SmoothPlastic
      v.Reflectance = 0
      v.CastShadow = false
   elseif v:IsA("Decal") or v:IsA("Texture") then
      v:Destroy()
   elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
      v.Enabled = false
   elseif v:IsA("PostEffect") then
      v.Enabled = false
   end
end

local function ApplyFPSBoost()
   if FPSBoostApplied then return end
   FPSBoostApplied = true

   local Terrain = workspace:FindFirstChildOfClass("Terrain")
   if Terrain then
      Terrain.WaterWaveSize = 0
      Terrain.WaterWaveSpeed = 0
      Terrain.WaterReflectance = 0
      Terrain.WaterTransparency = 0
      Terrain.Decoration = false
   end

   Lighting.GlobalShadows = false
   Lighting.FogEnd = 9e9
   settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

   for _, effect in ipairs(Lighting:GetChildren()) do
      if effect:IsA("PostEffect") then
         effect.Enabled = false
      end
   end

   local descendants = workspace:GetDescendants()
   for i = 1, #descendants do
      OptimizeInstance(descendants[i])
      if i % 500 == 0 then
         task.wait()
      end
   end

   if not DescendantConnection then
      DescendantConnection = workspace.DescendantAdded:Connect(OptimizeInstance)
   end
end

-- Run Ultra FPS Boost automatically in a separate thread
task.spawn(ApplyFPSBoost)

-- 3. Rayfield UI (Synced with active states)
local Window = Rayfield:CreateWindow({
   Name = "Multi-Account FPS & Anti-AFK",
   LoadingTitle = "Loading Utility...",
   LoadingSubtitle = "by Elias",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main Utilities", 4483362458)

MainTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = true,
   Flag = "AntiAFK_Toggle",
   Callback = function(Value)
      AntiAFKEnabled = Value
   end,
})

MainTab:CreateToggle({
   Name = "Disable 3D Rendering (AFK Mode)",
   CurrentValue = false,
   Flag = "Disable3D_Toggle",
   Callback = function(Value)
      RunService:Set3dRenderingEnabled(not Value)
   end,
})

MainTab:CreateSlider({
   Name = "FPS Cap",
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
   Title = "Auto-Optimization Active",
   Content = "Anti-AFK and Ultra FPS Boost started automatically.",
   Duration = 4,
   Image = 4483362458,
})
