dlocal Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FPS & Anti-AFK Script",
   LoadingTitle = "Loading Utility...",
   LoadingSubtitle = "by Elias",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main Utilities", 4483362458) -- Title, ImageId

-- Anti-AFK Implementation
local AntiAFKEnabled = false
local VirtualUser = game:GetService("VirtualUser")

MainTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAFK_Toggle",
   Callback = function(Value)
      AntiAFKEnabled = Value
      if AntiAFKEnabled then
         Rayfield:Notify({
            Title = "Anti-AFK Enabled",
            Content = "You will no longer be kicked for idling.",
            Duration = 3,
            Image = 4483362458,
         })
      end
   end,
})

-- Anti-AFK Event Connection
game:GetService("Players").LocalPlayer.Idled:Connect(function()
   if AntiAFKEnabled then
      VirtualUser:CaptureController()
      VirtualUser:ClickButton2(Vector2.new())
   end
end)

-- Ultra FPS Boost Function
local function ApplyFPSBoost()
   local Terrain = workspace:FindFirstChildOfClass('Terrain')
   if Terrain then
      Terrain.WaterWaveSize = 0
      Terrain.WaterWaveSpeed = 0
      Terrain.WaterReflectance = 0
      Terrain.WaterTransparency = 0
   end

   game:GetService("Lighting").GlobalShadows = false
   game:GetService("Lighting").FogEnd = 9e9

   for _, v in pairs(game:GetDescendants()) do
      if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
         v.Material = Enum.Material.SmoothPlastic
         v.Reflectance = 0
      elseif v:IsA("Decal") or v:IsA("Texture") then
         v:Destroy()
      elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
         v.Enabled = false
      elseif v:IsA("PostEffect") then
         v.Enabled = false
      end
   end

   -- Handle future instances spawned in
   workspace.DescendantAdded:Connect(function(v)
      if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
         v.Material = Enum.Material.SmoothPlastic
         v.Reflectance = 0
      elseif v:IsA("Decal") or v:IsA("Texture") then
         v:Destroy()
      elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
         v.Enabled = false
      elseif v:IsA("PostEffect") then
         v.Enabled = false
      end
   end)
end

MainTab:CreateButton({
   Name = "Ultra FPS Boost",
   Callback = function()
      ApplyFPSBoost()
      Rayfield:Notify({
         Title = "FPS Boost Applied",
         Content = "Textures, particles, shadows, and water effects disabled.",
         Duration = 4,
         Image = 4483362458,
      })
   end,
})
